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
    booking: { update: vi.fn() },
    settlementEvent: { findFirst: vi.fn(), create: vi.fn() },
    auditLog: { create: vi.fn() }
  };

  const prisma = {
    payment: {
      findFirst: vi.fn(),
      findUnique: vi.fn(),
      update: vi.fn()
    },
    $transaction: vi.fn(async (fn: (txArg: typeof tx) => Promise<void>) => fn(tx))
  };

  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const loggerError = vi.fn();

  return { adapter, tx, prisma, requireRole, ok, fail, loggerError };
});

vi.mock("../adapters/index.js", () => ({
  createPaymentAdapter: () => mocks.adapter
}));

vi.mock("../lib/prisma.js", () => ({
  prisma: mocks.prisma
}));

vi.mock("../lib/auth.js", () => {
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

vi.mock("../lib/http.js", () => ({
  ok: mocks.ok,
  fail: mocks.fail
}));

vi.mock("../lib/logger.js", () => ({
  logger: {
    error: mocks.loggerError
  }
}));

import { PaymentController } from "./payments.js";

describe("PaymentController", () => {
  const controller = new PaymentController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.tx.settlementEvent.findFirst.mockResolvedValue(null);
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

    await controller.webhookPayTech({ body: { any: "payload" } } as never, {} as never);

    expect(mocks.prisma.$transaction).toHaveBeenCalledTimes(1);
    expect(mocks.tx.payment.update).toHaveBeenCalledWith(expect.objectContaining({
      where: { id: "pay_1" },
      data: expect.objectContaining({ status: "succeeded", providerTxId: "REF_123" })
    }));
    expect(mocks.tx.booking.update).toHaveBeenCalledWith(expect.objectContaining({
      where: { id: "book_1" },
      data: { depositPaymentStatus: "succeeded" }
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

    await controller.webhookPayTech({ body: { any: "payload" } } as never, {} as never);

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
        provider: "paytech",
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
        provider: "paytech",
        providerTxId: "REF_123",
        createdAt: new Date("2026-05-05T10:00:00.000Z")
      });

    await controller.reconcile({ params: { paymentId: "pay_1" } } as never, {} as never);

    expect(mocks.adapter.fetchPaymentStatus).toHaveBeenCalledWith({ providerToken: "tok_123" });
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
});
