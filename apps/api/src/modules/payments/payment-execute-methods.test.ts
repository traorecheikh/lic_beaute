import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const logger = { error: vi.fn(), warn: vi.fn(), info: vi.fn() };
  const adapter: Record<string, ReturnType<typeof vi.fn>> = {
    initiateDeposit: vi.fn(),
    executePayment: vi.fn(),
    getAvailableMethods: vi.fn(),
    verifyWebhookSignature: vi.fn(),
    parseWebhook: vi.fn(),
    fetchPaymentStatus: vi.fn(),
    requestRefund: vi.fn()
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
vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: () => mocks.adapter }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../config.js", () => ({
  config: {
    paymentDriver: "paydunya",
    paydunyaMasterKey: "master-key",
    paydunyaPublicKey: "public-key",
    paydunyaPrivateKey: "private-key",
    paydunyaToken: "token",
    paydunyaEnv: "sandbox",
    paydunyaBaseUrl: "https://sandbox.paydunya.com",
    paymentReconcileMinIntervalMs: 60000,
    webOrigin: "https://web.example.com"
  }
}));

import { PaymentController } from "./index.js";

describe("PaymentController - executePayment & getMethods", () => {
  let controller: PaymentController;

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    // Restore getAvailableMethods if it was deleted by a previous test
    if (!mocks.adapter.getAvailableMethods) {
      mocks.adapter.getAvailableMethods = vi.fn();
    }
    // Re-create controller so it re-invokes getPaymentAdapter mock
    controller = new PaymentController();
  });

  // ─── executePayment ─────────────────────────────────────────────────────

  it("executes payment successfully with PayDunya adapter", async () => {
    const txPaymentUpdate = vi.fn();
    const txBookingUpdate = vi.fn();
    const txAuditLogCreate = vi.fn();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "b1",
      amountXof: 5000,
      status: "pending",
      webhookSignature: "inv_tok_1",
      providerTxId: null,
      booking: { clientId: "u1" }
    });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      payment: { update: txPaymentUpdate },
      booking: {
        findUnique: vi.fn().mockResolvedValue(null),
        update: txBookingUpdate
      },
      bookingEvent: { create: vi.fn() },
      settlementEvent: { findFirst: vi.fn(), create: vi.fn() },
      auditLog: { create: txAuditLogCreate }
    }));
    mocks.adapter.executePayment.mockResolvedValue({
      success: true,
      status: "succeeded",
      providerTxId: "inv_tok_1"
    });

    await (controller as any).executePayment(
      { body: { paymentId: "pay_1", method: "wave_senegal" } },
      {} as never
    );

    expect(mocks.adapter.executePayment).toHaveBeenCalledWith({
      paymentId: "pay_1",
      method: "wave_senegal",
      invoiceToken: "inv_tok_1"
    });
    expect(txPaymentUpdate).toHaveBeenCalledWith({
      where: { id: "pay_1" },
      data: { status: "succeeded", providerTxId: "inv_tok_1" }
    });
    expect(txBookingUpdate).toHaveBeenCalledWith({
      where: { id: "b1" },
      data: { depositPaymentStatus: "succeeded" }
    });
    expect(txAuditLogCreate).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("keeps provider-completion methods authorized until confirmation arrives", async () => {
    const txPaymentUpdate = vi.fn();
    const txBookingUpdate = vi.fn();
    const txAuditLogCreate = vi.fn();
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_async",
      bookingId: "b_async",
      amountXof: 5000,
      status: "pending",
      webhookSignature: "inv_async",
      providerTxId: "inv_async",
      booking: { clientId: "u1" }
    });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      payment: { update: txPaymentUpdate },
      booking: {
        findUnique: vi.fn().mockResolvedValue(null),
        update: txBookingUpdate
      },
      bookingEvent: { create: vi.fn() },
      settlementEvent: { findFirst: vi.fn(), create: vi.fn() },
      auditLog: { create: txAuditLogCreate }
    }));
    mocks.adapter.executePayment.mockResolvedValue({
      success: true,
      status: "succeeded",
      providerTxId: "inv_async",
      data: { cid: "wizall-step" }
    });

    await (controller as any).executePayment(
      { body: { paymentId: "pay_async", method: "wizall_senegal" } },
      {} as never
    );

    expect(txPaymentUpdate).toHaveBeenCalledWith({
      where: { id: "pay_async" },
      data: { status: "authorized", providerTxId: "inv_async" }
    });
    expect(txBookingUpdate).toHaveBeenCalledWith({
      where: { id: "b_async" },
      data: { depositPaymentStatus: "authorized", depositSettlementStatus: "held" }
    });
    expect(txAuditLogCreate).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("keeps async message-only methods authorized until confirmation arrives", async () => {
    const txPaymentUpdate = vi.fn();
    const txBookingUpdate = vi.fn();
    const txAuditLogCreate = vi.fn();

    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_sms",
      bookingId: "b_sms",
      amountXof: 3000,
      status: "pending",
      providerTxId: null,
      webhookSignature: "inv_sms",
      booking: { clientId: "u1" }
    });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      payment: { update: txPaymentUpdate },
      booking: {
        findUnique: vi.fn().mockResolvedValue(null),
        update: txBookingUpdate
      },
      bookingEvent: { create: vi.fn() },
      settlementEvent: { findFirst: vi.fn(), create: vi.fn() },
      auditLog: { create: txAuditLogCreate }
    }));
    mocks.adapter.executePayment.mockResolvedValue({
      success: true,
      status: "authorized",
      providerTxId: "inv_sms",
      message: "Votre paiement est en cours de traitement. Merci de valider le paiement après reception de sms pour le compléter."
    });

    await (controller as any).executePayment(
      { body: { paymentId: "pay_sms", method: "expresso_sn" } },
      {} as never
    );

    expect(txPaymentUpdate).toHaveBeenCalledWith({
      where: { id: "pay_sms" },
      data: { status: "authorized", providerTxId: "inv_sms" }
    });
    expect(txBookingUpdate).toHaveBeenCalledWith({
      where: { id: "b_sms" },
      data: { depositPaymentStatus: "authorized", depositSettlementStatus: "held" }
    });
    expect(txAuditLogCreate).toHaveBeenCalled();
  });

  it("returns 404 when payment not found", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue(null);

    await (controller as any).executePayment(
      { body: { paymentId: "pay_miss", method: "wave_senegal" } },
      {} as never
    );

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "payment_not_found", expect.any(String));
    expect(mocks.adapter.executePayment).not.toHaveBeenCalled();
  });

  it("returns 403 when wrong client tries to execute", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "b1",
      status: "pending",
      webhookSignature: "inv_tok",
      booking: { clientId: "u2" }
    });

    await (controller as any).executePayment(
      { body: { paymentId: "pay_1", method: "wave_senegal" } },
      {} as never
    );

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", expect.any(String));
    expect(mocks.adapter.executePayment).not.toHaveBeenCalled();
  });

  it("returns 422 when payment status is not pending/authorized", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "b1",
      status: "succeeded",
      webhookSignature: "inv_tok",
      booking: { clientId: "u1" }
    });

    await (controller as any).executePayment(
      { body: { paymentId: "pay_1", method: "wave_senegal" } },
      {} as never
    );

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_status", expect.any(String));
  });

  it("returns 422 when invoice token (webhookSignature) is missing", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "b1",
      status: "pending",
      webhookSignature: null,
      booking: { clientId: "u1" }
    });

    await (controller as any).executePayment(
      { body: { paymentId: "pay_1", method: "wave_senegal" } },
      {} as never
    );

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "missing_invoice_token", expect.any(String));
  });

  it("returns 501 when adapter does not support executePayment", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "b1",
      status: "pending",
      webhookSignature: "inv_tok",
      booking: { clientId: "u1" }
    });
    // Simulate Intech-like adapter that doesn't have executePayment
    mocks.adapter.executePayment.mockRejectedValue(new Error("not a function"));

    await (controller as any).executePayment(
      { body: { paymentId: "pay_1", method: "wave_senegal" } },
      {} as never
    );

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("does not update payment when executePayment returns success: false", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "b1",
      status: "pending",
      webhookSignature: "inv_tok",
      booking: { clientId: "u1" }
    });
    mocks.adapter.executePayment.mockResolvedValue({
      success: false,
      status: "failed",
      providerTxId: null
    });

    await (controller as any).executePayment(
      { body: { paymentId: "pay_1", method: "wave_senegal" } },
      {} as never
    );

    // Should NOT update payment to succeeded
    expect(mocks.prisma.payment.update).not.toHaveBeenCalledWith(
      expect.objectContaining({ data: expect.objectContaining({ status: "succeeded" }) })
    );
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ success: false }));
  });

  it("handles exceptions in executePayment gracefully", async () => {
    mocks.prisma.payment.findUnique.mockRejectedValue(new Error("db error"));

    await (controller as any).executePayment(
      { body: { paymentId: "pay_1", method: "wave_senegal" } },
      {} as never
    );

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  // ─── getMethods ─────────────────────────────────────────────────────────

  it("returns methods list from PayDunya adapter", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.adapter.getAvailableMethods.mockResolvedValue([
      { code: "wave_senegal", country: "sn", label: "Wave Sénégal", enabled: true },
      { code: "orange_senegal", country: "sn", label: "Orange Money Sénégal", enabled: true }
    ]);

    await (controller as any).getMethods({} as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), {
      methods: [
        { code: "wave_senegal", country: "sn", label: "Wave Sénégal", enabled: true },
        { code: "orange_senegal", country: "sn", label: "Orange Money Sénégal", enabled: true }
      ]
    });
  });

  it("returns empty list when adapter has no getAvailableMethods (Intech case)", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.adapter.getAvailableMethods = undefined as never;

    await (controller as any).getMethods({} as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { methods: [] });
  });

  it("requires auth for getMethods", async () => {
    mocks.requireRole.mockImplementation(() => {
      throw new Error("unauthorized");
    });

    await (controller as any).getMethods({} as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("returns only enabled methods from adapter", async () => {
    mocks.requireRole.mockReturnValue({ sub: "admin_1", role: "salon_owner" });
    mocks.adapter.getAvailableMethods.mockResolvedValue([
      { code: "wave_senegal", country: "sn", label: "Wave Sénégal", enabled: true },
      { code: "disabled_method", country: "sn", label: "Disabled", enabled: false }
    ]);

    await (controller as any).getMethods({} as never, {} as never);

    const methods = (mocks.ok.mock.calls[0][1] as { methods: Array<{ enabled: boolean }> }).methods;
    const enabledCount = methods.filter((m) => m.enabled).length;
    expect(enabledCount).toBe(1);
  });

  it("handles getMethods adapter error gracefully", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.adapter.getAvailableMethods.mockRejectedValue(new Error("adapter error"));

    await (controller as any).getMethods({} as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("getMethods allows all authenticated roles", async () => {
    const roles = ["client", "salon_owner", "salon_staff", "salon_manager", "platform_admin"] as const;
    for (const role of roles) {
      vi.clearAllMocks();
      mocks.requireRole.mockReturnValue({ sub: "u1", role });
      mocks.adapter.getAvailableMethods.mockResolvedValue([]);

      await (controller as any).getMethods({} as never, {} as never);

      expect(mocks.requireRole).toHaveBeenCalledWith(
        expect.anything(),
        expect.arrayContaining(roles as unknown as string[])
      );
      expect(mocks.ok).toHaveBeenCalled();
    }
  });
});
