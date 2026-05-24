import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const handleError = vi.fn();
  const prisma = {
    user: { findUnique: vi.fn() }
  };
  return { requireRole, fail, ok, handleError, prisma };
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
vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => ({ initiateDeposit: vi.fn() })) }));
vi.mock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: vi.fn() }));
vi.mock("../../lib/cache.js", () => ({ getOrSetCachedJson: vi.fn(), invalidateCacheTags: vi.fn() }));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: vi.fn() }));
vi.mock("./data.js", () => ({ getProAnalytics: vi.fn(), getProDashboard: vi.fn() }));

import { ProController } from "./index.js";

describe("ProController owner-only guards", () => {
  const c = new ProController();
  const rep = {} as never;

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_staff" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
  });

  it("blocks owner-only endpoints for salon_staff", async () => {
    await c.updateSalon({ body: {} } as never, rep);
    await c.createService({ body: {} } as never, rep);
    await c.updateService({ params: { serviceId: "svc1" }, body: {} } as never, rep);
    await c.deleteService({ params: { serviceId: "svc1" } } as never, rep);
    await c.listStaff({} as never, rep);
    await c.createStaff({ body: {} } as never, rep);
    await c.updateStaff({ params: { employeeId: "e1" }, body: {} } as never, rep);
    await c.deleteStaff({ params: { employeeId: "e1" } } as never, rep);
    await c.updateHours({ body: [] } as never, rep);
    await c.acceptBooking({ params: { bookingId: "b1" } } as never, rep);
    await c.rejectBooking({ params: { bookingId: "b1" }, body: { reason: "x" } } as never, rep);
    await c.startBooking({ params: { bookingId: "b1" } } as never, rep);
    await c.completeBooking({ params: { bookingId: "b1" } } as never, rep);
    await c.createManualBooking({ body: {} } as never, rep);
    await c.respondToReview({ params: { reviewId: "r1" }, body: { responseText: "ok" } } as never, rep);
    await c.analytics({ query: { period: "30d" } } as never, rep);
    await c.getSubscription({} as never, rep);
    await c.updateSubscription({ body: {} } as never, rep);
    await c.subscriptionCheckout({ body: { action: "upgrade", provider: "paydunya" } } as never, rep);
    await c.listPayouts({} as never, rep);
    await c.listInvoices({} as never, rep);
    await c.downloadInvoicePdf({ params: { invoiceId: "inv1" } } as never, rep);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "owner_only", expect.any(String));
  });
});
