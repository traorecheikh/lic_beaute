import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const tx = {
    booking: { create: vi.fn(), update: vi.fn(), updateMany: vi.fn() },
    payment: { create: vi.fn() },
    bookingEvent: { create: vi.fn() },
    job: { updateMany: vi.fn(), create: vi.fn() },
    auditLog: { create: vi.fn() }
  };

  const prisma = {
    service: { findFirst: vi.fn() },
    salon: { findUnique: vi.fn() },
    employee: { findFirst: vi.fn(), findMany: vi.fn() },
    salonHours: { findUnique: vi.fn() },
    blockedSlot: { findMany: vi.fn() },
    booking: { findMany: vi.fn(), findFirst: vi.fn(), findUnique: vi.fn(), create: vi.fn(), update: vi.fn() },
    payment: { create: vi.fn() },
    bookingEvent: { create: vi.fn() },
    platformSetting: { findUnique: vi.fn() },
    job: { create: vi.fn(), updateMany: vi.fn() },
    $transaction: vi.fn(async (fn: (txArg: typeof tx) => Promise<any>) => fn(tx))
  };

  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const fetchAndComputeAvailableSlots = vi.fn();

  return { prisma, tx, requireRole, ok, fail, fetchAndComputeAvailableSlots };
});

vi.mock("../../adapters/index.js", () => ({
  getPaymentAdapter: () => ({})
}));

vi.mock("../../lib/db/prisma.js", () => ({
  prisma: mocks.prisma
}));

vi.mock("../../lib/auth/index.js", () => {
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

vi.mock("../../lib/http.js", () => ({
  ok: mocks.ok,
  fail: mocks.fail
}));

vi.mock("../../lib/availability.js", () => ({
  fetchAndComputeAvailableSlots: mocks.fetchAndComputeAvailableSlots
}));

import { BookingController } from "./index.js";

describe("BookingController invariants", () => {
  const controller = new BookingController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.prisma.service.findFirst.mockResolvedValue({
      id: "svc_1",
      salonId: "salon_1",
      isActive: true,
      durationMinutes: 30,
      priceXof: 10000,
      depositMode: "none",
      depositAmountXof: null,
      depositPercent: null
    });
    mocks.prisma.salon.findUnique.mockResolvedValue({ id: "salon_1", approvalStatus: "approved", canReceiveBookings: true });
    mocks.tx.booking.updateMany.mockResolvedValue({ count: 1 });
  });

  it("rejects marketplace booking in the past", async () => {
    await controller.create({
      body: {
        salonId: "salon_1",
        serviceId: "svc_1",
        startsAt: new Date(Date.now() - 60_000).toISOString()
      }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      422,
      "invalid_start_time",
      "La réservation doit être planifiée dans le futur."
    );
  });

  it("rejects employee that does not provide selected service", async () => {
    mocks.prisma.employee.findFirst.mockResolvedValue({
      id: "emp_1",
      specialties: [{ serviceId: "svc_other" }]
    });

    await controller.create({
      body: {
        salonId: "salon_1",
        serviceId: "svc_1",
        employeeId: "emp_1",
        startsAt: new Date(Date.now() + 2 * 60 * 60 * 1000).toISOString()
      }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      422,
      "employee_service_mismatch",
      "Cet employé ne propose pas ce service."
    );
  });

  it("keeps assigned employee constraint during reschedule availability check", async () => {
    const newStart = new Date(Date.now() + 36 * 60 * 60 * 1000);
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "book_1",
      clientId: "client_1",
      salonId: "salon_1",
      employeeId: "emp_1",
      status: "pending",
      startsAt: newStart,
      endsAt: new Date(newStart.getTime() + 30 * 60 * 1000),
      service: { durationMinutes: 30 },
      salon: { id: "salon_1" },
      payments: []
    });
    mocks.prisma.salonHours.findUnique.mockResolvedValue({
      salonId: "salon_1",
      dayOfWeek: newStart.getDay(),
      isOpen: true,
      opensAt: "08:00",
      closesAt: "20:00"
    });
    mocks.prisma.blockedSlot.findMany.mockResolvedValue([]);
    mocks.prisma.booking.findMany.mockResolvedValue([]);
    mocks.prisma.employee.findMany.mockResolvedValue([{ id: "emp_1", salonId: "salon_1" }]);
    mocks.fetchAndComputeAvailableSlots.mockReturnValue([{ startsAt: newStart.toISOString() }]);
    mocks.prisma.booking.findUnique.mockResolvedValue({
      id: "book_1",
      salonId: "salon_1",
      salon: { name: "Salon" },
      serviceId: "svc_1",
      service: { name: "Service" },
      startsAt: newStart,
      endsAt: new Date(newStart.getTime() + 30 * 60 * 1000),
      status: "pending",
      source: "marketplace",
      depositAmountXof: 0,
      depositPaymentStatus: "pending",
      paymentProvider: null,
      payments: []
    });

    await controller.reschedule({
      params: { bookingId: "book_1" },
      body: { startsAt: newStart.toISOString() }
    } as never, {} as never);

    expect(mocks.fetchAndComputeAvailableSlots).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({ employeeId: "emp_1" })
    );
  });

  it("writes audit log when client cancels booking", async () => {
    const futureDate = new Date();
    futureDate.setHours(futureDate.getHours() + 48);
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: "24" });
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "book_cancel_1",
      clientId: "client_1",
      status: "confirmed",
      startsAt: futureDate,
      payments: [{ id: "pay_1", status: "succeeded" }]
    });

    await controller.cancel({
      params: { bookingId: "book_cancel_1" }
    } as never, {} as never);

    expect(mocks.tx.booking.updateMany).toHaveBeenCalledWith(expect.objectContaining({
      where: expect.objectContaining({ id: "book_cancel_1" }),
      data: { status: "cancelled" }
    }));
    expect(mocks.tx.auditLog.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({
        action: "booking_cancelled_by_client",
        entityType: "Booking",
        entityId: "book_cancel_1",
        actorUserId: "client_1"
      })
    }));
  });

  it("rejects cancel when cancellation window has passed", async () => {
    const soonDate = new Date();
    soonDate.setHours(soonDate.getHours() + 1);
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: "24" });
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "book_cancel_2",
      clientId: "client_1",
      status: "confirmed",
      startsAt: soonDate,
      payments: []
    });

    await controller.cancel({
      params: { bookingId: "book_cancel_2" }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.any(Object), 422, "cancellation_window_closed", expect.any(String));
  });
});
