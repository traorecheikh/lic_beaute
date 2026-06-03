import { describe, expect, it, vi } from "vitest";

vi.mock("dotenv/config", () => ({}));

async function loadConfigWithEnv(env: Record<string, string | undefined>) {
  const prev = { ...process.env };
  for (const [k, v] of Object.entries(env)) {
    if (v === undefined) delete process.env[k];
    else process.env[k] = v;
  }
  vi.resetModules();
  const mod = await import("./config.js");
  process.env = prev;
  return mod;
}

describe("config", () => {
  it("uses development defaults", async () => {
    const { config } = await loadConfigWithEnv({ PAYMENT_DRIVER: undefined, NODE_ENV: "development", WEB_ORIGIN: undefined });
    expect(config.nodeEnv).toBe("development");
    expect(config.apiPort).toBe(3000);
    expect(config.webOrigin).toBe("http://localhost:5174");
    expect(config.cacheEnabled).toBe(true);
    expect(config.paymentDriver).toBe("mock");
  });

  it("parses typed env values", async () => {
    const { config } = await loadConfigWithEnv({
      PAYMENT_DRIVER: "paydunya",
      NODE_ENV: "test",
      API_PORT: "4100",
      CACHE_ENABLED: "false",
      QUEUE_CONCURRENCY_PAYMENTS: "7",
      MAX_UPLOAD_BYTES: "123"
    });

    expect(config.apiPort).toBe(4100);
    expect(config.cacheEnabled).toBe(false);
    expect(config.paymentDriver).toBe("paydunya");
    expect(config.queueConcurrencyPayments).toBe(7);
    expect(config.maxUploadBytes).toBe(123);
  });

  it("validateConfig allows non-production env", async () => {
    const { validateConfig } = await loadConfigWithEnv({ NODE_ENV: "test" });
    expect(() => validateConfig()).not.toThrow();
  });

  it("validateConfig blocks unsafe production config", async () => {
    const { validateConfig } = await loadConfigWithEnv({
      NODE_ENV: "production",
      JWT_ACCESS_SECRET: "dev-access-secret",
      JWT_REFRESH_SECRET: "dev-refresh-secret",
      WEB_ORIGIN: "*",
      DATABASE_URL: "postgresql://postgres:postgres@localhost:5434/beaute_avenue?schema=public"
    });

    expect(() => validateConfig()).toThrowError(/Production config validation failed/);
  });

  it("validateConfig enforces paydunya requirements", async () => {
    const { validateConfig } = await loadConfigWithEnv({
      NODE_ENV: "production",
      JWT_ACCESS_SECRET: "x",
      JWT_REFRESH_SECRET: "y",
      WEB_ORIGIN: "https://admin.example.com",
      DATABASE_URL: "postgresql://prod/prod",
      PAYMENT_DRIVER: "paydunya",
      PAYDUNYA_MASTER_KEY: "",
      PAYDUNYA_PRIVATE_KEY: "",
      PAYDUNYA_TOKEN: ""
    });

    expect(() => validateConfig()).toThrowError(/PAYDUNYA_MASTER_KEY is required/);
    expect(() => validateConfig()).toThrowError(/PAYDUNYA_PRIVATE_KEY is required/);
    expect(() => validateConfig()).toThrowError(/PAYDUNYA_TOKEN is required/);
  });

  it("reads NODE_ENV fallback when env var is missing", async () => {
    const { config } = await loadConfigWithEnv({ NODE_ENV: undefined });
    expect(config.nodeEnv).toBe("development");
  });

  it("validateConfig passes with safe production config", async () => {
    const { validateConfig } = await loadConfigWithEnv({
      NODE_ENV: "production",
      JWT_ACCESS_SECRET: "prod-access",
      JWT_REFRESH_SECRET: "prod-refresh",
      JWT_INVITE_SECRET: "prod-invite",
      WEB_ORIGIN: "https://admin.example.com",
      DATABASE_URL: "postgresql://prod/prod",
      PAYMENT_DRIVER: "paydunya",
      PAYDUNYA_MASTER_KEY: "master-key",
      PAYDUNYA_PUBLIC_KEY: "public-key",
      PAYDUNYA_PRIVATE_KEY: "private-key",
      PAYDUNYA_TOKEN: "token",
      STORAGE_DRIVER: "r2",
      OTP_DRIVER: "africastalking",
      EMAIL_DRIVER: "smtp",
      FCM_SERVICE_ACCOUNT_JSON_B64: "ZmFrZQ=="
    });

    expect(() => validateConfig()).not.toThrow();
  });
});
