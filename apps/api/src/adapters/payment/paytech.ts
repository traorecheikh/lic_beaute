import crypto from "node:crypto";

import type { PaymentAdapter, ParsedWebhookEvent } from "./index.js";
import type { PaymentStatus } from "@beauteavenue/contracts";

type PayTechDepositResponse = {
  success: number;
  token: string;
  redirect_url: string;
  redirectUrl: string;
};

type PayTechRefundResponse = {
  success: number;
  message: string;
};

type PayTechStatusResponse = {
  success?: number | boolean;
  payment_status?: string;
  status?: string;
  state?: string;
  type_event?: string;
  payment?: {
    status?: string;
    state?: string;
    type_event?: string;
  };
};

export class PayTechAdapter implements PaymentAdapter {
  constructor(
    private apiKey: string,
    private apiSecret: string,
    private env: "prod" | "test",
    private baseOrigin: string,
    private webhookPath = "paytech"
  ) {}

  async initiateDeposit(params: {
    paymentId: string;
    amountXof: number;
    description: string;
    callbackUrl: string;
    idempotencyKey: string;
    channel?: "wave" | "orange_money" | "free_money";
    phone?: string;
  }) {
    const refCommand = `CMD_${params.paymentId}_${params.idempotencyKey.slice(0, 12)}`;

    const body = new URLSearchParams({
      item_name: params.description,
      item_price: String(params.amountXof),
      currency: "XOF",
      ref_command: refCommand,
      command_name: params.description,
      env: this.env,
      ipn_url: `${this.baseOrigin}/api/v1/payments/webhooks/${this.webhookPath}`,
      success_url: `${params.callbackUrl}?status=success`,
      cancel_url: `${params.callbackUrl}?status=cancel`,
      custom_field: JSON.stringify({
        paymentId: params.paymentId,
        idempotencyKey: params.idempotencyKey
      })
    });

    const response = await fetch("https://paytech.sn/api/payment/request-payment", {
      method: "POST",
      headers: {
        "API_KEY": this.apiKey,
        "API_SECRET": this.apiSecret,
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body
    });

    if (!response.ok) {
      const text = await response.text();
      throw new Error(`PayTech request-payment failed: ${response.status} ${text}`);
    }

    const json = (await response.json()) as PayTechDepositResponse;

    if (json.success !== 1) {
      throw new Error(`PayTech request-payment rejected: ${JSON.stringify(json)}`);
    }

    return {
      redirectUrl: json.redirectUrl ?? json.redirect_url,
      providerRef: refCommand,
      providerToken: json.token,
      expiresAt: new Date(Date.now() + 30 * 60 * 1000)
    };
  }

  verifyWebhookSignature(_params: {
    rawBody: string;
    signature?: string;
    timestamp?: string;
  }): boolean {
    return true;
  }

  parseWebhook(rawBody: string): ParsedWebhookEvent {
    const payload = JSON.parse(rawBody);

    const expectedApiKey = crypto.createHash("sha256").update(this.apiKey).digest("hex");
    const expectedApiSecret = crypto.createHash("sha256").update(this.apiSecret).digest("hex");

    const payloadApiKey = payload.api_key_sha256 ?? "";
    const payloadApiSecret = payload.api_secret_sha256 ?? "";

    if (payload.hmac_compute) {
      const message = [
        payload.final_item_price ?? payload.item_price,
        payload.ref_command,
        this.apiKey
      ].join("|");
      const expectedHmac = crypto.createHmac("sha256", this.apiSecret).update(message).digest("hex");
      if (expectedHmac !== payload.hmac_compute) {
        throw new Error("Invalid webhook HMAC");
      }
    } else {
      if (payloadApiKey !== expectedApiKey || payloadApiSecret !== expectedApiSecret) {
        throw new Error("Invalid webhook credentials");
      }
    }

    const typeEvent: string = payload.type_event ?? "";
    const status = this._mapEventToStatus(typeEvent + "|" + (payload.state ?? ""));
    const amountXof = Number(payload.final_item_price ?? payload.item_price ?? payload.amount_xof ?? 0);
    const refCommand: string = payload.ref_command ?? payload.external_id ?? "";

    let customData: Record<string, unknown> = {};
    if (payload.custom_field) {
      try {
        const decoded = Buffer.from(payload.custom_field, "base64").toString("utf-8");
        customData = JSON.parse(decoded);
      } catch {
        try {
          customData = JSON.parse(payload.custom_field);
        } catch {
          // not JSON
        }
      }
    }

    return {
      providerRef: refCommand,
      status,
      amountXof,
      metadata: customData
    };
  }

  async requestRefund(params: { providerRef: string; amountXof: number; reason: string }) {
    const body = new URLSearchParams({ ref_command: params.providerRef });

    const response = await fetch("https://paytech.sn/api/payment/refund-payment", {
      method: "POST",
      headers: {
        "API_KEY": this.apiKey,
        "API_SECRET": this.apiSecret,
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body
    });

    if (!response.ok) {
      const text = await response.text();
      throw new Error(`PayTech refund-payment failed: ${response.status} ${text}`);
    }

    const json = (await response.json()) as PayTechRefundResponse;

    if (json.success !== 1) {
      throw new Error(`PayTech refund failed: ${json.message ?? "unknown error"}`);
    }

    return { refundRef: `refund-${params.providerRef}` };
  }

  async fetchPaymentStatus(params: { providerToken: string }): Promise<PaymentStatus> {
    const url = new URL("https://paytech.sn/api/payment/get-status");
    url.searchParams.set("token_payment", params.providerToken);

    const response = await fetch(url, {
      method: "GET",
      headers: {
        "API_KEY": this.apiKey,
        "API_SECRET": this.apiSecret
      }
    });

    if (!response.ok) {
      const text = await response.text();
      throw new Error(`PayTech get-status failed: ${response.status} ${text}`);
    }

    const json = (await response.json()) as PayTechStatusResponse;
    const success = json.success;
    if (!(success === 1 || success === true || success === undefined)) {
      throw new Error(`PayTech get-status rejected: ${JSON.stringify(json)}`);
    }

    const providerStatus =
      json.payment_status
      ?? json.payment?.status
      ?? json.payment?.state
      ?? json.payment?.type_event
      ?? json.status
      ?? json.state
      ?? json.type_event
      ?? "pending";

    return this.normalizeStatus(providerStatus);
  }

  normalizeStatus(providerStatus: string): PaymentStatus {
    const map: Record<string, PaymentStatus> = {
      sale_complete: "succeeded",
      sale_canceled: "failed",
      transfer_success: "succeeded",
      transfer_failed: "failed",
      refund_complete: "refunded",
      pending: "pending",
      success: "succeeded",
      failed: "failed"
    };
    return map[providerStatus] ?? "pending";
  }

  private _mapEventToStatus(composite: string): PaymentStatus {
    if (composite.includes("sale_complete")) return "succeeded";
    if (composite.includes("sale_canceled")) return "failed";
    if (composite.includes("transfer_success")) return "succeeded";
    if (composite.includes("transfer_failed")) return "failed";
    if (composite.includes("refund_complete")) return "refunded";
    if (composite.includes("success")) return "succeeded";
    if (composite.includes("failed")) return "failed";
    if (composite.includes("pending")) return "pending";
    return "pending";
  }
}
