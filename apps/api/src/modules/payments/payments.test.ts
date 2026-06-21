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
    job: { findFirst: vi.fn().mockResolvedValue(null), create: vi.fn() },
    $transaction: vi.fn(async (fn: (txArg: typeof tx) => Promise<void>) => fn(tx)),
    merchantPayout: {
      findFirst: vi.fn()
    }
  };

  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const loggerError = vi.fn();
  const loggerWarn = vi.fn();
  const loggerInfo = vi.fn();

  return { adapter, tx, prisma, requireRole, ok, fail, loggerError, loggerWarn, loggerInfo };
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
    error: mocks.loggerError,
    warn: mocks.loggerWarn,
    info: mocks.loggerInfo
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
    mocks.tx.booking.findUnique.mockResolvedValue({ status: "pending", source: "marketplace", startsAt: new Date(Date.now() + 48 * 60 * 60 * 1000), clientId: "client_1", client: { email: "test@test.com" }, service: { name: "Coupe" } });
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

    await controller.webhookPayDunya({ body: { any: "payload" } } as never, {} as never);

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

    await controller.webhookPayDunya({ body: { any: "payload" } } as never, {} as never);

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
        provider: "paydunya",
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
        provider: "paydunya",
        providerTxId: "REF_123",
        createdAt: new Date("2026-05-05T10:00:00.000Z")
      });

    await controller.reconcile({ params: { paymentId: "pay_1" } } as never, {} as never);

    expect(mocks.adapter.fetchPaymentStatus).toHaveBeenCalledWith({ providerToken: "tok_123" });
    expect(mocks.prisma.platformSetting.upsert).toHaveBeenCalledTimes(1);
    expect(mocks.prisma.$transaction).toHaveBeenCalledTimes(1);
    expect(mocks.tx.payment.update).toHaveBeenCalledWith(expect.objectContaining({
      where: { id: "pay_1" },
      data: expect.objectContaining({ status: "succeeded" })
    }));
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({
      id: "pay_1",
      status: "succeeded"
    }));
  });

  it("keeps an authorized payment authorized when provider confirmation is still pending", async () => {
    mocks.adapter.fetchPaymentStatus.mockResolvedValue("pending");
    mocks.prisma.payment.findUnique
      .mockResolvedValueOnce({
        id: "pay_1",
        bookingId: "book_1",
        amountXof: 12000,
        status: "authorized",
        provider: "paydunya",
        providerTxId: "REF_123",
        webhookSignature: "tok_123",
        updatedAt: new Date(Date.now() - 61_000),
        createdAt: new Date("2026-05-05T10:00:00.000Z"),
        booking: { id: "book_1", clientId: "client_1" }
      })
      .mockResolvedValueOnce({
        id: "pay_1",
        bookingId: "book_1",
        amountXof: 12000,
        status: "authorized",
        provider: "paydunya",
        providerTxId: "REF_123",
        createdAt: new Date("2026-05-05T10:00:00.000Z")
      });

    await controller.reconcile({ params: { paymentId: "pay_1" } } as never, {} as never);

    expect(mocks.adapter.fetchPaymentStatus).toHaveBeenCalledWith({ providerToken: "tok_123" });
    expect(mocks.prisma.platformSetting.upsert).toHaveBeenCalledTimes(1);
    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({
      id: "pay_1",
      status: "authorized"
    }));
  });

  it("throttles reconcile calls within guard window", async () => {
    const lastTs = Date.now();
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: String(lastTs) });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "book_1",
      amountXof: 12000,
      status: "pending",
      provider: "paydunya",
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
      provider: "paydunya",
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
      provider: "paydunya",
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
      provider: "paydunya",
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
      data: expect.objectContaining({ depositPaymentStatus: "refunded", depositSettlementStatus: "refunded" })
    });
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { refunded: true, refundRef: "refund-REF_123" });
  });

  it("rejects webhook when signature verification fails", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(false);

    await controller.webhookPayDunya({ body: { any: "payload" }, headers: {} } as never, {} as never);

    expect(mocks.adapter.parseWebhook).not.toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "invalid_signature", "Signature invalide.");
  });

  it("rejects webhook payload when parser throws", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockImplementation(() => {
      throw new Error("bad payload");
    });
    await controller.webhookPayDunya({ body: { any: "payload" }, headers: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 400, "invalid_payload", expect.any(String));
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

    await controller.webhookPayDunya({ body: { any: "payload" }, headers: {} } as never, {} as never);

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

    await controller.webhookPayDunya({ body: { any: "payload" } } as never, {} as never);

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

  it("rejects subscription charge callback when amount mismatches expected", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "SUB_REF_MISMATCH",
      status: "succeeded",
      amountXof: 5001,
      metadata: { paymentId: "subcharge_2" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.payment.findFirst.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "subcharge_2",
      subscriptionId: "sub_2",
      amountXof: 1000,
      status: "pending",
      chargeType: "upgrade",
      providerTxId: null,
      billingInvoiceId: null,
      subscription: { salonId: "salon_2", tier: "standard" }
    });
    await controller.webhookPayDunya({ body: { any: "payload" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "amount_mismatch", expect.any(String));
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

    await controller.webhookPayDunya({ body: { any: "payload" }, headers: {} } as never, {} as never);

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

    await controller.webhookPayDunya({ body: { any: "payload" } } as never, {} as never);

    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("maps refund adapter failures to internal_error", async () => {
    mocks.requireRole.mockReturnValue({ sub: "owner_1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "salon_1" });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "book_1",
      amountXof: 12000,
      status: "succeeded",
      provider: "paydunya",
      providerTxId: "REF_123",
      webhookSignature: "tok_123",
      createdAt: new Date("2026-05-05T10:00:00.000Z"),
      booking: { clientId: "client_1", salonId: "salon_1" }
    });
    mocks.prisma.payment.updateMany.mockResolvedValue({ count: 1 });
    mocks.adapter.requestRefund.mockRejectedValue(new Error("provider down"));
    await controller.refund({ params: { paymentId: "pay_1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("initiate stores null webhookSignature when redirect URL is invalid and no provider token", async () => {
    mocks.prisma.payment.findFirst.mockResolvedValue({
      id: "pay_bad_url",
      bookingId: "book_1",
      amountXof: 9000,
      status: "pending",
      idempotencyKey: "idem-1",
      booking: { clientId: "client_1" }
    });
    mocks.prisma.user.findUnique.mockResolvedValueOnce({ phone: "771234567" });
    mocks.adapter.initiateDeposit.mockResolvedValue({
      providerRef: "REF_BAD",
      providerToken: undefined,
      redirectUrl: "not-a-url",
      expiresAt: new Date("2030-01-01T00:00:00.000Z")
    });

    await controller.initiate({
      body: { bookingId: "book_1", provider: "paydunya", channel: "wave" }
    } as never, {} as never);

    expect(mocks.prisma.payment.update).toHaveBeenCalledWith(expect.objectContaining({
      where: { id: "pay_bad_url" },
      data: expect.objectContaining({ providerTxId: "REF_BAD", webhookSignature: null })
    }));
  });

  it("webhook uses first value from array headers", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_ARRAY",
      status: "failed",
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

    await controller.webhookPayDunya({
      body: { ok: true },
      headers: { "hmac-signature": ["sig1", "sig2"], timestamp: ["123"] }
    } as never, {} as never);

    expect(mocks.adapter.verifyWebhookSignature).toHaveBeenCalledWith(expect.objectContaining({
      signature: "sig1",
      timestamp: "123"
    }));
    expect(mocks.tx.booking.update).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ depositPaymentStatus: "failed", depositSettlementStatus: "none" })
    }));
  });

  it("reconcile maps unexpected provider errors to internal_error", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "book_1",
      amountXof: 12000,
      status: "pending",
      provider: "paydunya",
      providerTxId: "REF_123",
      webhookSignature: "tok_123",
      createdAt: new Date("2026-05-05T10:00:00.000Z"),
      booking: { id: "book_1", clientId: "client_1" }
    });
    mocks.adapter.fetchPaymentStatus.mockRejectedValue(new Error("provider-timeout"));

    await controller.reconcile({ params: { paymentId: "pay_1" } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", "Erreur interne.");
  });

  it("rejects webhook metadata binding when providerRef mismatches payment and subscription charge", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_NEW",
      status: "succeeded",
      amountXof: 5000,
      metadata: { paymentId: "same-id", externalTransactionId: "ext_1" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "same-id",
      bookingId: "book_1",
      amountXof: 5000,
      status: "pending",
      providerTxId: "REF_OLD",
      booking: { id: "book_1", clientId: "client_1" }
    });
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "same-id",
      subscriptionId: "sub_1",
      amountXof: 5000,
      status: "pending",
      chargeType: "upgrade",
      providerTxId: "REF_OLD",
      billingInvoiceId: null,
      subscription: { salonId: "salon_1", tier: "standard" }
    });

    await controller.webhookPayDunya({
      body: { ok: true },
      headers: { "hmac-signature": "sig1", timestamp: "123" }
    } as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
  });

  it("webhook succeeded without auto-confirm when booking is not pending marketplace", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_NO_AUTO",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_no_auto" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_no_auto",
      bookingId: "book_no_auto",
      amountXof: 12000,
      status: "pending",
      booking: { id: "book_no_auto", clientId: "client_1" }
    });
    mocks.tx.booking.findUnique.mockResolvedValue({ status: "confirmed", source: "manual" });

    await controller.webhookPayDunya({ body: { any: "payload" } } as never, {} as never);

    expect(mocks.tx.booking.update).toHaveBeenCalledWith(expect.objectContaining({
      data: { depositPaymentStatus: "succeeded" }
    }));
  });

  it("webhook succeeded skips held settlement creation when already present", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_HELD",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_held" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_held",
      bookingId: "book_held",
      amountXof: 12000,
      status: "pending",
      booking: { id: "book_held", clientId: "client_1" }
    });
    mocks.tx.booking.findUnique.mockResolvedValue({ status: "confirmed", source: "manual" });
    mocks.tx.settlementEvent.findFirst.mockResolvedValueOnce({ id: "existing-held" });

    await controller.webhookPayDunya({ body: { any: "payload" } } as never, {} as never);

    expect(mocks.tx.settlementEvent.create).not.toHaveBeenCalled();
  });

  it("subscription renewal extends from current future expiry date", async () => {
    const futureExpiry = new Date(Date.now() + 10 * 24 * 60 * 60 * 1000);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_RENEW",
      status: "succeeded",
      amountXof: 5000,
      metadata: { paymentId: "subrenew_1" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "subrenew_1",
      subscriptionId: "sub_renew",
      amountXof: 5000,
      status: "pending",
      chargeType: "renewal",
      providerTxId: "REF_RENEW",
      billingInvoiceId: null,
      subscription: { salonId: "salon_1", tier: "standard" }
    });
    mocks.tx.subscription.findUnique.mockResolvedValue({ salonId: "salon_1", expiresAt: futureExpiry });

    await controller.webhookPayDunya({ body: { any: "payload" } } as never, {} as never);

    expect(mocks.tx.subscription.update).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ expiresAt: expect.any(Date) })
    }));
  });

  it("subscription upgrade does not sync salon tier when subscription has no salonId", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_UPGRADE",
      status: "succeeded",
      amountXof: 7000,
      metadata: { paymentId: "subup_1" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "subup_1",
      subscriptionId: "sub_upgrade",
      amountXof: 7000,
      status: "pending",
      chargeType: "upgrade",
      providerTxId: "REF_UPGRADE",
      billingInvoiceId: null,
      subscription: { salonId: null, tier: "standard" }
    });
    mocks.tx.subscription.findUnique.mockResolvedValue({ salonId: null, expiresAt: null });

    await controller.webhookPayDunya({ body: { any: "payload" } } as never, {} as never);

    expect(mocks.tx.salon.update).not.toHaveBeenCalled();
  });

  // ─── Payout Webhook (webhookPayDunyaPayout) Tests ───────────────────────

  describe("webhookPayDunyaPayout", () => {

    it("rejects unsupported content-type with 415", async () => {
      const reply = { status: vi.fn().mockReturnThis(), send: vi.fn() };
      await controller.webhookPayDunyaPayout(
        { headers: { "content-type": "text/xml" }, body: {} } as never,
        reply as never
      );
      expect(reply.status).toHaveBeenCalledWith(415);
      expect(reply.send).toHaveBeenCalledWith({ error: "unsupported_media_type" });
    });

    it("rejects oversized payload with 413", async () => {
      const reply = { status: vi.fn().mockReturnThis(), send: vi.fn() };
      const largeBody = { disburse_id: "x".repeat(102401) };
      await controller.webhookPayDunyaPayout(
        { headers: { "content-type": "application/json" }, body: largeBody, rawBody: JSON.stringify(largeBody) } as never,
        reply as never
      );
      expect(reply.status).toHaveBeenCalledWith(413);
      expect(reply.send).toHaveBeenCalledWith({ error: "payload_too_large" });
    });

    it("rejects bad JSON body with 400", async () => {
      const reply = { status: vi.fn().mockReturnThis(), send: vi.fn() };
      await controller.webhookPayDunyaPayout(
        { headers: { "content-type": "application/json" }, body: "not-json", rawBody: "not-json" } as never,
        reply as never
      );
      expect(reply.status).toHaveBeenCalledWith(400);
      expect(reply.send).toHaveBeenCalledWith({ error: "bad_json" });
    });

    it("rejects payload with missing identifiers with 400", async () => {
      const reply = { status: vi.fn().mockReturnThis(), send: vi.fn() };
      await controller.webhookPayDunyaPayout(
        { headers: { "content-type": "application/json" }, body: { some: "data" }, rawBody: '{"some":"data"}' } as never,
        reply as never
      );
      expect(reply.status).toHaveBeenCalledWith(400);
      expect(reply.send).toHaveBeenCalledWith({ error: "missing_identifiers" });
    });

    it("returns payout_not_found when no matching payout exists", async () => {
      const reply = { status: vi.fn().mockReturnThis(), send: vi.fn() };
      mocks.prisma.merchantPayout.findFirst.mockResolvedValue(null);

      await controller.webhookPayDunyaPayout(
        { headers: { "content-type": "application/json" }, body: { disburse_id: "d1", token: "t1" }, rawBody: '{"disburse_id":"d1","token":"t1"}' } as never,
        reply as never
      );
      expect(reply.status).toHaveBeenCalledWith(200);
      expect(reply.send).toHaveBeenCalledWith({ ok: false, message: "payout_not_found" });
    });

    it("reconciles payout status on valid callback with both identifiers", async () => {
      const reply = { status: vi.fn().mockReturnThis(), send: vi.fn() };
      mocks.prisma.merchantPayout.findFirst.mockResolvedValue({
        id: "payout_1", disburseId: "d1", disburseToken: "t1"
      });

      await controller.webhookPayDunyaPayout(
        { headers: { "content-type": "application/json" }, body: { disburse_id: "d1", token: "t1" }, rawBody: '{"disburse_id":"d1","token":"t1"}' } as never,
        reply as never
      );

      expect(mocks.prisma.merchantPayout.findFirst).toHaveBeenCalledWith(
        expect.objectContaining({
          where: { disburseId: "d1", disburseToken: "t1" }
        })
      );
      expect(reply.status).toHaveBeenCalledWith(200);
      expect(reply.send).toHaveBeenCalledWith({ ok: true });
    });

    it("reconciles payout on valid callback with token only", async () => {
      const reply = { status: vi.fn().mockReturnThis(), send: vi.fn() };
      mocks.prisma.merchantPayout.findFirst.mockResolvedValue({
        id: "payout_2", disburseToken: "tok_only"
      });

      await controller.webhookPayDunyaPayout(
        { headers: { "content-type": "application/json" }, body: { disburse_token: "tok_only" }, rawBody: '{"disburse_token":"tok_only"}' } as never,
        reply as never
      );

      expect(mocks.prisma.merchantPayout.findFirst).toHaveBeenCalledWith(
        expect.objectContaining({ where: expect.objectContaining({ OR: expect.any(Array) }) })
      );
      expect(reply.status).toHaveBeenCalledWith(200);
      expect(reply.send).toHaveBeenCalledWith({ ok: true });
    });

    it("returns payout_not_found when both identifiers don't match (inconsistency check)", async () => {
      const reply = { status: vi.fn().mockReturnThis(), send: vi.fn() };
      mocks.prisma.merchantPayout.findFirst.mockResolvedValue(null);

      // Both identifiers provided but no single payout has both disburseId AND disburseToken
      await controller.webhookPayDunyaPayout(
        { headers: { "content-type": "application/json" }, body: { disburse_id: "d1", token: "tok_mismatch" }, rawBody: '{"disburse_id":"d1","token":"tok_mismatch"}' } as never,
        reply as never
      );

      // Must search by BOTH identifiers together (consistency check)
      expect(mocks.prisma.merchantPayout.findFirst).toHaveBeenCalledWith(
        expect.objectContaining({ where: { disburseId: "d1", disburseToken: "tok_mismatch" } })
      );
      expect(reply.status).toHaveBeenCalledWith(200);
      expect(reply.send).toHaveBeenCalledWith({ ok: false, message: "payout_not_found" });
    });

    it("queries by OR when only one identifier is present", async () => {
      const reply = { status: vi.fn().mockReturnThis(), send: vi.fn() };
      mocks.prisma.merchantPayout.findFirst.mockResolvedValue({
        id: "payout_4", disburseId: "d4_only"
      });

      await controller.webhookPayDunyaPayout(
        { headers: { "content-type": "application/json" }, body: { disburse_id: "d4_only" }, rawBody: '{"disburse_id":"d4_only"}' } as never,
        reply as never
      );

      expect(mocks.prisma.merchantPayout.findFirst).toHaveBeenCalledWith(
        expect.objectContaining({ where: expect.objectContaining({ OR: expect.any(Array) }) })
      );
      expect(reply.status).toHaveBeenCalledWith(200);
      expect(reply.send).toHaveBeenCalledWith({ ok: true });
    });
  });
});
