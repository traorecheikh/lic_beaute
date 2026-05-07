import { createApp } from "./app.js";
import { config, validateConfig } from "./config.js";
import { resolveDatabaseRuntime } from "./lib/database-runtime.js";
import "./lib/push.js";

validateConfig();

const databaseRuntime = await resolveDatabaseRuntime({
  nodeEnv: config.nodeEnv,
  databaseUrl: config.databaseUrl,
  sqliteDatabasePath: config.sqliteDatabasePath,
  retries: config.databaseConnectRetries,
  retryDelayMs: config.databaseConnectRetryDelayMs
});

const app = await createApp({ databaseRuntime });

try {
  await app.listen({ port: config.apiPort, host: "0.0.0.0" });
  if (databaseRuntime.mode === "fallback") {
    app.log.warn(
      {
        driver: databaseRuntime.driver,
        filePath: databaseRuntime.filePath,
        attempts: databaseRuntime.attempts,
        reason: databaseRuntime.reason
      },
      "PostgreSQL unavailable, using SQLite fallback because NODE_ENV=development"
    );
  } else {
    app.log.info(
      {
        driver: databaseRuntime.driver,
        url: databaseRuntime.url,
        attempts: databaseRuntime.attempts
      },
      "Database runtime selected"
    );
  }
  app.log.info({ port: config.apiPort }, "API started");
} catch (error) {
  app.log.error(
    { error: error instanceof Error ? error.message : "unknown" },
    "API failed to start"
  );
  process.exit(1);
}

async function shutdown(signal: string) {
  app.log.info({ signal }, "Shutting down");
  try {
    await app.close();
  } catch (err) {
    app.log.error({ error: err instanceof Error ? err.message : "unknown" }, "Error closing server");
  }
  try {
    const { prisma } = await import("./lib/prisma.js");
    await prisma.$disconnect();
  } catch {}
  process.exit(0);
}

process.on("SIGTERM", () => shutdown("SIGTERM"));
process.on("SIGINT", () => shutdown("SIGINT"));
