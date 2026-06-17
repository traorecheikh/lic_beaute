import type { PaymentStatus } from "@beauteavenue/contracts";

import type { ParsedWebhookEvent, PaymentAdapter } from "./index.js";

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

  async executePayment(params: {
    paymentId: string;
    method: string;
    invoiceToken: string;
    details?: Record<string, any>;
  }) {
    return {
      success: true,
      status: "succeeded",
      providerTxId: `mock-exec-${params.paymentId}`,
      method: params.method,
      invoiceToken: params.invoiceToken,
      details: params.details ?? null
    };
  }

  async fetchPaymentStatus(_params: { providerToken: string }): Promise<PaymentStatus> {
    return "succeeded";
  }

  normalizeStatus(providerStatus: string): PaymentStatus {
    return providerStatus as PaymentStatus;
  }

  async createDisbursementInvoice(params: {
    phone: string;
    amountXof: number;
    withdrawMode: string;
    callbackUrl: string;
  }): Promise<{ disburseToken: string }> {
    if (params.phone.includes("invalid") || params.phone.length < 9) {
      throw new Error("Invalid phone number");
    }
    return { disburseToken: `mock-disburse-token-${params.phone}-${params.amountXof}` };
  }

  async submitDisbursement(params: {
    disburseToken: string;
    disburseId: string;
  }): Promise<{
    success: boolean;
    status: "success" | "pending" | "failed";
    responseText?: string;
    description?: string;
    transactionId?: string;
    providerRef?: string;
  }> {
    if (params.disburseToken.includes("fail")) {
      return { success: false, status: "failed", responseText: "Mock error message" };
    }
    if (params.disburseToken.includes("pending")) {
      return { success: false, status: "pending", responseText: "Mock pending message" };
    }
    return {
      success: true,
      status: "success",
      transactionId: `mock-disburse-tx-${params.disburseId}`,
      providerRef: `mock-disburse-tx-${params.disburseId}`
    };
  }

  async checkDisbursementStatus(params: {
    disburseToken: string;
  }): Promise<{
    status: "success" | "pending" | "failed";
    responseText?: string;
    description?: string;
    transactionId?: string;
    providerDisburseTxId?: string;
    amount?: number;
  }> {
    if (params.disburseToken.includes("fail")) {
      return { status: "failed" };
    }
    if (params.disburseToken.includes("pending")) {
      return { status: "pending" };
    }
    return { status: "success", transactionId: "mock-tx-123", providerDisburseTxId: "mock-tx-123" };
  }

  resolveWithdrawMode(payoutMethod: string): string {
    switch (payoutMethod) {
      case "wave_senegal": return "wave-senegal";
      case "orange_money_senegal": return "orange-money-senegal";
      case "free_senegal": return "free-money-senegal";
      case "expresso_sn": return "expresso-senegal";
      default: throw new Error(`Unsupported payout method: ${payoutMethod}`);
    }
  }

  async getApproximateBalance(): Promise<{ balance: number; currency: string }> {
    return { balance: 9999999, currency: "XOF" };
  }
}
