import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const adapter = {
    requestRefund: vi.fn(),
    verifyWebhookSignature: vi.fn(),
    parseWebhook: vi.fn(),
    fetchPaymentStatus: vi.fn(),
    normalizeStatus: vi.fn(),
    initiateDeposit: vi.fn()
  };
  const prisma = {
    payment: { findUnique: vi.fn(), updateMany: vi.fn() },
    user: { findUnique: vi.fn() },
    $transaction: vi.fn(async (fn: any) => fn({
      booking: { update: vi.fn() },
      settlementEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() }
    }))
  };
  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  return { adapter, prisma, requireRole, ok, fail };
});

vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: () => mocks.adapter }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});

import { PaymentController } from "./index.js";

describe("Payment refund race guard", () => {
  const controller = new PaymentController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "owner_1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "salon_1" });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "book_1",
      amountXof: 12000,
      status: "succeeded",
      providerTxId: "REF_1",
      booking: { clientId: "c1", salonId: "salon_1" }
    });
  });

  it("returns conflict when refund claim is already lost", async () => {
    mocks.prisma.payment.updateMany.mockResolvedValue({ count: 0 });

    await controller.refund({ params: { paymentId: "pay_1" } } as never, {} as never);

    expect(mocks.adapter.requestRefund).not.toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      409,
      "already_refunded",
      "Ce paiement a déjà été remboursé."
    );
  });
});

