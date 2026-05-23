import type { PaymentStatus } from "@beauteavenue/contracts";

export type ParsedWebhookEvent = {
  providerRef: string;
  status: PaymentStatus;
  amountXof: number;
  metadata: Record<string, unknown>;
};

export type AvailableMethod = {
  code: string;
  country: string;
  label: string;
  enabled: boolean;
};

export interface PaymentAdapter {
  initiateDeposit(params: {
    paymentId: string;
    amountXof: number;
    description: string;
    callbackUrl: string;
    idempotencyKey: string;
    channel?: string;
    phone?: string;
  }): Promise<{ redirectUrl: string; providerRef: string; providerToken?: string; expiresAt: Date }>;

  /**
   * Step 2 of PayDunya's two-step flow: execute a payment after the invoice is created.
   * For single-step providers (Intech), this is a no-op.
   */
  executePayment?(params: {
    paymentId: string;
    method: string;
    invoiceToken: string;
  }): Promise<{ success: boolean; status: string; providerTxId: string | null }>;

  /**
   * List available payment methods for the provider.
   */
  getAvailableMethods?(): Promise<AvailableMethod[]>;

  /**
   * Lookup a payment invoice / transaction status raw from the provider.
   * For providers with a read-status endpoint (unlike Intech which uses webhook-only).
   */
  lookupTransaction?(params: {
    providerRef: string;
  }): Promise<{ status: PaymentStatus; providerTxId?: string }>;

  verifyWebhookSignature(params: {
    rawBody: string;
    signature?: string;
    timestamp?: string;
  }): boolean;

  parseWebhook(rawBody: string): ParsedWebhookEvent;

  /**
   * Request a refund / payout.
   * For PayDunya, this triggers a Disburse flow (two-step: get invoice → submit invoice).
   * For Intech, this calls the refund endpoint directly.
   */
  requestRefund(params: {
    providerRef: string;
    amountXof: number;
    reason: string;
    phone?: string;
    method?: string;
    withdrawMode?: string;
  }): Promise<{ refundRef: string }>;

  fetchPaymentStatus(params: {
    providerToken: string;
  }): Promise<PaymentStatus>;

  normalizeStatus(providerStatus: string): PaymentStatus;
}
