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
    payment: { findFirst: vi.fn(), findUnique: vi.fn(), update: vi.fn(), updateMany: vi.fn() },
    booking: { findUnique: vi.fn() },
    subscriptionCharge: { findUnique: vi.fn(), findFirst: vi.fn() },
    billingInvoice: { create: vi.fn(), findFirst: vi.fn() },
    subscription: { update: vi.fn() },
    platformSetting: { findUnique: vi.fn(), upsert: vi.fn() },
    user: { findUnique: vi.fn() },
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
  const enqueueJob = vi.fn();

  return { adapter, tx, prisma, requireRole, ok, fail, loggerError, loggerWarn, sendEmail, sendNotification, enqueueJob };
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
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: mocks.enqueueJob, queueForJob: vi.fn(), closeJobQueues: vi.fn() }));

import { PaymentController } from "./index.js";

describe("Concurrent webhook + refund races", { timeout: 15000 }, () => {
  const controller = new PaymentController();

  const basePayment = {
    id: "pay_racecr",
    bookingId: "book_racecr",
    amountXof: 12000,
    status: "succeeded",
    provider: "paydunya",
    providerTxId: "INVOICE_RACE",
    webhookSignature: "TOKEN_RACE",
    createdAt: new Date()
  };

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);
    mocks.prisma.platformSetting.upsert.mockResolvedValue({ key: "k", value: String(Date.now()) });
    mocks.tx.platformSetting.findUnique.mockResolvedValue(null);
    mocks.tx.platformSetting.upsert.mockResolvedValue({ key: "k", value: String(Date.now()) });
  });

  // ─── 1. Two concurrent webhooks: same idempotencyKey — only one wins ──
  it("processes only one of two concurrent webhooks with the same idempotencyKey", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "INVOICE_RACE",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_racecr", idempotencyKey: "unique_ik" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      ...basePayment,
      status: "pending",
      booking: { clientId: "client_1", salonId: "s1" }
    });
    mocks.tx.booking.findUnique.mockResolvedValue({
      status: "pending",
      startsAt: new Date(Date.now() + 48 * 60 * 60 * 1000),
      clientId: "client_1",
      client: { email: "test@test.com" },
      service: { name: "Coupe" }
    });
    mocks.tx.settlementEvent.findFirst.mockResolvedValue(null);

    const [r1, r2] = await Promise.all([
      controller.webhookPayDunya({ body: {}, rawBody: "{}", headers: {} } as never, {} as never),
      controller.webhookPayDunya({ body: {}, rawBody: "{}", headers: {} } as never, {} as never)
    ]);

    expect(mocks.ok).toHaveBeenCalledTimes(2);
  });

  // ─── 2. Refund API + late webhook race ─────────────────────────────────
  it("handles refund winning against a late-arriving succeeded webhook", async () => {
    mocks.requireRole.mockReturnValue({ sub: "owner_1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      ...basePayment,
      booking: { clientId: "client_1", salonId: "s1" }
    });
    mocks.prisma.payment.updateMany.mockResolvedValue({ count: 1 });
    mocks.adapter.requestRefund.mockResolvedValue({ refundRef: "refund_racecr" });
    mocks.prisma.booking.findUnique.mockResolvedValue({
      client: { phone: "+221771234567" }
    });

    await controller.refund({ params: { paymentId: "pay_racecr" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { refunded: true, refundRef: "refund_racecr" });

    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "INVOICE_RACE",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_racecr", idempotencyKey: "late_ik" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      ...basePayment,
      status: "refunded",
      booking: { clientId: "client_1", salonId: "s1" }
    });

    await controller.webhookPayDunya({ body: {}, rawBody: "{}", headers: {} } as never, {} as never);

    expect(mocks.tx.payment.update).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  // ─── 3. Duplicate refund API concurrency (atomic claim) ────────────────
  it("prevents double refund via updateMany atomic claim", async () => {
    mocks.requireRole.mockReturnValue({ sub: "owner_1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      ...basePayment,
      booking: { clientId: "client_1", salonId: "s1" }
    });
    mocks.prisma.booking.findUnique.mockResolvedValue({
      client: { phone: "+221771234567" }
    });

    mocks.prisma.payment.updateMany
      .mockResolvedValueOnce({ count: 1 })
      .mockResolvedValueOnce({ count: 0 });

    mocks.adapter.requestRefund.mockResolvedValue({ refundRef: "refund_race_deduped" });

    const [r1, r2] = await Promise.all([
      controller.refund({ params: { paymentId: "pay_racecr" } } as never, {} as never),
      controller.refund({ params: { paymentId: "pay_racecr" } } as never, {} as never)
    ]);

    expect(mocks.adapter.requestRefund).toHaveBeenCalledTimes(1);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "already_refunded", expect.any(String));
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { refunded: true, refundRef: "refund_race_deduped" });
  });

  // ─── 4. Reconcile + webhook time-order race ────────────────────────────
  it("handles reconcile and webhook arriving in any order without double-processing", async () => {
    mocks.adapter.fetchPaymentStatus.mockResolvedValue("succeeded");
    mocks.prisma.payment.findUnique
      .mockResolvedValueOnce({
        ...basePayment,
        status: "pending",
        booking: { clientId: "client_1", salonId: "s1" }
      })
      .mockResolvedValueOnce({
        ...basePayment,
        status: "succeeded",
        booking: { clientId: "client_1", salonId: "s1" }
      });

    await controller.reconcile({ params: { paymentId: "pay_racecr" } } as never, {} as never);
    expect(mocks.tx.payment.update).toHaveBeenCalled();

    vi.clearAllMocks();
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);
    mocks.prisma.platformSetting.upsert.mockResolvedValue({ key: "k", value: String(Date.now()) });
    mocks.tx.platformSetting.findUnique.mockResolvedValue(null);
    mocks.tx.platformSetting.upsert.mockResolvedValue({ key: "k", value: String(Date.now()) });

    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "INVOICE_RACE",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_racecr", idempotencyKey: "race_ik_2" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      ...basePayment,
      status: "succeeded",
      booking: { clientId: "client_1", salonId: "s1" }
    });

    await controller.webhookPayDunya({ body: {}, rawBody: "{}", headers: {} } as never, {} as never);

    expect(mocks.tx.payment.update).not.toHaveBeenCalled();
  });
});
