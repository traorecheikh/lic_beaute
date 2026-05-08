import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import dotenv from "dotenv";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../../generated/prisma/client.js";
import { config } from "../../config.js";

// Load .env from repo root regardless of which directory the process runs from.
// apps/api/src/lib → apps/api/src → apps/api → apps → repo root
const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), "../../../../");
dotenv.config({ path: resolve(repoRoot, ".env") });

let _instance: PrismaClient | null = null;

export function getPrisma(): PrismaClient {
  if (!_instance) {
    const connectionString = process.env.DATABASE_URL ?? config.databaseUrl;
    const adapter = new PrismaPg({ connectionString });
    _instance = new PrismaClient({ adapter });
  }
  return _instance;
}

export function setPrisma(client: PrismaClient): void {
  _instance = client;
}

export const prisma: PrismaClient = new Proxy({} as PrismaClient, {
  get(_, prop) {
    return (getPrisma() as any)[prop];
  }
});
