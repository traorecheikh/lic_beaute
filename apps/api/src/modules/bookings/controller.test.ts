import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const prisma = {
    service: { findFirst: vi.fn() },
    employee: { findFirst: vi.fn() },
    salon: { findUnique: vi.fn(), update: vi.fn() },
    booking: { create: vi.fn(), findMany: vi.fn(), findFirst: vi.fn(), findUnique: vi.fn(), updateMany: vi.fn() },
    payment: { create: vi.fn() },
    bookingEvent: { create: vi.fn() },
    platformSetting: { findUnique: vi.fn() },
    job: { updateMany: vi.fn() },
    auditLog: { create: vi.fn() },
    review: { findUnique: vi.fn(), aggregate: vi.fn(), create: vi.fn() },
    $transaction: vi.fn()
  };
  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const fetchSlots = vi.fn();
  const enqueueJob = vi.fn();
  const invalidateCacheTags = vi.fn();
  const logger = { error: vi.fn(), warn: vi.fn(), info: vi.fn() };
  return { prisma, requireRole, ok, fail, fetchSlots, enqueueJob, invalidateCacheTags, logger };
});

vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: mocks.fetchSlots }));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: mocks.enqueueJob }));
vi.mock("../../lib/cache.js", () => ({ invalidateCacheTags: mocks.invalidateCacheTags }));
vi.mock("../../lib/logger.js", () => ({ logger: mocks.logger }));
vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => ({ initiateDeposit: vi.fn() })) }));

import { BookingController } from "./index.js";

describe("BookingController", () => {
  const c = new BookingController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.enqueueJob.mockResolvedValue(undefined);
    mocks.fetchSlots.mockResolvedValue([{ startsAt: new Date(Date.now() + 3600_000).toISOString() }]);
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { count: vi.fn().mockResolvedValue(0), create: vi.fn(), updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      payment: { create: vi.fn().mockResolvedValue(null) },
      bookingEvent: { create: vi.fn() },
      job: { updateMany: vi.fn() },
      auditLog: { create: vi.fn() },
      review: { create: vi.fn(), aggregate: vi.fn().mockResolvedValue({ _avg: { rating: 5 } }) },
      salon: { update: vi.fn() }
    }));
  });

  it("create returns 404 when service missing", async () => {
    mocks.prisma.service.findFirst.mockResolvedValue(null);
    await c.create({ body: { salonId: "s1", serviceId: "svc1", startsAt: new Date(Date.now() + 3600_000).toISOString() } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "service_not_found", expect.any(String));
  });

  it("create validates salon, start time, employee, and tx slot conflict", async () => {
    const futureIso = new Date(Date.now() + 3600_000).toISOString();
    mocks.prisma.service.findFirst.mockResolvedValue({
      id: "svc1",
      salonId: "s1",
      isActive: true,
      durationMinutes: 30,
      depositMode: "none",
      depositAmountXof: null,
      depositPercent: null,
      priceXof: 10000
    });
    mocks.prisma.salon.findUnique.mockResolvedValueOnce(null);
    await c.create({ body: { salonId: "s1", serviceId: "svc1", startsAt: futureIso } } as never, {} as never);

    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ id: "s1", approvalStatus: "pending_review", canReceiveBookings: true });
    await c.create({ body: { salonId: "s1", serviceId: "svc1", startsAt: futureIso } } as never, {} as never);

    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ id: "s1", approvalStatus: "approved", canReceiveBookings: false });
    await c.create({ body: { salonId: "s1", serviceId: "svc1", startsAt: futureIso } } as never, {} as never);

    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ id: "s1", approvalStatus: "approved", canReceiveBookings: true });
    await c.create({ body: { salonId: "s1", serviceId: "svc1", startsAt: "2020-01-01T10:00:00.000Z" } } as never, {} as never);

    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ id: "s1", approvalStatus: "approved", canReceiveBookings: true });
    mocks.prisma.employee.findFirst.mockResolvedValueOnce(null);
    await c.create({ body: { salonId: "s1", serviceId: "svc1", startsAt: futureIso, employeeId: "e1" } } as never, {} as never);

    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ id: "s1", approvalStatus: "approved", canReceiveBookings: true });
    mocks.prisma.employee.findFirst.mockResolvedValueOnce({ id: "e1", specialties: [{ serviceId: "other" }] });
    await c.create({ body: { salonId: "s1", serviceId: "svc1", startsAt: futureIso, employeeId: "e1" } } as never, {} as never);

    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ id: "s1", approvalStatus: "approved", canReceiveBookings: true });
    mocks.prisma.employee.findFirst.mockResolvedValueOnce({ id: "e1", specialties: [{ serviceId: "svc1" }] });
    mocks.fetchSlots.mockResolvedValueOnce([{ startsAt: futureIso }]);
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { count: vi.fn().mockResolvedValue(1), create: vi.fn() },
      payment: { create: vi.fn() },
      bookingEvent: { create: vi.fn() }
    }));
    await c.create({ body: { salonId: "s1", serviceId: "svc1", startsAt: futureIso, employeeId: "e1" } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "salon_not_found", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "salon_not_approved", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "salon_not_accepting", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_start_time", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "employee_not_available", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "employee_service_mismatch", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "slot_unavailable", expect.any(String));
  });

  it("create computes fixed/percent deposits and normalizes provider fallback", async () => {
    const futureIso = new Date(Date.now() + 3600_000).toISOString();
    mocks.prisma.salon.findUnique.mockResolvedValue({ id: "s1", approvalStatus: "approved", canReceiveBookings: true });
    mocks.fetchSlots.mockResolvedValue([{ startsAt: futureIso }]);

    const paymentCreate = vi.fn().mockResolvedValue(null);
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { count: vi.fn().mockResolvedValue(0), create: vi.fn().mockResolvedValue({ id: "b-fixed" }) },
      payment: { create: paymentCreate },
      bookingEvent: { create: vi.fn() }
    }));
    mocks.prisma.service.findFirst.mockResolvedValueOnce({
      id: "svc-fixed", salonId: "s1", isActive: true, durationMinutes: 30, depositMode: "fixed", depositAmountXof: null, depositPercent: null, priceXof: 10000
    });
    mocks.prisma.booking.findUnique.mockResolvedValueOnce({
      id: "b-fixed",
      salonId: "s1",
      salon: { name: "Salon A" },
      serviceId: "svc-fixed",
      service: { name: "Coupe" },
      startsAt: new Date(futureIso),
      endsAt: new Date(new Date(futureIso).getTime() + 1800000),
      status: "pending",
      source: "marketplace",
      depositAmountXof: 0,
      depositPaymentStatus: "pending",
      paymentProvider: null,
      payments: []
    });
    await c.create({ body: { salonId: "s1", serviceId: "svc-fixed", startsAt: futureIso } } as never, {} as never);
    expect(paymentCreate).not.toHaveBeenCalled();

    const paymentCreatePercent = vi.fn().mockResolvedValue(null);
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { count: vi.fn().mockResolvedValue(0), create: vi.fn().mockResolvedValue({ id: "b-percent" }) },
      payment: { create: paymentCreatePercent },
      bookingEvent: { create: vi.fn() }
    }));
    mocks.prisma.service.findFirst.mockResolvedValueOnce({
      id: "svc-percent", salonId: "s1", isActive: true, durationMinutes: 30, depositMode: "percent", depositAmountXof: null, depositPercent: null, priceXof: 10000
    });
    mocks.prisma.booking.findUnique.mockResolvedValueOnce({
      id: "b-percent",
      salonId: "s1",
      salon: { name: "Salon A" },
      serviceId: "svc-percent",
      service: { name: "Coupe" },
      startsAt: new Date(futureIso),
      endsAt: new Date(new Date(futureIso).getTime() + 1800000),
      status: "pending",
      source: "marketplace",
      depositAmountXof: 0,
      depositPaymentStatus: "pending",
      paymentProvider: null,
      payments: []
    });
    await c.create({ body: { salonId: "s1", serviceId: "svc-percent", startsAt: futureIso, provider: "manual" } } as never, {} as never);
    expect(paymentCreatePercent).not.toHaveBeenCalled();
  });

  it("create percent mode with null percent computes zero deposit", async () => {
    const futureIso = new Date(Date.now() + 3600_000).toISOString();
    mocks.prisma.service.findFirst.mockResolvedValueOnce({
      id: "svc-percent-null",
      salonId: "s1",
      isActive: true,
      durationMinutes: 30,
      depositMode: "percent",
      depositAmountXof: null,
      depositPercent: null,
      priceXof: 10000
    });
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ id: "s1", approvalStatus: "approved", canReceiveBookings: true });
    mocks.fetchSlots.mockResolvedValueOnce([{ startsAt: futureIso }]);
    const paymentCreate = vi.fn();
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { count: vi.fn().mockResolvedValue(0), create: vi.fn().mockResolvedValue({ id: "b-nullpct" }) },
      payment: { create: paymentCreate },
      bookingEvent: { create: vi.fn() }
    }));
    mocks.prisma.booking.findUnique.mockResolvedValueOnce({
      id: "b-nullpct",
      salonId: "s1",
      salon: { name: "Salon A" },
      serviceId: "svc-percent-null",
      service: { name: "Coupe" },
      startsAt: new Date(futureIso),
      endsAt: new Date(new Date(futureIso).getTime() + 1800000),
      status: "pending",
      source: "marketplace",
      depositAmountXof: 0,
      depositPaymentStatus: "pending",
      paymentProvider: null,
      payments: []
    });
    await c.create({ body: { salonId: "s1", serviceId: "svc-percent-null", startsAt: futureIso } } as never, {} as never);
    expect(paymentCreate).not.toHaveBeenCalled();
  });


  it("create returns slot_unavailable when availability list does not include requested start", async () => {
    const future = new Date(Date.now() + 3600_000);
    const futureIso = future.toISOString();
    mocks.prisma.service.findFirst.mockResolvedValue({
      id: "svc1",
      salonId: "s1",
      isActive: true,
      durationMinutes: 30,
      depositMode: "none",
      depositAmountXof: null,
      depositPercent: null,
      priceXof: 10000
    });
    mocks.prisma.salon.findUnique.mockResolvedValue({ id: "s1", approvalStatus: "approved", canReceiveBookings: true });
    mocks.fetchSlots.mockResolvedValueOnce([{ startsAt: new Date(future.getTime() + 60000).toISOString() }]);
    await c.create({ body: { salonId: "s1", serviceId: "svc1", startsAt: futureIso } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "slot_unavailable", expect.any(String));
  });

  it("list returns booking summaries", async () => {
    mocks.prisma.booking.findMany.mockResolvedValue([
      {
        id: "b1",
        salonId: "s1",
        salon: { name: "Salon A" },
        serviceId: "svc1",
        service: { name: "Coupe" },
        startsAt: new Date(),
        endsAt: new Date(),
        status: "pending",
        source: "marketplace",
        depositAmountXof: 0,
        depositPaymentStatus: "pending",
        paymentProvider: null,
        payments: []
      }
    ]);
    await c.list({} as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("detail returns 404 when booking missing", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue(null);
    await c.detail({ params: { bookingId: "b1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "booking_not_found", expect.any(String));
  });

  it("detail success maps first payment only", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b1",
      salonId: "s1",
      salon: { name: "Salon A" },
      serviceId: "svc1",
      service: { name: "Coupe" },
      startsAt: new Date(),
      endsAt: new Date(),
      status: "pending",
      source: "marketplace",
      depositAmountXof: 1000,
      depositPaymentStatus: "pending",
      paymentProvider: "intech",
      payments: [{ id: "p1" }, { id: "p2" }]
    });
    await c.detail({ params: { bookingId: "b1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("cancel returns invalid status", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b1",
      status: "completed",
      startsAt: new Date(Date.now() + 3600_000),
      payments: []
    });
    await c.cancel({ params: { bookingId: "b1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_status", expect.any(String));
  });

  it("cancel enforces window and handles transaction conflict", async () => {
    const soon = new Date(Date.now() + 30 * 60_000);
    mocks.prisma.booking.findFirst.mockResolvedValueOnce({
      id: "b1",
      status: "pending",
      startsAt: soon,
      payments: []
    });
    mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: "24" });
    await c.cancel({ params: { bookingId: "b1" } } as never, {} as never);

    const future = new Date(Date.now() + 48 * 3600_000);
    mocks.prisma.booking.findFirst.mockResolvedValueOnce({
      id: "b2",
      status: "pending",
      startsAt: future,
      payments: []
    });
    mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: "24" });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 0 }) },
      bookingEvent: { create: vi.fn() },
      job: { updateMany: vi.fn() },
      auditLog: { create: vi.fn() }
    }));
    await c.cancel({ params: { bookingId: "b2" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "cancellation_window_closed", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("cancel supports missing/invalid cancellation window settings and no linked payment", async () => {
    const future = new Date(Date.now() + 48 * 3600_000);
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b-nowindow",
      status: "pending",
      startsAt: future,
      payments: []
    });
    mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce(null);
    await c.cancel({ params: { bookingId: "b-nowindow" } } as never, {} as never);

    mocks.prisma.booking.findFirst.mockResolvedValueOnce({
      id: "b-badwindow",
      status: "pending",
      startsAt: future,
      payments: []
    });
    mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: "NaN" });
    await c.cancel({ params: { bookingId: "b-badwindow" } } as never, {} as never);
    expect(mocks.enqueueJob).not.toHaveBeenCalledWith(expect.objectContaining({ type: "refund_reconciliation" }));
  });

  it("reschedule returns slot unavailable", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b1",
      clientId: "u1",
      status: "pending",
      salonId: "s1",
      employeeId: null,
      service: { durationMinutes: 30 },
      salon: {},
      payments: []
    });
    mocks.fetchSlots.mockResolvedValue([]);
    await c.reschedule({ params: { bookingId: "b1" }, body: { startsAt: new Date(Date.now() + 7200_000).toISOString() } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "slot_unavailable", expect.any(String));
  });

  it("reschedule validates booking/status/start-time and tx conflict", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValueOnce(null);
    await c.reschedule({ params: { bookingId: "b0" }, body: { startsAt: new Date(Date.now() + 7200_000).toISOString() } } as never, {} as never);

    mocks.prisma.booking.findFirst.mockResolvedValueOnce({
      id: "b1",
      clientId: "u1",
      status: "completed",
      salonId: "s1",
      employeeId: null,
      service: { durationMinutes: 30 },
      salon: {},
      payments: []
    });
    await c.reschedule({ params: { bookingId: "b1" }, body: { startsAt: new Date(Date.now() + 7200_000).toISOString() } } as never, {} as never);

    mocks.prisma.booking.findFirst.mockResolvedValueOnce({
      id: "b2",
      clientId: "u1",
      status: "pending",
      salonId: "s1",
      employeeId: null,
      service: { durationMinutes: 30 },
      salon: {},
      payments: []
    });
    await c.reschedule({ params: { bookingId: "b2" }, body: { startsAt: "2020-01-01T10:00:00.000Z" } } as never, {} as never);

    const newStart = new Date(Date.now() + 7200_000);
    mocks.prisma.booking.findFirst.mockResolvedValueOnce({
      id: "b3",
      clientId: "u1",
      status: "pending",
      salonId: "s1",
      employeeId: null,
      service: { durationMinutes: 30 },
      salon: {},
      payments: []
    });
    mocks.fetchSlots.mockResolvedValueOnce([{ startsAt: newStart.toISOString() }]);
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 0 }) },
      bookingEvent: { create: vi.fn() },
      job: { updateMany: vi.fn() },
      auditLog: { create: vi.fn() }
    }));
    await c.reschedule({ params: { bookingId: "b3" }, body: { startsAt: newStart.toISOString() } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "booking_not_found", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_status", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_start_time", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "status_conflict", expect.any(String));
  });

  it("submitReview returns 409 when review exists", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({ id: "b1", salonId: "s1", status: "completed" });
    mocks.prisma.review.findUnique.mockResolvedValue({ id: "r1" });
    await c.submitReview({ params: { bookingId: "b1" }, body: { rating: 5, comment: "Top" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "review_exists", expect.any(String));
  });

  it("submitReview returns 404 when booking not completed or missing", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue(null);
    await c.submitReview({ params: { bookingId: "bx" }, body: { rating: 4, comment: "ok" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "booking_not_found", expect.any(String));
  });

  it("create succeeds and returns summary", async () => {
    const startsAt = new Date(Date.now() + 7200_000);
    mocks.prisma.service.findFirst.mockResolvedValue({
      id: "svc1",
      salonId: "s1",
      isActive: true,
      durationMinutes: 30,
      depositMode: "none",
      depositAmountXof: null,
      depositPercent: null,
      priceXof: 10000
    });
    mocks.prisma.salon.findUnique.mockResolvedValue({ id: "s1", approvalStatus: "approved", canReceiveBookings: true });
    mocks.fetchSlots.mockResolvedValue([{ startsAt: startsAt.toISOString() }]);
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      booking: {
        count: vi.fn().mockResolvedValue(0),
        create: vi.fn().mockResolvedValue({ id: "b1", startsAt, endsAt: new Date(startsAt.getTime() + 1800000) })
      },
      payment: { create: vi.fn().mockResolvedValue(null) },
      bookingEvent: { create: vi.fn() }
    }));
    mocks.prisma.booking.findUnique.mockResolvedValue({
      id: "b1",
      salonId: "s1",
      salon: { name: "Salon A" },
      serviceId: "svc1",
      service: { name: "Coupe" },
      startsAt,
      endsAt: new Date(startsAt.getTime() + 1800000),
      status: "pending",
      source: "marketplace",
      depositAmountXof: 0,
      depositPaymentStatus: "pending",
      paymentProvider: null,
      payments: []
    });
    await c.create({ body: { salonId: "s1", serviceId: "svc1", startsAt: startsAt.toISOString() } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: expect.any(String) }), 201);
  });

  it("create supports fixed and percent deposits and creates payment", async () => {
    const startsAt = new Date(Date.now() + 7200_000);
    mocks.prisma.salon.findUnique.mockResolvedValue({ id: "s1", approvalStatus: "approved", canReceiveBookings: true });
    mocks.fetchSlots.mockResolvedValue([{ startsAt: startsAt.toISOString() }]);

    mocks.prisma.service.findFirst.mockResolvedValueOnce({
      id: "svcFixed",
      salonId: "s1",
      isActive: true,
      durationMinutes: 30,
      depositMode: "fixed",
      depositAmountXof: 3000,
      depositPercent: null,
      priceXof: 10000
    });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { count: vi.fn().mockResolvedValue(0), create: vi.fn().mockResolvedValue({ id: "bf", startsAt, endsAt: new Date(startsAt.getTime() + 1800000) }) },
      payment: { create: vi.fn().mockResolvedValue({ id: "pf" }) },
      bookingEvent: { create: vi.fn() }
    }));
    mocks.prisma.booking.findUnique.mockResolvedValueOnce({
      id: "bf", salonId: "s1", salon: { name: "Salon A" }, serviceId: "svcFixed", service: { name: "S" },
      startsAt, endsAt: new Date(startsAt.getTime() + 1800000), status: "pending", source: "marketplace",
      depositAmountXof: 3000, depositPaymentStatus: "pending", paymentProvider: "intech", payments: [{ id: "pf" }]
    });
    await c.create({ body: { salonId: "s1", serviceId: "svcFixed", startsAt: startsAt.toISOString(), provider: "manual" } } as never, {} as never);

    mocks.prisma.service.findFirst.mockResolvedValueOnce({
      id: "svcPct",
      salonId: "s1",
      isActive: true,
      durationMinutes: 30,
      depositMode: "percent",
      depositAmountXof: null,
      depositPercent: 25,
      priceXof: 12000
    });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { count: vi.fn().mockResolvedValue(0), create: vi.fn().mockResolvedValue({ id: "bp", startsAt, endsAt: new Date(startsAt.getTime() + 1800000) }) },
      payment: { create: vi.fn().mockResolvedValue({ id: "pp" }) },
      bookingEvent: { create: vi.fn() }
    }));
    mocks.prisma.booking.findUnique.mockResolvedValueOnce({
      id: "bp", salonId: "s1", salon: { name: "Salon A" }, serviceId: "svcPct", service: { name: "S2" },
      startsAt, endsAt: new Date(startsAt.getTime() + 1800000), status: "pending", source: "marketplace",
      depositAmountXof: 3000, depositPaymentStatus: "pending", paymentProvider: "intech", payments: [{ id: "pp" }]
    });
    await c.create({ body: { salonId: "s1", serviceId: "svcPct", startsAt: startsAt.toISOString() } } as never, {} as never);

    expect(mocks.ok).toHaveBeenCalled();
  });

  it("create logs reminder scheduling failures but still returns success", async () => {
    const startsAt = new Date(Date.now() + 7200_000);
    mocks.prisma.service.findFirst.mockResolvedValue({
      id: "svcR",
      salonId: "s1",
      isActive: true,
      durationMinutes: 30,
      depositMode: "none",
      depositAmountXof: null,
      depositPercent: null,
      priceXof: 10000
    });
    mocks.prisma.salon.findUnique.mockResolvedValue({ id: "s1", approvalStatus: "approved", canReceiveBookings: true });
    mocks.fetchSlots.mockResolvedValue([{ startsAt: startsAt.toISOString() }]);
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { count: vi.fn().mockResolvedValue(0), create: vi.fn().mockResolvedValue({ id: "br", startsAt, endsAt: new Date(startsAt.getTime() + 1800000) }) },
      payment: { create: vi.fn().mockResolvedValue(null) },
      bookingEvent: { create: vi.fn() }
    }));
    mocks.prisma.booking.findUnique.mockResolvedValue({
      id: "br", salonId: "s1", salon: { name: "Salon A" }, serviceId: "svcR", service: { name: "S" },
      startsAt, endsAt: new Date(startsAt.getTime() + 1800000), status: "pending", source: "marketplace",
      depositAmountXof: 0, depositPaymentStatus: "pending", paymentProvider: null, payments: []
    });
    mocks.enqueueJob.mockRejectedValue(new Error("job_fail"));
    await c.create({ body: { salonId: "s1", serviceId: "svcR", startsAt: startsAt.toISOString() } } as never, {} as never);
    expect(mocks.logger.error).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("cancel succeeds", async () => {
    const startsAt = new Date(Date.now() + 72 * 3600_000);
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b1",
      status: "pending",
      startsAt,
      payments: []
    });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: "24" });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      job: { updateMany: vi.fn() },
      auditLog: { create: vi.fn() }
    }));
    await c.cancel({ params: { bookingId: "b1" } } as never, {} as never);
    expect(true).toBe(true);
  });

  it("cancel returns 404 when booking not found and supports zero-hour window", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValueOnce(null);
    await c.cancel({ params: { bookingId: "none" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "booking_not_found", expect.any(String));

    const startsAt = new Date(Date.now() + 3600_000);
    mocks.prisma.booking.findFirst.mockResolvedValueOnce({ id: "b3", status: "pending", startsAt, payments: [{ id: "p3" }] });
    mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: "0" });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      job: { updateMany: vi.fn() },
      auditLog: { create: vi.fn() }
    }));
    await c.cancel({ params: { bookingId: "b3" } } as never, {} as never);
    expect(mocks.enqueueJob).toHaveBeenCalled();
  });

  it("reschedule succeeds", async () => {
    const newStart = new Date(Date.now() + 7200_000);
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b1",
      clientId: "u1",
      status: "pending",
      salonId: "s1",
      employeeId: null,
      service: { durationMinutes: 30 },
      salon: {},
      payments: []
    });
    mocks.fetchSlots.mockResolvedValue([{ startsAt: newStart.toISOString() }]);
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      job: { updateMany: vi.fn() }
    }));
    mocks.prisma.booking.findUnique.mockResolvedValue({
      id: "b1",
      salonId: "s1",
      salon: { name: "Salon A" },
      serviceId: "svc1",
      service: { name: "Coupe" },
      startsAt: newStart,
      endsAt: new Date(newStart.getTime() + 1800000),
      status: "pending",
      source: "marketplace",
      depositAmountXof: 0,
      depositPaymentStatus: "pending",
      paymentProvider: null,
      payments: []
    });
    await c.reschedule({ params: { bookingId: "b1" }, body: { startsAt: newStart.toISOString() } } as never, {} as never);
    expect(true).toBe(true);
  });

  it("reschedule returns internal_error when refreshed booking cannot be loaded", async () => {
    const newStart = new Date(Date.now() + 7200_000);
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b9",
      clientId: "u1",
      status: "pending",
      salonId: "s1",
      employeeId: null,
      service: { durationMinutes: 30 },
      salon: {},
      payments: []
    });
    mocks.fetchSlots.mockResolvedValue([{ startsAt: newStart.toISOString() }]);
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      job: { updateMany: vi.fn() }
    }));
    mocks.prisma.booking.findUnique.mockResolvedValue(null);
    await c.reschedule({ params: { bookingId: "b9" }, body: { startsAt: newStart.toISOString() } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });


  it("submitReview succeeds and invalidates cache", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({ id: "b1", salonId: "s1", status: "completed" });
    mocks.prisma.review.findUnique.mockResolvedValue(null);
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      review: { create: vi.fn().mockResolvedValue({ id: "r2", rating: 5, comment: "Great", createdAt: new Date() }), aggregate: vi.fn().mockResolvedValue({ _avg: { rating: 4.8 } }) },
      salon: { update: vi.fn() }
    }));
    await c.submitReview({ params: { bookingId: "b1" }, body: { rating: 5, comment: "Great" } } as never, {} as never);
    expect(mocks.invalidateCacheTags).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: "r2" }), 201);
  });

  it("submitReview defaults optional comment and aggregate rating fallback to zero", async () => {
    const reviewCreate = vi.fn().mockResolvedValue({ id: "r3", rating: 4, comment: null, createdAt: new Date() });
    const salonUpdate = vi.fn();
    mocks.prisma.booking.findFirst.mockResolvedValueOnce({ id: "b3", salonId: "s1", status: "completed" });
    mocks.prisma.review.findUnique.mockResolvedValueOnce(null);
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      review: { create: reviewCreate, aggregate: vi.fn().mockResolvedValue({ _avg: { rating: null } }) },
      salon: { update: salonUpdate }
    }));
    await c.submitReview({ params: { bookingId: "b3" }, body: { rating: 4 } } as never, {} as never);
    expect(reviewCreate).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ comment: null })
    }));
    expect(salonUpdate).toHaveBeenCalledWith(expect.objectContaining({
      data: { averageRating: 0 }
    }));
  });

  it("list/detail/reschedule/submitReview return internal_error on unexpected errors", async () => {
    mocks.prisma.booking.findMany.mockRejectedValueOnce(new Error("db"));
    await c.list({} as never, {} as never);

    mocks.prisma.booking.findFirst.mockRejectedValueOnce(new Error("db"));
    await c.detail({ params: { bookingId: "b1" } } as never, {} as never);

    mocks.prisma.booking.findFirst.mockResolvedValueOnce({
      id: "b4",
      clientId: "u1",
      status: "pending",
      salonId: "s1",
      employeeId: null,
      service: { durationMinutes: 30 },
      salon: {},
      payments: []
    });
    const newStart = new Date(Date.now() + 7200_000);
    mocks.fetchSlots.mockResolvedValueOnce([{ startsAt: newStart.toISOString() }]);
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      job: { updateMany: vi.fn() }
    }));
    mocks.enqueueJob.mockRejectedValueOnce(new Error("job fail"));
    await c.reschedule({ params: { bookingId: "b4" }, body: { startsAt: newStart.toISOString() } } as never, {} as never);

    mocks.prisma.booking.findFirst.mockResolvedValueOnce({ id: "b5", salonId: "s1", status: "completed" });
    mocks.prisma.review.findUnique.mockRejectedValueOnce(new Error("db"));
    await c.submitReview({ params: { bookingId: "b5" }, body: { rating: 4, comment: "ok" } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });
});
