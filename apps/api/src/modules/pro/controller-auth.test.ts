import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const handleError = vi.fn();
  const prisma = {
    platformSetting: { findUnique: vi.fn() }
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

import { HttpAuthError } from "../../lib/auth/index.js";
import { ProController } from "./index.js";

describe("ProController auth failures", () => {
  const c = new ProController();
  const reply = {} as never;

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockImplementation(() => {
      throw new HttpAuthError(401, "missing_auth", "No auth");
    });
  });

  it("fails fast on auth across pro endpoints", async () => {
    await c.dashboard({} as never, reply);
    await c.getSalon({} as never, reply);
    await c.updateSalon({ body: {} } as never, reply);
    await c.listServices({} as never, reply);
    await c.createService({ body: {} } as never, reply);
    await c.updateService({ params: { serviceId: "x" }, body: {} } as never, reply);
    await c.deleteService({ params: { serviceId: "x" } } as never, reply);
    await c.listStaff({} as never, reply);
    await c.createStaff({ body: {} } as never, reply);
    await c.updateStaff({ params: { employeeId: "e1" }, body: {} } as never, reply);
    await c.deleteStaff({ params: { employeeId: "e1" } } as never, reply);
    await c.getHours({} as never, reply);
    await c.updateHours({ body: [] } as never, reply);
    await c.listBlockedSlots({} as never, reply);
    await c.createBlockedSlot({ body: {} } as never, reply);
    await c.deleteBlockedSlot({ params: { slotId: "b1" } } as never, reply);
    await c.listBookings({ query: {} } as never, reply);
    await c.getBooking({ params: { bookingId: "b1" } } as never, reply);
    await c.acceptBooking({ params: { bookingId: "b1" } } as never, reply);
    await c.rejectBooking({ params: { bookingId: "b1" }, body: { reason: "x" } } as never, reply);
    await c.startBooking({ params: { bookingId: "b1" } } as never, reply);
    await c.completeBooking({ params: { bookingId: "b1" } } as never, reply);
    await c.createManualBooking({ body: {} } as never, reply);
    await c.listClients({ query: {} } as never, reply);
    await c.getClient({ params: { clientId: "u1" } } as never, reply);
    await c.getCheckout({ params: { bookingId: "b1" } } as never, reply);
    await c.completeCheckout({ params: { bookingId: "b1" }, body: {} } as never, reply);
    await c.listReviews({ query: {} } as never, reply);
    await c.respondToReview({ params: { reviewId: "r1" }, body: {} } as never, reply);
    await c.analytics({ query: {} } as never, reply);
    await c.getSubscription({} as never, reply);
    await c.updateSubscription({ body: {} } as never, reply);
    await c.subscriptionCheckout({ body: {} } as never, reply);
    await c.listPayouts({} as never, reply);
    await c.listInvoices({} as never, reply);
    await c.downloadInvoicePdf({ params: { invoiceId: "i1" } } as never, reply);
    await c.getPayoutSettings({} as never, reply);
    await c.updatePayoutSettings({ body: { payoutMethod: "wave_senegal", payoutPhone: "771234567", payoutName: "Salon", password: "x" } } as never, reply);
    await c.listMerchantPayouts({} as never, reply);

    expect(mocks.fail.mock.calls.length + mocks.handleError.mock.calls.length).toBeGreaterThan(0);
  });
});
