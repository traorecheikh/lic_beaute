import crypto from "node:crypto";

import { afterEach, describe, expect, it, vi } from "vitest";

import { prisma } from "../../lib/db/prisma.js";
import { PayDunyaAdapter } from "./paydunya.js";

describe("PayDunyaAdapter", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  const MASTER_KEY = "mk_test";
  const PRIVATE_KEY = "pk_test";
  const TOKEN = "tok_test";
  const BASE_ORIGIN = "https://app.example.com";

  function makeAdapter(overrides?: Partial<ConstructorParameters<typeof PayDunyaAdapter>>) {
    return new PayDunyaAdapter(
      overrides?.[0] ?? MASTER_KEY,
      overrides?.[1] ?? PRIVATE_KEY,
      overrides?.[2] ?? TOKEN,
      overrides?.[3] ?? BASE_ORIGIN,
      overrides?.[4] ?? "sandbox",
      overrides?.[5] ?? "https://app.paydunya.com"
    );
  }

  function mockFetch(
    json: unknown,
    opts?: { ok?: boolean; status?: number; statusText?: string }
  ) {
    return vi.fn().mockResolvedValue({
      ok: opts?.ok ?? true,
      status: opts?.status ?? 200,
      statusText: opts?.statusText ?? "OK",
      json: async () => json,
      text: async () => (typeof json === "object" ? JSON.stringify(json) : String(json))
    });
  }

  // ─── initiateDeposit ─────────────────────────────────────────────────────

  it("initiates deposit with default wave_senegal method when no channel given", async () => {
    const fetchMock = mockFetch({
      response_code: "00",
      response_text: "https://paydunya.com/sandbox-checkout/invoice/test_token_1",
      description: "Checkout Invoice Created.",
      token: "test_token_1"
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    const result = await adapter.initiateDeposit({
      paymentId: "pay_1",
      amountXof: 10000,
      description: "Acompte réservation b1",
      callbackUrl: "https://app.example.com/payment/callback",
      idempotencyKey: "idem-1"
    });

    expect(result.providerRef).toBe("test_token_1");
    expect(result.providerToken).toBe("test_token_1");
    expect(result.redirectUrl).toBe("https://app.paydunya.com/sandbox-checkout/invoice/test_token_1");
    expect(result.expiresAt).toBeInstanceOf(Date);

    const init = fetchMock.mock.calls[0][1] as RequestInit;
    const headers = init.headers as Record<string, string>;
    expect(headers["PAYDUNYA-MASTER-KEY"]).toBe(MASTER_KEY);
    expect(headers["PAYDUNYA-PRIVATE-KEY"]).toBe(PRIVATE_KEY);
    expect(headers["PAYDUNYA-TOKEN"]).toBe(TOKEN);

    const body = JSON.parse(String(init.body)) as Record<string, unknown>;
    expect(body.store).toMatchObject({ name: "Beauté Avenue Dev" });
    expect(body.actions).toMatchObject({
      return_url: "https://app.example.com/payment/callback",
      cancel_url: "https://app.example.com/payment/callback",
      callback_url: "https://app.example.com/api/v1/payments/webhooks/paydunya"
    });
    const cd = body.custom_data as Record<string, unknown>;
    expect(cd.payment_method).toBe("wave_senegal");
    expect(cd.paymentId).toBe("pay_1");
    const invoice = body.invoice as Record<string, unknown>;
    expect(invoice.total_amount).toBe(10000);
    // Items should be object format, not array
    expect(invoice.items).toMatchObject({
      item_0: expect.objectContaining({ name: "Acompte réservation b1" })
    });
  });

  it("uses production store name and production API URL", async () => {
    const fetchMock = mockFetch({
      response_code: "00",
      response_text: "https://paydunya.com/checkout/invoice/prod_tok",
      description: "Checkout Invoice Created.",
      token: "prod_tok"
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter([MASTER_KEY, PRIVATE_KEY, TOKEN, BASE_ORIGIN, "production", "https://app.paydunya.com"]);
    await adapter.initiateDeposit({
      paymentId: "pay_1",
      amountXof: 5000,
      description: "Acompte",
      callbackUrl: "https://cb",
      idempotencyKey: "k1"
    });

    const body = JSON.parse(String((fetchMock.mock.calls[0][1] as RequestInit).body)) as Record<string, unknown>;
    expect((body.store as Record<string, unknown>).name).toBe("Beauté Avenue");
  });

  it("initiates deposit with orange_senegal method when channel matches", async () => {
    const fetchMock = mockFetch({
      response_code: "00",
      response_text: "https://paydunya.com/sandbox-checkout/invoice/test_om",
      description: "Checkout Invoice Created.",
      token: "test_om"
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    await adapter.initiateDeposit({
      paymentId: "pay_2",
      amountXof: 15000,
      description: "Acompte",
      callbackUrl: "https://cb",
      idempotencyKey: "k2",
      channel: "orange_senegal",
      phone: "771234567"
    });

    const init = fetchMock.mock.calls[0][1] as RequestInit;
    const body = JSON.parse(String(init.body)) as Record<string, unknown>;
    expect((body.custom_data as Record<string, unknown>).payment_method).toBe("orange_senegal");
  });

  it("rejects initiateDeposit when provider returns non-00 response code", async () => {
    vi.stubGlobal(
      "fetch",
      mockFetch({
        response_code: "48",
        response_text: "Invalid parameters"
      })
    );

    const adapter = makeAdapter();
    await expect(
      adapter.initiateDeposit({
        paymentId: "p1",
        amountXof: 1000,
        description: "d",
        callbackUrl: "https://cb",
        idempotencyKey: "k"
      })
    ).rejects.toThrow(/PayDunya checkout-invoice\/create failed: 48 Invalid parameters/);
  });

  it("propagates non-ok HTTP in initiateDeposit", async () => {
    vi.stubGlobal(
      "fetch",
      mockFetch("Internal Server Error", { ok: false, status: 500 })
    );

    const adapter = makeAdapter();
    await expect(
      adapter.initiateDeposit({
        paymentId: "p1",
        amountXof: 1000,
        description: "d",
        callbackUrl: "https://cb",
        idempotencyKey: "k"
      })
    ).rejects.toThrow(/PayDunya \/checkout-invoice\/create failed: 500/);
  });

  it("handles sandbox API URL correctly", async () => {
    const fetchMock = mockFetch({
      response_code: "00",
      response_text: "OK",
      token: "sandbox_tok"
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    await adapter.initiateDeposit({
      paymentId: "pay_sand",
      amountXof: 1000,
      description: "d",
      callbackUrl: "https://cb",
      idempotencyKey: "k"
    });

    expect(String(fetchMock.mock.calls[0][0])).toBe(
      "https://app.paydunya.com/sandbox-api/v1/checkout-invoice/create"
    );
  });

  it("uses production API URL in production mode", async () => {
    const fetchMock = mockFetch({
      response_code: "00",
      response_text: "OK",
      token: "prod_tok"
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter([MASTER_KEY, PRIVATE_KEY, TOKEN, BASE_ORIGIN, "production", "https://app.paydunya.com"]);
    await adapter.initiateDeposit({
      paymentId: "pay_prod",
      amountXof: 1000,
      description: "d",
      callbackUrl: "https://cb",
      idempotencyKey: "k"
    });

    expect(String(fetchMock.mock.calls[0][0])).toBe(
      "https://app.paydunya.com/api/v1/checkout-invoice/create"
    );
  });

  // ─── executePayment ──────────────────────────────────────────────────────

  it("executes Wave payment successfully", async () => {
    const fetchMock = mockFetch({
      success: true,
      message: "Rediriger vers cette URL pour completer le paiement.",
      url: "https://pay.wave.com/c/test",
      currency: "XOF"
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    const result = await adapter.executePayment({
      paymentId: "pay_1",
      method: "wave_senegal",
      invoiceToken: "inv_tok"
    });

    expect(result.success).toBe(true);
    expect(result.status).toBe("authorized");
    expect(result.pendingProviderConfirmation).toBe(true);
    expect(result.providerTxId).toBe("inv_tok");

    const init = fetchMock.mock.calls[0][0] as string;
    expect(init).toContain("/softpay/wave-senegal");
    expect(init).toBe("https://app.paydunya.com/api/v1/softpay/wave-senegal");

    const body = JSON.parse(String((fetchMock.mock.calls[0][1] as RequestInit).body)) as Record<string, unknown>;
    expect(body).toMatchObject({
      wave_senegal_payment_token: "inv_tok",
      wave_senegal_fullName: "Client",
      wave_senegal_email: "client@beauteavenue.sn",
      wave_senegal_phone: "777777777"
    });
  });

  it("executes Orange Money payment successfully", async () => {
    const fetchMock = mockFetch({
      success: true,
      message: "Rediriger vers cette URL pour completer le paiement.",
      url: "https://app.paydunya.com/recharge-orange-sn",
      currency: "XOF"
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    const result = await adapter.executePayment({
      paymentId: "pay_2",
      method: "orange_senegal",
      invoiceToken: "inv_om"
    });

    expect(result.success).toBe(true);
    expect(result.status).toBe("authorized");
    expect(result.pendingProviderConfirmation).toBe(true);

    const init = fetchMock.mock.calls[0][0] as string;
    expect(init).toContain("/softpay/new-orange-money-senegal");
  });

  it("keeps async non-redirect methods awaiting confirmation", async () => {
    const fetchMock = mockFetch({
      success: true,
      message: "Votre paiement est en cours de traitement. Merci de valider le paiement après reception de sms pour le compléter.",
      currency: "XOF"
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    const result = await adapter.executePayment({
      paymentId: "pay_expresso",
      method: "expresso_sn",
      invoiceToken: "inv_expresso"
    });

    expect(result.success).toBe(true);
    expect(result.status).toBe("authorized");
    expect(result.pendingProviderConfirmation).toBe(true);
    expect(result.providerTxId).toBe("inv_expresso");
  });

  it("uses the provider success token returned by Wizall confirm", async () => {
    const fetchMock = mockFetch({
      success: true,
      message: "Paiement réussi",
      return_url: "https://www.paydunya.com/successful-payment",
      token: "wizall_confirm_tok"
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    const result = await adapter.executePayment({
      paymentId: "pay_wizall_confirm",
      method: "wizall_senegal",
      invoiceToken: "inv_wizall",
      details: {
        authorization_code: "461050",
        phone_number: "777777777",
        transaction_id: "286513913"
      }
    });

    expect(result.success).toBe(true);
    expect(result.status).toBe("succeeded");
    expect(result.pendingProviderConfirmation).toBe(false);
    expect(result.providerTxId).toBe("wizall_confirm_tok");

    const endpoint = fetchMock.mock.calls[0][0] as string;
    expect(endpoint).toContain("/softpay/wizall-money-senegal/confirm");
    const body = JSON.parse(String((fetchMock.mock.calls[0][1] as RequestInit).body)) as Record<string, unknown>;
    expect(body).toMatchObject({
      authorization_code: "461050",
      phone_number: "777777777",
      transaction_id: "286513913"
    });
  });

  it("passes code_country for Djamo payments", async () => {
    const fetchMock = mockFetch({
      success: true,
      message: "Rediriger vers cette URL pour completer le paiement.",
      url: "https://p.djamo.com/payment-link/charge"
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    await adapter.executePayment({
      paymentId: "pay_djamo",
      method: "djamo",
      invoiceToken: "inv_djamo",
      details: {
        phone: "0777568646",
        fullName: "Camille",
        email: "camille@example.com",
        code_country: "ci"
      }
    });

    const body = JSON.parse(String((fetchMock.mock.calls[0][1] as RequestInit).body)) as Record<string, unknown>;
    expect(body).toMatchObject({
      djamo_payment_token: "inv_djamo",
      djamo_phone: "0777568646",
      djamo_fullName: "Camille",
      djamo_email: "camille@example.com",
      code_country: "ci"
    });
  });

  it("returns failed when softpay execution returns success=false", async () => {
    vi.stubGlobal(
      "fetch",
      mockFetch({ success: false, message: "invoice inexistant" })
    );

    const adapter = makeAdapter();
    const result = await adapter.executePayment({
      paymentId: "pay_1",
      method: "wave_senegal",
      invoiceToken: "inv_bad"
    });

    expect(result.success).toBe(false);
    expect(result.status).toBe("failed");
    expect(result.providerTxId).toBeNull();
  });

  it("returns failed when HTTP request throws", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockRejectedValue(new Error("network error"))
    );

    const adapter = makeAdapter();
    const result = await adapter.executePayment({
      paymentId: "pay_1",
      method: "wave_senegal",
      invoiceToken: "inv_net"
    });

    expect(result.success).toBe(false);
    expect(result.status).toBe("failed");
    expect(result.providerTxId).toBeNull();
  });

  it("returns failed for unknown method code", async () => {
    const adapter = makeAdapter();
    const result = await adapter.executePayment({
      paymentId: "pay_1",
      method: "unknown_method",
      invoiceToken: "inv_unk"
    });

    expect(result.success).toBe(false);
    expect(result.status).toBe("failed");
  });

  // ─── getAvailableMethods ─────────────────────────────────────────────────

  it("returns all PayDunya methods with correct shape", async () => {
    vi.spyOn(prisma.platformSetting, "findMany").mockResolvedValue([
      { key: "paydunya_enabled_wave_senegal", value: "true" },
      { key: "paydunya_enabled_orange_senegal", value: "true" },
      { key: "paydunya_enabled_free_senegal", value: "true" },
      { key: "paydunya_enabled_wizall_senegal", value: "true" }
    ] as never);
    const adapter = makeAdapter();
    const methods = await adapter.getAvailableMethods();

    expect(methods.length).toBeGreaterThanOrEqual(4);
    const snMethod = methods.find((m) => m.country === "sn");
    expect(snMethod).toBeDefined();
    expect(snMethod).toMatchObject({
      code: expect.any(String),
      country: "sn",
      label: expect.any(String),
      enabled: true
    });
    const codes = methods.map((m) => m.code);
    expect(codes).toContain("wave_senegal");
    expect(codes).toContain("orange_senegal");
    expect(codes).toContain("free_senegal");
    expect(codes).toContain("wizall_senegal");
    const labels = methods.map((m) => m.label);
    expect(labels).toContain("Wave Sénégal");
    expect(labels).toContain("Orange Money Sénégal");
    expect(labels).toContain("Free Money Sénégal");
    expect(labels).toContain("Wizall Sénégal");
  });

  // ─── lookupTransaction ───────────────────────────────────────────────────

  it("returns pending status for lookupTransaction (no public endpoint)", async () => {
    const adapter = makeAdapter();
    const result = await adapter.lookupTransaction({ providerRef: "any_ref" });
    expect(result.status).toBe("pending");
  });

  it("confirms payment status from PayDunya invoice token", async () => {
    const fetchMock = mockFetch({
      response_code: "00",
      response_text: "https://app.paydunya.com/sandbox-checkout/invoice/test_token_1",
      description: "Checkout Invoice Confirmed",
      status: "completed",
      token: "test_token_1"
    });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    const status = await adapter.fetchPaymentStatus({ providerToken: "test_token_1" });

    expect(status).toBe("succeeded");
    expect(String(fetchMock.mock.calls[0][0])).toBe(
      "https://app.paydunya.com/sandbox-api/v1/checkout-invoice/confirm/test_token_1"
    );
  });

  // ─── verifyWebhookSignature ──────────────────────────────────────────────

  it("verifies the documented IPN SHA-512 webhook signature", () => {
    const adapter = makeAdapter();
    const hash = crypto
      .createHash("sha512")
      .update(MASTER_KEY)
      .digest("hex");

    const payload = JSON.stringify({
      data: {
        response_code: "00",
        response_text: "Transaction Found",
        hash,
        invoice: {
          token: "test_jkEdPY8SuG",
          total_amount: "42300",
          description: "Paiement test"
        },
        status: "completed",
        custom_data: {
          paymentId: "pay_1",
          idempotencyKey: "idem_1"
        }
      }
    });
    expect(adapter.verifyWebhookSignature({ rawBody: payload })).toBe(true);
  });

  it("keeps compatibility with the legacy webhook signature format", () => {
    const adapter = makeAdapter();
    const token = "ipn_token_123";
    const invoiceData = '{"status":"completed","total_amount":"10000","custom_data":{"paymentId":"pay_1"}}';
    const hash = crypto
      .createHash("sha512")
      .update(token + PRIVATE_KEY + invoiceData)
      .digest("hex");

    const payload = JSON.stringify({ token, invoice_data: invoiceData, hash });
    expect(adapter.verifyWebhookSignature({ rawBody: payload })).toBe(true);
  });

  it("rejects webhook with invalid SHA-512 hash", () => {
    const adapter = makeAdapter();
    const payload = JSON.stringify({
      token: "t1",
      invoice_data: '{"status":"completed"}',
      hash: "invalid_hash_value"
    });
    expect(adapter.verifyWebhookSignature({ rawBody: payload })).toBe(false);
  });

  it("rejects webhook with missing token or hash", () => {
    const adapter = makeAdapter();
    expect(adapter.verifyWebhookSignature({ rawBody: '{"hash":"x"}' })).toBe(false);
    expect(adapter.verifyWebhookSignature({ rawBody: '{"token":"t"}' })).toBe(false);
    expect(adapter.verifyWebhookSignature({ rawBody: "{}" })).toBe(false);
  });

  it("returns false when rawBody is malformed JSON", () => {
    const adapter = makeAdapter();
    expect(adapter.verifyWebhookSignature({ rawBody: "not-json" })).toBe(false);
  });

  it("handles empty invoice_data in hash verification", () => {
    const adapter = makeAdapter();
    const token = "ipn_token";
    const hash = crypto
      .createHash("sha512")
      .update(token + PRIVATE_KEY + "")
      .digest("hex");

    const payload = JSON.stringify({ token, invoice_data: "", hash });
    expect(adapter.verifyWebhookSignature({ rawBody: payload })).toBe(true);
  });

  // ─── parseWebhook ────────────────────────────────────────────────────────

  it("parses webhook with valid invoice_data JSON", () => {
    const adapter = makeAdapter();
    const event = adapter.parseWebhook(
      JSON.stringify({
        token: "ipn_token_1",
        invoice_data: JSON.stringify({
          status: "COMPLETED",
          total_amount: "15000",
          custom_data: { paymentId: "pay_1", idempotencyKey: "k1", payment_method: "wave_senegal" }
        }),
        hash: "any"
      })
    );

    expect(event.providerRef).toBe("ipn_token_1");
    expect(event.status).toBe("succeeded");
    expect(event.amountXof).toBe(15000);
    expect(event.metadata).toMatchObject({
      paymentId: "pay_1",
      idempotencyKey: "k1",
      payment_method: "wave_senegal"
    });
  });

  it("parses the documented IPN payload shape", () => {
    const adapter = makeAdapter();
    const event = adapter.parseWebhook(
      JSON.stringify({
        data: {
          response_code: "00",
          response_text: "Transaction Found",
          hash: "any",
          invoice: {
            token: "test_jkEdPY8SuG",
            total_amount: "42300",
            description: "Paiement test",
            custom_data: {
              paymentId: "pay_doc",
              idempotencyKey: "doc_1",
              payment_method: "wave_senegal"
            }
          },
          status: "completed"
        }
      })
    );

    expect(event.providerRef).toBe("test_jkEdPY8SuG");
    expect(event.status).toBe("succeeded");
    expect(event.amountXof).toBe(42300);
    expect(event.metadata).toMatchObject({
      paymentId: "pay_doc",
      idempotencyKey: "doc_1",
      payment_method: "wave_senegal"
    });
  });

  it("parses webhook with non-JSON invoice_data fallback to empty metadata", () => {
    const adapter = makeAdapter();
    const event = adapter.parseWebhook(
      JSON.stringify({
        token: "ipn_token_2",
        invoice_data: "not-json",
        hash: "any"
      })
    );

    expect(event.providerRef).toBe("ipn_token_2");
    // Defaults to "completed" → "succeeded" when invoice_data can't be parsed
    expect(event.status).toBe("succeeded");
    expect(event.amountXof).toBe(0);
    expect(event.metadata).not.toContain("paymentId");
  });

  it("parses webhook with missing/empty custom_data", () => {
    const adapter = makeAdapter();
    const event = adapter.parseWebhook(
      JSON.stringify({
        token: "ipn_token_3",
        invoice_data: JSON.stringify({
          status: "FAILED",
          total_amount: "5000"
        }),
        hash: "any"
      })
    );

    expect(event.status).toBe("failed");
    expect(event.amountXof).toBe(5000);
    expect(event.metadata).toEqual({});
  });

  it("parses webhook with null custom_data gracefully", () => {
    const adapter = makeAdapter();
    const event = adapter.parseWebhook(
      JSON.stringify({
        token: "ipn_null",
        invoice_data: JSON.stringify({
          status: "SUCCESS",
          total_amount: "3000",
          custom_data: null
        }),
        hash: "any"
      })
    );

    expect(event.status).toBe("succeeded");
    expect(event.metadata).toEqual({});
  });

  it("parses webhook with rawInvoiceData from nested invoice_data string", () => {
    const adapter = makeAdapter();
    const innerData = JSON.stringify({ extra: "value" });
    const event = adapter.parseWebhook(
      JSON.stringify({
        token: "ipn_raw",
        invoice_data: JSON.stringify({
          status: "PENDING",
          total_amount: "2000",
          invoice_data: innerData,
          custom_data: { paymentId: "pay_raw" }
        }),
        hash: "any"
      })
    );

    expect(event.metadata.rawInvoiceData).toBe(innerData);
    expect((event.metadata as Record<string, unknown>).paymentId).toBe("pay_raw");
  });

  it("parses webhook with status normalization mappings", () => {
    const adapter = makeAdapter();

    const testStatus = (providerStatus: string, expected: string) => {
      const event = adapter.parseWebhook(
        JSON.stringify({
          token: "t",
          invoice_data: JSON.stringify({
            status: providerStatus,
            total_amount: "1000"
          }),
          hash: "any"
        })
      );
      expect(event.status).toBe(expected);
    };

    testStatus("COMPLETED", "succeeded");
    testStatus("SUCCESS", "succeeded");
    testStatus("SUCCESSFUL", "succeeded");
    testStatus("PENDING", "pending");
    testStatus("PROCESSING", "pending");
    testStatus("FAILED", "failed");
    testStatus("ERROR", "failed");
    testStatus("CANCELLED", "failed");
    testStatus("CANCELED", "failed");
    testStatus("REFUNDED", "refunded");
    testStatus("AUTHORIZED", "authorized");
    testStatus("UNKNOWN", "pending");
  });

  // ─── requestRefund ───────────────────────────────────────────────────────

  it("refunds via two-step disburse flow successfully", async () => {
    const fetchMock = mockFetch({})
      .mockResolvedValueOnce({
        ok: true,
        json: async () => ({
          response_code: "00",
          response_text: "Success",
          invoice_token: "disburse_inv_1"
        })
      })
      .mockResolvedValueOnce({
        ok: true,
        json: async () => ({
          response_code: "00",
          response_text: "Success",
          status: "completed"
        })
      });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    const result = await adapter.requestRefund({
      providerRef: "ref_1",
      amountXof: 10000,
      reason: "Booking cancelled",
      phone: "771234567",
      method: "wave_senegal",
      withdrawMode: "wave-senegal"
    });

    expect(result.refundRef).toBe("disburse_inv_1");
    expect(fetchMock).toHaveBeenCalledTimes(2);

    // Step 1: get-invoice
    const step1Body = JSON.parse(String((fetchMock.mock.calls[0][1] as RequestInit).body)) as Record<string, unknown>;
    expect(step1Body.account_alias).toBe("771234567");
    expect(step1Body.withdraw_mode).toBe("wave-senegal");
    expect((step1Body.custom_data as Record<string, unknown>).type).toBe("disbursement");

    // Step 2: submit-invoice
    const step2Body = JSON.parse(String((fetchMock.mock.calls[1][1] as RequestInit).body)) as Record<string, unknown>;
    expect((step2Body.invoice as Record<string, unknown>).token).toBe("disburse_inv_1");
  });

  it("rejects refund when phone missing", async () => {
    const adapter = makeAdapter();
    await expect(
      adapter.requestRefund({
        providerRef: "r1",
        amountXof: 5000,
        reason: "Cancel"
      })
    ).rejects.toThrow(/requires a recipient phone number/);
  });

  it("rejects refund when get-invoice fails", async () => {
    vi.stubGlobal(
      "fetch",
      mockFetch({ response_code: "99", response_text: "Invoice creation failed" })
    );

    const adapter = makeAdapter();
    await expect(
      adapter.requestRefund({
        providerRef: "r1",
        amountXof: 5000,
        reason: "x",
        phone: "771234567",
        method: "orange_senegal"
      })
    ).rejects.toThrow(/Disburse get-invoice failed: 99 Invoice creation failed/);
  });

  it("rejects refund when submit-invoice fails", async () => {
    const fetchMock = mockFetch({})
      .mockResolvedValueOnce({
        ok: true,
        json: async () => ({
          response_code: "00",
          response_text: "Success",
          invoice_token: "disburse_inv"
        })
      })
      .mockResolvedValueOnce({
        ok: true,
        json: async () => ({
          response_code: "98",
          response_text: "Submit failed"
        })
      });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    await expect(
      adapter.requestRefund({
        providerRef: "r1",
        amountXof: 5000,
        reason: "x",
        phone: "771234567",
        method: "free_senegal"
      })
    ).rejects.toThrow(/Disburse submit-invoice failed: 98 Submit failed/);
  });

  it("resolves withdrawMode from method when not explicitly provided", async () => {
    const fetchMock = mockFetch({})
      .mockResolvedValueOnce({
        ok: true,
        json: async () => ({
          response_code: "00",
          response_text: "Success",
          invoice_token: "inv_wd"
        })
      })
      .mockResolvedValueOnce({
        ok: true,
        json: async () => ({
          response_code: "00",
          response_text: "Success",
          status: "completed"
        })
      });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    await adapter.requestRefund({
      providerRef: "r_wd",
      amountXof: 5000,
      reason: "x",
      phone: "771234567",
      method: "wizall_senegal"
    });

    const body = JSON.parse(String((fetchMock.mock.calls[0][1] as RequestInit).body)) as Record<string, unknown>;
    expect(body.withdraw_mode).toBe("wave-senegal");
  });

  it("uses default wave-senegal withdrawMode when method unknown", async () => {
    const fetchMock = mockFetch({})
      .mockResolvedValueOnce({
        ok: true,
        json: async () => ({
          response_code: "00",
          response_text: "Success",
          invoice_token: "inv_def"
        })
      })
      .mockResolvedValueOnce({
        ok: true,
        json: async () => ({
          response_code: "00",
          response_text: "Success",
          status: "completed"
        })
      });
    vi.stubGlobal("fetch", fetchMock);

    const adapter = makeAdapter();
    await adapter.requestRefund({
      providerRef: "r_def",
      amountXof: 5000,
      reason: "x",
      phone: "771234567",
      method: "unknown_method"
    });

    const body = JSON.parse(String((fetchMock.mock.calls[0][1] as RequestInit).body)) as Record<string, unknown>;
    expect(body.withdraw_mode).toBe("wave-senegal");
  });

  it("propagates non-ok HTTP response in refund get-invoice", async () => {
    vi.stubGlobal(
      "fetch",
      mockFetch("Service Unavailable", { ok: false, status: 503 })
    );

    const adapter = makeAdapter();
    await expect(
      adapter.requestRefund({
        providerRef: "r1",
        amountXof: 5000,
        reason: "x",
        phone: "771234567",
        method: "wave_senegal"
      })
    ).rejects.toThrow(/PayDunya \/disburse\/v2\/get-invoice failed: 503/);
  });

  // ─── fetchPaymentStatus ──────────────────────────────────────────────────

  it("throws when fetchPaymentStatus receives a non-ok HTTP response", async () => {
    vi.stubGlobal(
      "fetch",
      mockFetch("Service Unavailable", { ok: false, status: 503 })
    );

    const adapter = makeAdapter();
    await expect(
      adapter.fetchPaymentStatus({ providerToken: "any_token" })
    ).rejects.toThrow(/PayDunya \/checkout-invoice\/confirm failed: 503/);
  });

  // ─── normalizeStatus (direct mapping coverage) ──────────────────────────

  it("normalizeStatus covers all edge cases", () => {
    const adapter = makeAdapter();
    expect(adapter.normalizeStatus("COMPLETED")).toBe("succeeded");
    expect(adapter.normalizeStatus("SUCCESS")).toBe("succeeded");
    expect(adapter.normalizeStatus("SUCCESSFUL")).toBe("succeeded");
    expect(adapter.normalizeStatus("PENDING")).toBe("pending");
    expect(adapter.normalizeStatus("PROCESSING")).toBe("pending");
    expect(adapter.normalizeStatus("FAILED")).toBe("failed");
    expect(adapter.normalizeStatus("ERROR")).toBe("failed");
    expect(adapter.normalizeStatus("CANCELLED")).toBe("failed");
    expect(adapter.normalizeStatus("CANCELED")).toBe("failed");
    expect(adapter.normalizeStatus("REFUNDED")).toBe("refunded");
    expect(adapter.normalizeStatus("AUTHORIZED")).toBe("authorized");
    expect(adapter.normalizeStatus("COMPLETED")).toBe("succeeded");
  });
});
