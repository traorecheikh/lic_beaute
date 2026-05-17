import crypto from "node:crypto";

import { afterEach, describe, expect, it, vi } from "vitest";

import { IntechAdapter } from "./intech.js";

describe("IntechAdapter", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("initiates an Intech operation with channel -> codeService mapping", async () => {
    const fetchMock = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({
        code: 2000,
        error: false,
        data: {
          transactionId: "T_1001",
          externalTransactionId: "EXT_1001",
          deepLinkUrl: "https://api.intech.sn/deep/T_1001"
        }
      })
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    const result = await adapter.initiateDeposit({
      paymentId: "pay_1",
      amountXof: 15000,
      description: "Acompte",
      callbackUrl: "https://app.example.com/payment/callback",
      idempotencyKey: "booking-pay_1-deposit",
      channel: "orange_money",
      phone: "770000000"
    });

    expect(result.providerRef).toBe("T_1001");
    expect(result.providerToken).toBe("EXT_1001");
    expect(result.redirectUrl).toBe("https://api.intech.sn/deep/T_1001");

    const requestUrl = String(fetchMock.mock.calls[0][0]);
    expect(requestUrl).toBe("https://api.intech.sn/api-services/operation");

    const init = fetchMock.mock.calls[0][1] as RequestInit;
    const body = JSON.parse(String(init.body)) as Record<string, unknown>;
    expect(body.apiKey).toBe("api_key_1");
    expect(body.phone).toBe("770000000");
    expect(body.amount).toBe(15000);
    expect(body.codeService).toBe("ORANGE_SN_API_CASH_IN");
    expect(body.callbackUrl).toBe("https://app.example.com/api/v1/payments/webhooks/intech");
    expect(String(body.externalTransactionId)).toContain("PAY_pay_1_");
  });

  it("validates callback sha256 hash and parses metadata", () => {
    const apiKey = "api_key_1";
    const adapter = new IntechAdapter(apiKey, "https://app.example.com");

    const transactionId = "6584079423914";
    const externalTransactionId = "EXT_123";
    const sha256Hash = crypto
      .createHash("sha256")
      .update(`${transactionId}|${externalTransactionId}|${apiKey}`)
      .digest("hex");

    const payload = {
      status: "SUCCESS",
      sha256Hash,
      transaction: {
        transactionId,
        externalTransactionId,
        amount: 12000,
        data: {
          paymentId: "pay_1"
        }
      }
    };

    const event = adapter.parseWebhook(JSON.stringify(payload));
    expect(event.providerRef).toBe(transactionId);
    expect(event.status).toBe("succeeded");
    expect(event.amountXof).toBe(12000);
    expect(event.metadata).toMatchObject({ paymentId: "pay_1", externalTransactionId });
  });

  it("rejects callback with invalid sha256 hash", () => {
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    const payload = {
      status: "SUCCESS",
      sha256Hash: "invalid",
      transaction: {
        transactionId: "T_1",
        externalTransactionId: "EXT_1",
        amount: 1000
      }
    };

    expect(() => adapter.parseWebhook(JSON.stringify(payload))).toThrow("Invalid Intech callback hash");
  });

  it("validates optional callback HMAC signature when enabled", () => {
    const hmacSecret = "super-secret";
    const adapter = new IntechAdapter(
      "api_key_1",
      "https://app.example.com",
      "https://api.intech.sn",
      true,
      hmacSecret,
      300000
    );

    const rawBody = JSON.stringify({ status: "SUCCESS" });
    const timestamp = String(Date.now());
    const signature = crypto
      .createHmac("sha256", hmacSecret)
      .update(`POST:${timestamp}:${rawBody}`)
      .digest("hex");

    expect(adapter.verifyWebhookSignature({ rawBody, timestamp, signature })).toBe(true);
    expect(adapter.verifyWebhookSignature({ rawBody, timestamp, signature: "invalid" })).toBe(false);
  });

  it("fetches payment status using externalTransactionId", async () => {
    const fetchMock = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({
        code: 2000,
        error: false,
        data: {
          status: "FAILLED"
        }
      })
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    const status = await adapter.fetchPaymentStatus({ providerToken: "EXT_1001" });

    expect(status).toBe("failed");
    const init = fetchMock.mock.calls[0][1] as RequestInit;
    const body = JSON.parse(String(init.body)) as Record<string, unknown>;
    expect(body.externalTransactionId).toBe("EXT_1001");
    expect(body.apiKey).toBe("api_key_1");
  });

  it("rejects initiateDeposit when phone missing", async () => {
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    await expect(
      adapter.initiateDeposit({
        paymentId: "p1",
        amountXof: 1000,
        description: "d",
        callbackUrl: "https://cb",
        idempotencyKey: "key",
        phone: ""
      })
    ).rejects.toThrow(/requires a payer phone/);
  });

  it("rejects initiateDeposit when provider returns error code", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ code: 4000, error: true, msg: "bad request", data: {} })
    }));
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    await expect(
      adapter.initiateDeposit({
        paymentId: "p1",
        amountXof: 1000,
        description: "d",
        callbackUrl: "https://cb",
        idempotencyKey: "key",
        phone: "770000000"
      })
    ).rejects.toThrow(/operation rejected/);
  });

  it("rejects initiateDeposit when redirect URL is missing", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({
        code: 2000,
        error: false,
        data: { transactionId: "T1", externalTransactionId: "E1", notificationMessage: "no url here" }
      })
    }));
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    await expect(
      adapter.initiateDeposit({
        paymentId: "p1",
        amountXof: 1000,
        description: "d",
        callbackUrl: "https://cb",
        idempotencyKey: "key",
        phone: "770000000"
      })
    ).rejects.toThrow(/no redirect URL/);
  });

  it("verifyWebhookSignature fails for missing inputs / stale timestamp", () => {
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com", "https://api.intech.sn", true, "hmac-secret", 10);
    expect(adapter.verifyWebhookSignature({ rawBody: "{}" })).toBe(false);
    expect(adapter.verifyWebhookSignature({ rawBody: "{}", timestamp: "bad", signature: "x" })).toBe(false);
    const staleTs = String(Date.now() - 10_000);
    expect(adapter.verifyWebhookSignature({ rawBody: "{}", timestamp: staleTs, signature: "x" })).toBe(false);
  });

  it("parseWebhook rejects when callback hash missing with identifiers", () => {
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    expect(() =>
      adapter.parseWebhook(
        JSON.stringify({ status: "SUCCESS", transaction: { transactionId: "T1", externalTransactionId: "E1", amount: 1000 } })
      )
    ).toThrow(/Missing Intech callback hash/);
  });

  it("parseWebhook parses JSON-string metadata and status fallbacks", () => {
    const apiKey = "api_key_1";
    const adapter = new IntechAdapter(apiKey, "https://app.example.com");
    const txId = "T42";
    const extId = "E42";
    const sha256Hash = crypto.createHash("sha256").update(`${txId}|${extId}|${apiKey}`).digest("hex");
    const event = adapter.parseWebhook(JSON.stringify({
      status: "PROCESSING",
      sha256Hash,
      transaction: { transactionId: txId, externalTransactionId: extId, amount: "2000", data: "{\"x\":1}" }
    }));
    expect(event.status).toBe("pending");
    expect(event.amountXof).toBe(2000);
    expect(event.metadata).toMatchObject({ x: 1, externalTransactionId: extId, transactionId: txId });
  });

  it("requestRefund rejects non-success statuses", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ statutTreatment: "FAILED" })
    }));
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    await expect(adapter.requestRefund({ providerRef: "T1", amountXof: 1000, reason: "x" })).rejects.toThrow(/refund rejected/);
  });

  it("propagates non-ok HTTP responses", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
      ok: false,
      status: 500,
      text: async () => "server down"
    }));
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    await expect(adapter.fetchPaymentStatus({ providerToken: "EXT_1" })).rejects.toThrow(/failed: 500/);
  });

  it("requestRefund succeeds on SUCCESS status and returns provider ref", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ statutTreatment: "SUCCESS" })
    }));
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    await expect(adapter.requestRefund({ providerRef: "T_OK", amountXof: 1000, reason: "ok" }))
      .resolves.toEqual({ refundRef: "T_OK" });
  });

  it("verifyWebhookSignature returns true when HMAC is disabled", () => {
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com", "https://api.intech.sn", false);
    expect(adapter.verifyWebhookSignature({ rawBody: "{}", signature: "any", timestamp: String(Date.now()) })).toBe(true);
  });

  it("parseWebhook handles callbacks without hash/ids and fallback metadata parser cases", () => {
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    const eventNoIds = adapter.parseWebhook(JSON.stringify({ status: "PENDING", data: "not-json" }));
    expect(eventNoIds.status).toBe("pending");
    expect(eventNoIds.metadata).toEqual({});

    const eventArrayData = adapter.parseWebhook(JSON.stringify({
      status: "SUCCESS",
      data: [1, 2, 3],
      amount: "123"
    }));
    expect(eventArrayData.metadata).toEqual({});
    expect(eventArrayData.amountXof).toBe(123);
  });

  it("normalizeStatus covers remaining statuses and default path", () => {
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    expect(adapter.normalizeStatus("SUCCESS")).toBe("succeeded");
    expect(adapter.normalizeStatus("AUTHORIZED")).toBe("authorized");
    expect(adapter.normalizeStatus("REFUNDED")).toBe("refunded");
    expect(adapter.normalizeStatus("CANCELLED")).toBe("failed");
    expect(adapter.normalizeStatus("UNKNOWN_STATUS")).toBe("pending");
  });

  it("adds transport HMAC headers when enabled", async () => {
    const fetchMock = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({
        code: 2000,
        error: false,
        data: {
          transactionId: "T_H",
          externalTransactionId: "EXT_H",
          authLinkUrl: "https://api.intech.sn/auth/T_H"
        }
      })
    });
    vi.stubGlobal("fetch", fetchMock);
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com", "https://api.intech.sn", true, "hmac-secret");
    await adapter.initiateDeposit({
      paymentId: "pay_h",
      amountXof: 1200,
      description: "h",
      callbackUrl: "https://cb",
      idempotencyKey: "idem-h",
      channel: "free_money",
      phone: "770000000"
    });
    const headers = (fetchMock.mock.calls[0][1] as RequestInit).headers as Record<string, string>;
    expect(headers["Hmac-Signature"]).toBeTruthy();
    expect(headers.Timestamp).toBeTruthy();
  });

  it("covers fallback branches for identifiers/status/channel/hmac secret", async () => {
    const fetchMock = vi.fn().mockResolvedValueOnce({
      ok: true,
      json: async () => ({
        code: 2000,
        error: false,
        data: {
          authLinkUrl: "https://api.intech.sn/auth/only"
        }
      })
    });
    vi.stubGlobal("fetch", fetchMock);
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    const out = await adapter.initiateDeposit({
      paymentId: "pay_fb",
      amountXof: 1000,
      description: "d",
      callbackUrl: "https://cb",
      idempotencyKey: "idem-fb",
      channel: "unknown" as any,
      phone: "770000000"
    });
    expect(out.providerRef).toContain("PAY_pay_fb_");
    expect(out.providerToken).toContain("PAY_pay_fb_");

    const hash = crypto.createHash("sha256").update("t1|e1|api_key_1").digest("hex");
    const event = adapter.parseWebhook(JSON.stringify({
      sha256Hash: hash,
      transaction: { transactionId: "t1", externalTransactionId: "e1", status: 123, amount: 1000, data: null }
    }));
    expect(event.status).toBe("pending");

    vi.stubGlobal("fetch", vi.fn().mockResolvedValueOnce({ ok: true, json: async () => ({}) }));
    await expect(adapter.requestRefund({ providerRef: "T1", amountXof: 1000, reason: "ok" }))
      .resolves.toEqual({ refundRef: "T1" });

    const hmacMissingSecret = new IntechAdapter("api_key_1", "https://app.example.com", "https://api.intech.sn", true, "");
    expect(hmacMissingSecret.verifyWebhookSignature({ rawBody: "{}", timestamp: String(Date.now()), signature: "x" })).toBe(false);
  });

  it("covers null data fallback and code/status branch variants", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValueOnce({
      ok: true,
      json: async () => ({ code: 5000, error: false, data: null, msg: "bad code" })
    }));
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    await expect(adapter.initiateDeposit({
      paymentId: "p2",
      amountXof: 1000,
      description: "d",
      callbackUrl: "https://cb",
      idempotencyKey: "k2",
      phone: "770000000"
    })).rejects.toThrow(/operation rejected/);

    const sha = crypto.createHash("sha256").update("tt|ee|api_key_1").digest("hex");
    const event = adapter.parseWebhook(JSON.stringify({
      sha256Hash: sha,
      status: null,
      transaction: { transactionId: "tt", externalTransactionId: "ee", status: "SUCCESS", amount: 1000 }
    }));
    expect(event.status).toBe("succeeded");
  });

  it("covers json.error=true rejection and default pending status fallback", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValueOnce({
      ok: true,
      json: async () => ({ code: 2000, error: true, data: { deepLinkUrl: "https://x" }, msg: "flagged" })
    }));
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    await expect(adapter.initiateDeposit({
      paymentId: "p3",
      amountXof: 1000,
      description: "d",
      callbackUrl: "https://cb",
      idempotencyKey: "k3",
      phone: "770000000"
    })).rejects.toThrow(/operation rejected/);

    const sha = crypto.createHash("sha256").update("t9|e9|api_key_1").digest("hex");
    const event = adapter.parseWebhook(JSON.stringify({
      sha256Hash: sha,
      transaction: { transactionId: "t9", externalTransactionId: "e9", amount: 1000 }
    }));
    expect(event.status).toBe("pending");
  });

  it("covers unknown/no_message fallback text on rejected operation", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValueOnce({
      ok: true,
      json: async () => ({ error: true, data: {} })
    }));
    const adapter = new IntechAdapter("api_key_1", "https://app.example.com");
    await expect(adapter.initiateDeposit({
      paymentId: "p4",
      amountXof: 1000,
      description: "d",
      callbackUrl: "https://cb",
      idempotencyKey: "k4",
      phone: "770000000"
    })).rejects.toThrow(/unknown no_message/);
  });
});
