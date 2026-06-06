import { describe, expect, it } from "vitest";

import { MockPaymentAdapter } from "./mock.js";

describe("MockPaymentAdapter", () => {
  it("initiates deposit", async () => {
    const adapter = new MockPaymentAdapter();
    const result = await adapter.initiateDeposit({
      paymentId: "p1",
      amountXof: 5000,
      description: "desc",
      callbackUrl: "http://localhost/cb",
      idempotencyKey: "k1"
    });
    expect(result.providerRef).toBe("mock-p1");
    expect(result.redirectUrl).toContain("mock://pay/p1");
  });

  it("parses webhook and normalizes status", () => {
    const adapter = new MockPaymentAdapter();
    expect(adapter.verifyWebhookSignature({ rawBody: "{}" })).toBe(true);
    expect(adapter.parseWebhook('{"ref":"r1","amount":900}')).toEqual({
      providerRef: "r1",
      status: "succeeded",
      amountXof: 900,
      metadata: {}
    });
    expect(adapter.normalizeStatus("failed")).toBe("failed");
  });

  it("refund and fetch status", async () => {
    const adapter = new MockPaymentAdapter();
    await expect(adapter.requestRefund({ providerRef: "r1", amountXof: 100, reason: "x" })).resolves.toEqual({
      refundRef: "mock-refund-r1"
    });
    await expect(adapter.fetchPaymentStatus({ providerToken: "t" })).resolves.toBe("succeeded");
  });

  it("executes payment for two-step demo flows", async () => {
    const adapter = new MockPaymentAdapter();
    await expect(
      adapter.executePayment({
        paymentId: "p1",
        method: "wave_senegal",
        invoiceToken: "mock-p1",
        details: { phone: "770000000" }
      })
    ).resolves.toEqual({
      success: true,
      status: "succeeded",
      providerTxId: "mock-exec-p1",
      method: "wave_senegal",
      invoiceToken: "mock-p1",
      details: { phone: "770000000" }
    });
  });
});
