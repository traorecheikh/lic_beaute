import { access, mkdir, writeFile } from "node:fs/promises";
import { dirname } from "node:path";

import { Client } from "pg";

export type DatabaseRuntime = {
  driver: "postgresql" | "sqlite";
  mode: "primary" | "fallback";
  attempts: number;
  url: string | null;
  filePath: string | null;
  reason: string | null;
};

type ResolveDatabaseRuntimeOptions = {
  nodeEnv: string;
  databaseUrl: string;
  sqliteDatabasePath: string;
  retries: number;
  retryDelayMs: number;
  probePostgres?: (databaseUrl: string) => Promise<void>;
  bootstrapSqlite?: (filePath: string) => Promise<void>;
};

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

export async function probePostgres(databaseUrl: string) {
  const client = new Client({
    connectionString: databaseUrl,
    connectionTimeoutMillis: 1_500
  });

  try {
    await client.connect();
    await client.query("select 1");
  } finally {
    await client.end().catch(() => undefined);
  }
}

export async function bootstrapSqlite(filePath: string) {
  await mkdir(dirname(filePath), { recursive: true });

  try {
    await access(filePath);
  } catch {
    await writeFile(filePath, "");
  }
}

export async function resolveDatabaseRuntime({
  nodeEnv,
  databaseUrl,
  sqliteDatabasePath,
  retries,
  retryDelayMs,
  probePostgres: customProbePostgres,
  bootstrapSqlite: customBootstrapSqlite
}: ResolveDatabaseRuntimeOptions): Promise<DatabaseRuntime> {
  const postgresProbe = customProbePostgres ?? probePostgres;
  const sqliteBootstrap = customBootstrapSqlite ?? bootstrapSqlite;

  let lastErrorMessage = "unknown_error";

  for (let attempt = 1; attempt <= retries; attempt += 1) {
    try {
      await postgresProbe(databaseUrl);

      return {
        driver: "postgresql",
        mode: "primary",
        attempts: attempt,
        url: databaseUrl,
        filePath: null,
        reason: null
      };
    } catch (error) {
      lastErrorMessage = error instanceof Error ? error.message : "unknown_error";

      if (attempt < retries) {
        await sleep(retryDelayMs);
      }
    }
  }

  if (nodeEnv === "development") {
    await sqliteBootstrap(sqliteDatabasePath);

    return {
      driver: "sqlite",
      mode: "fallback",
      attempts: retries,
      url: null,
      filePath: sqliteDatabasePath,
      reason: `postgres_unavailable:${lastErrorMessage}`
    };
  }

  throw new Error(`PostgreSQL unavailable after ${retries} attempts: ${lastErrorMessage}`);
}
