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
  { group: "pricing", key: "subscription_standard_price_xof",  value: "15000",                      description: "Prix abonnement Standard (XOF/mois)" },
  { group: "pricing", key: "subscription_premium_price_xof",   value: "25000",                      description: "Prix abonnement Premium (XOF/mois)" },
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
  // Subscription feature flags — toggleable from admin Configuration page
  { group: "subscription_features", key: "feature_deposits_enabled",      value: "true",   description: "Activer les acomptes clients" },
  { group: "subscription_features", key: "feature_deposits_tier_required", value: "premium", description: "Niveau requis pour les acomptes" },
  { group: "subscription_features", key: "feature_analytics_enabled",      value: "true",   description: "Activer les rapports financiers" },
  { group: "subscription_features", key: "feature_analytics_tier_required", value: "premium", description: "Niveau requis pour les rapports" },
  { group: "subscription_features", key: "feature_auto_renew_enabled",     value: "true",   description: "Activer le renouvellement automatique" },
  { group: "subscription_features", key: "feature_billing_paydunya",       value: "false",  description: "Afficher PayDunya comme mode de facturation" },
  { group: "subscription_features", key: "feature_billing_intech",         value: "true",   description: "Afficher Intech comme mode de facturation" },
  { group: "subscription_features", key: "feature_billing_manual",         value: "true",   description: "Afficher le mode manuel" },
  { group: "subscription_features", key: "feature_card_payments",          value: "false",  description: "Activer l'option carte bancaire" },
];

async function main() {
  // ── Admin user ──────────────────────────────────────────────────────────────
  const existing = await prisma.user.findFirst({ where: { role: "platform_admin" } });
  if (existing) {
    console.log("[seed-admin] platform_admin already exists:", existing.email, "— skipping.");
  } else {
    const email = process.env.ADMIN_EMAIL ?? "admin@beauteavenue.local";
    const password = process.env.ADMIN_PASSWORD ?? "supersecure";
    const passwordHash = await argon2.hash(password);
    const admin = await prisma.user.create({
      data: { fullName: "Chef de Plateforme", email, passwordHash, role: "platform_admin" }
    });
    console.log("[seed-admin] platform_admin created:", admin.email);
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
  const existingPro = await prisma.user.findUnique({ where: { email: PRO_EMAIL } });
  if (existingPro) {
    console.log("[seed-admin] test pro account already exists:", PRO_EMAIL, "— skipping.");
  } else {
    const proPasswordHash = await argon2.hash("pro1234");
    const testSalon = await prisma.salon.create({
      data: {
        name: "Salon Démo",
        category: "Beauté & Bien-être",
        city: "Dakar",
        address: "1 Avenue Bourguiba, Dakar",
        description: "Salon de démonstration pour les tests de la plateforme.",
        approvalStatus: "approved",
        isVisibleInMarketplace: true,
        canReceiveBookings: true,
        staffMembers: {
          create: {
            fullName: "Gérant Démo",
            email: PRO_EMAIL,
            phone: "+221770000000",
            role: "salon_owner",
            passwordHash: proPasswordHash
          }
        }
      }
    });
    await prisma.subscription.create({
      data: { salonId: testSalon.id, tier: "standard", status: "active" }
    });
    console.log(`[seed-admin] test pro account created: ${PRO_EMAIL} / pro1234 (salonId: ${testSalon.id})`);
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
