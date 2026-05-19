import { spawnSync } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

const seedDir = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(seedDir, "../../..");

const result = spawnSync(
  "pnpm",
  ["--filter", "@beauteavenue/api", "exec", "tsx", "prisma/seed-impl.ts"],
  {
    stdio: "inherit",
    env: process.env,
    cwd: repoRoot
  }
);

if (result.error) {
  console.error(result.error);
  process.exit(1);
}

process.exit(result.status ?? 1);
