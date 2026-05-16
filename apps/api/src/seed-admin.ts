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
  { group: "pricing", key: "commission_rate_percent",        value: "5",                          description: "Commission plateforme %" },
  { group: "pricing", key: "subscription_standard_price_xof", value: "15000",                    description: "Prix abonnement Standard (XOF/mois)" },
  { group: "pricing", key: "subscription_premium_price_xof",  value: "25000",                    description: "Prix abonnement Premium (XOF/mois)" },
  { group: "pricing", key: "deposit_minimum_xof",            value: "2000",                       description: "Acompte minimum (XOF)" },
  { group: "pricing", key: "cancellation_window_hours",      value: "24",                         description: "Fenêtre d'annulation gratuite (heures)" },
  { group: "general", key: "support_email",                  value: "support@beauteavenue.local", description: "Email du support" },
  { group: "general", key: "support_phone",                  value: "+221338001234",              description: "Téléphone du support" },
  { group: "general", key: "booking_advance_days_max",       value: "30",                         description: "Horizon de réservation max (jours)" },
  { group: "general", key: "salon_approval_sla_days",        value: "3",                          description: "Délai SLA approbation salon (jours)" },
];

async function main() {
  // Seed admin user
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

  // Seed default platform settings (idempotent upsert)
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
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
