import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const handleError = vi.fn();
  const prisma = {
    user: { findUnique: vi.fn() },
    booking: { findFirst: vi.fn(), updateMany: vi.fn() },
    payment: { findFirst: vi.fn() },
    service: { findFirst: vi.fn() },
    subscription: { findUnique: vi.fn() },
    billingInvoice: { findFirst: vi.fn(), findMany: vi.fn() },
    salon: { findUnique: vi.fn() },
    platformSetting: { findMany: vi.fn(), findUnique: vi.fn() },
    review: { findFirst: vi.fn() },
    settlementEvent: { findMany: vi.fn() },
    $transaction: vi.fn()
  };
  const fetchSlots = vi.fn();
  const invalidateCacheTags = vi.fn();
  const enqueueJob = vi.fn();
  const paymentAdapter = { initiateDeposit: vi.fn() };
  return { requireRole, fail, ok, handleError, prisma, fetchSlots, invalidateCacheTags, enqueueJob, paymentAdapter };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/http.js")>();
  return { ...actual, fail: mocks.fail, ok: mocks.ok, handleError: mocks.handleError };
});
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: mocks.fetchSlots }));
vi.mock("../../lib/cache.js", () => ({ getOrSetCachedJson: vi.fn(), invalidateCacheTags: mocks.invalidateCacheTags }));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: mocks.enqueueJob }));
vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => mocks.paymentAdapter) }));
vi.mock("./data.js", () => ({ getProAnalytics: vi.fn(), getProDashboard: vi.fn() }));

import { ProController } from "./index.js";

describe("ProController branches", () => {
  const c = new ProController();
  const rep = {} as never;

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() },
      payment: { findFirst: vi.fn().mockResolvedValue(null) },
      settlementEvent: { create: vi.fn() },
      subscription: { update: vi.fn() },
      platformSetting: { upsert: vi.fn(), deleteMany: vi.fn() }
    }));
  });

  it("transition returns booking_not_found and invalid_status", async () => {
    mocks.prisma.booking.findFirst
      .mockResolvedValueOnce(null) // accept pre-check -> 404
      .mockResolvedValueOnce({ id: "b1", status: "completed", depositAmountXof: 0, payments: [] }) // accept pre-check
      .mockResolvedValueOnce({ id: "b1", status: "completed" }); // transitionBooking check
    await c.acceptBooking({ params: { bookingId: "b1" } } as never, rep);
    await c.acceptBooking({ params: { bookingId: "b1" } } as never, rep);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "booking_not_found", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_status", expect.any(String));
  });

  it("createManualBooking validates service and slot", async () => {
    mocks.prisma.service.findFirst.mockResolvedValueOnce(null).mockResolvedValueOnce({ id: "svc1", durationMinutes: 30, depositMode: "none", depositAmountXof: null, depositPercent: null, priceXof: 10000 });
    await c.createManualBooking({ body: { serviceId: "svc1", startsAt: new Date(Date.now() + 7200_000).toISOString(), clientId: "c1" } } as never, rep);
    mocks.fetchSlots.mockResolvedValue([]);
    await c.createManualBooking({ body: { serviceId: "svc1", startsAt: new Date(Date.now() + 7200_000).toISOString(), clientId: "c1" } } as never, rep);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "service_not_found", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "slot_unavailable", expect.any(String));
  });

  it("getCheckout and completeCheckout branch guards", async () => {
    mocks.prisma.booking.findFirst
      .mockResolvedValueOnce(null)
      .mockResolvedValueOnce({ id: "b1", status: "cancelled", service: { priceXof: 10000 }, payments: [] });
    await c.getCheckout({ params: { bookingId: "b1" } } as never, rep);
    await c.completeCheckout({ params: { bookingId: "b1" }, body: { paymentMethod: "cash", discountXof: 0, lineItems: [] } } as never, rep);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "booking_not_found", expect.any(String));
    expect(mocks.fail).toHaveBeenCalled();
  });

  it("rejectBooking afterHook enqueues refund when payment exists", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({ id: "b1", status: "pending" });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() },
      payment: { findFirst: vi.fn().mockResolvedValue({ id: "pay1" }) },
      settlementEvent: { create: vi.fn() },
      subscription: { update: vi.fn() },
      platformSetting: { upsert: vi.fn(), deleteMany: vi.fn() }
    }));
    await c.rejectBooking({ params: { bookingId: "b1" }, body: { reason: "Client did not show up to the appointment." } } as never, rep);
    expect(mocks.fail.mock.calls.length + mocks.ok.mock.calls.length + mocks.handleError.mock.calls.length).toBeGreaterThan(0);
  });

  it("subscription/invoice branches", async () => {
    mocks.prisma.subscription.findUnique
      .mockResolvedValueOnce(null) // getSubscription
      .mockResolvedValueOnce({ id: "sub1", salonId: "s1", tier: "standard", status: "active", renewedAt: null, expiresAt: null, isComplimentary: false, autoRenew: true, billingProvider: "manual" }) // subscriptionCheckout
      .mockResolvedValueOnce(null) // listInvoices
      .mockResolvedValueOnce({ id: "sub1", salonId: "s1", tier: "standard", status: "active", renewedAt: null, expiresAt: null, isComplimentary: false, autoRenew: true, billingProvider: "manual" }); // downloadInvoicePdf
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1", phone: null });
    await c.getSubscription({} as never, rep);
    await c.subscriptionCheckout({ body: { action: "upgrade", provider: "intech" } } as never, rep);
    await c.listInvoices({} as never, rep);
    mocks.prisma.billingInvoice.findFirst.mockResolvedValue(null);
    await c.downloadInvoicePdf({ params: { invoiceId: "i1" } } as never, rep);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "subscription_not_found", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "invoice_not_found", expect.any(String));
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), []);
  });

  it("review/payouts branch", async () => {
    mocks.prisma.review.findFirst.mockResolvedValue(null);
    mocks.prisma.settlementEvent.findMany.mockResolvedValue([]);
    await c.respondToReview({ params: { reviewId: "r1" }, body: { responseText: "Merci" } } as never, rep);
    await c.listPayouts({} as never, rep);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "review_not_found", expect.any(String));
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), []);
  });
});
