import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const handleError = vi.fn();
  const paymentAdapter = { initiateDeposit: vi.fn(), executePayment: vi.fn() };
  const prisma = {
    user: { findUnique: vi.fn() },
    subscription: { findUnique: vi.fn(), update: vi.fn() },
    subscriptionCharge: { findFirst: vi.fn(), findUnique: vi.fn(), create: vi.fn(), update: vi.fn() },
    platformSetting: { findMany: vi.fn(), findUnique: vi.fn() },
    billingInvoice: { findFirst: vi.fn() },
    salon: { findUnique: vi.fn() },
    $transaction: vi.fn()
  };
  return { requireRole, fail, ok, handleError, paymentAdapter, prisma };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/http.js")>();
  return { ...actual, fail: mocks.fail, ok: mocks.ok, handleError: mocks.handleError };
});
vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => mocks.paymentAdapter) }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/cache.js", () => ({ getOrSetCachedJson: vi.fn(), invalidateCacheTags: vi.fn() }));
vi.mock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: vi.fn() }));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: vi.fn() }));
vi.mock("./data.js", () => ({ getProAnalytics: vi.fn(), getProDashboard: vi.fn() }));

import { ProController } from "./index.js";

describe("Pro subscription/invoice branches", () => {
  const c = new ProController();
  const reply = {
    type: vi.fn(() => reply),
    header: vi.fn(() => reply),
    send: vi.fn(() => reply)
  } as never;

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1", phone: "+221770000000" });
  });

  it("subscriptionCheckout updates existing charge when providerTxId absent", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue({
      id: "sub1",
      tier: "standard",
      status: "active",
      renewedAt: null,
      expiresAt: null,
      isComplimentary: false,
      autoRenew: true,
      billingProvider: "manual"
    });
    mocks.prisma.platformSetting.findMany.mockResolvedValue([
      { key: "subscription_premium_price_xof", value: "25000" },
      { key: "subscription_standard_price_xof", value: "15000" }
    ]);
    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValue({ id: "ch1", providerTxId: null });
    mocks.paymentAdapter.initiateDeposit.mockResolvedValue({ providerRef: "pref1", redirectUrl: "https://pay", expiresAt: new Date() });
    mocks.prisma.subscriptionCharge.update.mockResolvedValue({ id: "ch1" });

    await c.subscriptionCheckout({ body: { action: "upgrade", provider: "paydunya" } } as never, reply);
    expect(mocks.prisma.subscriptionCharge.update).toHaveBeenCalled();
  });

  it("subscriptionCheckout revives failed charge for the same idempotency key", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue({
      id: "sub1",
      tier: "standard",
      status: "active",
      renewedAt: null,
      expiresAt: null,
      isComplimentary: false,
      autoRenew: true,
      billingProvider: "manual"
    });
    mocks.prisma.platformSetting.findMany.mockResolvedValue([
      { key: "subscription_premium_price_xof", value: "300" },
      { key: "subscription_standard_price_xof", value: "200" }
    ]);
    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValue({
      id: "ch_failed",
      status: "failed",
      providerTxId: "old_pref"
    });
    mocks.paymentAdapter.initiateDeposit.mockResolvedValue({ providerRef: "pref_new", redirectUrl: "https://pay-new", expiresAt: new Date() });
    mocks.prisma.subscriptionCharge.update.mockResolvedValue({ id: "ch_failed" });

    await c.subscriptionCheckout({ body: { action: "upgrade", provider: "paydunya" } } as never, reply);

    // First update resets the failed charge to pending
    expect(mocks.prisma.subscriptionCharge.update).toHaveBeenNthCalledWith(1, {
      where: { id: "ch_failed" },
      data: expect.objectContaining({ status: "pending" })
    });
    // Second update sets the new providerTxId
    expect(mocks.prisma.subscriptionCharge.update).toHaveBeenNthCalledWith(2, {
      where: { id: "ch_failed" },
      data: expect.objectContaining({ providerTxId: "pref_new" })
    });
  });

  it("subscriptionCheckout creates charge when no existing", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue({
      id: "sub2",
      tier: "premium",
      status: "active",
      renewedAt: null,
      expiresAt: null,
      isComplimentary: false,
      autoRenew: true,
      billingProvider: "paydunya"
    });
    mocks.prisma.platformSetting.findMany.mockResolvedValue([
      { key: "subscription_premium_price_xof", value: "25000" },
      { key: "subscription_standard_price_xof", value: "15000" }
    ]);
    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValue(null);
    mocks.paymentAdapter.initiateDeposit.mockResolvedValue({ providerRef: "pref2", redirectUrl: "https://pay2", expiresAt: new Date() });
    mocks.prisma.subscriptionCharge.create.mockResolvedValue({ id: "ch2" });

    await c.subscriptionCheckout({ body: { action: "renewal", provider: "manual" } } as never, reply);
    expect(mocks.prisma.subscriptionCharge.create).toHaveBeenCalled();
  });

  it("executeSubscriptionPayment marks charge failed when PayDunya says already initiated", async () => {
    // $transaction must execute the callback for _markSubscriptionChargeFailed.
    // The callback uses tx.auditLog (plus possibly tx.subscription for upgrade case)
    mocks.prisma.$transaction.mockImplementation(async (cb: any) => {
      if (typeof cb === "function") {
        return cb({
          subscriptionCharge: mocks.prisma.subscriptionCharge,
          subscription: mocks.prisma.subscription,
          auditLog: { create: vi.fn() }
        });
      }
      return [];
    });
    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "ch3",
      status: "pending",
      providerTxId: "live_token_123",
      subscriptionId: "sub3",
      subscription: { id: "sub3", salonId: "s1" }
    });
    mocks.paymentAdapter.executePayment.mockResolvedValue({
      success: false,
      status: "failed",
      providerTxId: null,
      message: "Ce paiement a déjà été initié."
    });

    await c.executeSubscriptionPayment({
      params: { chargeId: "ch3" },
      body: { method: "wave_senegal", details: { phone: "781706184" } }
    } as never, reply);

    expect(mocks.prisma.subscriptionCharge.update).toHaveBeenCalledWith({
      where: { id: "ch3" },
      data: { status: "failed" }
    });
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ success: false }));
  });

  it("downloadInvoicePdf falls back provider to manual when both setting and sub provider missing", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue({ id: "sub3", billingProvider: null });
    mocks.prisma.billingInvoice.findFirst.mockResolvedValue({
      id: "inv3",
      invoiceNumber: "INV3",
      amountXof: 10000,
      status: "paid",
      createdAt: new Date(),
      pdfUrl: ""
    });
    mocks.prisma.salon.findUnique.mockResolvedValue(null);
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);

    await c.downloadInvoicePdf({ params: { invoiceId: "inv3" } } as never, reply);
    expect(mocks.fail).not.toHaveBeenCalledWith(expect.anything(), 404, "subscription_not_found", expect.anything());
  });
});
