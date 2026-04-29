import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import dotenv from "dotenv";
import { PrismaClient } from "@prisma/client";

// Load .env from repo root regardless of which directory the process runs from.
// apps/api/src/lib → apps/api/src → apps/api → apps → repo root
const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), "../../../../");
dotenv.config({ path: resolve(repoRoot, ".env") });

export const prisma = new PrismaClient();
