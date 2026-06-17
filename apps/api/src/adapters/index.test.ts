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

  it("creates and caches local storage adapter by first call", async () => {
    const mod = await import("./index.js");
    const local = mod.getStorageAdapter("local", { storagePath: "/tmp/uploads" });
    expect(local.constructor.name).toBe("LocalStorageAdapter");
    const stillLocal = mod.getStorageAdapter("unknown", {});
    expect(stillLocal).toBe(local);
    expect(mod.createStorageAdapter("local", { storagePath: "/tmp/x" })).toBe(local);
  });

  it("creates local storage with default path when storagePath is omitted", async () => {
    const mod = await import("./index.js");
    const local = mod.getStorageAdapter("local", {});
    expect(local.constructor.name).toBe("LocalStorageAdapter");
  });

  it("falls back to noop storage adapter for unknown driver", async () => {
    const mod = await import("./index.js");
    const storage = mod.getStorageAdapter("unknown", {});
    expect(storage.constructor.name).toBe("NoopStorageAdapter");
  });

  it("creates payment adapters and validates PayDunya master key", async () => {
    const mod = await import("./index.js");
    expect(() =>
      mod.createPaymentAdapter("paydunya", {
        baseOrigin: "http://localhost:3000"
      })
    ).toThrow(/PAYDUNYA_MASTER_KEY/);
    const mock = mod.createPaymentAdapter("mock", { baseOrigin: "http://localhost:3000" });
    expect(mock.constructor.name).toBe("MockPaymentAdapter");
    const cached = mod.getPaymentAdapter("mock", { baseOrigin: "http://localhost:3000" });
    expect(cached).toBe(mod.getPaymentAdapter("mock", { baseOrigin: "http://localhost:3000" }));
  });

  it("covers payment/otp factory default and paydunya success branches", async () => {
    const mod = await import("./index.js");
    const otp = mod.createOtpAdapter("at", { atApiKey: "k", atUsername: "u", atSenderId: "SENDER" });
    expect(otp.constructor.name).toBe("AfricasTalkingOtpAdapter");

    const fallbackPayment = mod.createPaymentAdapter("unknown", { baseOrigin: "http://localhost:3000" });
    expect(fallbackPayment.constructor.name).toBe("MockPaymentAdapter");

    const paydunya = mod.createPaymentAdapter("paydunya", {
      baseOrigin: "http://localhost:3000",
      paydunyaMasterKey: "master-key",
      paydunyaPublicKey: "public-key",
      paydunyaPrivateKey: "private-key",
      paydunyaToken: "token",
      paydunyaEnv: "sandbox",
      paydunyaBaseUrl: "https://sandbox.paydunya.com"
    });
    expect(paydunya.constructor.name).toBe("PayDunyaAdapter");
  });
});
