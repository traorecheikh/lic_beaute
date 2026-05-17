import { beforeEach, describe, expect, it, vi } from "vitest";

describe("adapters index", () => {
  beforeEach(() => {
    vi.resetModules();
  });

  it("creates OTP adapters and validates AT config", async () => {
    const mod = await import("./index.js");
    expect(() => mod.createOtpAdapter("at", { atApiKey: "", atUsername: "" })).toThrow(/AT_API_KEY/);
    const noop = mod.createOtpAdapter("noop", {});
    expect(noop.constructor.name).toBe("NoopOtpAdapter");
    const at = mod.createOtpAdapter("africastalking", { atApiKey: "k", atUsername: "u" });
    expect(at.constructor.name).toBe("AfricasTalkingOtpAdapter");
  });

  it("creates and caches storage adapters by first call", async () => {
    const mod = await import("./index.js");
    const local = mod.getStorageAdapter("local", { storagePath: "/tmp/uploads" });
    expect(local.constructor.name).toBe("LocalStorageAdapter");
    const stillLocal = mod.getStorageAdapter("r2", {
      r2AccountId: "a",
      r2AccessKeyId: "k",
      r2SecretAccessKey: "s",
      r2Bucket: "b"
    });
    expect(stillLocal).toBe(local);
    expect(mod.getR2Adapter()).toBeNull();
  });

  it("creates local storage with default path when storagePath is omitted", async () => {
    const mod = await import("./index.js");
    const local = mod.getStorageAdapter("local", {});
    expect(local.constructor.name).toBe("LocalStorageAdapter");
  });

  it("creates R2 storage and exposes getR2Adapter", async () => {
    const mod = await import("./index.js");
    const r2 = mod.getStorageAdapter("r2", {
      r2AccountId: "a",
      r2AccessKeyId: "k",
      r2SecretAccessKey: "s",
      r2Bucket: "b",
      mediaPublicBaseUrl: "https://media.example.com"
    });
    expect(r2.constructor.name).toBe("R2StorageAdapter");
    expect(mod.getR2Adapter()).toBe(r2);
    expect(mod.createStorageAdapter("local", { storagePath: "/tmp/x" })).toBe(r2);
  });

  it("falls back to noop storage adapter for unknown driver", async () => {
    const mod = await import("./index.js");
    const storage = mod.getStorageAdapter("unknown", {});
    expect(storage.constructor.name).toBe("NoopStorageAdapter");
    expect(mod.getR2Adapter()).toBeNull();
  });

  it("creates R2 storage with default fallback values", async () => {
    const mod = await import("./index.js");
    const r2 = mod.getStorageAdapter("r2", {});
    expect(r2.constructor.name).toBe("R2StorageAdapter");
  });

  it("creates payment adapters and validates intech API key", async () => {
    const mod = await import("./index.js");
    expect(() =>
      mod.createPaymentAdapter("intech", {
        baseOrigin: "http://localhost:3000"
      })
    ).toThrow(/INTECH_API_KEY/);
    const mock = mod.createPaymentAdapter("mock", { baseOrigin: "http://localhost:3000" });
    expect(mock.constructor.name).toBe("MockPaymentAdapter");
    const cached = mod.getPaymentAdapter("mock", { baseOrigin: "http://localhost:3000" });
    expect(cached).toBe(mod.getPaymentAdapter("intech", { baseOrigin: "http://localhost:3000", intechApiKey: "x" }));
  });

  it("covers payment/otp factory default and intech success branches", async () => {
    const mod = await import("./index.js");
    const otp = mod.createOtpAdapter("at", { atApiKey: "k", atUsername: "u", atSenderId: "SENDER" });
    expect(otp.constructor.name).toBe("AfricasTalkingOtpAdapter");

    const fallbackPayment = mod.createPaymentAdapter("unknown", { baseOrigin: "http://localhost:3000" });
    expect(fallbackPayment.constructor.name).toBe("MockPaymentAdapter");

    const intech = mod.createPaymentAdapter("intech", {
      baseOrigin: "http://localhost:3000",
      intechApiKey: "api-key",
      intechBaseUrl: "https://api.intech.sn",
      intechCallbackHmacEnabled: true,
      intechHmacSecretKey: "secret",
      intechHmacMaxAgeMs: 1000,
      intechRequestTimeoutMs: 2000
    });
    expect(intech.constructor.name).toBe("IntechAdapter");
  });

  it("creates intech adapter with default optional config values", async () => {
    const mod = await import("./index.js");
    const intech = mod.createPaymentAdapter("intech", {
      baseOrigin: "http://localhost:3000",
      intechApiKey: "api-key"
    });
    expect(intech.constructor.name).toBe("IntechAdapter");
  });
});
