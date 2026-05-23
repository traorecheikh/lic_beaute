import crypto from "node:crypto";

import type { PaymentStatus } from "@beauteavenue/contracts";

import type { AvailableMethod, ParsedWebhookEvent, PaymentAdapter } from "./index.js";

// ─── Checkout API types ──────────────────────────────────────────────────────

type CheckoutCreateInvoiceResponse = {
  response_code: string;
  response_text: string;
  description: string;
  token: string;
};

type SoftPayExecuteResponse = {
  success: boolean;
  message: string;
  url?: string;
  fees?: number;
  currency?: string;
  data?: Record<string, unknown>;
};

// ─── Disburse (payout) API types ──────────────────────────────────────────────

type DisburseGetInvoiceResponse = {
  response_code: string;
  response_text: string;
  invoice_token: string;
};

type DisburseSubmitInvoiceResponse = {
  response_code: string;
  response_text: string;
  status: string;
};

// ─── IPN types ────────────────────────────────────────────────────────────────

type IpnPayload = {
  token: string;
  invoice_data: string;
  hash: string;
};

// ─── Method registry ──────────────────────────────────────────────────────────

type MethodEntry = {
  country: string;
  label: string;
  /** SoftPay per-method endpoint suffix (under `/softpay/`). */
  endpoint: string;
  /** Body fields expected by this method's SoftPay endpoint. */
  bodyKeys: SoftPayBodyKeys;
  disbursable: boolean;
};

type SoftPayBodyKeys = {
  /** Field name for invoice/payment token. */
  tokenKey: string;
  /** Field name for customer phone number. */
  phoneKey: string;
  /** Field name for customer full name. */
  nameKey: string;
  /** Field name for customer email. */
  emailKey: string;
  /** Additional static fields to include. */
  extra?: Record<string, string>;
};

const PAYDUNYA_METHODS: Record<string, MethodEntry> = {
  wave_senegal: {
    country: "sn", label: "Wave Sénégal",
    endpoint: "wave-senegal",
    bodyKeys: { tokenKey: "wave_senegal_payment_token", phoneKey: "wave_senegal_phone", nameKey: "wave_senegal_fullName", emailKey: "wave_senegal_email" },
    disbursable: false
  },
  orange_senegal: {
    country: "sn", label: "Orange Money Sénégal",
    endpoint: "new-orange-money-senegal",
    bodyKeys: { tokenKey: "invoice_token", phoneKey: "phone_number", nameKey: "customer_name", emailKey: "customer_email" },
    disbursable: false
  },
  free_senegal: {
    country: "sn", label: "Free Money Sénégal",
    endpoint: "free-money-senegal",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "phone_number", nameKey: "customer_name", emailKey: "customer_email" },
    disbursable: false
  },
  wizall_senegal: {
    country: "sn", label: "Wizall Sénégal",
    endpoint: "wizall-money-senegal",
    bodyKeys: { tokenKey: "invoice_token", phoneKey: "phone_number", nameKey: "customer_name", emailKey: "customer_email" },
    disbursable: false
  }
};

const SOFTPAY_METHOD_MAP: Record<string, string> = {
  wave_senegal: "wave_senegal",
  orange_senegal: "orange_senegal",
  free_senegal: "free_senegal",
  wizall_senegal: "wizall_senegal"
};

export class PayDunyaAdapter implements PaymentAdapter {
  private baseApiUrl: string;
  private checkoutHost: string;

  constructor(
    private masterKey: string,
    private privateKey: string,
    private token: string,
    private baseOrigin: string,
    private env: "sandbox" | "production" = "sandbox",
    private baseUrl = "https://app.paydunya.com"
  ) {
    // Sandbox uses the `/sandbox-api/v1` path prefix on app.paydunya.com
    this.baseApiUrl = this.env === "sandbox"
      ? "https://app.paydunya.com/sandbox-api/v1"
      : `${this.baseUrl}/api/v1`;
    this.checkoutHost = this.env === "sandbox"
      ? "https://app.paydunya.com/sandbox-checkout"
      : "https://app.paydunya.com/checkout";
  }

  // ─── Headers ────────────────────────────────────────────────────────────────

  private _headers(): Record<string, string> {
    return {
      "Content-Type": "application/json",
      "PAYDUNYA-MASTER-KEY": this.masterKey,
      "PAYDUNYA-PRIVATE-KEY": this.privateKey,
      "PAYDUNYA-TOKEN": this.token
    };
  }

  // ─── Step 1: initiateDeposit (Create Checkout Invoice) ─────────────────────

  async initiateDeposit(params: {
    paymentId: string;
    amountXof: number;
    description: string;
    callbackUrl: string;
    idempotencyKey: string;
    channel?: string;
    phone?: string;
  }) {
    const method = params.channel && SOFTPAY_METHOD_MAP[params.channel]
      ? SOFTPAY_METHOD_MAP[params.channel]
      : "wave_senegal";

    const storeName = this.env === "sandbox" ? "Beauté Avenue Dev" : "Beauté Avenue";

    const body: Record<string, unknown> = {
      invoice: {
        items: {
          item_0: {
            name: params.description,
            quantity: 1,
            unit_price: params.amountXof.toString(),
            total_price: params.amountXof.toString(),
            description: params.description
          }
        },
        total_amount: params.amountXof,
        description: params.description
      },
      store: {
        name: storeName,
        website_url: this.baseOrigin
      },
      actions: {
        cancel_url: `${this.baseOrigin}/payment/cancel`,
        return_url: `${this.baseOrigin}/payment/success`,
        callback_url: `${this.baseOrigin}/api/v1/payments/webhooks/paydunya`
      },
      custom_data: {
        paymentId: params.paymentId,
        idempotencyKey: params.idempotencyKey,
        payment_method: method
      }
    };

    const json = await this._postJson<CheckoutCreateInvoiceResponse>(
      "/checkout-invoice/create",
      body
    );

    if (json.response_code !== "00") {
      throw new Error(
        `PayDunya checkout-invoice/create failed: ${json.response_code} ${json.response_text}`
      );
    }

    return {
      redirectUrl: `${this.checkoutHost}/invoice/${json.token}`,
      providerRef: json.token,
      providerToken: json.token,
      expiresAt: new Date(Date.now() + 30 * 60 * 1000)
    };
  }

  // ─── Step 2: executePayment (per-method SoftPay endpoint) ─────────────────

  async executePayment(params: {
    paymentId: string;
    method: string;
    invoiceToken: string;
  }): Promise<{ success: boolean; status: string; providerTxId: string | null }> {
    const methodEntry = PAYDUNYA_METHODS[params.method];
    if (!methodEntry) {
      return { success: false, status: "failed", providerTxId: null };
    }

    const keys = methodEntry.bodyKeys;
    const body: Record<string, unknown> = {
      [keys.tokenKey]: params.invoiceToken,
      [keys.nameKey]: "Client",
      [keys.emailKey]: "client@beauteavenue.sn",
      [keys.phoneKey]: "777777777"
    };
    if (keys.extra) {
      Object.assign(body, keys.extra);
    }

    try {
      const json = await this._postJson<SoftPayExecuteResponse>(
        `/softpay/${methodEntry.endpoint}`,
        body
      );

      if (json.success) {
        return {
          success: true,
          status: "succeeded",
          providerTxId: params.invoiceToken
        };
      }

      return {
        success: false,
        status: "failed",
        providerTxId: null
      };
    } catch {
      return {
        success: false,
        status: "failed",
        providerTxId: null
      };
    }
  }

  // ─── getAvailableMethods ──────────────────────────────────────────────────

  async getAvailableMethods(): Promise<AvailableMethod[]> {
    return Object.entries(PAYDUNYA_METHODS).map(([code, entry]) => ({
      code,
      country: entry.country,
      label: entry.label,
      enabled: true
    }));
  }

  // ─── lookupTransaction ────────────────────────────────────────────────────

  async lookupTransaction(params: { providerRef: string }): Promise<{
    status: PaymentStatus;
    providerTxId?: string;
  }> {
    return { status: "pending" };
  }

  // ─── verifyWebhookSignature ───────────────────────────────────────────────

  verifyWebhookSignature(params: {
    rawBody: string;
    signature?: string;
    timestamp?: string;
  }): boolean {
    try {
      const payload = JSON.parse(params.rawBody) as IpnPayload;
      if (!payload.token || !payload.hash) return false;

      const expected = crypto
        .createHash("sha512")
        .update(payload.token + this.privateKey + (payload.invoice_data ?? ""))
        .digest("hex");

      return crypto.timingSafeEqual(
        Buffer.from(expected, "utf8"),
        Buffer.from(payload.hash, "utf8")
      );
    } catch {
      return false;
    }
  }

  // ─── parseWebhook ─────────────────────────────────────────────────────────

  parseWebhook(rawBody: string): ParsedWebhookEvent {
    const payload = JSON.parse(rawBody) as {
      token: string;
      invoice_data: string;
      hash: string;
    };

    let invoiceData: Record<string, unknown> = {};
    try {
      invoiceData = JSON.parse(payload.invoice_data ?? "{}") as Record<string, unknown>;
    } catch {
      invoiceData = {};
    }

    const customData =
      (typeof invoiceData.custom_data === "object" && invoiceData.custom_data
        ? (invoiceData.custom_data as Record<string, unknown>)
        : {}) ?? {};
    const metadata: Record<string, unknown> = {
      paymentId: customData.paymentId,
      idempotencyKey: customData.idempotencyKey,
      payment_method: customData.payment_method
    };
    if (invoiceData.invoice_data && typeof invoiceData.invoice_data === "string") {
      metadata.rawInvoiceData = invoiceData.invoice_data;
    }

    return {
      providerRef: payload.token,
      status: this.normalizeStatus(
        String(invoiceData.status ?? "completed")
      ),
      amountXof: Number(invoiceData.total_amount ?? 0),
      metadata
    };
  }

  // ─── requestRefund (Disburse flow) ───────────────────────────────────────

  async requestRefund(params: {
    providerRef: string;
    amountXof: number;
    reason: string;
    phone?: string;
    method?: string;
    withdrawMode?: string;
  }): Promise<{ refundRef: string }> {
    if (!params.phone) {
      throw new Error("PayDunya disbursement requires a recipient phone number");
    }

    const storeName = this.env === "sandbox" ? "Beauté Avenue Dev" : "Beauté Avenue";

    const getInvoiceBody: Record<string, unknown> = {
      invoice: {
        total_amount: String(params.amountXof),
        description: params.reason
      },
      store: {
        name: storeName,
        website_url: this.baseOrigin
      },
      actions: {
        callback_url: `${this.baseOrigin}/api/v1/payments/webhooks/paydunya`
      },
      custom_data: {
        type: "disbursement",
        originalProviderRef: params.providerRef,
        reason: params.reason
      },
      account_alias: params.phone,
      withdraw_mode: params.withdrawMode ?? "wave-senegal"
    };

    const getInvoiceResponse = await this._postJson<DisburseGetInvoiceResponse>(
      "/disburse/v2/get-invoice",
      getInvoiceBody
    );

    if (getInvoiceResponse.response_code !== "00") {
      throw new Error(
        `PayDunya Disburse get-invoice failed: ${getInvoiceResponse.response_code} ${getInvoiceResponse.response_text}`
      );
    }

    const invoiceToken = getInvoiceResponse.invoice_token;

    const submitBody = {
      invoice: {
        token: invoiceToken
      }
    };

    const submitResponse = await this._postJson<DisburseSubmitInvoiceResponse>(
      "/disburse/v2/submit-invoice",
      submitBody
    );

    if (submitResponse.response_code !== "00") {
      throw new Error(
        `PayDunya Disburse submit-invoice failed: ${submitResponse.response_code} ${submitResponse.response_text}`
      );
    }

    return { refundRef: invoiceToken };
  }

  // ─── fetchPaymentStatus ──────────────────────────────────────────────────

  async fetchPaymentStatus(params: { providerToken: string }): Promise<PaymentStatus> {
    return "pending";
  }

  // ─── normalizeStatus ─────────────────────────────────────────────────────

  normalizeStatus(providerStatus: string): PaymentStatus {
    const normalized = providerStatus.toUpperCase();
    if (normalized === "COMPLETED" || normalized === "SUCCESS" || normalized === "SUCCESSFUL") {
      return "succeeded";
    }
    if (normalized === "PENDING" || normalized === "PROCESSING") {
      return "pending";
    }
    if (normalized === "FAILED" || normalized === "ERROR" || normalized === "CANCELLED" || normalized === "CANCELED") {
      return "failed";
    }
    if (normalized === "REFUNDED") {
      return "refunded";
    }
    if (normalized === "AUTHORIZED") {
      return "authorized";
    }
    return "pending";
  }

  // ─── HTTP helper ─────────────────────────────────────────────────────────

  private async _postJson<T>(path: string, body: Record<string, unknown>): Promise<T> {
    const response = await fetch(`${this.baseApiUrl}${path}`, {
      method: "POST",
      headers: this._headers(),
      body: JSON.stringify(body),
      signal: AbortSignal.timeout(30_000)
    });

    if (!response.ok) {
      const text = await response.text();
      throw new Error(`PayDunya ${path} failed: ${response.status} ${text}`);
    }

    return (await response.json()) as T;
  }
}
