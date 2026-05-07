import type { PaymentStatus } from "@beauteavenue/contracts";

import type { ParsedWebhookEvent, PaymentAdapter } from "./payment.js";

export class MockPaymentAdapter implements PaymentAdapter {
  async initiateDeposit(params: {
    paymentId: string;
    amountXof: number;
    description: string;
    callbackUrl: string;
    idempotencyKey: string;
    channel?: "wave" | "orange_money" | "free_money";
    phone?: string;
  }) {
    return {
      redirectUrl: `mock://pay/${params.paymentId}?amount=${params.amountXof}`,
      providerRef: `mock-${params.paymentId}`,
      providerToken: `mock-${params.paymentId}`,
      expiresAt: new Date(Date.now() + 30 * 60 * 1000)
    };
  }

  verifyWebhookSignature(_params: { rawBody: string; signature?: string; timestamp?: string }): boolean {
    return true;
  }

  parseWebhook(rawBody: string): ParsedWebhookEvent {
    const payload = JSON.parse(rawBody) as { ref: string; amount: number };
    return {
      providerRef: payload.ref,
      status: "succeeded" as PaymentStatus,
      amountXof: payload.amount,
      metadata: {}
    };
  }

  async requestRefund(params: { providerRef: string; amountXof: number; reason: string }) {
    return { refundRef: `mock-refund-${params.providerRef}` };
  }

  async fetchPaymentStatus(_params: { providerToken: string }): Promise<PaymentStatus> {
    return "succeeded";
  }

  normalizeStatus(providerStatus: string): PaymentStatus {
    return providerStatus as PaymentStatus;
  }
}
