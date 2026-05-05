import { fileURLToPath } from "node:url";

import "dotenv/config";

export const config = {
  nodeEnv: process.env.NODE_ENV ?? "development",
  apiPort: Number(process.env.API_PORT ?? 3000),
  webOrigin: process.env.WEB_ORIGIN ?? "http://localhost:5174",
  databaseUrl:
    process.env.DATABASE_URL ??
    "postgresql://postgres:postgres@localhost:5434/beaute_avenue?schema=public",
  sqliteDatabasePath:
    process.env.SQLITE_DATABASE_PATH ??
    fileURLToPath(new URL("../.data/beauteavenue.dev.sqlite", import.meta.url)),
  databaseConnectRetries: Number(process.env.DATABASE_CONNECT_RETRIES ?? 3),
  databaseConnectRetryDelayMs: Number(process.env.DATABASE_CONNECT_RETRY_DELAY_MS ?? 750),
  jwtAccessSecret: process.env.JWT_ACCESS_SECRET ?? "dev-access-secret",
  jwtRefreshSecret: process.env.JWT_REFRESH_SECRET ?? "dev-refresh-secret",
  jwtAccessTtlSeconds: Number(process.env.JWT_ACCESS_TTL_SECONDS ?? 900),
  jwtRefreshTtlSeconds: Number(process.env.JWT_REFRESH_TTL_SECONDS ?? 2592000),
  emailDriver: process.env.EMAIL_DRIVER ?? "noop",
  otpDriver: process.env.OTP_DRIVER ?? "noop",
  pushDriver: process.env.PUSH_DRIVER ?? "fcm",
  paymentDriver: process.env.PAYMENT_DRIVER ?? "mock",
  paytechApiKey: process.env.PAYTECH_API_KEY ?? "",
  paytechApiSecret: process.env.PAYTECH_API_SECRET ?? "",
  paytechEnv: (process.env.PAYTECH_ENV as "test" | "prod") ?? "test",
  storageDriver: process.env.STORAGE_DRIVER ?? "noop",
  workerPollIntervalMs: Number(process.env.WORKER_POLL_INTERVAL_MS ?? 5000),
  workerBatchSize: Number(process.env.WORKER_BATCH_SIZE ?? 25),
  maxUploadBytes: Number(process.env.MAX_UPLOAD_BYTES ?? 15 * 1024 * 1024)
};
