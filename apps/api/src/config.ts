import { fileURLToPath } from "node:url";
import { resolve, isAbsolute } from "node:path";

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
  jwtAccessTtlSeconds: Number(process.env.JWT_ACCESS_TTL_SECONDS ?? 7200),
  jwtRefreshTtlSeconds: Number(process.env.JWT_REFRESH_TTL_SECONDS ?? 2592000),
  emailDriver: process.env.EMAIL_DRIVER ?? "noop",
  emailFrom: process.env.EMAIL_FROM ?? "noreply@beauteavenue.sn",
  brevoApiKey: process.env.BREVO_API_KEY ?? "",
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
  paydunyaPublicKey: process.env.PAYDUNYA_PUBLIC_KEY ?? "",
  paydunyaPrivateKey: process.env.PAYDUNYA_PRIVATE_KEY ?? "",
  paydunyaToken: process.env.PAYDUNYA_TOKEN ?? "",
  paydunyaEnv: (process.env.PAYDUNYA_ENV as "sandbox" | "production") ?? "sandbox",
  paydunyaBaseUrl: process.env.PAYDUNYA_BASE_URL ?? "https://app.paydunya.com",
  merchantPayoutEnabled: process.env.MERCHANT_PAYOUT_ENABLED !== "false",
  merchantPayoutHoldHours: Number(process.env.MERCHANT_PAYOUT_HOLD_HOURS ?? 24),
  merchantPayoutLowBalanceAlertLimit: Number(process.env.MERCHANT_PAYOUT_LOW_BALANCE_ALERT_LIMIT ?? 10000),
  paydunyaCallbackUrl: process.env.PAYDUNYA_DISBURSEMENT_CALLBACK_URL ?? "",
  prorationEnabled: process.env.PRORATION_ENABLED !== "false",
  atApiKey: process.env.AT_API_KEY ?? "",
  atUsername: process.env.AT_USERNAME ?? "",
  atSenderId: process.env.AT_SENDER_ID,
  storageDriver: process.env.STORAGE_DRIVER ?? "noop",
  storagePath: process.env.STORAGE_PATH
    ? isAbsolute(process.env.STORAGE_PATH)
      ? process.env.STORAGE_PATH
      : resolve(fileURLToPath(new URL("..", import.meta.url)), process.env.STORAGE_PATH)
    : fileURLToPath(new URL("../.data/uploads", import.meta.url)),
  subscriptionGracePeriodDays: Number(process.env.SUBSCRIPTION_GRACE_PERIOD_DAYS ?? 3),
  workerPollIntervalMs: Number(process.env.WORKER_POLL_INTERVAL_MS ?? 5000),
  workerBatchSize: Number(process.env.WORKER_BATCH_SIZE ?? 25),
  workerDriver: (process.env.WORKER_DRIVER as "db" | "bull" | "hybrid" | undefined) ?? "bull",
  redisUrl: process.env.REDIS_URL ?? "",
  restrictedFeatureEnabled: (process.env.RESTRICTED_FEATURE ?? "") === "on",
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
  mediaPublicBaseUrl: process.env.MEDIA_PUBLIC_BASE_URL ?? "https://media.beauteavenu.com",
  subscriptionExpiryEnabled: process.env.SUBSCRIPTION_EXPIRY_ENABLED !== "false"
};

const isStagingOrigin =
  /\.(sslip\.io|nip\.io)(:\d+)?$/.test(config.webOrigin) ||
  /^https?:\/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(:\d+)?\/?$/.test(config.webOrigin);

export function validateConfig() {
  if (config.nodeEnv !== "development" && config.nodeEnv !== "test") {
    const isRealProd = !isStagingOrigin;
    const issues: string[] = [];
    if (config.jwtAccessSecret === "dev-access-secret") {
      issues.push("JWT_ACCESS_SECRET is the development default");
    }
    if (config.jwtRefreshSecret === "dev-refresh-secret") {
      issues.push("JWT_REFRESH_SECRET is the development default");
    }
    if (config.paymentDriver === "mock") {
      if (isRealProd) {
        issues.push("PAYMENT_DRIVER=mock in production — all payments will silently succeed without real money");
      } else {
        issues.push("PAYMENT_DRIVER=mock in staging — payments are simulated. Set PAYMENT_DRIVER=paydunya for real payments.");
      }
    }
    if (config.storageDriver === "noop") {
      if (isRealProd) {
        issues.push("STORAGE_DRIVER=noop in production — all uploaded files will be silently discarded");
      } else {
        issues.push("STORAGE_DRIVER=noop in staging — uploads are discarded. Set STORAGE_DRIVER=local or r2.");
      }
    }
    if (config.otpDriver === "noop") {
      if (isRealProd) {
        issues.push("OTP_DRIVER=noop in production — any OTP code will authenticate any phone number");
      } else {
        issues.push("OTP_DRIVER=noop in staging — OTP is bypassed, any code authenticates. Set OTP_DRIVER=africastalking.");
      }
    }
    if (config.emailDriver === "noop") {
      if (isRealProd) {
        issues.push("EMAIL_DRIVER=noop in production — no emails will be sent (invites, confirmations, alerts)");
      } else {
        issues.push("EMAIL_DRIVER=noop in staging — no emails sent. Set EMAIL_DRIVER=brevo, resend, or smtp.");
      }
    }
    if (config.pushDriver === "fcm" && !config.fcmServiceAccountJsonB64) {
      issues.push("FCM_SERVICE_ACCOUNT_JSON_B64 is required when PUSH_DRIVER=fcm");
    }
    if (isRealProd && !config.redisUrl) {
      console.warn("[config] WARNING: REDIS_URL not set — rate limiting will use in-memory store (not distributed)");
    }
    if (config.emailDriver === "brevo" && !config.brevoApiKey) {
      issues.push("BREVO_API_KEY is required when EMAIL_DRIVER=brevo");
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
    if (!isStagingOrigin && !config.webOrigin.startsWith("https://")) {
      issues.push(`WEB_ORIGIN must start with https:// in production, got: ${config.webOrigin}`);
    }
    if (config.paymentDriver === "paydunya" || config.merchantPayoutEnabled) {
      if (!config.paydunyaMasterKey) {
        issues.push("PAYDUNYA_MASTER_KEY is required when PAYMENT_DRIVER=paydunya or merchant payouts are enabled");
      }
      if (!config.paydunyaPublicKey) {
        issues.push("PAYDUNYA_PUBLIC_KEY is required when PAYMENT_DRIVER=paydunya or merchant payouts are enabled");
      }
      if (!config.paydunyaPrivateKey) {
        issues.push("PAYDUNYA_PRIVATE_KEY is required when PAYMENT_DRIVER=paydunya or merchant payouts are enabled");
      }
      if (!config.paydunyaToken) {
        issues.push("PAYDUNYA_TOKEN is required when PAYMENT_DRIVER=paydunya or merchant payouts are enabled");
      }
    }
    if (config.merchantPayoutEnabled && !config.paydunyaCallbackUrl) {
      issues.push("PAYDUNYA_DISBURSEMENT_CALLBACK_URL is required when merchant payouts are enabled");
    }
    if (config.billingAccountSecret.length < 16 && (config.merchantPayoutEnabled || config.paymentDriver === "paydunya")) {
      issues.push("BILLING_ACCOUNT_SECRET must be at least 16 characters when merchant payouts or paydunya are enabled");
    }
    if (issues.length > 0) {
      throw new Error(
        `Production config validation failed:\n${issues.map((i) => `- ${i}`).join("\n")}`
      );
    }
  }
}
