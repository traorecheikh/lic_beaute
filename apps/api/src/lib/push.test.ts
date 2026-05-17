import { beforeEach, describe, expect, it, vi } from "vitest";

describe("push module", () => {
  beforeEach(() => {
    vi.resetModules();
    vi.clearAllMocks();
    vi.unstubAllGlobals();
  });

  it("throws in production when FCM base64 is missing", async () => {
    vi.doMock("../config.js", () => ({
      config: { pushDriver: "fcm", fcmServiceAccountJsonB64: "", nodeEnv: "production" }
    }));
    vi.doMock("./logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./db/prisma.js", () => ({ prisma: { pushToken: { updateMany: vi.fn() } } }));

    await expect(import("./push.js")).rejects.toThrow(/required in production/);
  });

  it("warns and skips send when no account in development", async () => {
    const warn = vi.fn();
    const error = vi.fn();
    vi.doMock("../config.js", () => ({
      config: { pushDriver: "fcm", fcmServiceAccountJsonB64: "", nodeEnv: "development" }
    }));
    vi.doMock("./logger.js", () => ({ logger: { warn, error, info: vi.fn() } }));
    vi.doMock("./db/prisma.js", () => ({ prisma: { pushToken: { updateMany: vi.fn() } } }));

    const mod = await import("./push.js");
    await mod.sendPush("token1", { title: "t", body: "b" });
    await mod.sendPushBatch(["t1", "t2"], { title: "t", body: "b" });

    expect(warn).toHaveBeenCalled();
    expect(error).not.toHaveBeenCalled();
  });

  it("noops when push driver is not fcm", async () => {
    const warn = vi.fn();
    vi.doMock("../config.js", () => ({
      config: { pushDriver: "noop", fcmServiceAccountJsonB64: "", nodeEnv: "development" }
    }));
    vi.doMock("./logger.js", () => ({ logger: { warn, error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./db/prisma.js", () => ({ prisma: { pushToken: { updateMany: vi.fn() } } }));
    const mod = await import("./push.js");
    await mod.sendPush("token1", { title: "t", body: "b" });
    expect(warn).toHaveBeenCalledWith("[PUSH] sendPush skipped — no FCM service account available", { pushToken: "token1" });
  });

  it("throws in production when FCM base64 is invalid", async () => {
    vi.doMock("../config.js", () => ({
      config: { pushDriver: "fcm", fcmServiceAccountJsonB64: "%%%bad%%%", nodeEnv: "production" }
    }));
    vi.doMock("./logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./db/prisma.js", () => ({ prisma: { pushToken: { updateMany: vi.fn() } } }));
    await expect(import("./push.js")).rejects.toThrow(/decode failed/);
  });

  it("warns in development when FCM service account misses required fields", async () => {
    const warn = vi.fn();
    const service = Buffer.from(JSON.stringify({ project_id: "p1" }), "utf8").toString("base64");
    vi.doMock("../config.js", () => ({
      config: { pushDriver: "fcm", fcmServiceAccountJsonB64: service, nodeEnv: "development" }
    }));
    vi.doMock("./logger.js", () => ({ logger: { warn, error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./db/prisma.js", () => ({ prisma: { pushToken: { updateMany: vi.fn() } } }));
    const mod = await import("./push.js");
    await mod.sendPush("token1", { title: "t", body: "b" });
    expect(warn).toHaveBeenCalled();
  });

  it("revokes dead token on 400/404 failures", async () => {
    const updateMany = vi.fn(async () => ({ count: 1 }));
    const info = vi.fn();
    const error = vi.fn();

    const service = Buffer.from(
      JSON.stringify({ project_id: "p1", client_email: "x@y.z", private_key: "---KEY---" }),
      "utf8"
    ).toString("base64");

    vi.doMock("../config.js", () => ({
      config: { pushDriver: "fcm", fcmServiceAccountJsonB64: service, nodeEnv: "development" }
    }));
    vi.doMock("./logger.js", () => ({ logger: { warn: vi.fn(), error, info } }));
    vi.doMock("./db/prisma.js", () => ({ prisma: { pushToken: { updateMany } } }));
    vi.doMock("node:crypto", () => ({
      default: {
        sign: vi.fn(() => Buffer.from("sig")),
        constants: { RSA_PKCS1_PADDING: 1 }
      }
    }));

    const fetchMock = vi
      .fn()
      .mockResolvedValueOnce({ ok: true, json: async () => ({ access_token: "token", expires_in: 1 }) })
      .mockResolvedValueOnce({ ok: false, status: 400, text: async () => "bad token" });
    vi.stubGlobal("fetch", fetchMock as any);

    const mod = await import("./push.js");
    await mod.sendPush("bad-token", { title: "T", body: "B" });

    expect(updateMany).toHaveBeenCalled();
    expect(error).toHaveBeenCalledWith("[PUSH] FCM delivery failed", expect.anything());
    expect(info).not.toHaveBeenCalled();
  });

  it("revokes dead token on 404 responses too", async () => {
    const updateMany = vi.fn(async () => ({ count: 1 }));
    const service = Buffer.from(
      JSON.stringify({ project_id: "p1", client_email: "x@y.z", private_key: "---KEY---" }),
      "utf8"
    ).toString("base64");
    vi.doMock("../config.js", () => ({
      config: { pushDriver: "fcm", fcmServiceAccountJsonB64: service, nodeEnv: "development" }
    }));
    vi.doMock("./logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./db/prisma.js", () => ({ prisma: { pushToken: { updateMany } } }));
    vi.doMock("node:crypto", () => ({
      default: {
        sign: vi.fn(() => Buffer.from("sig")),
        constants: { RSA_PKCS1_PADDING: 1 }
      }
    }));
    const fetchMock = vi
      .fn()
      .mockResolvedValueOnce({ ok: true, json: async () => ({ access_token: "token", expires_in: 1 }) })
      .mockResolvedValueOnce({ ok: false, status: 404, text: async () => "not found" });
    vi.stubGlobal("fetch", fetchMock as any);
    const mod = await import("./push.js");
    await mod.sendPush("dead-token", { title: "T", body: "B" });
    expect(updateMany).toHaveBeenCalled();
  });

  it("does not revoke token on non-terminal FCM failure status", async () => {
    const updateMany = vi.fn(async () => ({ count: 1 }));
    const service = Buffer.from(
      JSON.stringify({ project_id: "p1", client_email: "x@y.z", private_key: "---KEY---" }),
      "utf8"
    ).toString("base64");
    vi.doMock("../config.js", () => ({
      config: { pushDriver: "fcm", fcmServiceAccountJsonB64: service, nodeEnv: "development" }
    }));
    vi.doMock("./logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./db/prisma.js", () => ({ prisma: { pushToken: { updateMany } } }));
    vi.doMock("node:crypto", () => ({
      default: { sign: vi.fn(() => Buffer.from("sig")), constants: { RSA_PKCS1_PADDING: 1 } }
    }));
    const fetchMock = vi
      .fn()
      .mockResolvedValueOnce({ ok: true, json: async () => ({ access_token: "token", expires_in: 1 }) })
      .mockResolvedValueOnce({ ok: false, status: 500, text: async () => "server error" });
    vi.stubGlobal("fetch", fetchMock as any);
    const mod = await import("./push.js");
    await mod.sendPush("retry-token", { title: "T", body: "B" });
    expect(updateMany).not.toHaveBeenCalled();
  });

  it("logs success and reuses cached OAuth token", async () => {
    const info = vi.fn();
    const service = Buffer.from(
      JSON.stringify({ project_id: "p1", client_email: "x@y.z", private_key: "---KEY---" }),
      "utf8"
    ).toString("base64");

    vi.doMock("../config.js", () => ({
      config: { pushDriver: "fcm", fcmServiceAccountJsonB64: service, nodeEnv: "development" }
    }));
    vi.doMock("./logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info } }));
    vi.doMock("./db/prisma.js", () => ({ prisma: { pushToken: { updateMany: vi.fn() } } }));
    vi.doMock("node:crypto", () => ({
      default: {
        sign: vi.fn(() => Buffer.from("sig")),
        constants: { RSA_PKCS1_PADDING: 1 }
      }
    }));

    const fetchMock = vi
      .fn()
      .mockResolvedValueOnce({ ok: true, json: async () => ({ access_token: "token", expires_in: 3600 }) })
      .mockResolvedValueOnce({ ok: true, status: 200, text: async () => "", json: async () => ({}) })
      .mockResolvedValueOnce({ ok: true, status: 200, text: async () => "", json: async () => ({}) });
    vi.stubGlobal("fetch", fetchMock as any);

    const mod = await import("./push.js");
    await mod.sendPush("token-1", { title: "T1", body: "B1" }, { k: "v" });
    await mod.sendPush("token-2", { title: "T2", body: "B2" });

    expect(info).toHaveBeenCalled();
    expect(fetchMock).toHaveBeenCalledTimes(3);
  });

  it("uses default expires_in when oauth response omits it", async () => {
    const service = Buffer.from(
      JSON.stringify({ project_id: "p1", client_email: "x@y.z", private_key: "---KEY---" }),
      "utf8"
    ).toString("base64");
    vi.doMock("../config.js", () => ({
      config: { pushDriver: "fcm", fcmServiceAccountJsonB64: service, nodeEnv: "development" }
    }));
    vi.doMock("./logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./db/prisma.js", () => ({ prisma: { pushToken: { updateMany: vi.fn() } } }));
    vi.doMock("node:crypto", () => ({
      default: {
        sign: vi.fn(() => Buffer.from("sig")),
        constants: { RSA_PKCS1_PADDING: 1 }
      }
    }));
    const fetchMock = vi
      .fn()
      .mockResolvedValueOnce({ ok: true, json: async () => ({ access_token: "token-no-exp" }) })
      .mockResolvedValueOnce({ ok: true, status: 200, text: async () => "", json: async () => ({}) });
    vi.stubGlobal("fetch", fetchMock as any);
    const mod = await import("./push.js");
    await mod.sendPush("token-1", { title: "T1", body: "B1" });
    expect(fetchMock).toHaveBeenCalledTimes(2);
  });

  it("logs send error on OAuth failure", async () => {
    const error = vi.fn();
    const service = Buffer.from(
      JSON.stringify({ project_id: "p1", client_email: "x@y.z", private_key: "---KEY---" }),
      "utf8"
    ).toString("base64");

    vi.doMock("../config.js", () => ({
      config: { pushDriver: "fcm", fcmServiceAccountJsonB64: service, nodeEnv: "development" }
    }));
    vi.doMock("./logger.js", () => ({ logger: { warn: vi.fn(), error, info: vi.fn() } }));
    vi.doMock("./db/prisma.js", () => ({ prisma: { pushToken: { updateMany: vi.fn() } } }));
    vi.doMock("node:crypto", () => ({
      default: {
        sign: vi.fn(() => Buffer.from("sig")),
        constants: { RSA_PKCS1_PADDING: 1 }
      }
    }));

    const fetchMock = vi.fn().mockResolvedValue({ ok: false, status: 500, text: async () => "oauth boom" });
    vi.stubGlobal("fetch", fetchMock as any);

    const mod = await import("./push.js");
    await mod.sendPush("token-x", { title: "T", body: "B" });

    expect(error).toHaveBeenCalledWith("[PUSH] sendPush error", expect.anything());
  });
});
