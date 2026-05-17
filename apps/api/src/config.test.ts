import { describe, expect, it, vi } from "vitest";

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
    const { config } = await loadConfigWithEnv({ NODE_ENV: "development", WEB_ORIGIN: undefined });
    expect(config.nodeEnv).toBe("development");
    expect(config.apiPort).toBe(3000);
    expect(config.webOrigin).toBe("http://localhost:5174");
    expect(config.cacheEnabled).toBe(true);
    expect(config.intechCallbackHmacEnabled).toBe(false);
  });

  it("parses typed env values", async () => {
    const { config } = await loadConfigWithEnv({
      NODE_ENV: "test",
      API_PORT: "4100",
      CACHE_ENABLED: "false",
      INTECH_CALLBACK_HMAC_ENABLED: "true",
      QUEUE_CONCURRENCY_PAYMENTS: "7",
      MAX_UPLOAD_BYTES: "123"
    });

    expect(config.apiPort).toBe(4100);
    expect(config.cacheEnabled).toBe(false);
    expect(config.intechCallbackHmacEnabled).toBe(true);
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

  it("validateConfig enforces intech requirements", async () => {
    const { validateConfig } = await loadConfigWithEnv({
      NODE_ENV: "production",
      JWT_ACCESS_SECRET: "x",
      JWT_REFRESH_SECRET: "y",
      WEB_ORIGIN: "https://admin.example.com",
      DATABASE_URL: "postgresql://prod/prod",
      PAYMENT_DRIVER: "intech",
      INTECH_CALLBACK_HMAC_ENABLED: "false",
      INTECH_API_KEY: "",
      INTECH_HMAC_SECRET_KEY: ""
    });

    expect(() => validateConfig()).toThrowError(/INTECH_CALLBACK_HMAC_ENABLED must be true/);
  });

  it("validateConfig surfaces API key and HMAC key requirements when callback HMAC is enabled", async () => {
    const { validateConfig } = await loadConfigWithEnv({
      NODE_ENV: "production",
      JWT_ACCESS_SECRET: "x",
      JWT_REFRESH_SECRET: "y",
      WEB_ORIGIN: "https://admin.example.com",
      DATABASE_URL: "postgresql://prod/prod",
      PAYMENT_DRIVER: "intech",
      INTECH_CALLBACK_HMAC_ENABLED: "true",
      INTECH_API_KEY: "",
      INTECH_HMAC_SECRET_KEY: ""
    });
    expect(() => validateConfig()).toThrowError(/INTECH_API_KEY is required/);
    expect(() => validateConfig()).toThrowError(/INTECH_HMAC_SECRET_KEY is required/);
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
      WEB_ORIGIN: "https://admin.example.com",
      DATABASE_URL: "postgresql://prod/prod",
      PAYMENT_DRIVER: "mock"
    });

    expect(() => validateConfig()).not.toThrow();
  });

  it("validateConfig passes for production intech config with required keys", async () => {
    const { validateConfig } = await loadConfigWithEnv({
      NODE_ENV: "production",
      JWT_ACCESS_SECRET: "prod-access",
      JWT_REFRESH_SECRET: "prod-refresh",
      WEB_ORIGIN: "https://admin.example.com",
      DATABASE_URL: "postgresql://prod/prod",
      PAYMENT_DRIVER: "intech",
      INTECH_CALLBACK_HMAC_ENABLED: "true",
      INTECH_API_KEY: "api-key",
      INTECH_HMAC_SECRET_KEY: "hmac-secret"
    });
    expect(() => validateConfig()).not.toThrow();
  });
});
