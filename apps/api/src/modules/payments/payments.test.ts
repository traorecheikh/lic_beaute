import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const adapter = {
    initiateDeposit: vi.fn(),
    verifyWebhookSignature: vi.fn(),
    parseWebhook: vi.fn(),
    requestRefund: vi.fn(),
    fetchPaymentStatus: vi.fn(),
    normalizeStatus: vi.fn()
  };

  const tx = {
    payment: { update: vi.fn() },
    booking: { update: vi.fn(), findUnique: vi.fn() },
    bookingEvent: { create: vi.fn() },
    settlementEvent: { findFirst: vi.fn(), create: vi.fn() },
    auditLog: { create: vi.fn() },
    subscriptionCharge: { update: vi.fn() },
    billingInvoice: { create: vi.fn().mockResolvedValue({ id: "inv_new" }) },
    subscription: { update: vi.fn(), findUnique: vi.fn() },
    salon: { update: vi.fn() },
    platformSetting: { findUnique: vi.fn(), upsert: vi.fn() }
  };

  const prisma = {
    payment: {
      findFirst: vi.fn(),
      findUnique: vi.fn(),
      update: vi.fn(),
      updateMany: vi.fn()
    },
    subscriptionCharge: {
      findUnique: vi.fn(),
      findFirst: vi.fn()
    },
    billingInvoice: {
      create: vi.fn(),
      findFirst: vi.fn()
    },
    subscription: {
      update: vi.fn()
    },
    platformSetting: {
      findUnique: vi.fn(),
      upsert: vi.fn()
    },
    user: {
      findUnique: vi.fn()
    },
    $transaction: vi.fn(async (fn: (txArg: typeof tx) => Promise<void>) => fn(tx))
  };

  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const loggerError = vi.fn();

  return { adapter, tx, prisma, requireRole, ok, fail, loggerError };
});

vi.mock("../../adapters/index.js", () => ({
  getPaymentAdapter: () => mocks.adapter
}));

vi.mock("../../lib/db/prisma.js", () => ({
  prisma: mocks.prisma
}));

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
  return {
    HttpAuthError,
    requireRole: mocks.requireRole
  };
});

vi.mock("../../lib/http.js", () => ({
  ok: mocks.ok,
  fail: mocks.fail
}));

vi.mock("../../lib/logger.js", () => ({
  logger: {
    error: mocks.loggerError
  }
}));

import { PaymentController } from "./index.js";

describe("PaymentController", () => {
  const controller = new PaymentController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.tx.settlementEvent.findFirst.mockResolvedValue(null);
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "salon_1" });
    mocks.tx.booking.findUnique.mockResolvedValue({ status: "pending", source: "marketplace" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);
    mocks.prisma.platformSetting.upsert.mockResolvedValue({ key: "k", value: String(Date.now()) });
    mocks.tx.platformSetting.findUnique.mockResolvedValue(null);
    mocks.tx.platformSetting.upsert.mockResolvedValue({ key: "k", value: String(Date.now()) });
  });

  it("processes webhook once and creates a single held settlement event", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_123",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_1" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "book_1",
      amountXof: 12000,
      status: "pending",
      booking: { id: "book_1", clientId: "client_1" }
    });

    await controller.webhookIntech({ body: { any: "payload" } } as never, {} as never);

    expect(mocks.prisma.$transaction).toHaveBeenCalledTimes(1);
    expect(mocks.tx.payment.update).toHaveBeenCalledWith(expect.objectContaining({
      where: { id: "pay_1" },
      data: expect.objectContaining({ status: "succeeded", providerTxId: "REF_123" })
    }));
    expect(mocks.tx.booking.update).toHaveBeenCalledWith(expect.objectContaining({
      where: { id: "book_1" },
      data: { depositPaymentStatus: "succeeded", status: "confirmed" }
    }));
    expect(mocks.tx.bookingEvent.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({
        bookingId: "book_1",
        eventType: "auto_confirmed_after_payment",
        fromStatus: "pending",
        toStatus: "confirmed"
      })
    }));
    expect(mocks.tx.settlementEvent.create).toHaveBeenCalledTimes(1);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
    expect(mocks.fail).not.toHaveBeenCalled();
  });

  it("is idempotent on repeated succeeded webhook and does not create duplicates", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_123",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_1" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "book_1",
      amountXof: 12000,
      status: "succeeded",
      booking: { id: "book_1", clientId: "client_1" }
    });

    await controller.webhookIntech({ body: { any: "payload" } } as never, {} as never);

    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
    expect(mocks.tx.settlementEvent.create).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("reconciles payment status from provider token when webhook is delayed", async () => {
    mocks.adapter.fetchPaymentStatus.mockResolvedValue("succeeded");
    mocks.prisma.payment.findUnique
      .mockResolvedValueOnce({
        id: "pay_1",
        bookingId: "book_1",
        amountXof: 12000,
        status: "pending",
        provider: "intech",
        providerTxId: "REF_123",
        webhookSignature: "tok_123",
        createdAt: new Date("2026-05-05T10:00:00.000Z"),
        booking: { id: "book_1", clientId: "client_1" }
      })
      .mockResolvedValueOnce({
        id: "pay_1",
        bookingId: "book_1",
        amountXof: 12000,
        status: "succeeded",
        provider: "intech",
        providerTxId: "REF_123",
        createdAt: new Date("2026-05-05T10:00:00.000Z")
      });

    await controller.reconcile({ params: { paymentId: "pay_1" } } as never, {} as never);

    expect(mocks.adapter.fetchPaymentStatus).toHaveBeenCalledWith({ providerToken: "tok_123" });
    expect(mocks.tx.platformSetting.upsert).toHaveBeenCalledTimes(1);
    expect(mocks.prisma.$transaction).toHaveBeenCalledTimes(2);
    expect(mocks.tx.payment.update).toHaveBeenCalledWith(expect.objectContaining({
      where: { id: "pay_1" },
      data: expect.objectContaining({ status: "succeeded" })
    }));
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({
      id: "pay_1",
      status: "succeeded"
    }));
  });

  it("throttles reconcile calls within guard window", async () => {
    const lastTs = Date.now();
    mocks.tx.platformSetting.findUnique.mockResolvedValue({ value: String(lastTs) });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "book_1",
      amountXof: 12000,
      status: "pending",
      provider: "intech",
      providerTxId: "REF_123",
      webhookSignature: "tok_123",
      createdAt: new Date("2026-05-05T10:00:00.000Z"),
      booking: { id: "book_1", clientId: "client_1" }
    });

    await controller.reconcile({ params: { paymentId: "pay_1" } } as never, {} as never);

    expect(mocks.adapter.fetchPaymentStatus).not.toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      429,
      "reconcile_throttled",
      expect.stringContaining("Réconciliation trop fréquente")
    );
  });

  it("forbids reconcile when salon staff does not belong to payment salon", async () => {
    mocks.requireRole.mockReturnValue({ sub: "staff_2", role: "salon_staff" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "salon_2" });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "book_1",
      amountXof: 12000,
      status: "pending",
      provider: "intech",
      providerTxId: "REF_123",
      webhookSignature: "tok_123",
      createdAt: new Date("2026-05-05T10:00:00.000Z"),
      booking: { clientId: "client_1", salonId: "salon_1" }
    });

    await controller.reconcile({ params: { paymentId: "pay_1" } } as never, {} as never);

    expect(mocks.adapter.fetchPaymentStatus).not.toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", "Accès interdit.");
  });

  it("forbids refund when salon owner does not belong to payment salon", async () => {
    mocks.requireRole.mockReturnValue({ sub: "owner_2", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "salon_2" });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "book_1",
      amountXof: 12000,
      status: "succeeded",
      provider: "intech",
      providerTxId: "REF_123",
      webhookSignature: "tok_123",
      createdAt: new Date("2026-05-05T10:00:00.000Z"),
      booking: { clientId: "client_1", salonId: "salon_1" }
    });

    await controller.refund({ params: { paymentId: "pay_1" } } as never, {} as never);

    expect(mocks.adapter.requestRefund).not.toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", "Accès interdit.");
  });

  it("syncs booking deposit status when refund succeeds", async () => {
    mocks.requireRole.mockReturnValue({ sub: "owner_1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "salon_1" });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "book_1",
      amountXof: 12000,
      status: "succeeded",
      provider: "intech",
      providerTxId: "REF_123",
      webhookSignature: "tok_123",
      createdAt: new Date("2026-05-05T10:00:00.000Z"),
      booking: { clientId: "client_1", salonId: "salon_1" }
    });
    mocks.adapter.requestRefund.mockResolvedValue({ refundRef: "refund-REF_123" });
    mocks.prisma.payment.updateMany.mockResolvedValue({ count: 1 });

    await controller.refund({ params: { paymentId: "pay_1" } } as never, {} as never);

    expect(mocks.prisma.payment.updateMany).toHaveBeenCalledWith(expect.objectContaining({
      where: expect.objectContaining({ id: "pay_1" }),
      data: { status: "refunded" }
    }));
    expect(mocks.tx.booking.update).toHaveBeenCalledWith({
      where: { id: "book_1" },
      data: { depositPaymentStatus: "refunded" }
    });
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { refunded: true, refundRef: "refund-REF_123" });
  });

  it("rejects webhook when signature verification fails", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(false);

    await controller.webhookIntech({ body: { any: "payload" }, headers: {} } as never, {} as never);

    expect(mocks.adapter.parseWebhook).not.toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "invalid_signature", "Signature invalide.");
  });

  // --- Subscription charge webhook tests (A5) ---

  it("processes subscription charge webhook and creates invoice on succeeded", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "SUB_REF_99",
      status: "succeeded",
      amountXof: 5000,
      metadata: { paymentId: "subcharge_1" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.payment.findFirst.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "subcharge_1",
      subscriptionId: "sub_1",
      amountXof: 5000,
      status: "pending",
      chargeType: "upgrade",
      providerTxId: null,
      billingInvoiceId: null,
      subscription: { salonId: "salon_1", tier: "standard" }
    });
    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValue(null);
    mocks.tx.subscription.findUnique.mockResolvedValue({ salonId: "salon_1", expiresAt: null });

    await controller.webhookIntech({ body: { any: "payload" }, headers: {} } as never, {} as never);

    expect(mocks.prisma.$transaction).toHaveBeenCalled();
    expect(mocks.tx.subscriptionCharge.update).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { id: "subcharge_1" },
        data: expect.objectContaining({ status: "succeeded", providerTxId: "SUB_REF_99" })
      })
    );
    expect(mocks.tx.billingInvoice.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          subscriptionId: "sub_1",
          amountXof: 5000
        })
      })
    );
    expect(mocks.tx.subscription.update).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { id: "sub_1" },
        data: expect.objectContaining({ tier: "premium" })
      })
    );
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("processes subscription charge webhook and updates status on failed", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "SUB_REF_FAIL",
      status: "failed",
      amountXof: 5000,
      metadata: { paymentId: "subcharge_2" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.payment.findFirst.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "subcharge_2",
      subscriptionId: "sub_2",
      amountXof: 5000,
      status: "pending",
      chargeType: "upgrade",
      providerTxId: null,
      billingInvoiceId: null,
      subscription: { salonId: "salon_2", tier: "standard" }
    });
    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValue(null);

    await controller.webhookIntech({ body: { any: "payload" } } as never, {} as never);

    expect(mocks.prisma.$transaction).toHaveBeenCalled();
    expect(mocks.tx.subscriptionCharge.update).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { id: "subcharge_2" },
        data: expect.objectContaining({ status: "failed", providerTxId: "SUB_REF_FAIL" })
      })
    );
    expect(mocks.tx.billingInvoice.create).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("returns received:true when subscription charge not found", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "UNKNOWN",
      status: "succeeded",
      amountXof: 5000,
      metadata: { paymentId: "nonexistent" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.payment.findFirst.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValue(null);

    await controller.webhookIntech({ body: { any: "payload" }, headers: {} } as never, {} as never);

    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
    expect(mocks.fail).not.toHaveBeenCalled();
  });

  it("subscription charge webhook is idempotent when already succeeded", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "SUB_REF_DUP",
      status: "succeeded",
      amountXof: 5000,
      metadata: { paymentId: "subcharge_3" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.payment.findFirst.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "subcharge_3",
      subscriptionId: "sub_3",
      amountXof: 5000,
      status: "succeeded",
      chargeType: "upgrade",
      providerTxId: "SUB_REF_DUP",
      billingInvoiceId: "inv_3",
      subscription: { salonId: "salon_3", tier: "premium" }
    });

    await controller.webhookIntech({ body: { any: "payload" } } as never, {} as never);

    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });
});
