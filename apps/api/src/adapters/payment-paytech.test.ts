import crypto from "node:crypto";

import { afterEach, describe, expect, it, vi } from "vitest";

import { PayTechAdapter } from "./payment-paytech.js";

describe("PayTechAdapter", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("initiates a payment request and returns redirect payload", async () => {
    const fetchMock = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({
        success: 1,
        token: "tok_123",
        redirect_url: "https://paytech.sn/payment/checkout/tok_123"
      })
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = new PayTechAdapter("api_key_1", "api_secret_1", "test", "https://app.example.com");
    const result = await adapter.initiateDeposit({
      paymentId: "pay_1",
      amountXof: 15000,
      description: "Acompte réservation",
      callbackUrl: "https://app.example.com/payment/callback",
      idempotencyKey: "booking-pay_1-deposit"
    });

    expect(result.providerRef).toContain("CMD_pay_1_");
    expect(result.redirectUrl).toBe("https://paytech.sn/payment/checkout/tok_123");
    expect(fetchMock).toHaveBeenCalledTimes(1);

    const init = fetchMock.mock.calls[0][1] as RequestInit;
    expect(init?.method).toBe("POST");
    expect((init?.headers as Record<string, string>)["API_KEY"]).toBe("api_key_1");
    expect((init?.headers as Record<string, string>)["API_SECRET"]).toBe("api_secret_1");
    expect((init?.headers as Record<string, string>)["Content-Type"]).toContain("application/x-www-form-urlencoded");

    const body = init?.body as URLSearchParams;
    expect(body.get("env")).toBe("test");
    expect(body.get("ipn_url")).toBe("https://app.example.com/api/v1/payments/webhooks/paytech");
    expect(body.get("success_url")).toBe("https://app.example.com/payment/callback?status=success");
    expect(body.get("cancel_url")).toBe("https://app.example.com/payment/callback?status=cancel");
  });

  it("parses webhook payload with SHA256 verification and base64 custom_field", () => {
    const apiKey = "api_key_1";
    const apiSecret = "api_secret_1";
    const adapter = new PayTechAdapter(apiKey, apiSecret, "test", "https://app.example.com");
    const customField = Buffer.from(JSON.stringify({ paymentId: "pay_1" }), "utf8").toString("base64");

    const payload = {
      type_event: "sale_complete",
      ref_command: "REF_123",
      final_item_price: 12500,
      custom_field: customField,
      api_key_sha256: crypto.createHash("sha256").update(apiKey).digest("hex"),
      api_secret_sha256: crypto.createHash("sha256").update(apiSecret).digest("hex")
    };

    const event = adapter.parseWebhook(JSON.stringify(payload));
    expect(event.providerRef).toBe("REF_123");
    expect(event.status).toBe("succeeded");
    expect(event.amountXof).toBe(12500);
    expect(event.metadata).toMatchObject({ paymentId: "pay_1" });
  });

  it("rejects webhook payload with invalid signature hashes", () => {
    const adapter = new PayTechAdapter("api_key_1", "api_secret_1", "test", "https://app.example.com");
    const payload = {
      type_event: "sale_complete",
      ref_command: "REF_123",
      item_price: 5000,
      api_key_sha256: "invalid",
      api_secret_sha256: "invalid"
    };

    expect(() => adapter.parseWebhook(JSON.stringify(payload))).toThrow("Invalid webhook credentials");
  });

  it("fetches remote payment status from token and normalizes it", async () => {
    const fetchMock = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ success: 1, payment_status: "sale_complete" })
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = new PayTechAdapter("api_key_1", "api_secret_1", "prod", "https://app.example.com");
    const status = await adapter.fetchPaymentStatus({ providerToken: "tok_123" });

    expect(status).toBe("succeeded");
    expect(fetchMock).toHaveBeenCalledTimes(1);
    expect(String(fetchMock.mock.calls[0][0])).toContain("/payment/get-status?token_payment=tok_123");
  });

  it("submits refund request using ref_command form body", async () => {
    const fetchMock = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ success: 1, message: "ok" })
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = new PayTechAdapter("api_key_1", "api_secret_1", "prod", "https://app.example.com");
    const refund = await adapter.requestRefund({ providerRef: "REF_123", amountXof: 1000, reason: "manual" });

    expect(refund.refundRef).toBe("refund-REF_123");
    const init = fetchMock.mock.calls[0][1] as RequestInit;
    const body = init?.body as URLSearchParams;
    expect(body.get("ref_command")).toBe("REF_123");
  });
});
