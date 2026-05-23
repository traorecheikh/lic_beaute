import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const handleError = vi.fn();
  const paymentAdapter = { initiateDeposit: vi.fn() };
  const prisma = {
    user: { findUnique: vi.fn() },
    subscription: { findUnique: vi.fn(), update: vi.fn() },
    subscriptionCharge: { findFirst: vi.fn(), create: vi.fn(), update: vi.fn() },
    platformSetting: { findMany: vi.fn(), findUnique: vi.fn(), upsert: vi.fn(), deleteMany: vi.fn() },
    $transaction: vi.fn()
  };
  return { requireRole, fail, ok, handleError, paymentAdapter, prisma };
});

describe("Pro forced branches", () => {
  beforeEach(() => {
    vi.resetModules();
    vi.clearAllMocks();
  });

  it("forces updateSubscription path with empty updatePayload (Object.keys length == 0)", async () => {
    vi.doMock("@beauteavenue/contracts", async (importOriginal) => {
      const actual = await importOriginal<typeof import("@beauteavenue/contracts")>();
      return {
        ...actual,
        proSubscriptionUpdateInputSchema: { parse: vi.fn(() => ({})) }
      };
    });
    vi.doMock("../../lib/auth/index.js", async (importOriginal) => {
      const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
      return { ...actual, requireRole: mocks.requireRole };
    });
    vi.doMock("../../lib/http.js", async (importOriginal) => {
      const actual = await importOriginal<typeof import("../../lib/http.js")>();
      return { ...actual, fail: mocks.fail, ok: mocks.ok, handleError: mocks.handleError };
    });
    vi.doMock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => mocks.paymentAdapter) }));
    vi.doMock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
    vi.doMock("../../lib/cache.js", () => ({ getOrSetCachedJson: vi.fn(), invalidateCacheTags: vi.fn() }));
    vi.doMock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: vi.fn() }));
    vi.doMock("../../lib/jobs.js", () => ({ enqueueJob: vi.fn() }));
    vi.doMock("./data.js", () => ({ getProAnalytics: vi.fn(), getProDashboard: vi.fn() }));

    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1", phone: "+221770000000" });
    mocks.prisma.$transaction.mockImplementation(async (cb: any) => cb({
      subscription: { update: vi.fn() },
      platformSetting: { upsert: vi.fn(), deleteMany: vi.fn() }
    }));

    const { ProController } = await import("./index.js");
    const c = new ProController();
    await c.updateSubscription({ body: { anything: "ignored" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { updated: true });
  });

  it("forces checkout create fallback provider when parsed provider is undefined", async () => {
    vi.doMock("@beauteavenue/contracts", async (importOriginal) => {
      const actual = await importOriginal<typeof import("@beauteavenue/contracts")>();
      return {
        ...actual,
        proSubscriptionCheckoutInputSchema: {
          parse: vi.fn(() => ({ action: "upgrade", provider: undefined }))
        }
      };
    });
    vi.doMock("../../lib/auth/index.js", async (importOriginal) => {
      const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
      return { ...actual, requireRole: mocks.requireRole };
    });
    vi.doMock("../../lib/http.js", async (importOriginal) => {
      const actual = await importOriginal<typeof import("../../lib/http.js")>();
      return { ...actual, fail: mocks.fail, ok: mocks.ok, handleError: mocks.handleError };
    });
    vi.doMock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => mocks.paymentAdapter) }));
    vi.doMock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
    vi.doMock("../../lib/cache.js", () => ({ getOrSetCachedJson: vi.fn(), invalidateCacheTags: vi.fn() }));
    vi.doMock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: vi.fn() }));
    vi.doMock("../../lib/jobs.js", () => ({ enqueueJob: vi.fn() }));
    vi.doMock("./data.js", () => ({ getProAnalytics: vi.fn(), getProDashboard: vi.fn() }));

    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1", phone: "+221770000000" });
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
    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValue(null);
    mocks.paymentAdapter.initiateDeposit.mockResolvedValue({ providerRef: "pref-x", redirectUrl: "https://pay", expiresAt: new Date() });
    mocks.prisma.subscriptionCharge.create.mockResolvedValue({ id: "ch-x" });

    const { ProController } = await import("./index.js");
    const c = new ProController();
    await c.subscriptionCheckout({ body: { any: "ignored" } } as never, {} as never);
    expect(mocks.prisma.subscriptionCharge.create).toHaveBeenCalled();
  });

  it("forces completeCheckout with undefined paymentMethod/discount to hit nullish fallback math branches", async () => {
    vi.resetModules();
    vi.doMock("@beauteavenue/contracts", async (importOriginal) => {
      const actual = await importOriginal<typeof import("@beauteavenue/contracts")>();
      return {
        ...actual,
        proCheckoutCompleteInputSchema: {
          parse: vi.fn(() => ({ paymentMethod: "cash", lineItems: [{ name: "Service", amountXof: 10000 }] }))
        }
      };
    });
    vi.doMock("../../lib/auth/index.js", async (importOriginal) => {
      const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
      return { ...actual, requireRole: mocks.requireRole };
    });
    vi.doMock("../../lib/http.js", async (importOriginal) => {
      const actual = await importOriginal<typeof import("../../lib/http.js")>();
      return { ...actual, fail: mocks.fail, ok: mocks.ok, handleError: mocks.handleError };
    });
    vi.doMock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => mocks.paymentAdapter) }));
    vi.doMock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
    vi.doMock("../../lib/cache.js", () => ({ getOrSetCachedJson: vi.fn(), invalidateCacheTags: vi.fn() }));
    vi.doMock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: vi.fn() }));
    vi.doMock("../../lib/jobs.js", () => ({ enqueueJob: vi.fn() }));
    vi.doMock("./data.js", () => ({ getProAnalytics: vi.fn(), getProDashboard: vi.fn() }));

    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1", phone: "+221770000000" });
    (mocks.prisma as any).booking = { findFirst: vi.fn().mockResolvedValue({
      id: "b1",
      status: "confirmed",
      service: { priceXof: 10000 },
      payments: []
    }) };
    const settlementCreate = vi.fn();
    mocks.prisma.$transaction.mockImplementation(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      settlementEvent: { create: settlementCreate }
    }));

    const { ProController } = await import("./index.js");
    const c = new ProController();
    await c.completeCheckout({ params: { bookingId: "b1" }, body: { any: "ignored" } } as never, {} as never);
    expect(settlementCreate).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ providerReference: "manual-cash" })
    }));
  });
});
