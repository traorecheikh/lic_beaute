import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const handleError = vi.fn();
  const getOrSetCachedJson = vi.fn();
  const getProAnalytics = vi.fn();
  const invalidateCacheTags = vi.fn();
  const enqueueJob = vi.fn();
  const prisma = {
    user: { findUnique: vi.fn() },
    booking: { findFirst: vi.fn() },
    salon: { findUnique: vi.fn().mockResolvedValue({ subscription: { status: "active" } }) },
    $transaction: vi.fn(),
    platformSetting: { findMany: vi.fn().mockResolvedValue([]) },
  };
  return { requireRole, fail, ok, handleError, getOrSetCachedJson, getProAnalytics, invalidateCacheTags, enqueueJob, prisma };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/http.js")>();
  return { ...actual, fail: mocks.fail, ok: mocks.ok, handleError: mocks.handleError };
});
vi.mock("../../lib/cache.js", () => ({
  getOrSetCachedJson: mocks.getOrSetCachedJson,
  invalidateCacheTags: mocks.invalidateCacheTags
}));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: mocks.enqueueJob }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => ({ initiateDeposit: vi.fn() })) }));
vi.mock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: vi.fn() }));
vi.mock("./data.js", () => ({ getProAnalytics: mocks.getProAnalytics, getProDashboard: vi.fn() }));

import { ProController } from "./index.js";

describe("Pro checkout/analytics branches", () => {
  const c = new ProController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
  });

  it("completeCheckout creates settlementEvent when positive balance remains", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b1",
      status: "confirmed",
      service: { priceXof: 10000 },
      payments: [{ amountXof: 1000 }]
    });
    const settlementCreate = vi.fn();
    mocks.prisma.$transaction.mockImplementation(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      settlementEvent: { create: settlementCreate }
    }));
    await c.completeCheckout({
      params: { bookingId: "b1" },
      body: { paymentMethod: "cash", discountXof: 0, lineItems: [{ name: "Service", amountXof: 10000 }] }
    } as never, {} as never);
    expect(settlementCreate).toHaveBeenCalled();
  });

  it("completeCheckout clamps discount to subtotal and skips settlement when balance is zero", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b2",
      status: "confirmed",
      service: { priceXof: 10000 },
      payments: [{ amountXof: 10000 }]
    });
    const settlementCreate = vi.fn();
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      settlementEvent: { create: settlementCreate }
    }));
    await c.completeCheckout({
      params: { bookingId: "b2" },
      body: { paymentMethod: "cash", discountXof: 999999, lineItems: [{ name: "Service", amountXof: 10000 }] }
    } as never, {} as never);
    expect(settlementCreate).not.toHaveBeenCalled();
  });

  it("completeCheckout stores manual-cash providerReference on settlement event", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b3",
      status: "confirmed",
      service: { priceXof: 10000 },
      payments: []
    });
    const settlementCreate = vi.fn();
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      settlementEvent: { create: settlementCreate }
    }));
    await c.completeCheckout({
      params: { bookingId: "b3" },
      body: { paymentMethod: "cash", discountXof: 0, lineItems: [{ name: "Service", amountXof: 10000 }] }
    } as never, {} as never);
    expect(settlementCreate).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ providerReference: "manual-cash" })
    }));
  });

  it("analytics defaults period to 30d when query period is missing", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue({ subscriptionTier: "premium", subscription: { status: "active" } });
    mocks.getOrSetCachedJson.mockResolvedValue({ value: { ok: true }, cacheStatus: "MISS" });
    await c.analytics({ query: {} } as never, { header: vi.fn() } as never);
    expect(mocks.getOrSetCachedJson).toHaveBeenCalledWith(expect.objectContaining({
      key: "kpi:pro:analytics:s1:30d"
    }));
  });
});
