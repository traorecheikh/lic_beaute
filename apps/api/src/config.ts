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
  fcmServiceAccountJsonB64: process.env.FCM_SERVICE_ACCOUNT_JSON_B64 ?? "",
  paymentDriver: process.env.PAYMENT_DRIVER ?? "mock",
  intechApiKey: process.env.INTECH_API_KEY ?? "",
  intechApiSecret: process.env.INTECH_API_SECRET ?? "",
  intechEnv: (process.env.INTECH_ENV as "test" | "prod") ?? "test",
  intechBaseUrl: process.env.INTECH_BASE_URL ?? "https://api.intech.sn",
  intechCallbackHmacEnabled: (process.env.INTECH_CALLBACK_HMAC_ENABLED ?? "false") === "true",
  intechHmacSecretKey: process.env.INTECH_HMAC_SECRET_KEY ?? "",
  intechHmacMaxAgeMs: Number(process.env.INTECH_HMAC_MAX_AGE_MS ?? 5 * 60 * 1000),
  intechRequestTimeoutMs: Number(process.env.INTECH_REQUEST_TIMEOUT_MS ?? 65_000),
  atApiKey: process.env.AT_API_KEY ?? "",
  atUsername: process.env.AT_USERNAME ?? "",
  atSenderId: process.env.AT_SENDER_ID,
  storageDriver: process.env.STORAGE_DRIVER ?? "noop",
  storagePath: process.env.STORAGE_PATH ?? fileURLToPath(new URL("../.data/uploads", import.meta.url)),
  workerPollIntervalMs: Number(process.env.WORKER_POLL_INTERVAL_MS ?? 5000),
  workerBatchSize: Number(process.env.WORKER_BATCH_SIZE ?? 25),
  maxUploadBytes: Number(process.env.MAX_UPLOAD_BYTES ?? 15 * 1024 * 1024),
  paymentReconcileMinIntervalMs: Number(process.env.PAYMENT_RECONCILE_MIN_INTERVAL_MS ?? 15_000),
  r2AccountId: process.env.R2_ACCOUNT_ID ?? "",
  r2AccessKeyId: process.env.R2_ACCESS_KEY_ID ?? "",
  r2SecretAccessKey: process.env.R2_SECRET_ACCESS_KEY ?? "",
  r2Bucket: process.env.R2_BUCKET ?? "beauteavenu",
  mediaPublicBaseUrl: process.env.MEDIA_PUBLIC_BASE_URL ?? "https://media.beauteavenu.com"
};

export function validateConfig() {
  if (config.nodeEnv !== "development" && config.nodeEnv !== "test") {
    const issues: string[] = [];
    if (config.jwtAccessSecret === "dev-access-secret") {
      issues.push("JWT_ACCESS_SECRET is the development default");
    }
    if (config.jwtRefreshSecret === "dev-refresh-secret") {
      issues.push("JWT_REFRESH_SECRET is the development default");
    }
    if (
      config.databaseUrl ===
      "postgresql://postgres:postgres@localhost:5434/beaute_avenue?schema=public"
    ) {
      issues.push("DATABASE_URL uses default development credentials");
    }
    if (issues.length > 0) {
      throw new Error(
        `Production config validation failed:\n${issues.map((i) => `- ${i}`).join("\n")}`
      );
    }
  }
}
