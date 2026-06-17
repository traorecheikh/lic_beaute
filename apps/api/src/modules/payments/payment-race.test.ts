import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const adapter = {
    initiateDeposit: vi.fn(),
    verifyWebhookSignature: vi.fn(),
    parseWebhook: vi.fn(),
    fetchPaymentStatus: vi.fn(),
    requestRefund: vi.fn()
  };

  const tx = {
    payment: { update: vi.fn() },
    booking: { update: vi.fn(), findUnique: vi.fn() },
    settlementEvent: { findFirst: vi.fn(), create: vi.fn() },
    bookingEvent: { create: vi.fn() },
    auditLog: { create: vi.fn() },
    subscriptionCharge: { update: vi.fn() },
    billingInvoice: { create: vi.fn() },
    subscription: { update: vi.fn(), findUnique: vi.fn() },
    salon: { update: vi.fn() },
    platformSetting: { findUnique: vi.fn(), upsert: vi.fn() }
  };

  const prisma = {
    payment: { findFirst: vi.fn(), findUnique: vi.fn(), update: vi.fn(), updateMany: vi.fn() },
    subscriptionCharge: { findFirst: vi.fn(), findUnique: vi.fn() },
    billingInvoice: { create: vi.fn(), findFirst: vi.fn() },
    subscription: { update: vi.fn() },
    platformSetting: { findUnique: vi.fn(), upsert: vi.fn() },
    user: { findUnique: vi.fn() },
    job: { findFirst: vi.fn().mockResolvedValue(null), create: vi.fn() },
    $transaction: vi.fn(async (fn: (txArg: typeof tx) => Promise<void>) => fn(tx))
  };

  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const loggerError = vi.fn();
  const loggerWarn = vi.fn();

  return { adapter, tx, prisma, requireRole, ok, fail, loggerError, loggerWarn };
});

vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: () => mocks.adapter }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/auth/index.js", () => {
  class HttpAuthError extends Error {
    statusCode: number;
    code: string;
    constructor(statusCode: number, code: string, message: string) {
      super(message);
      this.statusCode = statusCode;
      this.code = code;
    }
  }
  return { HttpAuthError, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/logger.js", () => ({ logger: { error: mocks.loggerError, warn: mocks.loggerWarn } }));

import { PaymentController } from "./index.js";

describe("PaymentController - Hardcore webhook security", { timeout: 10000 }, () => {
  const controller = new PaymentController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.tx.settlementEvent.findFirst.mockResolvedValue(null);
    mocks.tx.booking.findUnique.mockResolvedValue({
      status: "pending", startsAt: new Date(Date.now() + 48 * 60 * 60 * 1000),
      clientId: "client_1", client: { email: "test@test.com" }, service: { name: "Coupe" }
    });
  });

  // ─── ProviderRef binding attack surface ─────────────────────────────────

  it("rejects webhook when metadata.paymentId exists but providerRef does not match (spoofing attempt)", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_ATTACKER",
      status: "succeeded",
      amountXof: 0,
      metadata: { paymentId: "pay_victim" }
    });
    // Existing payment has a different providerTxId — this is a hijack attempt
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_victim",
      bookingId: "b_victim",
      amountXof: 10000,
      status: "pending",
      providerTxId: "REF_REAL",
      booking: { clientId: "u_other", salonId: "s1" }
    });
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValueOnce(null);

    await controller.webhookPayDunya({ body: {}, headers: {} } as never, {} as never);

    // Must NOT process — the providerRef doesn't match the stored one
    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("accepts webhook when providerTxId is null (first-time binding)", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_FIRST",
      status: "succeeded",
      amountXof: 10000,
      metadata: { paymentId: "pay_new" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_new",
      bookingId: "b_new",
      amountXof: 10000,
      status: "pending",
      providerTxId: null,
      booking: { clientId: "client_1", salonId: "s1" }
    });

    await controller.webhookPayDunya({ body: {}, headers: {} } as never, {} as never);

    // Must proceed — null providerTxId means no prior binding, so the ref is accepted
    expect(mocks.prisma.$transaction).toHaveBeenCalled();
    expect(mocks.tx.payment.update).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ status: "succeeded", providerTxId: "REF_FIRST" })
    }));
  });

  it("accepts webhook when providerRef matches existing providerTxId exactly", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_123",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_match" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_match",
      bookingId: "b_match",
      amountXof: 12000,
      status: "pending",
      providerTxId: "REF_123",
      booking: { clientId: "client_1", salonId: "s1" }
    });

    await controller.webhookPayDunya({ body: {}, headers: {} } as never, {} as never);

    expect(mocks.prisma.$transaction).toHaveBeenCalled();
  });

  it("rejects subscription charge webhook when metadata chargeId exists but providerRef mismatches", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_FAKE",
      status: "succeeded",
      amountXof: 0,
      metadata: { paymentId: "ch_victim" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "ch_victim",
      subscriptionId: "sub_1",
      amountXof: 5000,
      status: "pending",
      chargeType: "renewal",
      providerTxId: "REF_REAL",
      billingInvoiceId: null,
      subscription: { salonId: "s1", tier: "standard" }
    });

    await controller.webhookPayDunya({ body: {}, headers: {} } as never, {} as never);

    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("accepts subscription charge webhook with null providerTxId (first binding)", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_CHARGE",
      status: "succeeded",
      amountXof: 5000,
      metadata: { paymentId: "ch_new" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "ch_new",
      subscriptionId: "sub_1",
      amountXof: 5000,
      status: "pending",
      chargeType: "renewal",
      providerTxId: null,
      billingInvoiceId: null,
      subscription: { salonId: null, tier: "standard" }
    });
    mocks.tx.subscription.findUnique.mockResolvedValue({ salonId: null, expiresAt: null });
    // billingInvoice.create must return an object with .id for the invoice update
    mocks.tx.billingInvoice.create.mockResolvedValue({ id: "inv_1" });

    await controller.webhookPayDunya({ body: {}, headers: {} } as never, {} as never);

    expect(mocks.prisma.$transaction).toHaveBeenCalled();
  });

  // ─── Amount mismatch edge cases ─────────────────────────────────────────

  it("rejects webhook when callback amount differs by more than 1 XOF", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_AMT",
      status: "succeeded",
      amountXof: 9998, // diff of 2 > 1
      metadata: { paymentId: "pay_amt" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_amt",
      bookingId: "b_amt",
      amountXof: 10000,
      status: "pending",
      providerTxId: "REF_AMT",
      booking: { clientId: "client_1", salonId: "s1" }
    });

    await controller.webhookPayDunya({ body: {}, headers: {} } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "amount_mismatch", expect.any(String));
  });

  it("accepts webhook when callback amount differs by exactly 1 XOF", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_ROUND",
      status: "succeeded",
      amountXof: 10001,
      metadata: { paymentId: "pay_round" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_round",
      bookingId: "b_round",
      amountXof: 10000,
      status: "pending",
      providerTxId: "REF_ROUND",
      booking: { clientId: "client_1", salonId: "s1" }
    });

    await controller.webhookPayDunya({ body: {}, headers: {} } as never, {} as never);

    // Diff is exactly 1 — within margin
    expect(mocks.prisma.$transaction).toHaveBeenCalled();
  });

  it("accepts webhook when callback amount is 0 (provider didn't send amount)", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_ZERO",
      status: "succeeded",
      amountXof: 0,
      metadata: { paymentId: "pay_zero" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_zero",
      bookingId: "b_zero",
      amountXof: 10000,
      status: "pending",
      providerTxId: "REF_ZERO",
      booking: { clientId: "client_1", salonId: "s1" }
    });

    await controller.webhookPayDunya({ body: {}, headers: {} } as never, {} as never);

    // amountXof is 0 -> amount guard skipped
    expect(mocks.prisma.$transaction).toHaveBeenCalled();
  });

  // ─── Fallback lookup edge cases ─────────────────────────────────────────

  it("finds payment by providerRef fallback when no metadata paymentId and externalTransactionId absent", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_FALLBACK",
      status: "succeeded",
      amountXof: 10000,
      metadata: {}
    });
    mocks.prisma.payment.findFirst.mockResolvedValue({
      id: "pay_fb",
      bookingId: "b_fb",
      amountXof: 10000,
      status: "pending",
      providerTxId: "REF_FALLBACK",
      booking: { clientId: "client_1", salonId: "s1" }
    });

    await controller.webhookPayDunya({ body: {}, headers: {} } as never, {} as never);

    expect(mocks.prisma.payment.findFirst).toHaveBeenCalledWith(
      expect.objectContaining({
        where: expect.objectContaining({
          OR: expect.arrayContaining([
            expect.objectContaining({ providerTxId: "REF_FALLBACK" }),
            expect.objectContaining({ webhookSignature: "REF_FALLBACK" })
          ])
        })
      })
    );
    expect(mocks.prisma.$transaction).toHaveBeenCalled();
  });

  it("finds payment by webhookSignature when providerTxId doesn't match but webhookSignature does", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_WEBHOOK",
      status: "succeeded",
      amountXof: 8000,
      metadata: {}
    });
    mocks.prisma.payment.findFirst.mockResolvedValue({
      id: "pay_wh",
      bookingId: "b_wh",
      amountXof: 8000,
      status: "pending",
      providerTxId: "REF_DIFFERENT", // providerTxId doesn't match
      webhookSignature: "REF_WEBHOOK", // but webhookSignature does
      booking: { clientId: "client_1", salonId: "s1" }
    });

    await controller.webhookPayDunya({ body: {}, headers: {} } as never, {} as never);

    expect(mocks.prisma.$transaction).toHaveBeenCalled();
  });

  it("ignores webhook for unknown payment — returns received:true", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_UNKNOWN",
      status: "succeeded",
      amountXof: 5000,
      metadata: { paymentId: "pay_ghost" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.payment.findFirst.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValue(null);

    await controller.webhookPayDunya({ body: {}, headers: {} } as never, {} as never);

    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("falls back to externalTransactionId OR query when available", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_EXT",
      status: "succeeded",
      amountXof: 5000,
      metadata: { externalTransactionId: "EXT_1001" }
    });
    mocks.prisma.payment.findFirst.mockResolvedValue({
      id: "pay_ext",
      bookingId: "b_ext",
      amountXof: 5000,
      status: "pending",
      providerTxId: "REF_EXT",
      booking: { clientId: "client_1", salonId: "s1" }
    });

    await controller.webhookPayDunya({ body: {}, headers: {} } as never, {} as never);

    expect(mocks.prisma.payment.findFirst).toHaveBeenCalledWith(
      expect.objectContaining({
        where: expect.objectContaining({
          OR: expect.arrayContaining([
            expect.objectContaining({ providerTxId: "REF_EXT" }),
            expect.objectContaining({ webhookSignature: "EXT_1001" })
          ])
        })
      })
    );
    expect(mocks.prisma.$transaction).toHaveBeenCalled();
  });

  // ─── Concurrent reconcile + webhook races ───────────────────────────────

  it("reconcile and webhook can both succeed treating same payment independently", async () => {
    // Simulate: reconcile runs first and changes status to succeeded
    mocks.adapter.fetchPaymentStatus.mockResolvedValue("succeeded");
    mocks.prisma.payment.findUnique
      .mockResolvedValueOnce({
        id: "pay_race",
        bookingId: "b_race",
        amountXof: 10000,
        status: "pending",
        provider: "paydunya",
        providerTxId: "REF_RACE",
        webhookSignature: "tok_race",
        createdAt: new Date(),
        booking: { clientId: "client_1", salonId: "s1" }
      })
      // After _applyPaymentStatus, payment is already succeeded
      .mockResolvedValueOnce({
        id: "pay_race",
        bookingId: "b_race",
        amountXof: 10000,
        status: "succeeded",
        provider: "paydunya",
        providerTxId: "REF_RACE",
        createdAt: new Date(),
        booking: { clientId: "client_1", salonId: "s1" }
      });

    await controller.reconcile({ params: { paymentId: "pay_race" } } as never, {} as never);

    expect(mocks.tx.payment.update).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ status: "succeeded" })
    }));
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({
      id: "pay_race",
      status: "succeeded"
    }));
  });

  it("short-circuits when reconcile races with webhook and payment already succeeded", async () => {
    // Payment is already succeeded when reconcile tries to apply
    mocks.adapter.fetchPaymentStatus.mockResolvedValue("succeeded");
    mocks.prisma.payment.findUnique
      .mockResolvedValueOnce({
        id: "pay_race2",
        bookingId: "b_race2",
        amountXof: 10000,
        status: "succeeded",
        provider: "paydunya",
        providerTxId: "REF_RACE2",
        webhookSignature: "tok_race2",
        createdAt: new Date(),
        booking: { clientId: "client_1", salonId: "s1" }
      })
      // Refreshed payment lookup after _applyPaymentStatus returns early
      .mockResolvedValueOnce({
        id: "pay_race2",
        bookingId: "b_race2",
        amountXof: 10000,
        status: "succeeded",
        provider: "paydunya",
        providerTxId: "REF_RACE2",
        createdAt: new Date(),
        booking: { clientId: "client_1", salonId: "s1" }
      });

    await controller.reconcile({ params: { paymentId: "pay_race2" } } as never, {} as never);

    // _applyPaymentStatus short-circuits on same status — no status update
    expect(mocks.tx.payment.update).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({
      id: "pay_race2",
      status: "succeeded"
    }));
  });

  // ─── Concurrent refund + webhook race ───────────────────────────────────

  it("refund claim wins over late-arriving webhook", async () => {
    mocks.requireRole.mockReturnValue({ sub: "owner_1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "salon_1" });
    mocks.adapter.requestRefund.mockResolvedValue({ refundRef: "refund_race" });

    // Payment is in succeeded state
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_race_ref",
      bookingId: "b_race_ref",
      amountXof: 10000,
      status: "succeeded",
      providerTxId: "REF_RACE_REF",
      booking: { clientId: "c1", salonId: "salon_1" }
    });
    mocks.prisma.payment.updateMany.mockResolvedValue({ count: 1 });

    await controller.refund({ params: { paymentId: "pay_race_ref" } } as never, {} as never);

    expect(mocks.adapter.requestRefund).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), {
      refunded: true,
      refundRef: "refund_race"
    });

    // Now a webhook arrives with status "succeeded" — should be short-circuited by refunded check
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_RACE_REF",
      status: "succeeded",
      amountXof: 10000,
      metadata: { paymentId: "pay_race_ref" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_race_ref",
      bookingId: "b_race_ref",
      amountXof: 10000,
      status: "refunded",
      booking: { clientId: "c1", salonId: "salon_1" }
    });

    // Call _applyPaymentStatus directly to verify the short-circuit
    mocks.prisma.$transaction.mockClear();
    mocks.tx.payment.update.mockClear();
    const applyPaymentStatus = (controller as any)._applyPaymentStatus.bind(controller);
    await applyPaymentStatus(
      { id: "pay_race_ref", bookingId: "b_race_ref", amountXof: 10000, status: "refunded" },
      "succeeded",
      "{}",
      "REF_RACE_REF"
    );

    // Must not process — already refunded
    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
  });

  // ─── Double reconcile throttle across concurrent requests ───────────────

  it("handles two simultaneous reconcile calls — first wins, second is throttled", async () => {
    // Both calls start at the same time
    mocks.prisma.payment.findUnique
      .mockResolvedValueOnce({
        id: "pay_double",
        bookingId: "b_double",
        amountXof: 10000,
        status: "pending",
        provider: "paydunya",
        providerTxId: "REF_DOUBLE",
        webhookSignature: "tok_double",
        createdAt: new Date(),
        booking: { clientId: "client_1", salonId: "s1" }
      })
      // Refreshed payment after _applyPaymentStatus (first call)
      .mockResolvedValueOnce({
        id: "pay_double",
        bookingId: "b_double",
        amountXof: 10000,
        status: "succeeded",
        provider: "paydunya",
        providerTxId: "REF_DOUBLE",
        createdAt: new Date()
      })
      // Payment lookup for second reconcile call
      .mockResolvedValueOnce({
        id: "pay_double",
        bookingId: "b_double",
        amountXof: 10000,
        status: "pending",
        provider: "paydunya",
        providerTxId: "REF_DOUBLE",
        webhookSignature: "tok_double",
        createdAt: new Date(),
        booking: { clientId: "client_1", salonId: "s1" }
      });

    // _checkReconcileWindow succeeds (no prior timestamp)
    mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce(null);
    // _claimReconcileWindow succeeds
    mocks.prisma.platformSetting.upsert.mockResolvedValueOnce(undefined);
    // _applyPaymentStatus
    const appTx = {
      payment: { update: vi.fn() },
      booking: { update: vi.fn(), findUnique: vi.fn().mockResolvedValue({
        status: "pending", startsAt: new Date(Date.now() + 48 * 60 * 60 * 1000),
        clientId: "client_1", client: { email: "test@test.com" }, service: { name: "Coupe" }
      })},
      settlementEvent: { findFirst: vi.fn().mockResolvedValue(null), create: vi.fn() },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() }
    } as const;

    mocks.prisma.$transaction
      .mockImplementationOnce(async (fn: any) => fn(appTx));

    mocks.adapter.fetchPaymentStatus.mockResolvedValue("succeeded");

    // First call succeeds
    await controller.reconcile({ params: { paymentId: "pay_double" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();

    // Second call — _checkReconcileWindow sees previous timestamp from first call
    mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: String(Date.now()) });

    await controller.reconcile({ params: { paymentId: "pay_double" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 429, "reconcile_throttled", expect.any(String));
  });
});
