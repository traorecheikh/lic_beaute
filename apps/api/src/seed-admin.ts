import "dotenv/config";

import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "./generated/prisma/client.js";
import bcrypt from "bcrypt";

const adapter = new PrismaPg({
  connectionString:
    process.env.DATABASE_URL ??
    "postgresql://postgres:postgres@localhost:5434/beaute_avenue?schema=public"
});
const prisma = new PrismaClient({ adapter });

async function main() {
  const email = "admin@beauteavenue.local";
  const password = "supersecure";
  const hashedPassword = await bcrypt.hash(password, 10);

  const admin = await prisma.user.upsert({
    where: { email },
    update: { passwordHash: hashedPassword },
    create: {
      fullName: "Chef de Plateforme",
      email,
      passwordHash: hashedPassword,
      role: "platform_admin"
    }
  });

  console.log("Admin user created/updated:", admin.email);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
