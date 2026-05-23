import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const adapter = {
    requestRefund: vi.fn(),
    initiateDeposit: vi.fn(),
    verifyWebhookSignature: vi.fn(),
    parseWebhook: vi.fn(),
    fetchPaymentStatus: vi.fn(),
    normalizeStatus: vi.fn()
  };

  const prisma = {
    booking: {
      findUnique: vi.fn(),
      update: vi.fn()
    },
    payment: {
      findUnique: vi.fn(),
      update: vi.fn(),
      updateMany: vi.fn()
    },
    settlementEvent: {
      findFirst: vi.fn(),
      create: vi.fn()
    },
    user: { findMany: vi.fn() },
    pushToken: { findMany: vi.fn() },
    notification: { create: vi.fn() },
    job: { findFirst: vi.fn().mockResolvedValue(null), findMany: vi.fn().mockResolvedValue([]), create: vi.fn() }
  };

  const config = {
    paymentDriver: "mock",
    webOrigin: "http://localhost:5174",
    workerPollIntervalMs: 5000,
    bullConnectionLimit: 10,
    storageDriver: "local",
    storagePath: "/tmp",
    mediaPublicBaseUrl: "http://localhost:3000",
    r2AccountId: "",
    r2AccessKeyId: "",
    r2SecretAccessKey: "",
    r2Bucket: "",
    paydunyaMasterKey: "",
    paydunyaPrivateKey: "",
    paydunyaToken: "",
    paydunyaEnv: "",
    paydunyaBaseUrl: "",
    workerDriver: "mock",
    workerBatchSize: 10,
    queueConcurrencyPayments: 5,
    queueConcurrencyNotifications: 5,
    queueConcurrencyMaintenance: 5
  };

  const enqueueJob = vi.fn();
  const sendNotification = vi.fn();
  const sendEmail = vi.fn();
  const sendPushBatch = vi.fn();
  const loggerWarn = vi.fn();

  return { adapter, prisma, config, enqueueJob, sendNotification, sendEmail, sendPushBatch, loggerWarn };
});

vi.mock("./adapters/index.js", () => ({
  getPaymentAdapter: () => mocks.adapter,
  getStorageAdapter: () => ({ deleteFile: vi.fn().mockResolvedValue(undefined) })
}));

vi.mock("./config.js", () => ({ config: mocks.config, validateConfig: vi.fn() }));

vi.mock("./lib/db/prisma.js", () => ({ prisma: mocks.prisma }));

vi.mock("./lib/jobs.js", () => ({ enqueueJob: mocks.enqueueJob, closeJobQueues: vi.fn(), shouldRunBull: vi.fn().mockReturnValue(false) }));

vi.mock("./modules/notifications/index.js", () => ({ sendNotification: mocks.sendNotification }));

vi.mock("./lib/email.js", () => ({ sendEmail: mocks.sendEmail }));

vi.mock("./lib/push.js", () => ({ sendPushBatch: mocks.sendPushBatch }));

vi.mock("./lib/logger.js", () => ({
  logger: { warn: mocks.loggerWarn, error: vi.fn(), info: vi.fn() }
}));

vi.mock("bullmq", () => ({ Job: class {}, Worker: class {} }));
vi.mock("./lib/redis.js", () => ({ getQueueRedis: vi.fn() }));

import { handleJob } from "./worker.js";

beforeEach(() => {
  vi.clearAllMocks();
});

describe("handleJob — deposit_settlement", () => {
  const bookingId = "booking_1";
  const paymentId = "pay_1";

  it("creates a released settlementEvent when booking has a succeeded payment", async () => {
    mocks.prisma.booking.findUnique.mockResolvedValue({
      id: bookingId,
      payments: [{ id: paymentId, amountXof: 12_000, providerTxId: "txn_1" }]
    });
    mocks.prisma.settlementEvent.findFirst.mockResolvedValue(null);

    await handleJob("deposit_settlement", { bookingId });

    expect(mocks.prisma.settlementEvent.create).toHaveBeenCalledWith({
      data: {
        bookingId,
        paymentId,
        eventType: "released",
        amountXof: 12_000,
        providerReference: "txn_1"
      }
    });
  });

  it("does nothing when booking is not found", async () => {
    mocks.prisma.booking.findUnique.mockResolvedValue(null);

    await handleJob("deposit_settlement", { bookingId });

    expect(mocks.prisma.settlementEvent.create).not.toHaveBeenCalled();
  });

  it("does nothing when booking has no succeeded payments", async () => {
    mocks.prisma.booking.findUnique.mockResolvedValue({
      id: bookingId,
      payments: []
    });

    await handleJob("deposit_settlement", { bookingId });

    expect(mocks.prisma.settlementEvent.create).not.toHaveBeenCalled();
  });

  it("does nothing when a released settlementEvent already exists (dedupe)", async () => {
    mocks.prisma.booking.findUnique.mockResolvedValue({
      id: bookingId,
      payments: [{ id: paymentId, amountXof: 12_000, providerTxId: "txn_1" }]
    });
    mocks.prisma.settlementEvent.findFirst.mockResolvedValue({ id: "existing_release" });

    await handleJob("deposit_settlement", { bookingId });

    expect(mocks.prisma.settlementEvent.create).not.toHaveBeenCalled();
  });
});

describe("handleJob — refund_reconciliation", () => {
  const paymentId = "pay_1";

  const succeededPayment = {
    id: paymentId,
    bookingId: "booking_1",
    amountXof: 12_000,
    status: "succeeded",
    providerTxId: "txn_1"
  };

  const authorizedPayment = {
    id: paymentId,
    bookingId: "booking_1",
    amountXof: 12_000,
    status: "authorized",
    providerTxId: "txn_1"
  };

  it("processes a refund for a succeeded payment", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue(succeededPayment);
    mocks.prisma.settlementEvent.findFirst.mockResolvedValue(null);
    mocks.prisma.payment.updateMany.mockResolvedValue({ count: 1 });
    mocks.adapter.requestRefund.mockResolvedValue({ refundRef: "refund_1" });

    await handleJob("refund_reconciliation", { paymentId });

    expect(mocks.adapter.requestRefund).toHaveBeenCalledWith({
      providerRef: "txn_1",
      amountXof: 12_000,
      reason: "booking_cancelled",
      phone: undefined
    });
    expect(mocks.prisma.booking.update).toHaveBeenCalledWith({
      where: { id: "booking_1" },
      data: { depositPaymentStatus: "refunded" }
    });
    expect(mocks.prisma.settlementEvent.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          bookingId: "booking_1",
          paymentId,
          eventType: "refunded",
          amountXof: 12_000,
          providerReference: "refund_1"
        })
      })
    );
  });

  it("does nothing when payment is not found", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue(null);

    await handleJob("refund_reconciliation", { paymentId });

    expect(mocks.prisma.payment.updateMany).not.toHaveBeenCalled();
    expect(mocks.adapter.requestRefund).not.toHaveBeenCalled();
  });

  it("does nothing when payment has no providerTxId", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue({ ...succeededPayment, providerTxId: null });

    await handleJob("refund_reconciliation", { paymentId });

    expect(mocks.prisma.payment.updateMany).not.toHaveBeenCalled();
  });

  it("does nothing when payment status is not authorized/succeeded (e.g. pending)", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue({
      ...succeededPayment,
      status: "pending"
    });

    await handleJob("refund_reconciliation", { paymentId });

    expect(mocks.prisma.payment.updateMany).not.toHaveBeenCalled();
  });

  it("does nothing when a refunded settlementEvent already exists (dedupe)", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue(succeededPayment);
    mocks.prisma.settlementEvent.findFirst.mockResolvedValue({ id: "existing_refund" });

    await handleJob("refund_reconciliation", { paymentId });

    expect(mocks.prisma.payment.updateMany).not.toHaveBeenCalled();
    expect(mocks.adapter.requestRefund).not.toHaveBeenCalled();
  });

  it("handles race condition — loses atomic claim (updateMany returns 0)", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue(succeededPayment);
    mocks.prisma.settlementEvent.findFirst.mockResolvedValue(null);
    mocks.prisma.payment.updateMany.mockResolvedValue({ count: 0 });

    await handleJob("refund_reconciliation", { paymentId });

    expect(mocks.adapter.requestRefund).not.toHaveBeenCalled();
  });

  it("rolls back payment status when requestRefund throws", async () => {
    mocks.prisma.payment.findUnique.mockResolvedValue(succeededPayment);
    mocks.prisma.settlementEvent.findFirst.mockResolvedValue(null);
    mocks.prisma.payment.updateMany.mockResolvedValue({ count: 1 });
    mocks.adapter.requestRefund.mockRejectedValue(new Error("Provider timeout"));
    mocks.prisma.payment.update.mockResolvedValue({});

    await expect(handleJob("refund_reconciliation", { paymentId })).rejects.toThrow("Provider timeout");

    // Should have rolled back the status
    expect(mocks.prisma.payment.update).toHaveBeenCalledWith({
      where: { id: paymentId },
      data: { status: "succeeded" }
    });
  });

  it("resolves client phone when paymentDriver is paydunya", async () => {
    mocks.config.paymentDriver = "paydunya";
    mocks.prisma.payment.findUnique.mockResolvedValue(succeededPayment);
    mocks.prisma.settlementEvent.findFirst.mockResolvedValue(null);
    mocks.prisma.payment.updateMany.mockResolvedValue({ count: 1 });
    mocks.adapter.requestRefund.mockResolvedValue({ refundRef: "refund_1" });
    mocks.prisma.booking.findUnique.mockResolvedValue({
      id: "booking_1",
      client: { phone: "+221771234567" }
    });

    await handleJob("refund_reconciliation", { paymentId });

    expect(mocks.adapter.requestRefund).toHaveBeenCalledWith(
      expect.objectContaining({ phone: "+221771234567" })
    );
  });

  it("resolves null phone when paydunya booking has no client phone", async () => {
    mocks.config.paymentDriver = "paydunya";
    mocks.prisma.payment.findUnique.mockResolvedValue(succeededPayment);
    mocks.prisma.settlementEvent.findFirst.mockResolvedValue(null);
    mocks.prisma.payment.updateMany.mockResolvedValue({ count: 1 });
    mocks.adapter.requestRefund.mockResolvedValue({ refundRef: "refund_1" });
    mocks.prisma.booking.findUnique.mockResolvedValue({
      id: "booking_1",
      client: { phone: null }
    });

    await handleJob("refund_reconciliation", { paymentId });

    expect(mocks.adapter.requestRefund).toHaveBeenCalledWith(
      expect.objectContaining({ phone: undefined })
    );
  });

  it("does not resolve phone when paymentDriver is not paydunya", async () => {
    mocks.config.paymentDriver = "mock";
    mocks.prisma.payment.findUnique.mockResolvedValue(succeededPayment);
    mocks.prisma.settlementEvent.findFirst.mockResolvedValue(null);
    mocks.prisma.payment.updateMany.mockResolvedValue({ count: 1 });
    mocks.adapter.requestRefund.mockResolvedValue({ refundRef: "refund_1" });

    await handleJob("refund_reconciliation", { paymentId });

    // phone should be undefined regardless — but the booking lookup should NOT have happened
    expect(mocks.prisma.booking.findUnique).not.toHaveBeenCalled();
  });
});
