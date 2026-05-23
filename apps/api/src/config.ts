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
  jwtInviteSecret: process.env.JWT_INVITE_SECRET ?? "dev-invite-secret",
  jwtAccessTtlSeconds: Number(process.env.JWT_ACCESS_TTL_SECONDS ?? 900),
  jwtRefreshTtlSeconds: Number(process.env.JWT_REFRESH_TTL_SECONDS ?? 2592000),
  emailDriver: process.env.EMAIL_DRIVER ?? "noop",
  emailFrom: process.env.EMAIL_FROM ?? "noreply@beauteavenue.sn",
  resendApiKey: process.env.RESEND_API_KEY ?? "",
  smtpHost: process.env.SMTP_HOST ?? "",
  smtpPort: Number(process.env.SMTP_PORT ?? 587),
  smtpUser: process.env.SMTP_USER ?? "",
  smtpPass: process.env.SMTP_PASS ?? "",
  otpDriver: process.env.OTP_DRIVER ?? "noop",
  pushDriver: process.env.PUSH_DRIVER ?? "fcm",
  fcmServiceAccountJsonB64: process.env.FCM_SERVICE_ACCOUNT_JSON_B64 ?? "",
  paymentDriver: process.env.PAYMENT_DRIVER ?? "mock",
  paydunyaMasterKey: process.env.PAYDUNYA_MASTER_KEY ?? "",
  paydunyaPrivateKey: process.env.PAYDUNYA_PRIVATE_KEY ?? "",
  paydunyaToken: process.env.PAYDUNYA_TOKEN ?? "",
  paydunyaEnv: (process.env.PAYDUNYA_ENV as "sandbox" | "production") ?? "sandbox",
  paydunyaBaseUrl: process.env.PAYDUNYA_BASE_URL ?? "https://app.paydunya.com",
  atApiKey: process.env.AT_API_KEY ?? "",
  atUsername: process.env.AT_USERNAME ?? "",
  atSenderId: process.env.AT_SENDER_ID,
  storageDriver: process.env.STORAGE_DRIVER ?? "noop",
  storagePath: process.env.STORAGE_PATH ?? fileURLToPath(new URL("../.data/uploads", import.meta.url)),
  workerPollIntervalMs: Number(process.env.WORKER_POLL_INTERVAL_MS ?? 5000),
  workerBatchSize: Number(process.env.WORKER_BATCH_SIZE ?? 25),
  workerDriver: (process.env.WORKER_DRIVER as "db" | "bull" | "hybrid" | undefined) ?? "hybrid",
  redisUrl: process.env.REDIS_URL ?? "",
  cacheEnabled: (process.env.CACHE_ENABLED ?? "true") === "true",
  cacheVersion: process.env.CACHE_VERSION ?? "v1",
  cacheTtlCatalogSeconds: Number(process.env.CACHE_TTL_CATALOG_SECONDS ?? 45),
  cacheTtlKpiSeconds: Number(process.env.CACHE_TTL_KPI_SECONDS ?? 20),
  queueConcurrencyPayments: Number(process.env.QUEUE_CONCURRENCY_PAYMENTS ?? 3),
  queueConcurrencyNotifications: Number(process.env.QUEUE_CONCURRENCY_NOTIFICATIONS ?? 8),
  queueConcurrencyMaintenance: Number(process.env.QUEUE_CONCURRENCY_MAINTENANCE ?? 2),
  maxUploadBytes: Number(process.env.MAX_UPLOAD_BYTES ?? 15 * 1024 * 1024),
  paymentReconcileMinIntervalMs: Number(process.env.PAYMENT_RECONCILE_MIN_INTERVAL_MS ?? 15_000),
  billingAccountSecret: process.env.BILLING_ACCOUNT_SECRET ?? "",
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
    if (config.jwtInviteSecret === "dev-invite-secret") {
      issues.push("JWT_INVITE_SECRET is the development default");
    }
    if (config.paymentDriver === "mock") {
      issues.push("PAYMENT_DRIVER=mock in production — all payments will silently succeed without real money");
    }
    if (config.storageDriver === "noop") {
      issues.push("STORAGE_DRIVER=noop in production — all uploaded files will be silently discarded");
    }
    if (config.otpDriver === "noop") {
      issues.push("OTP_DRIVER=noop in production — any OTP code will authenticate any phone number");
    }
    if (config.emailDriver === "noop") {
      issues.push("EMAIL_DRIVER=noop in production — no emails will be sent (invites, confirmations, alerts)");
    }
    if (
      config.databaseUrl ===
      "postgresql://postgres:postgres@localhost:5434/beaute_avenue?schema=public"
    ) {
      issues.push("DATABASE_URL uses default development credentials");
    }
    if (config.webOrigin === "*") {
      issues.push("WEB_ORIGIN must not be '*' in production — CORS would be fully open");
    }
    const isStagingOrigin =
      /\.(sslip\.io|nip\.io)(:\d+)?$/.test(config.webOrigin) ||
      /^https?:\/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(:\d+)?\/?$/.test(config.webOrigin);
    if (!isStagingOrigin && !config.webOrigin.startsWith("https://")) {
      issues.push(`WEB_ORIGIN must start with https:// in production, got: ${config.webOrigin}`);
    }
    if (config.paymentDriver === "paydunya") {
      if (!config.paydunyaMasterKey) {
        issues.push("PAYDUNYA_MASTER_KEY is required when PAYMENT_DRIVER=paydunya");
      }
      if (!config.paydunyaPrivateKey) {
        issues.push("PAYDUNYA_PRIVATE_KEY is required when PAYMENT_DRIVER=paydunya");
      }
      if (!config.paydunyaToken) {
        issues.push("PAYDUNYA_TOKEN is required when PAYMENT_DRIVER=paydunya");
      }
    }
    if (issues.length > 0) {
      throw new Error(
        `Production config validation failed:\n${issues.map((i) => `- ${i}`).join("\n")}`
      );
    }
  }
}
