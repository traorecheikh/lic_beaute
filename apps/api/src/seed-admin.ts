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

async function main() {
  const existing = await prisma.user.findFirst({ where: { role: "platform_admin" } });
  if (existing) {
    console.log("[seed-admin] platform_admin already exists:", existing.email, "— skipping.");
    return;
  }

  const email = process.env.ADMIN_EMAIL ?? "admin@beauteavenue.local";
  const password = process.env.ADMIN_PASSWORD ?? "supersecure";
  const passwordHash = await argon2.hash(password);

  const admin = await prisma.user.create({
    data: {
      fullName: "Chef de Plateforme",
      email,
      passwordHash,
      role: "platform_admin"
    }
  });

  console.log("[seed-admin] platform_admin created:", admin.email);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
