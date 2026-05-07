import crypto from "node:crypto";

import { afterEach, describe, expect, it, vi } from "vitest";

import { IntechAdapter } from "./payment-intech.js";

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
});
