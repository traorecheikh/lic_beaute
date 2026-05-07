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
    channel?: "wave" | "orange_money" | "free_money";
    phone?: string;
  }): Promise<{ redirectUrl: string; providerRef: string; providerToken?: string; expiresAt: Date }>;

  verifyWebhookSignature(params: {
    rawBody: string;
    signature?: string;
    timestamp?: string;
  }): boolean;

  parseWebhook(rawBody: string): ParsedWebhookEvent;

  requestRefund(params: {
    providerRef: string;
    amountXof: number;
    reason: string;
  }): Promise<{ refundRef: string }>;

  fetchPaymentStatus(params: {
    providerToken: string;
  }): Promise<PaymentStatus>;

  normalizeStatus(providerStatus: string): PaymentStatus;
}
