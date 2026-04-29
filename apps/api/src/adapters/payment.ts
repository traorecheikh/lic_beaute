import type { PaymentStatus } from "@beauteavenue/contracts";

export type ParsedWebhookEvent = {
  providerRef: string;
  status: PaymentStatus;
  amountXof: number;
  metadata: Record<string, unknown>;
};

export interface PaymentAdapter {
  initiateDeposit(params: {
    paymentId: string;
    amountXof: number;
    description: string;
    callbackUrl: string;
    idempotencyKey: string;
  }): Promise<{ redirectUrl: string; providerRef: string; expiresAt: Date }>;

  verifyWebhookSignature(rawBody: string, signature: string): boolean;

  parseWebhook(rawBody: string): ParsedWebhookEvent;

  requestRefund(params: {
    providerRef: string;
    amountXof: number;
    reason: string;
  }): Promise<{ refundRef: string }>;

  normalizeStatus(providerStatus: string): PaymentStatus;
}
