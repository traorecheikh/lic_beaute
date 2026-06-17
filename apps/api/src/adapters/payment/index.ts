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

  /** Step 2 of PayDunya's two-step flow: execute a payment after the invoice is created. */
  executePayment?(params: {
    paymentId: string;
    method: string;
    invoiceToken: string;
    details?: Record<string, any>;
  }): Promise<{ success: boolean; status: string; providerTxId: string | null; [key: string]: any }>;

  /**
   * List available payment methods for the provider.
   */
  getAvailableMethods?(): Promise<AvailableMethod[]>;

  /** Lookup a payment invoice / transaction status raw from the provider. */
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

  createDisbursementInvoice?(params: {
    phone: string;
    amountXof: number;
    withdrawMode: string;
    callbackUrl: string;
  }): Promise<{ disburseToken: string }>;

  resolveWithdrawMode?(payoutMethod: string): string;

  submitDisbursement?(params: {
    disburseToken: string;
    disburseId: string;
  }): Promise<{
    success: boolean;
    status: "success" | "pending" | "failed";
    responseText?: string;
    description?: string;
    transactionId?: string;
    providerRef?: string;
  }>;

  checkDisbursementStatus?(params: {
    disburseToken: string;
  }): Promise<{
    status: "success" | "pending" | "failed";
    responseText?: string;
    description?: string;
    transactionId?: string;
    providerDisburseTxId?: string;
    amount?: number;
  }>;

  getApproximateBalance?(): Promise<{ balance: number; currency: string }>;
}

