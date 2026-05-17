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

  const prisma = {
    payment: {
      findUnique: vi.fn(),
      findFirst: vi.fn()
    },
    subscriptionCharge: {
      findUnique: vi.fn(),
      findFirst: vi.fn()
    },
    $transaction: vi.fn()
  };
  const ok = vi.fn();
  const fail = vi.fn();
  return { adapter, prisma, ok, fail };
});

vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: () => mocks.adapter }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: vi.fn() };
});

import { PaymentController } from "./index.js";

describe("Payment webhook security", () => {
  const controller = new PaymentController();

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("rejects webhook when signature verification fails", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(false);

    await controller.webhookIntech({ body: { test: true }, headers: {} } as never, {} as never);

    expect(mocks.adapter.parseWebhook).not.toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "invalid_signature", "Signature invalide.");
  });

  it("rejects payment callback when amount mismatches expected amount", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_123",
      status: "succeeded",
      amountXof: 15000,
      metadata: { paymentId: "pay_1" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "book_1",
      amountXof: 12000,
      status: "pending",
      providerTxId: "REF_123",
      booking: { clientId: "c1", salonId: "s1" }
    });

    await controller.webhookIntech({ body: { test: true }, headers: {} } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      422,
      "amount_mismatch",
      "Montant du callback incohérent."
    );
  });

  it("ignores webhook when metadata paymentId exists but providerRef does not match", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_OTHER",
      status: "succeeded",
      amountXof: 0,
      metadata: { paymentId: "pay_1" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_1",
      bookingId: "book_1",
      amountXof: 12000,
      status: "pending",
      providerTxId: "REF_123",
      booking: { clientId: "c1", salonId: "s1" }
    });
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue(null);

    await controller.webhookIntech({ body: { test: true }, headers: {} } as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("ignores webhook when metadata chargeId exists but providerRef does not match", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_OTHER",
      status: "succeeded",
      amountXof: 0,
      metadata: { paymentId: "charge_1" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "charge_1",
      subscriptionId: "sub_1",
      amountXof: 10000,
      status: "pending",
      chargeType: "renewal",
      providerTxId: "REF_123",
      subscription: { id: "sub_1" }
    });

    await controller.webhookIntech({ body: { test: true }, headers: {} } as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("accepts webhook when metadata paymentId matches providerRef binding", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
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
      providerTxId: "REF_123",
      booking: { clientId: "c1", salonId: "s1" }
    });

    await controller.webhookIntech({ body: { test: true }, headers: {} } as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("handles metadata paymentId when payment record is missing", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_404",
      status: "succeeded",
      amountXof: 0,
      metadata: { paymentId: "pay_missing" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue(null);

    await controller.webhookIntech({ body: { test: true }, headers: {} } as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("accepts webhook when metadata chargeId matches providerRef binding", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_CHARGE",
      status: "succeeded",
      amountXof: 10000,
      metadata: { paymentId: "charge_1" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "charge_1",
      subscriptionId: "sub_1",
      amountXof: 10000,
      status: "pending",
      chargeType: "renewal",
      providerTxId: "REF_CHARGE",
      subscription: { id: "sub_1" }
    });

    await controller.webhookIntech({ body: { test: true }, headers: {} } as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("accepts webhook when metadata paymentId record has null providerTxId", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_NEW",
      status: "succeeded",
      amountXof: 12000,
      metadata: { paymentId: "pay_2" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue({
      id: "pay_2",
      bookingId: "book_2",
      amountXof: 12000,
      status: "pending",
      providerTxId: null,
      booking: { clientId: "c1", salonId: "s1" }
    });
    await controller.webhookIntech({ body: { test: true }, headers: {} } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });

  it("accepts webhook when metadata chargeId record has null providerTxId", async () => {
    mocks.adapter.verifyWebhookSignature.mockReturnValue(true);
    mocks.adapter.parseWebhook.mockReturnValue({
      providerRef: "REF_NEW_C",
      status: "succeeded",
      amountXof: 10000,
      metadata: { paymentId: "charge_2" }
    });
    mocks.prisma.payment.findUnique.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "charge_2",
      subscriptionId: "sub_2",
      amountXof: 10000,
      status: "pending",
      chargeType: "renewal",
      providerTxId: null,
      subscription: { id: "sub_2" }
    });
    await controller.webhookIntech({ body: { test: true }, headers: {} } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { received: true });
  });
});
