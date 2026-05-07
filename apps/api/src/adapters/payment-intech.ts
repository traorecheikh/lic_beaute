import crypto from "node:crypto";

import type { PaymentStatus } from "@beauteavenue/contracts";

import type { ParsedWebhookEvent, PaymentAdapter } from "./payment.js";

type IntechOperationResponse = {
  code?: number;
  msg?: string;
  error?: boolean;
  data?: {
    transactionId?: string | number;
    externalTransactionId?: string;
    status?: string;
    deepLinkUrl?: string;
    authLinkUrl?: string;
    redirectUrl?: string;
    notificationMessage?: string;
    [key: string]: unknown;
  };
};

type IntechStatusResponse = {
  code?: number;
  msg?: string;
  error?: boolean;
  data?: {
    status?: string;
    transactionId?: string | number;
    externalTransactionId?: string;
    [key: string]: unknown;
  };
};

type IntechRefundResponse = {
  message?: string;
  statutTreatment?: string;
  status?: string;
  [key: string]: unknown;
};

type IntechCallbackPayload = {
  status?: string;
  sha256Hash?: string;
  secureHash?: string;
  infoHash?: string;
  transaction?: {
    transactionId?: string | number;
    externalTransactionId?: string;
    amount?: number | string;
    data?: unknown;
    status?: string;
    [key: string]: unknown;
  };
  idFromGu?: string;
  idFromClient?: string;
  amount?: number | string;
  amountWithoutFees?: number | string;
  data?: unknown;
  [key: string]: unknown;
};

export class IntechAdapter implements PaymentAdapter {
  constructor(
    private apiKey: string,
    private baseOrigin: string,
    private baseUrl = "https://api.intech.sn",
    private hmacEnabled = false,
    private hmacSecretKey = "",
    private hmacMaxAgeMs = 5 * 60 * 1000,
    private requestTimeoutMs = 65_000
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
    if (!params.phone || !params.phone.trim()) {
      throw new Error("Intech requires a payer phone number");
    }

    const externalTransactionId = `PAY_${params.paymentId}_${params.idempotencyKey.slice(0, 12)}`;
    const codeService = this._resolveCodeService(params.channel);

    const payload = {
      apiKey: this.apiKey,
      phone: params.phone.trim(),
      amount: params.amountXof,
      codeService,
      externalTransactionId,
      callbackUrl: `${this.baseOrigin}/api/v1/payments/webhooks/intech`,
      data: JSON.stringify({
        paymentId: params.paymentId,
        idempotencyKey: params.idempotencyKey
      })
    };

    const json = await this._postJson<IntechOperationResponse>("/api-services/operation", payload);
    const txData = json.data ?? {};

    if (json.error === true || json.code !== 2000) {
      throw new Error(`Intech operation rejected: ${json.code ?? "unknown"} ${json.msg ?? "no_message"}`);
    }

    const providerRef = String(txData.transactionId ?? externalTransactionId);
    const redirectUrl =
      this._firstHttpUrl([
        this._toString(txData.deepLinkUrl),
        this._toString(txData.authLinkUrl),
        this._toString(txData.redirectUrl),
        this._extractHttpUrl(this._toString(txData.notificationMessage))
      ])
      ?? `${this.baseOrigin}/payment/callback?status=pending`;

    return {
      redirectUrl,
      providerRef,
      providerToken: String(txData.externalTransactionId ?? externalTransactionId),
      expiresAt: new Date(Date.now() + 30 * 60 * 1000)
    };
  }

  verifyWebhookSignature(params: { rawBody: string; signature?: string; timestamp?: string }): boolean {
    if (!this.hmacEnabled) return true;
    if (!this.hmacSecretKey) return false;
    if (!params.signature || !params.timestamp) return false;

    const requestTime = Number(params.timestamp);
    if (!Number.isFinite(requestTime)) return false;
    if (Math.abs(Date.now() - requestTime) > this.hmacMaxAgeMs) return false;

    const expected = crypto
      .createHmac("sha256", this.hmacSecretKey)
      .update(`POST:${params.timestamp}:${params.rawBody}`)
      .digest("hex");

    return this._safeCompareHex(expected, params.signature);
  }

  parseWebhook(rawBody: string): ParsedWebhookEvent {
    const payload = JSON.parse(rawBody) as IntechCallbackPayload;

    const tx = payload.transaction ?? {};
    const transactionId = this._toString(tx.transactionId ?? payload.idFromGu);
    const externalTransactionId = this._toString(tx.externalTransactionId ?? payload.idFromClient);
    const receivedHash = this._toString(payload.sha256Hash ?? payload.secureHash ?? payload.infoHash);

    // Always validate the callback hash when present — it's the primary integrity check
    // for Intech callbacks independent of the optional HMAC transport signature.
    if (receivedHash) {
      const expectedHash = crypto
        .createHash("sha256")
        .update(`${transactionId}|${externalTransactionId}|${this.apiKey}`)
        .digest("hex");
      if (!this._safeCompareHex(expectedHash, receivedHash)) {
        throw new Error("Invalid Intech callback hash");
      }
    } else if (this.hmacEnabled && transactionId && externalTransactionId) {
      // Missing callback hash while identifiers are present is suspicious when HMAC is on.
      throw new Error("Missing Intech callback hash — reject without integrity proof");
    }

    const metadata = this._parseCallbackData(tx.data ?? payload.data);
    if (externalTransactionId) metadata.externalTransactionId = externalTransactionId;
    if (transactionId) metadata.transactionId = transactionId;

    return {
      providerRef: transactionId || externalTransactionId,
      status: this.normalizeStatus(this._toString(payload.status ?? tx.status ?? "PENDING")),
      amountXof: Number(tx.amount ?? payload.amount ?? payload.amountWithoutFees ?? 0),
      metadata
    };
  }

  async requestRefund(params: { providerRef: string; amountXof: number; reason: string }) {
    const json = await this._postJson<IntechRefundResponse>("/api-services/transaction/refund-cancel", {
      apiKey: this.apiKey,
      transactionId: params.providerRef
    });

    const status = this._toString(json.statutTreatment ?? json.status).toUpperCase();
    if (status && status !== "SUCCESS") {
      throw new Error(`Intech refund rejected: ${status}`);
    }

    return { refundRef: this._toString(params.providerRef) };
  }

  async fetchPaymentStatus(params: { providerToken: string }): Promise<PaymentStatus> {
    const json = await this._postJson<IntechStatusResponse>("/api-services/get-transaction-status", {
      apiKey: this.apiKey,
      externalTransactionId: params.providerToken
    });

    const status = this._toString(json.data?.status);
    return this.normalizeStatus(status);
  }

  normalizeStatus(providerStatus: string): PaymentStatus {
    const normalized = providerStatus.toUpperCase();
    if (normalized === "SUCCESS") return "succeeded";
    if (normalized === "REFUNDED") return "refunded";
    if (normalized === "AUTHORIZED") return "authorized";
    if (normalized === "PENDING" || normalized === "PROCESSING") return "pending";
    // Intech occasionally returns "FAILLED" (French-language typo) rather than "FAILED".
    if (normalized === "FAILLED" || normalized === "FAILED" || normalized === "CANCELED" || normalized === "CANCELLED") return "failed";
    return "pending";
  }

  private async _postJson<T>(path: string, payload: Record<string, unknown>): Promise<T> {
    const body = JSON.stringify(payload);
    const headers: Record<string, string> = {
      "Content-Type": "application/json"
    };

    if (this.hmacEnabled && this.hmacSecretKey) {
      const timestamp = String(Date.now());
      const signature = crypto
        .createHmac("sha256", this.hmacSecretKey)
        .update(`POST:${timestamp}:${body}`)
        .digest("hex");
      headers["Hmac-Signature"] = signature;
      headers.Timestamp = timestamp;
    }

    const response = await fetch(`${this.baseUrl}${path}`, {
      method: "POST",
      headers,
      body,
      signal: AbortSignal.timeout(this.requestTimeoutMs)
    });

      if (!response.ok) {
      const text = await response.text();
      throw new Error(`Intech ${path} failed: ${response.status} ${text}`);
    }

    return (await response.json()) as T;
  }

  private _resolveCodeService(channel: "wave" | "orange_money" | "free_money" | undefined): string {
    const map: Record<string, string> = {
      wave: "WAVE_SN_API_CASH_IN",
      orange_money: "ORANGE_SN_API_CASH_IN",
      free_money: "FREE_SN_WALLET_CASH_IN"
    };

    return map[channel ?? "wave"] ?? "WAVE_SN_API_CASH_IN";
  }

  private _parseCallbackData(value: unknown): Record<string, unknown> {
    if (!value) return {};
    if (typeof value === "object" && !Array.isArray(value)) {
      return value as Record<string, unknown>;
    }
    if (typeof value === "string") {
      try {
        const parsed = JSON.parse(value);
        if (parsed && typeof parsed === "object" && !Array.isArray(parsed)) {
          return parsed as Record<string, unknown>;
        }
      } catch {
        return {};
      }
    }
    return {};
  }

  private _safeCompareHex(expected: string, candidate: string): boolean {
    const expectedBuf = Buffer.from(expected.toLowerCase(), "utf8");
    const candidateBuf = Buffer.from(candidate.toLowerCase(), "utf8");
    if (expectedBuf.length !== candidateBuf.length) return false;
    return crypto.timingSafeEqual(expectedBuf, candidateBuf);
  }

  private _firstHttpUrl(values: Array<string | null>): string | null {
    return values.find((value) => Boolean(value && /^https?:\/\//.test(value))) ?? null;
  }

  private _extractHttpUrl(text: string | null): string | null {
    if (!text) return null;
    const match = text.match(/https?:\/\/[^\s]+/);
    return match?.[0] ?? null;
  }

  private _toString(value: unknown): string {
    if (typeof value === "string") return value;
    if (typeof value === "number") return String(value);
    return "";
  }
}
