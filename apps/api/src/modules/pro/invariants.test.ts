import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const tx = {
    booking: { update: vi.fn(), updateMany: vi.fn() },
    bookingEvent: { create: vi.fn() },
    auditLog: { create: vi.fn() },
    payment: { findFirst: vi.fn() },
    job: { create: vi.fn(), findFirst: vi.fn() }
  };

  const prisma = {
    user: { findUnique: vi.fn() },
    employee: { findFirst: vi.fn(), findMany: vi.fn() },
    blockedSlot: { create: vi.fn(), findMany: vi.fn() },
    service: { findFirst: vi.fn(), count: vi.fn(), create: vi.fn(), update: vi.fn() },
    salonHours: { findUnique: vi.fn() },
    salon: { findUnique: vi.fn() },
    booking: { findMany: vi.fn(), findFirst: vi.fn() },
    $transaction: vi.fn(async (fn: (txArg: typeof tx) => Promise<unknown>) => fn(tx))
  };

  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  const loggerError = vi.fn();
  const fetchAndComputeAvailableSlots = vi.fn();

  return { prisma, tx, requireRole, ok, fail, loggerError, fetchAndComputeAvailableSlots };
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

vi.mock("../../lib/http.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/http.js")>();
  return { ...actual, ok: mocks.ok, fail: mocks.fail };
});

vi.mock("../../lib/logger.js", () => ({
  logger: { error: mocks.loggerError }
}));

vi.mock("../../lib/availability.js", () => ({
  fetchAndComputeAvailableSlots: mocks.fetchAndComputeAvailableSlots
}));

vi.mock("./pro-data.js", () => ({
  getProDashboard: vi.fn(),
  getProAnalytics: vi.fn()
}));

import { ProController } from "./index.js";

describe("ProController invariants", () => {
  const controller = new ProController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "owner_1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "salon_1" });
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
  });

  it("rejects blocked slot with invalid time range", async () => {
    await controller.createBlockedSlot({
      body: {
        startsAt: "2026-05-08T10:00:00.000Z",
        endsAt: "2026-05-08T09:00:00.000Z",
        scope: "salon"
      }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      422,
      "invalid_time_range",
      "L'heure de fin doit être après l'heure de début."
    );
  });

  it("rejects employee-scope blocked slot without employeeId", async () => {
    await controller.createBlockedSlot({
      body: {
        startsAt: "2026-05-08T10:00:00.000Z",
        endsAt: "2026-05-08T11:00:00.000Z",
        scope: "employee"
      }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      422,
      "employee_required",
      "Un employé est requis pour un blocage scope=employee."
    );
  });

  it("rejects manual booking in the past", async () => {
    await controller.createManualBooking({
      body: {
        serviceId: "svc_1",
        startsAt: new Date(Date.now() - 60_000).toISOString(),
        clientPhone: "+221700000000"
      }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      422,
      "invalid_start_time",
      "La réservation doit être planifiée dans le futur."
    );
  });

  it("rejects manual booking when employee does not provide service", async () => {
    mocks.prisma.employee.findFirst.mockResolvedValue({
      id: "emp_1",
      specialties: [{ serviceId: "svc_other" }]
    });

    await controller.createManualBooking({
      body: {
        serviceId: "svc_1",
        employeeId: "emp_1",
        startsAt: new Date(Date.now() + 2 * 60 * 60 * 1000).toISOString(),
        clientPhone: "+221700000000"
      }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      422,
      "employee_service_mismatch",
      "Cet employé ne propose pas ce service."
    );
  });

  it("rejects manual booking when slot is unavailable", async () => {
    const startsAt = new Date(Date.now() + 4 * 60 * 60 * 1000);
    mocks.prisma.salonHours.findUnique.mockResolvedValue({
      salonId: "salon_1",
      dayOfWeek: startsAt.getDay(),
      isOpen: true,
      opensAt: "08:00",
      closesAt: "20:00"
    });
    mocks.prisma.blockedSlot.findMany.mockResolvedValue([]);
    mocks.prisma.booking.findMany.mockResolvedValue([]);
    mocks.prisma.employee.findMany.mockResolvedValue([{ id: "emp_1", salonId: "salon_1" }]);
    mocks.fetchAndComputeAvailableSlots.mockReturnValue([]);

    await controller.createManualBooking({
      body: {
        serviceId: "svc_1",
        startsAt: startsAt.toISOString(),
        clientPhone: "+221700000000"
      }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      422,
      "slot_unavailable",
      "Ce créneau n'est plus disponible."
    );
  });

  it("writes audit log when pro rejects booking", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "book_1",
      salonId: "salon_1",
      status: "confirmed"
    });
    mocks.tx.booking.updateMany.mockResolvedValue({ count: 1 });
    mocks.tx.payment.findFirst.mockResolvedValue({
      id: "pay_1"
    });

    await controller.rejectBooking({
      params: { bookingId: "book_1" }
    } as never, {} as never);

    expect(mocks.tx.auditLog.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({
        action: "booking_rejected",
        entityType: "Booking",
        entityId: "book_1",
        actorUserId: "owner_1"
      })
    }));
  });

  // ─── Deposit premium gate ────────────────────────────────────────────────

  it("rejects deposit creation when salon is standard tier", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue({ subscriptionTier: "standard" });

    await controller.createService({
      body: { name: "Test", category: "Hair", durationMinutes: 30, priceXof: 5000, depositMode: "fixed", depositAmountXof: 2000 }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      402,
      "premium_required",
      "Les dépôts en ligne sont réservés aux salons Premium."
    );
  });

  it("rejects deposit update when salon is standard tier", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue({ subscriptionTier: "standard" });

    await controller.updateService({
      params: { serviceId: "svc_1" },
      body: { depositMode: "fixed", depositAmountXof: 2000 }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      402,
      "premium_required",
      "Les dépôts en ligne sont réservés aux salons Premium."
    );
  });

  it("allows deposit creation when salon is premium tier", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue({ subscriptionTier: "premium" });
    mocks.prisma.service.count.mockResolvedValue(5);
    mocks.prisma.service.create.mockResolvedValue({
      id: "svc_new", name: "Test", category: "Hair", durationMinutes: 30,
      priceXof: 5000, depositMode: "fixed", depositAmountXof: 2000,
      depositPercent: null, isActive: true, displayOrder: 5
    });

    await controller.createService({
      body: { name: "Test", category: "Hair", durationMinutes: 30, priceXof: 5000, depositMode: "fixed", depositAmountXof: 2000 }
    } as never, {} as never);

    expect(mocks.fail).not.toHaveBeenCalled();
  });

  it("allows update without changing deposit mode regardless of tier", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue({ subscriptionTier: "standard" });
    mocks.prisma.service.update.mockResolvedValue({
      id: "svc_1", name: "Service", category: "Hair", durationMinutes: 30,
      priceXof: 12000, depositMode: "none", depositAmountXof: null,
      depositPercent: null, isActive: true, displayOrder: 0
    });

    await controller.updateService({
      params: { serviceId: "svc_1" },
      body: { priceXof: 12000 }
    } as never, {} as never);

    expect(mocks.fail).not.toHaveBeenCalled();
  });
});
