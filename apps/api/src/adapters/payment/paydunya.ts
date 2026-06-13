import crypto from "node:crypto";

import type { PaymentStatus } from "@beauteavenue/contracts";
import { prisma } from "../../lib/db/prisma.js";
import { logger } from "../../lib/logger.js";

function normalizePhoneNumber(phone: string, country: string): string {
  let cleaned = phone.replace(/[\s+\-()]/g, "");
  if (cleaned.startsWith("221") && cleaned.length > 9) cleaned = cleaned.substring(3);
  if (cleaned.startsWith("225") && cleaned.length > 10) cleaned = cleaned.substring(3);
  if (cleaned.startsWith("223") && cleaned.length > 8) cleaned = cleaned.substring(3);
  if (cleaned.startsWith("228") && cleaned.length > 8) cleaned = cleaned.substring(3);
  if (cleaned.startsWith("229") && cleaned.length > 8) cleaned = cleaned.substring(3);
  if (cleaned.startsWith("226") && cleaned.length > 8) cleaned = cleaned.substring(3);
  if (cleaned.startsWith("237") && cleaned.length > 9) cleaned = cleaned.substring(3);
  return cleaned;
}

function inferDjamoCodeCountry(phone: string): "sn" | "ci" {
  const cleaned = phone.replace(/[\s\-()]/g, "");
  if (
    cleaned.startsWith("+225") ||
    cleaned.startsWith("225") ||
    cleaned.length === 10
  ) {
    return "ci";
  }
  return "sn";
}

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
  token?: string;
  url?: string;
  return_url?: string;
  other_url?: Record<string, unknown>;
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

type DocumentedIpnPayload = {
  data?: {
    response_code?: string;
    response_text?: string;
    hash?: string;
    invoice?: Record<string, unknown>;
    custom_data?: Record<string, unknown> | null;
    status?: string;
  };
  hash?: string;
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
  carte_bancaire: {
    country: "intl", label: "Carte Bancaire",
    endpoint: "card",
    bodyKeys: { tokenKey: "token", phoneKey: "", nameKey: "full_name", emailKey: "email" },
    disbursable: false
  },
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
  },
  expresso_sn: {
    country: "sn", label: "Expresso Sénégal",
    endpoint: "expresso-senegal",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "expresso_sn_phone", nameKey: "expresso_sn_fullName", emailKey: "expresso_sn_email" },
    disbursable: false
  },
  om_ci: {
    country: "ci", label: "Orange Money Côte d'Ivoire",
    endpoint: "orange-money-ci",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "orange_money_ci_phone_number", nameKey: "orange_money_ci_customer_fullname", emailKey: "orange_money_ci_email" },
    disbursable: false
  },
  mtn_ci: {
    country: "ci", label: "MTN Money Côte d'Ivoire",
    endpoint: "mtn-ci",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "mtn_ci_phone_number", nameKey: "mtn_ci_customer_fullname", emailKey: "mtn_ci_email" },
    disbursable: false
  },
  moov_ci: {
    country: "ci", label: "Moov Côte d'Ivoire",
    endpoint: "moov-ci",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "moov_ci_phone_number", nameKey: "moov_ci_customer_fullname", emailKey: "moov_ci_email" },
    disbursable: false
  },
  wave_ci: {
    country: "ci", label: "Wave Côte d'Ivoire",
    endpoint: "wave-ci",
    bodyKeys: { tokenKey: "wave_ci_payment_token", phoneKey: "wave_ci_phone", nameKey: "wave_ci_fullName", emailKey: "wave_ci_email" },
    disbursable: false
  },
  om_bf: {
    country: "bf", label: "Orange Money Burkina Faso",
    endpoint: "orange-money-burkina",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "phone_bf", nameKey: "name_bf", emailKey: "email_bf" },
    disbursable: false
  },
  moov_bf: {
    country: "bf", label: "Moov Burkina Faso",
    endpoint: "moov-burkina",
    bodyKeys: { tokenKey: "moov_burkina_faso_payment_token", phoneKey: "moov_burkina_faso_phone_number", nameKey: "moov_burkina_faso_fullName", emailKey: "moov_burkina_faso_email" },
    disbursable: false
  },
  moov_bj: {
    country: "bj", label: "Moov Bénin",
    endpoint: "moov-benin",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "moov_benin_phone_number", nameKey: "moov_benin_customer_fullname", emailKey: "moov_benin_email" },
    disbursable: false
  },
  mtn_bj: {
    country: "bj", label: "MTN Bénin",
    endpoint: "mtn-benin",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "mtn_benin_phone_number", nameKey: "mtn_benin_customer_fullname", emailKey: "mtn_benin_email" },
    disbursable: false
  },
  t_money_tg: {
    country: "tg", label: "T-Money Togo",
    endpoint: "t-money-togo",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "phone_t_money", nameKey: "name_t_money", emailKey: "email_t_money" },
    disbursable: false
  },
  moov_tg: {
    country: "tg", label: "Moov Togo",
    endpoint: "moov-togo",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "moov_togo_phone_number", nameKey: "moov_togo_customer_fullname", emailKey: "moov_togo_email" },
    disbursable: false
  },
  om_ml: {
    country: "ml", label: "Orange Money Mali",
    endpoint: "orange-money-mali",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "orange_money_mali_phone_number", nameKey: "orange_money_mali_customer_fullname", emailKey: "orange_money_mali_email" },
    disbursable: false
  },
  moov_ml: {
    country: "ml", label: "Moov Mali",
    endpoint: "moov-mali",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "moov_ml_phone_number", nameKey: "moov_ml_customer_fullname", emailKey: "moov_ml_email" },
    disbursable: false
  },
  mtn_cm: {
    country: "cm", label: "MTN Cameroun",
    endpoint: "mtn-cameroun",
    bodyKeys: { tokenKey: "payment_token", phoneKey: "mtn_cameroun_phone_number", nameKey: "mtn_cameroun_customer_fullname", emailKey: "mtn_cameroun_email" },
    disbursable: false
  },
  djamo: {
    country: "intl", label: "Djamo",
    endpoint: "djamo",
    bodyKeys: { tokenKey: "djamo_payment_token", phoneKey: "djamo_phone", nameKey: "djamo_fullName", emailKey: "djamo_email" },
    disbursable: false
  },
  paydunya_wallet: {
    country: "intl", label: "Portefeuille PayDunya",
    endpoint: "paydunya",
    bodyKeys: { tokenKey: "invoice_token", phoneKey: "phone_phone", nameKey: "customer_name", emailKey: "customer_email" },
    disbursable: false
  }
};

const SOFTPAY_METHOD_MAP: Record<string, string> = {
  carte_bancaire: "carte_bancaire",
  wave_senegal: "wave_senegal",
  orange_senegal: "orange_senegal",
  free_senegal: "free_senegal",
  wizall_senegal: "wizall_senegal",
  expresso_sn: "expresso_sn",
  om_sn: "orange_senegal",
  free_money_sn: "free_senegal",
  wizall_sn: "wizall_senegal",
  wave_sn: "wave_senegal",
  om_ci: "om_ci",
  mtn_ci: "mtn_ci",
  moov_ci: "moov_ci",
  wave_ci: "wave_ci",
  om_bf: "om_bf",
  moov_bf: "moov_bf",
  moov_bj: "moov_bj",
  mtn_bj: "mtn_bj",
  t_money_tg: "t_money_tg",
  moov_tg: "moov_tg",
  om_ml: "om_ml",
  moov_ml: "moov_ml",
  mtn_cm: "mtn_cm",
  djamo: "djamo",
  paydunya_wallet: "paydunya_wallet",

  paydunya_card: "carte_bancaire",
  paydunya_wave_sn: "wave_senegal",
  paydunya_orange_sn: "orange_senegal",
  paydunya_free_sn: "free_senegal",
  paydunya_expresso: "expresso_sn",
  paydunya_orange_ml: "om_ml",
  paydunya_moov_ml: "moov_ml",
  paydunya_mtn_cm: "mtn_cm",
  paydunya_mtn_bj: "mtn_bj",
  paydunya_moov_bj: "moov_bj",
  paydunya_moov_tg: "moov_tg",
  paydunya_moov_ci: "moov_ci",
  paydunya_mtn_ci: "mtn_ci",
  paydunya_wave_ci: "wave_ci",
  paydunya_tm_ci: "om_ci",
  paydunya_orange_bf: "om_bf",
  paydunya_moov_bf: "moov_bf",
  paydunya_t_money_tg: "t_money_tg",
  paydunya_djamo: "djamo"
};

const SENEGAL_TOGGLE_BY_CODE: Record<string, string> = {
  wave_senegal: "paydunya_enabled_wave_senegal",
  orange_senegal: "paydunya_enabled_orange_senegal",
  free_senegal: "paydunya_enabled_free_senegal",
  wizall_senegal: "paydunya_enabled_wizall_senegal",
  expresso_sn: "paydunya_enabled_expresso_senegal"
};

export class PayDunyaAdapter implements PaymentAdapter {
  private invoiceApiUrl: string;
  private softpayApiUrl: string;
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
    this.invoiceApiUrl = this.env === "sandbox"
      ? "https://app.paydunya.com/sandbox-api/v1"
      : `${this.baseUrl}/api/v1`;
    // SoftPay method endpoints live under `/api/v1`, even for sandbox credentials.
    this.softpayApiUrl = `${this.baseUrl}/api/v1`;
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
        cancel_url: params.callbackUrl,
        return_url: params.callbackUrl,
        callback_url: `${this.baseOrigin}/api/v1/payments/webhooks/paydunya`
      },
      custom_data: {
        paymentId: params.paymentId,
        idempotencyKey: params.idempotencyKey,
        payment_method: method
      }
    };

    const json = await this._postJson<CheckoutCreateInvoiceResponse>(
      this.invoiceApiUrl,
      "/checkout-invoice/create",
      body
    );

    if (json.response_code !== "00") {
      throw new Error(
        `PayDunya checkout-invoice/create failed: ${json.response_code} ${json.response_text}`
      );
    }

    return {
      redirectUrl:
        typeof json.response_text === "string" && /^https?:\/\//i.test(json.response_text)
          ? json.response_text
          : `${this.checkoutHost}/invoice/${json.token}`,
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
    details?: Record<string, any>;
  }): Promise<{ success: boolean; status: string; providerTxId: string | null; [key: string]: any }> {
    const mappedMethod = SOFTPAY_METHOD_MAP[params.method] || params.method;
    const methodEntry = PAYDUNYA_METHODS[mappedMethod];
    if (!methodEntry) {
      return { success: false, status: "failed", providerTxId: null, message: `Méthode de paiement non supportée: ${params.method}` };
    }

    const keys = methodEntry.bodyKeys;
    const details = params.details ?? {};

    // Get input phone, email, and name
    const rawPhoneInput = String(
      details.phone_number || details.phoneNumber || details.phone || details.phone_phone || ""
    );
    let inputPhone = rawPhoneInput;
    if (inputPhone) {
      inputPhone = normalizePhoneNumber(inputPhone, methodEntry.country);
    } else {
      inputPhone = "777777777";
    }

    const inputName = details.customer_name || details.fullName || details.name || details.full_name || "Client";
    const inputEmail = details.customer_email || details.email || "client@beauteavenue.sn";

    // Build the request body dynamically
    const body: Record<string, unknown> = {};

    if (keys.tokenKey) {
      body[keys.tokenKey] = params.invoiceToken;
    }
    if (keys.phoneKey) {
      body[keys.phoneKey] = inputPhone;
    }
    if (keys.nameKey) {
      body[keys.nameKey] = inputName;
    }
    if (keys.emailKey) {
      body[keys.emailKey] = inputEmail;
    }

    if (keys.extra) {
      Object.assign(body, keys.extra);
    }

    // Apply special custom mappings and transformations
    if (mappedMethod === "carte_bancaire") {
      body.full_name = inputName;
      body.email = inputEmail;
      body.card_number = (details.cardNumber || details.card_number || "").replace(/\s/g, "");
      body.card_cvv = details.cardCvv || details.card_cvv || "";
      body.card_expired_date_year = details.cardExpiredDateYear || details.card_expired_date_year || "";
      body.card_expired_date_month = details.cardExpiredDateMonth || details.card_expired_date_month || "";
      body.token = params.invoiceToken;
    }

    if (mappedMethod === "om_ci") {
      body.orange_money_ci_otp = details.otp || details.orange_money_ci_otp || "";
    }

    if (mappedMethod === "mtn_ci") {
      body.mtn_ci_wallet_provider = details.provider || details.mtn_ci_wallet_provider || "MTNCI";
    }

    if (mappedMethod === "mtn_bj") {
      body.mtn_benin_wallet_provider = details.provider || details.mtn_benin_wallet_provider || "MTNBENIN";
    }

    if (mappedMethod === "mtn_cm") {
      body.mtn_cameroun_wallet_provider = details.provider || details.mtn_cameroun_wallet_provider || "MTNCAMEROUN";
    }

    if (mappedMethod === "om_bf") {
      body.otp_code = details.otp || details.otp_code || "";
    }

    if (mappedMethod === "moov_tg") {
      body.moov_togo_customer_address = details.address || details.moov_togo_customer_address || "Lomé";
    }

    if (mappedMethod === "om_ml") {
      body.orange_money_mali_customer_address = details.address || details.orange_money_mali_customer_address || "Bamako";
    }

    if (mappedMethod === "moov_ml") {
      body.moov_ml_customer_address = details.address || details.moov_ml_customer_address || "Bamako";
    }

    if (mappedMethod === "djamo") {
      body.code_country = String(
        details.code_country ||
        details.codeCountry ||
        details.country ||
        inferDjamoCodeCountry(rawPhoneInput || inputPhone)
      ).toLowerCase();
    }

    if (mappedMethod === "paydunya_wallet") {
      body.password = details.password || "";
    }

    // Determine target endpoint (handling Wizall confirm step)
    let endpoint = `/softpay/${methodEntry.endpoint}`;
    if (mappedMethod === "wizall_senegal" && details.authorization_code) {
      endpoint = `/softpay/wizall-money-senegal/confirm`;
      body.authorization_code = details.authorization_code;
      body.phone_number = inputPhone;
      body.transaction_id = details.transaction_id || details.transactionId || "";
      // delete normal softpay keys
      delete body.invoice_token;
      delete body.customer_name;
      delete body.customer_email;
    }

    logger.info("[paydunya] softpay execute", { endpoint, method: mappedMethod, bodyKeys: Object.keys(body) });

    try {
      const json = await this._postJson<SoftPayExecuteResponse>(
        this.softpayApiUrl,
        endpoint,
        body
      );

      logger.info("[paydunya] softpay response", { success: json.success, message: json.message, keys: Object.keys(json) });

      if (json.success) {
        const pendingProviderConfirmation = this._requiresProviderConfirmation(mappedMethod, json);
        const providerTxId = typeof json.token === "string" && json.token.length > 0
          ? json.token
          : params.invoiceToken;
        return {
          ...json,
          success: true,
          status: pendingProviderConfirmation ? "authorized" : "succeeded",
          pendingProviderConfirmation,
          providerTxId
        };
      }

      const errorMsg =
        json.message ||
        (json as any).response_text ||
        (json as any).errors?.message ||
        (json as any).errors?.description ||
        "Échec du paiement";
      logger.warn("[paydunya] softpay failed", { method: mappedMethod, message: errorMsg, fullResponse: JSON.stringify(json).slice(0, 500) });
      return {
        success: false,
        status: "failed",
        providerTxId: null,
        message: errorMsg
      };
    } catch (e: any) {
      logger.error("[paydunya] softpay exception", { method: mappedMethod, error: String(e) });
      return {
        success: false,
        status: "failed",
        providerTxId: null,
        message: e.message || "Erreur réseau lors de la transaction."
      };
    }
  }

  // ─── getAvailableMethods ──────────────────────────────────────────────────

  async getAvailableMethods(): Promise<AvailableMethod[]> {
    const allowedCountries = new Set(
      (process.env.PAYDUNYA_ALLOWED_COUNTRIES ?? "sn")
        .split(",")
        .map((v) => v.trim().toLowerCase())
        .filter(Boolean)
    );
    const rows = await prisma.platformSetting.findMany({
      where: { group: "payment_methods" },
      select: { key: true, value: true }
    });
    const settingMap = new Map(rows.map((row) => [row.key, row.value.toLowerCase()]));

    return Object.entries(PAYDUNYA_METHODS)
      .filter(([, entry]) => entry.country === "intl" || allowedCountries.has(entry.country))
      .map(([code, entry]) => ({
        code,
        country: entry.country,
        label: entry.label,
        enabled: (settingMap.get(SENEGAL_TOGGLE_BY_CODE[code] ?? "") ?? "false") === "true"
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
      const payload = JSON.parse(params.rawBody) as Partial<IpnPayload> & DocumentedIpnPayload;
      const payloadHash = typeof payload.hash === "string"
        ? payload.hash
        : typeof payload.data?.hash === "string"
          ? payload.data.hash
          : null;

      if (!payloadHash) return false;

      const documentedHash = crypto
        .createHash("sha512")
        .update(this.masterKey)
        .digest("hex");

      if (this._secureCompare(documentedHash, payloadHash)) {
        return true;
      }

      if (typeof payload.token === "string") {
        const legacyHash = crypto
          .createHash("sha512")
          .update(payload.token + this.privateKey + (payload.invoice_data ?? ""))
          .digest("hex");
        return this._secureCompare(legacyHash, payloadHash);
      }

      return false;
    } catch {
      return false;
    }
  }

  // ─── parseWebhook ─────────────────────────────────────────────────────────

  parseWebhook(rawBody: string): ParsedWebhookEvent {
    const payload = JSON.parse(rawBody) as Partial<IpnPayload> & DocumentedIpnPayload;

    let providerRef = typeof payload.token === "string" ? payload.token : "";
    let invoiceData: Record<string, unknown> = {};
    let customData: Record<string, unknown> = {};

    if (typeof payload.data === "object" && payload.data) {
      const documentedInvoice =
        typeof payload.data.invoice === "object" && payload.data.invoice
          ? payload.data.invoice
          : {};
      invoiceData = {
        ...documentedInvoice,
        ...(payload.data.status ? { status: payload.data.status } : {}),
        ...(payload.data.custom_data ? { custom_data: payload.data.custom_data } : {})
      };
      providerRef = typeof documentedInvoice.token === "string" ? documentedInvoice.token : providerRef;
      customData =
        typeof payload.data.custom_data === "object" && payload.data.custom_data
          ? payload.data.custom_data
          : typeof documentedInvoice.custom_data === "object" && documentedInvoice.custom_data
            ? documentedInvoice.custom_data as Record<string, unknown>
            : {};
    } else {
      try {
        invoiceData = JSON.parse(payload.invoice_data ?? "{}") as Record<string, unknown>;
      } catch {
        invoiceData = {};
      }
      customData =
        typeof invoiceData.custom_data === "object" && invoiceData.custom_data
          ? invoiceData.custom_data as Record<string, unknown>
          : {};
    }

    const metadata: Record<string, unknown> = {
      paymentId: customData.paymentId,
      idempotencyKey: customData.idempotencyKey,
      payment_method: customData.payment_method
    };
    if (invoiceData.invoice_data && typeof invoiceData.invoice_data === "string") {
      metadata.rawInvoiceData = invoiceData.invoice_data;
    }

    return {
      providerRef,
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
      this.invoiceApiUrl,
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
      this.invoiceApiUrl,
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
    const response = await fetch(
      `${this.invoiceApiUrl}/checkout-invoice/confirm/${encodeURIComponent(params.providerToken)}`,
      {
        method: "GET",
        headers: this._headers(),
        signal: AbortSignal.timeout(30_000)
      }
    );

    if (!response.ok) {
      const text = await response.text();
      throw new Error(`PayDunya /checkout-invoice/confirm failed: ${response.status} ${text}`);
    }

    const json = (await response.json()) as Record<string, unknown>;
    const responseCode = typeof json.response_code === "string" ? json.response_code : null;
    if (responseCode && responseCode !== "00") {
      throw new Error(
        `PayDunya checkout-invoice/confirm failed: ${responseCode} ${String(json.response_text ?? "")}`.trim()
      );
    }

    const rawStatus = typeof json.status === "string"
      ? json.status
      : typeof json.response_text === "string"
        ? json.response_text
        : "pending";

    return this.normalizeStatus(rawStatus);
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

  private async _postJson<T>(baseUrl: string, path: string, body: Record<string, unknown>): Promise<T> {
    const response = await fetch(`${baseUrl}${path}`, {
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

  private _secureCompare(expected: string, actual: string): boolean {
    if (expected.length !== actual.length) return false;
    return crypto.timingSafeEqual(
      Buffer.from(expected, "utf8"),
      Buffer.from(actual, "utf8")
    );
  }

  private _requiresProviderConfirmation(
    method: string,
    response: SoftPayExecuteResponse
  ): boolean {
    if (response.url || response.other_url) return true;

    const data = response.data && typeof response.data === "object"
      ? response.data as Record<string, unknown>
      : null;
    const details = data?.details && typeof data.details === "object"
      ? data.details as Record<string, unknown>
      : null;

    const providerState = typeof data?.status === "string" ? data.status.toUpperCase() : null;
    if (providerState === "PENDING" || providerState === "PROCESSING") return true;

    const cid = typeof data?.cid === "string" ? data.cid : typeof details?.cid === "string" ? details.cid : null;
    if (cid) return true;

    const normalizedMessage = response.message
      .normalize("NFD")
      .replace(/\p{Diacritic}/gu, "")
      .toLowerCase();
    if (
      normalizedMessage.includes("rediriger vers cette url") ||
      normalizedMessage.includes("en cours de traitement") ||
      normalizedMessage.includes("veuillez completer le paiement") ||
      normalizedMessage.includes("veuillez tapez") ||
      normalizedMessage.includes("compose") ||
      normalizedMessage.includes("valider le paiement")
    ) {
      return true;
    }

    // Wave and OM always require the user to approve on their device; treat them
    // as async regardless of what the execute response contains (safety net for
    // unexpected non-URL responses from the live API).
    return new Set([
      "wave_senegal",
      "orange_senegal",
      "free_senegal",
      "expresso_sn",
      "moov_bf",
      "mtn_bj",
      "t_money_tg",
      "moov_ci"
    ]).has(method);
  }
}
