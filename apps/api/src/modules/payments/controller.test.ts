import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const logger = { error: vi.fn(), warn: vi.fn(), info: vi.fn() };
  const adapter = {
    initiateDeposit: vi.fn(),
    verifyWebhookSignature: vi.fn(),
    parseWebhook: vi.fn(),
    fetchPaymentStatus: vi.fn()
  };
  const prisma = {
    payment: { findFirst: vi.fn(), update: vi.fn(), findUnique: vi.fn(), updateMany: vi.fn() },
    user: { findUnique: vi.fn() },
    booking: { update: vi.fn(), findUnique: vi.fn() },
    settlementEvent: { findFirst: vi.fn(), create: vi.fn() },
    bookingEvent: { create: vi.fn() },
    auditLog: { create: vi.fn() },
    platformSetting: { findUnique: vi.fn(), upsert: vi.fn() },
    subscriptionCharge: { findUnique: vi.fn(), findFirst: vi.fn(), update: vi.fn() },
    subscription: { update: vi.fn() },
    job: { findFirst: vi.fn().mockResolvedValue(null), create: vi.fn() },
    $transaction: vi.fn()
  };
  return { requireRole, ok, fail, logger, adapter, prisma };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/logger.js", () => ({ logger: mocks.logger }));
vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => mocks.adapter) }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../config.js", () => ({
  config: {
    paymentDriver: "intech",
    intechApiKey: "key",
    intechBaseUrl: "https://api.example.com",
    intechCallbackHmacEnabled: false,
    intechHmacSecretKey: "",
    intechHmacMaxAgeMs: 300000,
    intechRequestTimeoutMs: 10000,
    paymentReconcileMinIntervalMs: 60000,
    webOrigin: "https://web.example.com"
  }
}));

import { PaymentController } from "./index.js";

describe("PaymentController", () => {
  const c = new PaymentController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      payment: { update: vi.fn(), updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      booking: { update: vi.fn(), findUnique: vi.fn().mockResolvedValue({ status: "pending", source: "marketplace", startsAt: new Date(Date.now() + 48 * 60 * 60 * 1000), clientId: "client_1", client: { email: "test@test.com" }, service: { name: "Coupe" } }) },
      settlementEvent: { findFirst: vi.fn().mockResolvedValue(null), create: vi.fn() },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() },
      platformSetting: { findUnique: vi.fn().mockResolvedValue(null), upsert: vi.fn() },
      subscriptionCharge: { update: vi.fn() },
      subscription: { update: vi.fn() }
    }));
  });

  it("initiate returns 404 when pending payment missing", async () => {
    mocks.prisma.payment.findFirst.mockResolvedValue(null);
    await c.initiate({ body: { bookingId: "b1", provider: "intech" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "payment_not_found", expect.any(String));
  });

  it("initiate returns forbidden when payment is another client", async () => {
    mocks.prisma.payment.findFirst.mockResolvedValue({
      id: "p1",
      bookingId: "b1",
      amountXof: 1000,
      idempotencyKey: "k",
      booking: { clientId: "u2" }
    });
    await c.initiate({ body: { bookingId: "b1", provider: "intech" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", expect.any(String));
  });

  it("initiate requires phone for intech", async () => {
    mocks.prisma.payment.findFirst.mockResolvedValue({
      id: "p3",
      bookingId: "b3",
      amountXof: 1000,
      idempotencyKey: "k3",
      booking: { clientId: "u1" }
    });
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    await c.initiate({ body: { bookingId: "b3", provider: "intech" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "phone_required", expect.any(String));
  });

  it("status returns 404 when payment missing", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    await c.status({ params: { paymentId: "p1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "payment_not_found", expect.any(String));
  });

  it("status success returns payment payload", async () => {
    mocks.requireRole.mockReturnValue({ sub: "admin_1", role: "platform_admin" });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "p9",
      status: "succeeded",
      amountXof: 2000,
      provider: "intech",
      providerTxId: "ref9",
      createdAt: new Date(),
      booking: { clientId: "u2", salonId: "s1" }
    });
    await c.status({ params: { paymentId: "p9" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: "p9", status: "succeeded" }));
  });

  it("initiate success returns redirect URL", async () => {
    mocks.prisma.payment.findFirst.mockResolvedValue({
      id: "p1",
      bookingId: "b1",
      amountXof: 1000,
      idempotencyKey: "k",
      booking: { clientId: "u1" }
    });
    mocks.prisma.user.findUnique.mockResolvedValue({ phone: "771234567" });
    mocks.adapter.initiateDeposit.mockResolvedValue({ providerRef: "pref1", providerToken: "tok1", redirectUrl: "https://pay/x", expiresAt: new Date() });
    await c.initiate({ body: { bookingId: "b1", provider: "intech" } } as never, {} as never);
    expect(mocks.prisma.payment.update).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("initiate defaults db provider and forwards undefined phone on parsed non-intech payload", async () => {
    const cfgMod = await import("../../config.js");
    const prevDriver = cfgMod.config.paymentDriver;
    cfgMod.config.paymentDriver = "wave" as never;
    const contracts = await import("@beauteavenue/contracts");
    const parseSpy = vi.spyOn(contracts.paymentInitiateInputSchema, "parse").mockReturnValueOnce({
      bookingId: "b-wave",
      provider: "wave" as never,
      channel: "mobile_money" as never
    });
    mocks.prisma.payment.findFirst.mockResolvedValue({
      id: "p-wave",
      bookingId: "b-wave",
      amountXof: 1000,
      idempotencyKey: "k-wave",
      booking: { clientId: "u1" }
    });
    mocks.prisma.user.findUnique.mockResolvedValue({ phone: null });
    mocks.adapter.initiateDeposit.mockResolvedValue({ providerRef: "pref-wave", providerToken: "tok-wave", redirectUrl: "https://pay/wave", expiresAt: new Date() });
    await c.initiate({ body: { bookingId: "ignored-by-parse-spy" } } as never, {} as never);
    expect(mocks.adapter.initiateDeposit).toHaveBeenCalledWith(expect.objectContaining({ phone: undefined }));
    expect(mocks.prisma.payment.update).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ provider: "intech" })
    }));
    parseSpy.mockRestore();
    cfgMod.config.paymentDriver = prevDriver;
  });

  it("initiate returns internal_error on unexpected exception", async () => {
    mocks.prisma.payment.findFirst.mockRejectedValueOnce(new Error("db fail"));
    await c.initiate({ body: { bookingId: "b1", provider: "intech" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("initiate handles malformed redirect token fallback", async () => {
    mocks.prisma.payment.findFirst.mockResolvedValue({
      id: "p2",
      bookingId: "b2",
      amountXof: 1000,
      idempotencyKey: "k2",
      booking: { clientId: "u1" }
    });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ phone: "771234567" });
    mocks.adapter.initiateDeposit.mockResolvedValueOnce({
      providerRef: "pref2",
      providerToken: null,
      redirectUrl: "::not-a-url::",
      expiresAt: new Date()
    });
    await c.initiate({ body: { bookingId: "b2", provider: "intech" } } as never, {} as never);
    expect(mocks.prisma.payment.update).toHaveBeenCalled();
  });

  it("status forbids client access to other client payment", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "p1",
      status: "pending",
      amountXof: 1000,
      provider: "intech",
      providerTxId: null,
      createdAt: new Date(),
      booking: { clientId: "u2", salonId: "s1" }
    });
    await c.status({ params: { paymentId: "p1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", expect.any(String));
  });

  it("status returns internal_error on unexpected exception", async () => {
    mocks.prisma.payment.findUnique.mockRejectedValueOnce(new Error("db failure"));
    await c.status({ params: { paymentId: "p1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("reconcile returns missing provider token", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "p1",
      bookingId: "b1",
      status: "pending",
      amountXof: 1000,
      provider: "intech",
      providerTxId: null,
      webhookSignature: null,
      createdAt: new Date(),
      booking: { clientId: "u1", salonId: "s1" }
    });
    await c.reconcile({ params: { paymentId: "p1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "missing_provider_token", expect.any(String));
  });

  it("reconcile returns payment_not_found branches before and after apply", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValueOnce(null);
    await c.reconcile({ params: { paymentId: "missing" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "payment_not_found", expect.any(String));

    const tx = {
      payment: { update: vi.fn() },
      booking: { findUnique: vi.fn().mockResolvedValue({ status: "pending", source: "marketplace", startsAt: new Date(Date.now() + 48 * 60 * 60 * 1000), clientId: "client_1", client: { email: "test@test.com" }, service: { name: "Coupe" } }), update: vi.fn() },
      settlementEvent: { findFirst: vi.fn().mockResolvedValue(null), create: vi.fn() },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() },
      platformSetting: { findUnique: vi.fn().mockResolvedValue(null), upsert: vi.fn() },
      subscriptionCharge: { update: vi.fn() },
      subscription: { update: vi.fn() }
    };
    mocks.prisma.payment.findUnique
      .mockResolvedValueOnce({
        id: "p1",
        bookingId: "b1",
        status: "pending",
        amountXof: 1000,
        provider: "intech",
        providerTxId: null,
        webhookSignature: "tok",
        booking: { clientId: "u1", salonId: "s1" }
      })
      .mockResolvedValueOnce(null);
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));
    mocks.adapter.fetchPaymentStatus.mockResolvedValueOnce("succeeded");
    await c.reconcile({ params: { paymentId: "p1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "payment_not_found", expect.any(String));
  });

  it("refund returns not_refundable for failed status", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "platform_admin" });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "p1",
      bookingId: "b1",
      status: "failed",
      amountXof: 1000,
      providerTxId: "pref1",
      booking: { clientId: "u1", salonId: "s1" }
    });
    await c.refund({ params: { paymentId: "p1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "not_refundable", expect.any(String));
  });

  it("refund returns no_provider_ref and already_refunded branches", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "platform_admin" });
    mocks.prisma.payment.findUnique.mockResolvedValueOnce({
      id: "p1",
      bookingId: "b1",
      status: "succeeded",
      amountXof: 1000,
      providerTxId: null,
      booking: { clientId: "u1", salonId: "s1" }
    });
    await c.refund({ params: { paymentId: "p1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "no_provider_ref", expect.any(String));

    mocks.prisma.payment.findUnique.mockResolvedValueOnce({
      id: "p2",
      bookingId: "b2",
      status: "succeeded",
      amountXof: 1000,
      providerTxId: "ref2",
      booking: { clientId: "u1", salonId: "s1" }
    });
    mocks.prisma.payment.updateMany.mockResolvedValueOnce({ count: 0 });
    await c.refund({ params: { paymentId: "p2" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "already_refunded", expect.any(String));
  });

  it("webhook metadata paymentId executes providerRef binding ternary paths", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_NEW",
      status: "succeeded",
      amountXof: 0,
      metadata: { paymentId: "p_meta" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValueOnce({
      id: "p_meta",
      bookingId: "b_meta",
      amountXof: 1000,
      status: "pending",
      providerTxId: null,
      booking: { clientId: "u1", salonId: "s1" }
    });
    await c.webhookIntech({ body: { any: "payload" }, headers: {} } as never, {} as never);

    mocks.prisma.payment.findUnique.mockResolvedValueOnce({
      id: "p_meta_2",
      bookingId: "b_meta_2",
      amountXof: 1000,
      status: "pending",
      providerTxId: "REF_OLD",
      booking: { clientId: "u1", salonId: "s1" }
    });
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValueOnce(null);
    await c.webhookIntech({ body: { any: "payload" }, headers: {} } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("webhook metadata chargeId executes subscriptionCharge binding ternary paths", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_CHARGE",
      status: "failed",
      amountXof: 0,
      metadata: { paymentId: "ch_meta" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValueOnce({
      id: "ch_meta",
      subscriptionId: "sub1",
      amountXof: 1000,
      status: "pending",
      chargeType: "renewal",
      providerTxId: null,
      subscription: { id: "sub1" }
    });
    await c.webhookIntech({ body: { any: "payload" }, headers: {} } as never, {} as never);

    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValueOnce({
      id: "ch_meta_2",
      subscriptionId: "sub1",
      amountXof: 1000,
      status: "pending",
      chargeType: "renewal",
      providerTxId: "REF_OLD",
      subscription: { id: "sub1" }
    });
    await c.webhookIntech({ body: { any: "payload" }, headers: {} } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("webhook without metadata paymentId uses fallback findFirst paths for payment and subscriptionCharge", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_FALLBACK",
      status: "failed",
      amountXof: 0,
      metadata: {}
    });
    mocks.prisma.payment.findFirst.mockResolvedValueOnce({
      id: "p_fallback",
      bookingId: "b_fallback",
      amountXof: 1000,
      status: "pending",
      providerTxId: "REF_FALLBACK",
      booking: { clientId: "u1", salonId: "s1" }
    });
    await c.webhookIntech({ body: { any: "payload" }, headers: {} } as never, {} as never);

    mocks.prisma.payment.findFirst.mockResolvedValueOnce(null);
    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValueOnce({
      id: "ch_fallback",
      subscriptionId: "sub1",
      amountXof: 1000,
      status: "pending",
      chargeType: "renewal",
      providerTxId: "REF_FALLBACK",
      subscription: { id: "sub1" }
    });
    await c.webhookIntech({ body: { any: "payload" }, headers: {} } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("payment/charge status short-circuit branches skip transaction", async () => {
    const applyPaymentStatus = (c as any)._applyPaymentStatus.bind(c);
    const applySubscriptionChargeStatus = (c as any)._applySubscriptionChargeStatus.bind(c);

    await applyPaymentStatus(
      { id: "p_same", bookingId: "b1", amountXof: 1000, status: "pending" },
      "pending",
      "{}",
      undefined
    );
    await applyPaymentStatus(
      { id: "p_refunded", bookingId: "b2", amountXof: 1000, status: "refunded" },
      "succeeded",
      "{}",
      "provider-ref"
    );
    await applySubscriptionChargeStatus(
      { id: "ch_same", subscriptionId: "sub1", amountXof: 1000, status: "authorized", chargeType: "renewal" },
      "authorized",
      undefined,
      "{}"
    );
    await applySubscriptionChargeStatus(
      { id: "ch_refunded", subscriptionId: "sub2", amountXof: 1000, status: "refunded", chargeType: "renewal" },
      "succeeded",
      "provider-ref",
      "{}"
    );

    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
  });

  it("payment/charge status updates failed paths without provider ref", async () => {
    const tx = {
      payment: { update: vi.fn() },
      booking: { update: vi.fn(), findUnique: vi.fn() },
      settlementEvent: { findFirst: vi.fn(), create: vi.fn() },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() },
      subscriptionCharge: { update: vi.fn() },
      billingInvoice: { create: vi.fn() },
      subscription: { findUnique: vi.fn(), update: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));
    const applyPaymentStatus = (c as any)._applyPaymentStatus.bind(c);
    await applyPaymentStatus(
      { id: "p_failed", bookingId: "b_failed", amountXof: 5000, status: "pending" },
      "failed",
      "{}",
      undefined
    );
    expect(tx.booking.update).toHaveBeenCalledWith({ where: { id: "b_failed" }, data: { depositPaymentStatus: "failed" } });

    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));
    const applySubscriptionChargeStatus = (c as any)._applySubscriptionChargeStatus.bind(c);
    await applySubscriptionChargeStatus(
      { id: "ch_failed", subscriptionId: "sub_failed", amountXof: 4000, status: "pending", chargeType: "renewal" },
      "failed",
      undefined,
      "{}"
    );
    expect(tx.subscriptionCharge.update).toHaveBeenCalledWith(expect.objectContaining({
      where: { id: "ch_failed" },
      data: { status: "failed" }
    }));
  });

  it("extractCheckoutToken handles invalid URL and empty path token", () => {
    expect((c as any)._extractCheckoutToken("not-a-url")).toBeNull();
    expect((c as any)._extractCheckoutToken("https://pay.example.com/checkout/")).toBe("checkout");
    expect((c as any)._extractCheckoutToken("https://pay.example.com")).toBeNull();
  });

  it("refund returns payment_not_found when payment id does not exist", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "platform_admin" });
    mocks.prisma.payment.findUnique.mockResolvedValueOnce(null);
    await c.refund({ params: { paymentId: "missing" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "payment_not_found", expect.any(String));
  });

  it("claimReconcileWindow returns blocked result when interval not elapsed", async () => {
    const now = Date.now();
    const tx = {
      platformSetting: {
        findUnique: vi.fn().mockResolvedValue({ value: String(now - 1000) }),
        upsert: vi.fn()
      }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));
    const result = await (c as any)._claimReconcileWindow("pay_1");
    expect(result.allowed).toBe(false);
    expect(tx.platformSetting.upsert).not.toHaveBeenCalled();
  });

  it("reconcile returns 429 when claim window is throttled", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "p-throttle",
      bookingId: "b-throttle",
      status: "pending",
      amountXof: 1000,
      provider: "intech",
      providerTxId: null,
      webhookSignature: "tok-throttle",
      booking: { clientId: "u1", salonId: "s1" }
    });
    const tx = {
      platformSetting: {
        findUnique: vi.fn().mockResolvedValue({ value: String(Date.now() - 1000) }),
        upsert: vi.fn()
      }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));
    await c.reconcile({ params: { paymentId: "p-throttle" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 429, "reconcile_throttled", expect.any(String));
  });

  it("claimReconcileWindow proceeds when prior timestamp is non-finite", async () => {
    const tx = {
      platformSetting: {
        findUnique: vi.fn().mockResolvedValue({ value: "NaN" }),
        upsert: vi.fn()
      }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));
    const result = await (c as any)._claimReconcileWindow("pay_nan");
    expect(result.allowed).toBe(true);
    expect(tx.platformSetting.upsert).toHaveBeenCalled();
  });

  it("claimReconcileWindow allows when elapsed is above min interval", async () => {
    const tx = {
      platformSetting: {
        findUnique: vi.fn().mockResolvedValue({ value: String(Date.now() - 120_000) }),
        upsert: vi.fn()
      }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));
    const result = await (c as any)._claimReconcileWindow("pay_old");
    expect(result.allowed).toBe(true);
    expect(tx.platformSetting.upsert).toHaveBeenCalled();
  });

  it("payment status update sets refunded deposit status branch", async () => {
    const tx = {
      payment: { update: vi.fn() },
      booking: { update: vi.fn(), findUnique: vi.fn() },
      settlementEvent: { findFirst: vi.fn(), create: vi.fn() },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() },
      subscriptionCharge: { update: vi.fn() },
      billingInvoice: { create: vi.fn() },
      subscription: { findUnique: vi.fn(), update: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));
    await (c as any)._applyPaymentStatus(
      { id: "p_refund_branch", bookingId: "b_refund_branch", amountXof: 1000, status: "authorized" },
      "refunded",
      "{}",
      undefined
    );
    expect(tx.booking.update).toHaveBeenCalledWith({ where: { id: "b_refund_branch" }, data: { depositPaymentStatus: "refunded" } });
  });

  it("payment status update for authorized updates deposit and auto-confirms pending booking", async () => {
    const tx = {
      payment: { update: vi.fn() },
      booking: { update: vi.fn(), findUnique: vi.fn().mockResolvedValue({ status: "pending", startsAt: new Date(Date.now() + 48 * 60 * 60 * 1000), clientId: "c1", client: { email: "c@test.com" }, service: { name: "Coupe" } }) },
      settlementEvent: { findFirst: vi.fn(), create: vi.fn() },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() },
      subscriptionCharge: { update: vi.fn() },
      billingInvoice: { create: vi.fn() },
      subscription: { findUnique: vi.fn(), update: vi.fn() },
      job: { findFirst: vi.fn().mockResolvedValue(null), create: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));
    await (c as any)._applyPaymentStatus(
      { id: "p_authorized", bookingId: "b_authorized", amountXof: 1000, status: "pending" },
      "authorized",
      "{}",
      undefined
    );
    expect(tx.booking.update).toHaveBeenCalledWith({
      where: { id: "b_authorized" },
      data: { depositPaymentStatus: "authorized", status: "confirmed" }
    });
    expect(tx.bookingEvent.create).toHaveBeenCalledWith({
      data: expect.objectContaining({
        bookingId: "b_authorized",
        eventType: "auto_confirmed_after_payment",
        fromStatus: "pending",
        toStatus: "confirmed"
      })
    });
    expect(tx.settlementEvent.create).not.toHaveBeenCalled();
  });
});
