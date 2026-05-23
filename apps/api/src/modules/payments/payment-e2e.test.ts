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
    payment: { findFirst: vi.fn(), findUnique: vi.fn(), update: vi.fn(), updateMany: vi.fn(), create: vi.fn() },
    booking: { findUnique: vi.fn(), update: vi.fn() },
    subscriptionCharge: { findUnique: vi.fn(), findFirst: vi.fn() },
    billingInvoice: { create: vi.fn(), findFirst: vi.fn() },
    subscription: { update: vi.fn() },
    platformSetting: { findUnique: vi.fn(), upsert: vi.fn() },
    user: { findUnique: vi.fn() },
    bookingEvent: { create: vi.fn() },
    job: { findFirst: vi.fn().mockResolvedValue(null), create: vi.fn() },
    $transaction: vi.fn(async (fn: (t: typeof tx) => Promise<void>) => fn(tx))
  };

  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const loggerError = vi.fn();
  const loggerWarn = vi.fn();
  const sendEmail = vi.fn().mockResolvedValue(undefined);
  const sendNotification = vi.fn().mockResolvedValue(undefined);

  return { adapter, tx, prisma, requireRole, ok, fail, loggerError, loggerWarn, sendEmail, sendNotification };
});

vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: () => mocks.adapter }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/auth/index.js", () => {
  class HttpAuthError extends Error {
    statusCode: number; code: string;
    constructor(s: number, c: string, m: string) { super(m); this.statusCode = s; this.code = c; }
  }
  return { HttpAuthError, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/logger.js", () => ({ logger: { error: mocks.loggerError, warn: mocks.loggerWarn } }));
vi.mock("../../lib/email.js", () => ({ sendEmail: mocks.sendEmail }));
vi.mock("../../lib/push.js", () => ({ sendNotification: mocks.sendNotification, sendPushBatch: vi.fn() }));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: vi.fn(), queueForJob: vi.fn(), closeJobQueues: vi.fn() }));

import { PaymentController } from "./index.js";

describe("End-to-end payment flow", { timeout: 15000 }, () => {
  const controller = new PaymentController();

  const basePayment = {
    id: "pay_flow",
    bookingId: "book_flow",
    amountXof: 12000,
    status: "pending",
    provider: "paydunya",
    providerTxId: null,
    webhookSignature: null,
    createdAt: new Date()
  };

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.fetchPaymentStatus.mockResolvedValue("succeeded");
    mocks.adapter.requestRefund.mockResolvedValue({ refundRef: "refund_flow" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });

    mocks.tx.booking.findUnique.mockResolvedValue({
      status: "pending",
      startsAt: new Date(Date.now() + 48 * 60 * 60 * 1000),
      clientId: "client_1",
      client: { email: "test@test.com" },
      service: { name: "Coupe" }
    });
    mocks.tx.settlementEvent.findFirst.mockResolvedValue(null);
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);
    mocks.prisma.platformSetting.upsert.mockResolvedValue({ key: "k", value: String(Date.now()) });
    mocks.tx.platformSetting.findUnique.mockResolvedValue(null);
    mocks.tx.platformSetting.upsert.mockResolvedValue({ key: "k", value: String(Date.now()) });
  });

  // ─── 1. Initiate payment ────────────────────────────────────────────────
  it("initiates a deposit and stores the provider token", async () => {
    mocks.adapter.initiateDeposit.mockResolvedValue({
      redirectUrl: "https://paydunya.com/invoice/TOKEN_123",
      providerRef: "INVOICE_123",
      providerToken: "TOKEN_123",
      expiresAt: new Date(Date.now() + 30 * 60 * 1000)
    });
    mocks.prisma.payment.findFirst.mockResolvedValue({
      id: "pay_flow",
      bookingId: "book_flow",
      amountXof: 12000,
      status: "pending",
      idempotencyKey: "ik_init",
      booking: { clientId: "client_1" }
    });
    mocks.prisma.user.findUnique.mockResolvedValue({ phone: "+221771234567", salonId: "s1" });
    mocks.prisma.booking.findUnique.mockResolvedValue({
      id: "book_flow",
      clientId: "client_1",
      salonId: "s1",
      startsAt: new Date(),
      status: "pending",
      client: { fullName: "Jane Doe" }
    });

    await controller.initiate({
      body: { bookingId: "book_flow", amountXof: 12000, provider: "paydunya", channel: "wave" }
    } as never, {} as never);

    expect(mocks.adapter.initiateDeposit).toHaveBeenCalledWith(
      expect.objectContaining({ paymentId: "pay_flow", amountXof: 12000 })
    );
    expect(mocks.prisma.payment.update).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { id: "pay_flow" },
        data: expect.objectContaining({ provider: "paydunya", webhookSignature: "TOKEN_123" })
      })
    );
  });

  // ─── 2. Webhook arrives ─────────────────────────────────────────────────
  it("processes a webhook and transitions payment to succeeded", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "INVOICE_123",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_flow", idempotencyKey: "ik_1" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      ...basePayment,
      booking: { clientId: "client_1", salonId: "s1" }
    });

    await controller.webhookPayDunya({ body: {}, rawBody: "{}", headers: {} } as never, {} as never);

    expect(mocks.prisma.$transaction).toHaveBeenCalled();
    expect(mocks.tx.payment.update).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { id: "pay_flow" },
        data: expect.objectContaining({ status: "succeeded" })
      })
    );
    expect(mocks.tx.booking.update).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { id: "book_flow" },
        data: expect.objectContaining({ depositPaymentStatus: "succeeded", status: "confirmed" })
      })
    );
    expect(mocks.tx.settlementEvent.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ eventType: "held", amountXof: 12000 })
      })
    );
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  // ─── 3. Reconcile after webhook ─────────────────────────────────────────
  it("reconciles a payment that was already succeeded (webhook beat us)", async () => {
    mocks.prisma.payment.findUnique
      .mockResolvedValueOnce({
        ...basePayment,
        provider: "paydunya",
        providerTxId: "INVOICE_123",
        webhookSignature: "TOKEN_123",
        booking: { clientId: "client_1", salonId: "s1" }
      })
      .mockResolvedValueOnce({
        ...basePayment,
        status: "succeeded",
        provider: "paydunya",
        providerTxId: "INVOICE_123",
        booking: { clientId: "client_1", salonId: "s1" }
      });

    await controller.reconcile({ params: { paymentId: "pay_flow" } } as never, {} as never);

    // _applyPaymentStatus updates from pending → succeeded (it doesn't re-read the payment)
    expect(mocks.tx.payment.update).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { id: "pay_flow" },
        data: expect.objectContaining({ status: "succeeded" })
      })
    );
    expect(mocks.ok).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({ status: "succeeded" })
    );
  });

  // ─── 4. Refund the payment ──────────────────────────────────────────────
  it("refunds a succeeded payment atomically", async () => {
    mocks.requireRole.mockReturnValue({ sub: "owner_1", role: "salon_owner" });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      ...basePayment,
      status: "succeeded",
      providerTxId: "INVOICE_123",
      booking: { clientId: "client_1", salonId: "s1" }
    });
    mocks.prisma.payment.updateMany.mockResolvedValue({ count: 1 });
    mocks.prisma.booking.findUnique.mockResolvedValue({
      client: { phone: "+221771234567" }
    });

    await controller.refund({ params: { paymentId: "pay_flow" } } as never, {} as never);

    expect(mocks.prisma.payment.updateMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { id: "pay_flow", status: { in: ["authorized", "succeeded"] } },
        data: { status: "refunded" }
      })
    );
    expect(mocks.adapter.requestRefund).toHaveBeenCalledWith(
      expect.objectContaining({ providerRef: "INVOICE_123", amountXof: 12000 })
    );
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { refunded: true, refundRef: "refund_flow" });
  });

  // ─── 5. Late webhook after refund ───────────────────────────────────────
  it("ignores a late webhook arriving after payment was refunded", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "INVOICE_123",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_flow", idempotencyKey: "ik_2" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      ...basePayment,
      status: "refunded",
      providerTxId: "INVOICE_123",
      booking: { clientId: "client_1", salonId: "s1" }
    });

    await controller.webhookPayDunya({ body: {}, rawBody: "{}", headers: {} } as never, {} as never);

    // _applyPaymentStatus short-circuits on refunded status without calling $transaction
    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  // ─── 6. Webhook replay detected ─────────────────────────────────────────
  it("rejects a replayed webhook with the same idempotencyKey within the replay window", async () => {
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "INVOICE_123",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_flow", idempotencyKey: "ik_unique" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      ...basePayment,
      booking: { clientId: "client_1", salonId: "s1" }
    });

    // First webhook — processes normally
    await controller.webhookPayDunya({ body: {}, rawBody: "{}", headers: {} } as never, {} as never);
    expect(mocks.prisma.$transaction).toHaveBeenCalled();

    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "INVOICE_123",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_flow", idempotencyKey: "ik_unique" }
    });

    // Second webhook with same idempotencyKey — should be rejected as replay
    await controller.webhookPayDunya({ body: {}, rawBody: "{}", headers: {} } as never, {} as never);
    expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });
});
