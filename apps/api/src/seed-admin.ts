import "dotenv/config";

import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "./generated/prisma/client.js";
import argon2 from "argon2";

const adapter = new PrismaPg({
  connectionString:
    process.env.DATABASE_URL ??
    "postgresql://postgres:postgres@localhost:5434/beaute_avenue?schema=public"
});
const prisma = new PrismaClient({ adapter });

const DEFAULT_SETTINGS = [
  { group: "pricing", key: "commission_rate_percent",           value: "5",                          description: "Commission plateforme %" },
  { group: "pricing", key: "subscription_standard_price_xof",  value: "200",                        description: "Prix abonnement Standard (XOF/mois)" },
  { group: "pricing", key: "subscription_premium_price_xof",   value: "300",                        description: "Prix abonnement Premium (XOF/mois)" },
  { group: "pricing", key: "subscription_annual_discount_percent", value: "0",                       description: "Réduction annuelle (%)" },
  { group: "pricing", key: "deposit_minimum_xof",              value: "2000",                        description: "Acompte minimum (XOF)" },
  { group: "pricing", key: "cancellation_window_hours",        value: "24",                          description: "Fenêtre d'annulation gratuite (heures)" },
  { group: "general", key: "support_email",                    value: "support@beauteavenue.local",  description: "Email du support" },
  { group: "general", key: "support_phone",                    value: "+221338001234",               description: "Téléphone du support" },
  { group: "general", key: "booking_advance_days_max",         value: "30",                          description: "Horizon de réservation max (jours)" },
  { group: "general", key: "salon_approval_sla_days",          value: "3",                           description: "Délai SLA approbation salon (jours)" },
  // Payment method toggles — enabled by default, manageable via admin backoffice
  { group: "payment_methods", key: "paydunya_enabled_wave_senegal",    value: "true",  description: "Wave Sénégal activé" },
  { group: "payment_methods", key: "paydunya_enabled_orange_senegal",  value: "true",  description: "Orange Money Sénégal activé" },
  { group: "payment_methods", key: "paydunya_enabled_free_senegal",    value: "false", description: "Free Money Sénégal activé" },
  { group: "payment_methods", key: "paydunya_enabled_wizall_senegal",  value: "false", description: "Wizall Sénégal activé" },
  { group: "payment_methods", key: "paydunya_enabled_expresso_senegal", value: "false", description: "Expresso Sénégal activé" },
  // Subscription feature flags — toggleable from admin Configuration page
  { group: "subscription_features", key: "feature_deposits_enabled",      value: "true",   description: "Activer les acomptes clients" },
  { group: "subscription_features", key: "feature_deposits_tier_required", value: "premium", description: "Niveau requis pour les acomptes" },
  { group: "subscription_features", key: "feature_analytics_enabled",      value: "true",   description: "Activer les rapports financiers" },
  { group: "subscription_features", key: "feature_analytics_tier_required", value: "premium", description: "Niveau requis pour les rapports" },
  { group: "subscription_features", key: "feature_auto_renew_enabled",     value: "true",   description: "Activer le renouvellement automatique" },
  { group: "subscription_features", key: "feature_billing_paydunya",       value: "true",   description: "Afficher PayDunya comme mode de facturation" },
  { group: "subscription_features", key: "feature_billing_manual",         value: "true",   description: "Afficher le mode manuel" },
  { group: "subscription_features", key: "feature_card_payments",          value: "false",  description: "Activer l'option carte bancaire" },
];

async function main() {
  // ── Admin user ──────────────────────────────────────────────────────────────
  const email = process.env.ADMIN_EMAIL ?? "admin@beauteavenue.local";
  const password = process.env.ADMIN_PASSWORD ?? "admin1234";
  const existing = await prisma.user.findFirst({ where: { role: "platform_admin" } });
  if (existing) {
    const passwordHash = await argon2.hash(password);
    await prisma.user.update({
      where: { id: existing.id },
      data: { passwordHash }
    });
    console.log(`[seed-admin] platform_admin password refreshed: ${existing.email} / [password set]`);
  } else {
    const passwordHash = await argon2.hash(password);
    const admin = await prisma.user.create({
      data: { fullName: "Chef de Plateforme", email, passwordHash, role: "platform_admin" }
    });
    console.log(`[seed-admin] platform_admin created: ${admin.email} / [password set]`);
  }

  // ── Default platform settings (idempotent) ──────────────────────────────────
  let seeded = 0;
  for (const s of DEFAULT_SETTINGS) {
    const result = await prisma.platformSetting.upsert({
      where: { key: s.key },
      create: s,
      update: {}  // never overwrite existing values
    });
    if (result) seeded++;
  }
  console.log(`[seed-admin] platform settings upserted: ${seeded}/${DEFAULT_SETTINGS.length}`);

  // ── Test pro account (staging / first-run fallback) ─────────────────────────
  // Creates a fully-approved salon + owner so the pro dashboard can be tested
  // without going through the magic-link flow.
  const PRO_EMAIL = "pro@beauteavenue.local";
  const PRO_PASSWORD = "pro12345";

  if (process.env.NODE_ENV === "production") {
    console.log("[seed-admin] skipping demo pro account in production");
    return;
  }

  const proPasswordHash = await argon2.hash(PRO_PASSWORD);
  const ensureDemoSalon = async () => {
    const existing = await prisma.salon.findFirst({
      where: { name: "Salon Démo", city: "Dakar" }
    });
    if (existing) return existing;
    return prisma.salon.create({
      data: {
        name: "Salon Démo",
        category: "Beauté & Bien-être",
        city: "Dakar",
        address: "1 Avenue Bourguiba, Dakar",
        description: "Salon de démonstration pour les tests de la plateforme.",
        approvalStatus: "approved",
        isVisibleInMarketplace: true,
        canReceiveBookings: true
      }
    });
  };

  const ensureActiveSubscription = async (salonId: string) => {
    await prisma.subscription.upsert({
      where: { salonId },
      update: { status: "active", tier: "standard" },
      create: { salonId, tier: "standard", status: "active" }
    });
  };

  const existingPro = await prisma.user.findUnique({ where: { email: PRO_EMAIL } });
  if (existingPro) {
    const ensuredSalon = existingPro.salonId
      ? await prisma.salon.findUnique({ where: { id: existingPro.salonId } })
      : null;
    const salon = ensuredSalon ?? await ensureDemoSalon();
    await prisma.user.update({
      where: { email: PRO_EMAIL },
      data: { passwordHash: proPasswordHash, role: "salon_owner", salonId: salon.id, phone: existingPro.phone ?? "+221770000000" }
    });
    await ensureActiveSubscription(salon.id);
    console.log(`[seed-admin] test pro account password refreshed: ${PRO_EMAIL} / [password set]`);
  } else {
    const existingPhoneUser = await prisma.user.findFirst({ where: { phone: "+221770000000" } });
    if (existingPhoneUser) {
      const ensuredSalon = existingPhoneUser.salonId
        ? await prisma.salon.findUnique({ where: { id: existingPhoneUser.salonId } })
        : null;
      const salon = ensuredSalon ?? await ensureDemoSalon();
      await prisma.user.update({
        where: { id: existingPhoneUser.id },
        data: {
          email: PRO_EMAIL,
          role: "salon_owner",
          salonId: salon.id,
          passwordHash: proPasswordHash
        }
      });
      await ensureActiveSubscription(salon.id);
      console.log(`[seed-admin] linked existing owner to test pro account: ${PRO_EMAIL} / [password set]`);
      return;
    }

    const testSalon = await ensureDemoSalon();
    await prisma.user.create({
      data: {
        fullName: "Gérant Démo",
        email: PRO_EMAIL,
        phone: "+221770000000",
        role: "salon_owner",
        passwordHash: proPasswordHash,
        salonId: testSalon.id
      }
    });
    await ensureActiveSubscription(testSalon.id);
    console.log(`[seed-admin] test pro account created: ${PRO_EMAIL} / [password set] (salonId: ${testSalon.id})`);
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
