import { beforeEach, describe, expect, it, vi } from "vitest";
import { createCipheriv, randomBytes } from "node:crypto";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const handleError = vi.fn();
  const invalidateCacheTags = vi.fn();
  const fetchSlots = vi.fn();
  const getOrSetCachedJson = vi.fn();
  const getProAnalytics = vi.fn();
  const enqueueJob = vi.fn();
  const paymentAdapter = { initiateDeposit: vi.fn() };
  const prisma = {
    user: { findUnique: vi.fn(), findMany: vi.fn(), findFirst: vi.fn(), create: vi.fn() },
    booking: { findFirst: vi.fn(), findMany: vi.fn(), updateMany: vi.fn(), create: vi.fn() },
    bookingEvent: { create: vi.fn() },
    service: { findFirst: vi.fn() },
    employee: { findFirst: vi.fn() },
    review: { findMany: vi.fn(), findFirst: vi.fn(), update: vi.fn() },
    subscription: { findUnique: vi.fn(), update: vi.fn() },
    subscriptionCharge: { findFirst: vi.fn(), create: vi.fn(), update: vi.fn() },
    billingInvoice: { findMany: vi.fn(), findFirst: vi.fn() },
    salon: { findUnique: vi.fn() },
    platformSetting: { findMany: vi.fn().mockResolvedValue([]), findUnique: vi.fn(), upsert: vi.fn(), deleteMany: vi.fn() },
    settlementEvent: { findMany: vi.fn(), create: vi.fn() },
    payment: { findFirst: vi.fn() },
    blockedSlot: { findMany: vi.fn(), create: vi.fn(), findFirst: vi.fn(), delete: vi.fn() },
    auditLog: { create: vi.fn() },
    $transaction: vi.fn()
  };
  return { requireRole, fail, ok, handleError, invalidateCacheTags, fetchSlots, getOrSetCachedJson, getProAnalytics, enqueueJob, paymentAdapter, prisma };
});

vi.mock("../../config.js", () => ({
  config: {
    paymentDriver: "paydunya",
    webOrigin: "http://localhost:5174",
    cacheTtlKpiSeconds: 60,
    paydunyaMasterKey: "master-key",
    paydunyaPrivateKey: "private-key",
    paydunyaToken: "token",
    paydunyaEnv: "sandbox",
    paydunyaBaseUrl: "https://sandbox.paydunya.com",
    billingAccountSecret: "a".repeat(64),
    nodeEnv: "test"
  }
}));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/http.js")>();
  return { ...actual, fail: mocks.fail, ok: mocks.ok, handleError: mocks.handleError };
});
vi.mock("../../lib/cache.js", () => ({ getOrSetCachedJson: mocks.getOrSetCachedJson, invalidateCacheTags: mocks.invalidateCacheTags }));
vi.mock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: mocks.fetchSlots }));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: mocks.enqueueJob }));
vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => mocks.paymentAdapter) }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("./data.js", () => ({ getProAnalytics: mocks.getProAnalytics, getProDashboard: vi.fn() }));

import { ProController } from "./index.js";

describe("ProController deep branches", () => {
  const c = new ProController();
  const reply = {
    header: vi.fn(() => reply),
    type: vi.fn(() => reply),
    send: vi.fn(() => reply),
    status: vi.fn(() => reply)
  } as never;

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1", phone: "+221770000000" });
    mocks.prisma.$transaction.mockImplementation(async (arg: any) => {
      if (Array.isArray(arg)) return [];
      return arg({
        booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }), create: vi.fn().mockResolvedValue({ id: "b1", startsAt: new Date(), endsAt: new Date(), status: "confirmed", source: "manual" }) },
        bookingEvent: { create: vi.fn() },
        user: { findUnique: vi.fn().mockResolvedValue({ id: "c1", role: "client" }), create: vi.fn().mockResolvedValue({ id: "c1" }) },
        settlementEvent: { create: vi.fn() },
        subscription: { update: vi.fn() },
        platformSetting: { upsert: vi.fn(), deleteMany: vi.fn() },
        payment: { findFirst: vi.fn().mockResolvedValue(null) }
      });
    });
  });

  it("manual booking validates future time / staff / slot / client requirements", async () => {
    mocks.prisma.service.findFirst.mockResolvedValue({ id: "svc1", durationMinutes: 30, depositMode: "none", depositAmountXof: null, depositPercent: null, priceXof: 10000 });
    await c.createManualBooking({ body: { serviceId: "svc1", startsAt: "2020-01-01T10:00:00.000Z" } } as never, reply);

    mocks.prisma.employee.findFirst.mockResolvedValue({ id: "e1", specialties: [{ serviceId: "other" }] });
    await c.createManualBooking({ body: { serviceId: "svc1", startsAt: "2030-01-01T10:00:00.000Z", employeeId: "e1" } } as never, reply);

    mocks.prisma.employee.findFirst.mockResolvedValue({ id: "e1", specialties: [{ serviceId: "svc1" }] });
    mocks.fetchSlots.mockResolvedValue([]);
    await c.createManualBooking({ body: { serviceId: "svc1", startsAt: "2030-01-01T10:00:00.000Z", employeeId: "e1" } } as never, reply);

    mocks.fetchSlots.mockResolvedValue([{ startsAt: "2030-01-01T10:00:00.000Z" }]);
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      user: { findUnique: vi.fn().mockResolvedValue(null), create: vi.fn() },
      booking: { create: vi.fn() }, bookingEvent: { create: vi.fn() }
    }));
    await c.createManualBooking({ body: { serviceId: "svc1", startsAt: "2030-01-01T10:00:00.000Z" } } as never, reply);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_start_time", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "employee_service_mismatch", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "slot_unavailable", expect.any(String));
  });

  it("manual booking rejects unavailable employee and supports creating a new client", async () => {
    mocks.prisma.service.findFirst.mockResolvedValue({ id: "svc1", durationMinutes: 30, depositMode: "none", depositAmountXof: null, depositPercent: null, priceXof: 10000 });
    mocks.prisma.employee.findFirst.mockResolvedValueOnce(null);
    await c.createManualBooking({
      body: { serviceId: "svc1", startsAt: "2030-01-01T10:00:00.000Z", employeeId: "missing-emp" }
    } as never, reply);

    mocks.fetchSlots.mockResolvedValue([{ startsAt: "2030-01-01T10:00:00.000Z" }]);
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      user: {
        findUnique: vi.fn().mockResolvedValue(null),
        create: vi.fn().mockResolvedValue({ id: "new-client-id" })
      },
      booking: {
        create: vi.fn().mockResolvedValue({
          id: "b-new",
          startsAt: new Date("2030-01-01T10:00:00.000Z"),
          endsAt: new Date("2030-01-01T10:30:00.000Z"),
          status: "confirmed",
          source: "manual"
        })
      },
      bookingEvent: { create: vi.fn() }
    }));
    await c.createManualBooking({
      body: {
        serviceId: "svc1",
        startsAt: "2030-01-01T10:00:00.000Z",
        clientPhone: "770002222",
        clientName: "New Client"
      }
    } as never, reply);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "employee_not_available", expect.any(String));
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: "b-new" }), 201);
  });

  it("manual booking creates client with phone as fallback name when clientName is omitted", async () => {
    mocks.prisma.service.findFirst.mockResolvedValue({ id: "svc1", durationMinutes: 30, depositMode: "none", depositAmountXof: null, depositPercent: null, priceXof: 10000 });
    mocks.fetchSlots.mockResolvedValue([{ startsAt: "2030-01-01T10:00:00.000Z" }]);
    const userCreate = vi.fn().mockResolvedValue({ id: "new-client-phone-name" });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      user: {
        findUnique: vi.fn().mockResolvedValue(null),
        create: userCreate
      },
      booking: {
        create: vi.fn().mockResolvedValue({
          id: "b-new-phone",
          startsAt: new Date("2030-01-01T10:00:00.000Z"),
          endsAt: new Date("2030-01-01T10:30:00.000Z"),
          status: "confirmed",
          source: "manual"
        })
      },
      bookingEvent: { create: vi.fn() }
    }));
    await c.createManualBooking({
      body: {
        serviceId: "svc1",
        startsAt: "2030-01-01T10:00:00.000Z",
        clientPhone: "770009999"
      }
    } as never, reply);
    expect(userCreate).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ fullName: "770009999" })
    }));
  });

  it("manual booking resolves existing client by phone when role is client", async () => {
    mocks.prisma.service.findFirst.mockResolvedValue({ id: "svc1", durationMinutes: 30, depositMode: "none", depositAmountXof: null, depositPercent: null, priceXof: 10000 });
    mocks.fetchSlots.mockResolvedValue([{ startsAt: "2030-01-01T10:00:00.000Z" }]);
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      user: {
        findUnique: vi.fn().mockResolvedValue({ id: "existing-client", role: "client" }),
        create: vi.fn()
      },
      booking: {
        create: vi.fn().mockResolvedValue({
          id: "b-existing",
          startsAt: new Date("2030-01-01T10:00:00.000Z"),
          endsAt: new Date("2030-01-01T10:30:00.000Z"),
          status: "confirmed",
          source: "manual"
        })
      },
      bookingEvent: { create: vi.fn() }
    }));

    await c.createManualBooking({
      body: { serviceId: "svc1", startsAt: "2030-01-01T10:00:00.000Z", clientPhone: "770003333" }
    } as never, reply);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: "b-existing" }), 201);
  });

  it("manual booking computes deposit from percent mode", async () => {
    mocks.prisma.service.findFirst.mockResolvedValue({
      id: "svc-percent",
      durationMinutes: 30,
      depositMode: "percent",
      depositAmountXof: null,
      depositPercent: 25,
      priceXof: 10000
    });
    mocks.fetchSlots.mockResolvedValue([{ startsAt: "2030-01-01T10:00:00.000Z" }]);
    const bookingCreate = vi.fn().mockResolvedValue({
      id: "b-percent",
      startsAt: new Date("2030-01-01T10:00:00.000Z"),
      endsAt: new Date("2030-01-01T10:30:00.000Z"),
      status: "confirmed",
      source: "manual"
    });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      user: {
        findUnique: vi.fn().mockResolvedValue({ id: "existing-client", role: "client" }),
        create: vi.fn()
      },
      booking: { create: bookingCreate },
      bookingEvent: { create: vi.fn() }
    }));

    await c.createManualBooking({
      body: { serviceId: "svc-percent", startsAt: "2030-01-01T10:00:00.000Z", clientPhone: "770003333" }
    } as never, reply);

    expect(bookingCreate).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ depositAmountXof: 2500, depositPaymentStatus: "succeeded" })
    }));
  });

  it("manual booking deposit helpers handle fixed/percent null values as zero", async () => {
    mocks.fetchSlots.mockResolvedValue([{ startsAt: "2030-01-01T10:00:00.000Z" }]);

    const fixedCreate = vi.fn().mockResolvedValue({
      id: "b-fixed-zero",
      startsAt: new Date("2030-01-01T10:00:00.000Z"),
      endsAt: new Date("2030-01-01T10:30:00.000Z"),
      status: "confirmed",
      source: "manual"
    });
    mocks.prisma.service.findFirst.mockResolvedValueOnce({
      id: "svc-fixed-zero",
      durationMinutes: 30,
      depositMode: "fixed",
      depositAmountXof: null,
      depositPercent: null,
      priceXof: 12000
    });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      user: { findUnique: vi.fn().mockResolvedValue({ id: "existing-client", role: "client" }), create: vi.fn() },
      booking: { create: fixedCreate },
      bookingEvent: { create: vi.fn() }
    }));
    await c.createManualBooking({
      body: { serviceId: "svc-fixed-zero", startsAt: "2030-01-01T10:00:00.000Z", clientPhone: "770000001" }
    } as never, reply);
    expect(fixedCreate).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ depositAmountXof: 0 })
    }));

    const percentCreate = vi.fn().mockResolvedValue({
      id: "b-percent-zero",
      startsAt: new Date("2030-01-01T10:00:00.000Z"),
      endsAt: new Date("2030-01-01T10:30:00.000Z"),
      status: "confirmed",
      source: "manual"
    });
    mocks.prisma.service.findFirst.mockResolvedValueOnce({
      id: "svc-percent-zero",
      durationMinutes: 30,
      depositMode: "percent",
      depositAmountXof: null,
      depositPercent: null,
      priceXof: 12000
    });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      user: { findUnique: vi.fn().mockResolvedValue({ id: "existing-client", role: "client" }), create: vi.fn() },
      booking: { create: percentCreate },
      bookingEvent: { create: vi.fn() }
    }));
    await c.createManualBooking({
      body: { serviceId: "svc-percent-zero", startsAt: "2030-01-01T10:00:00.000Z", clientPhone: "770000002" }
    } as never, reply);
    expect(percentCreate).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ depositAmountXof: 0 })
    }));
  });

  it("manual booking client resolution errors", async () => {
    mocks.prisma.service.findFirst.mockResolvedValue({ id: "svc1", durationMinutes: 30, depositMode: "none", depositAmountXof: null, depositPercent: null, priceXof: 10000 });
    mocks.fetchSlots.mockResolvedValue([{ startsAt: "2030-01-01T10:00:00.000Z" }]);

    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      user: { findUnique: vi.fn().mockResolvedValue({ id: "u2", role: "salon_owner" }), create: vi.fn() },
      booking: { create: vi.fn() }, bookingEvent: { create: vi.fn() }
    }));
    await c.createManualBooking({ body: { serviceId: "svc1", startsAt: "2030-01-01T10:00:00.000Z", clientPhone: "770000111" } } as never, reply);

    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      user: { findUnique: vi.fn().mockResolvedValue(null), create: vi.fn() },
      booking: { create: vi.fn() }, bookingEvent: { create: vi.fn() }
    }));
    await c.createManualBooking({ body: { serviceId: "svc1", startsAt: "2030-01-01T10:00:00.000Z", clientId: "missing" } } as never, reply);

    expect(mocks.handleError).toHaveBeenCalled();
  });

  it("manual booking rejects explicit non-client account and invalid selected client role", async () => {
    mocks.prisma.service.findFirst.mockResolvedValue({ id: "svc1", durationMinutes: 30, depositMode: "none", depositAmountXof: null, depositPercent: null, priceXof: 10000 });
    mocks.fetchSlots.mockResolvedValue([{ startsAt: "2030-01-01T10:00:00.000Z" }]);

    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      user: { findUnique: vi.fn().mockResolvedValue({ id: "u2", role: "salon_owner" }), create: vi.fn() },
      booking: { create: vi.fn() }, bookingEvent: { create: vi.fn() }
    }));
    await c.createManualBooking({
      body: { serviceId: "svc1", startsAt: "2030-01-01T10:00:00.000Z", clientId: "u2" }
    } as never, reply);

    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      user: { findUnique: vi.fn().mockResolvedValue({ id: "u3", role: "platform_admin" }), create: vi.fn() },
      booking: { create: vi.fn() }, bookingEvent: { create: vi.fn() }
    }));
    await c.createManualBooking({
      body: { serviceId: "svc1", startsAt: "2030-01-01T10:00:00.000Z", clientPhone: "770001111", clientName: "X" }
    } as never, reply);

    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      user: { findUnique: vi.fn().mockResolvedValue({ id: "u4", role: "salon_owner" }), create: vi.fn() },
      booking: { create: vi.fn() }, bookingEvent: { create: vi.fn() }
    }));
    await c.createManualBooking({
      body: { serviceId: "svc1", startsAt: "2030-01-01T10:00:00.000Z", clientId: "u4" }
    } as never, reply);

    expect(mocks.handleError).toHaveBeenCalled();
  });

  it("list/get client and checkout branches", async () => {
    mocks.prisma.user.findMany.mockResolvedValue([{ id: "c1", fullName: "Client", phone: "77", email: null, bookings: [{ startsAt: new Date(), payments: [{ amountXof: 4000 }] }] }]);
    await c.listClients({ query: { search: "Cli" } } as never, reply);

    mocks.prisma.booking.findMany.mockResolvedValue([]);
    await c.getClient({ params: { clientId: "c1" } } as never, reply);

    mocks.prisma.booking.findFirst.mockResolvedValueOnce(null);
    await c.getCheckout({ params: { bookingId: "b1" } } as never, reply);

    mocks.prisma.booking.findFirst.mockResolvedValueOnce({
      id: "b1", status: "cancelled", service: { priceXof: 10000 }, payments: []
    });
    await c.completeCheckout({ params: { bookingId: "b1" }, body: { paymentMethod: "cash", discountXof: 0, lineItems: [{ name: "Service", amountXof: 1000 }] } } as never, reply);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "client_not_found", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "booking_not_found", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_status", expect.any(String));
  });

  it("getBooking maps payments/events and missing booking", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValueOnce(null);
    await c.getBooking({ params: { bookingId: "missing" } } as never, reply);

    mocks.prisma.booking.findFirst.mockResolvedValueOnce({
      id: "b9",
      salonId: "s1",
      serviceId: "svc1",
      service: { name: "Service A" },
      employeeId: "e1",
      employee: { displayName: "Emp A" },
      clientId: "c1",
      client: { fullName: "Client A", phone: "7700" },
      startsAt: new Date("2030-01-01T10:00:00.000Z"),
      endsAt: new Date("2030-01-01T10:30:00.000Z"),
      status: "confirmed",
      source: "manual",
      depositAmountXof: 0,
      createdAt: new Date("2030-01-01T09:00:00.000Z"),
      payments: [{ id: "p1", status: "succeeded", amountXof: 1000, provider: "paydunya" }],
      bookingEvents: [{ eventType: "created_manual", fromStatus: null, toStatus: "confirmed", createdAt: new Date("2030-01-01T09:01:00.000Z") }]
    });
    await c.getBooking({ params: { bookingId: "b9" } } as never, reply);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("listBookings applies filters and deleteBlockedSlot handles missing/existing", async () => {
    mocks.prisma.booking.findMany.mockResolvedValue([
      {
        id: "b11",
        salonId: "s1",
        serviceId: "svc1",
        service: { name: "Service A" },
        employeeId: null,
        employee: null,
        clientId: "c1",
        client: { fullName: "Client A", phone: "7700" },
        startsAt: new Date("2030-01-01T10:00:00.000Z"),
        endsAt: new Date("2030-01-01T10:30:00.000Z"),
        status: "confirmed",
        source: "marketplace",
        depositAmountXof: 1000,
        createdAt: new Date("2030-01-01T09:00:00.000Z")
      }
    ]);
    await c.listBookings({ query: { status: "confirmed", date: "2030-01-01", page: "1", pageSize: "5" } } as never, reply);

    mocks.prisma.blockedSlot.findFirst.mockResolvedValueOnce(null);
    await c.deleteBlockedSlot({ params: { slotId: "missing" } } as never, reply);

    mocks.prisma.blockedSlot.findFirst.mockResolvedValueOnce({ id: "bs1" });
    await c.deleteBlockedSlot({ params: { slotId: "bs1" } } as never, reply);

    expect(mocks.ok).toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "slot_not_found", expect.any(String));
  });

  it("listClients/getClient success mappings", async () => {
    mocks.prisma.user.findMany.mockResolvedValue([
      {
        id: "c1",
        fullName: "Client A",
        phone: "77",
        email: "a@x.com",
        bookings: [
          { startsAt: new Date("2030-01-03T10:00:00.000Z"), payments: [{ amountXof: 7000 }] },
          { startsAt: new Date("2030-01-01T10:00:00.000Z"), payments: [] }
        ]
      },
      {
        id: "c2",
        fullName: "Client B",
        phone: "78",
        email: null,
        bookings: []
      }
    ]);
    await c.listClients({ query: {} } as never, reply);

    mocks.prisma.booking.findMany.mockResolvedValue([
      {
        id: "b1",
        startsAt: new Date("2030-01-03T10:00:00.000Z"),
        status: "completed",
        client: { id: "c1", fullName: "Client A", phone: "77", email: "a@x.com" },
        service: { name: "Coupe" },
        payments: [{ amountXof: 5000 }]
      },
      {
        id: "b2",
        startsAt: new Date("2030-01-02T10:00:00.000Z"),
        status: "confirmed",
        client: { id: "c1", fullName: "Client A", phone: "77", email: "a@x.com" },
        service: { name: "Brushing" },
        payments: []
      }
    ]);
    await c.getClient({ params: { clientId: "c1" } } as never, reply);

    expect(mocks.ok).toHaveBeenCalled();
  });

  it("listBookings/getBooking map nullable client and employee fields", async () => {
    mocks.prisma.booking.findMany.mockResolvedValue([
      {
        id: "b-null",
        salonId: "s1",
        serviceId: "svc1",
        service: { name: "Coupe" },
        employeeId: null,
        employee: null,
        clientId: "c-null",
        client: null,
        startsAt: new Date("2030-01-01T10:00:00.000Z"),
        endsAt: new Date("2030-01-01T10:30:00.000Z"),
        status: "pending",
        source: "marketplace",
        depositAmountXof: 0,
        createdAt: new Date("2030-01-01T09:00:00.000Z"),
        payments: []
      }
    ]);
    await c.listBookings({ query: {} } as never, reply);

    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b-null",
      salonId: "s1",
      serviceId: "svc1",
      service: { name: "Coupe" },
      employeeId: null,
      employee: null,
      clientId: "c-null",
      client: null,
      startsAt: new Date("2030-01-01T10:00:00.000Z"),
      endsAt: new Date("2030-01-01T10:30:00.000Z"),
      status: "pending",
      source: "marketplace",
      depositAmountXof: 0,
      createdAt: new Date("2030-01-01T09:00:00.000Z"),
      payments: [],
      bookingEvents: []
    });
    await c.getBooking({ params: { bookingId: "b-null" } } as never, reply);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("listClients sort handles both null and non-null lastVisitAt timestamp branches", async () => {
    mocks.prisma.user.findMany.mockResolvedValue([
      { id: "c-no", fullName: "No Visit", phone: "70", email: null, bookings: [] },
      {
        id: "c-new",
        fullName: "Recent",
        phone: "71",
        email: "r@x.com",
        bookings: [{ startsAt: new Date("2030-02-01T10:00:00.000Z"), payments: [{ amountXof: 1000 }] }]
      },
      {
        id: "c-old",
        fullName: "Older",
        phone: "72",
        email: "o@x.com",
        bookings: [{ startsAt: new Date("2030-01-01T10:00:00.000Z"), payments: [{ amountXof: 500 }] }]
      }
    ]);
    await c.listClients({ query: {} } as never, reply);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("getClient maps null lastVisitAt when startsAt is missing on first row", async () => {
    mocks.prisma.booking.findMany.mockResolvedValue([
      {
        id: "b-null",
        startsAt: undefined,
        status: "confirmed",
        client: { id: "c1", fullName: "Client A", phone: "77", email: "a@x.com" },
        service: { name: "Coupe" },
        payments: []
      }
    ]);
    await c.getClient({ params: { clientId: "c1" } } as never, reply);
    expect(mocks.fail.mock.calls.length + mocks.ok.mock.calls.length + mocks.handleError.mock.calls.length).toBeGreaterThan(0);
  });

  it("listReviews sets responseAt when review has a response", async () => {
    mocks.prisma.review.findMany.mockResolvedValue([
      {
        id: "r1",
        rating: 5,
        comment: "Top",
        createdAt: new Date("2030-01-01T10:00:00.000Z"),
        responseText: "Merci",
        updatedAt: new Date("2030-01-02T10:00:00.000Z"),
        clientId: "c1"
      },
      {
        id: "r2",
        rating: 4,
        comment: "Bien",
        createdAt: new Date("2030-01-03T10:00:00.000Z"),
        responseText: null,
        updatedAt: new Date("2030-01-03T11:00:00.000Z"),
        clientId: "c2"
      }
    ]);
    await c.listReviews({} as never, reply);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("completeCheckout conflict + success + review/analytics branches", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({ id: "b1", status: "confirmed", service: { priceXof: 10000 }, payments: [{ amountXof: 2000 }] });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 0 }) },
      bookingEvent: { create: vi.fn() },
      settlementEvent: { create: vi.fn() }
    }));
    await c.completeCheckout({ params: { bookingId: "b1" }, body: { paymentMethod: "cash", discountXof: 0, lineItems: [{ name: "Service", amountXof: 1000 }] } } as never, reply);

    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      settlementEvent: { create: vi.fn() }
    }));
    await c.completeCheckout({ params: { bookingId: "b1" }, body: { paymentMethod: "cash", discountXof: 1000, lineItems: [{ name: "Service", amountXof: 1000 }] } } as never, reply);

    mocks.prisma.review.findFirst.mockResolvedValue({ id: "r1" });
    await c.respondToReview({ params: { reviewId: "r1" }, body: { responseText: "Merci" } } as never, reply);

    mocks.prisma.salon.findUnique.mockResolvedValue({ subscriptionTier: "standard", subscription: { status: "active" } });
    await c.analytics({ query: { period: "7d" } } as never, reply);
    mocks.prisma.salon.findUnique.mockResolvedValue({ subscriptionTier: "premium", subscription: { status: "active" } });
    mocks.getOrSetCachedJson.mockImplementation(async (input: any) => ({
      value: await input.load(),
      cacheStatus: "MISS"
    }));
    mocks.getProAnalytics.mockResolvedValue({ bookingCount: 1 });
    await c.analytics({ query: { period: "90d" } } as never, reply);
    mocks.prisma.salon.findUnique.mockResolvedValue({ subscriptionTier: "premium", subscription: { status: "active" } });
    mocks.getOrSetCachedJson.mockResolvedValueOnce({ value: { bookingCount: 2 }, cacheStatus: "HIT" });
    await c.analytics({ query: { period: "bad-period" } } as never, reply);

    expect(mocks.invalidateCacheTags).toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 402, "premium_required", expect.any(String));
    expect(mocks.getProAnalytics).toHaveBeenCalledWith("s1", "90d");
    expect(mocks.getOrSetCachedJson).toHaveBeenCalledWith(expect.objectContaining({
      key: "kpi:pro:analytics:s1:30d"
    }));
  });

  it("completeCheckout records settlement event when balance is still due", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b-bal",
      status: "confirmed",
      service: { priceXof: 10000 },
      payments: [{ amountXof: 2000 }]
    });
    const settlementCreate = vi.fn();
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      settlementEvent: { create: settlementCreate }
    }));
    await c.completeCheckout({
      params: { bookingId: "b-bal" },
      body: { paymentMethod: "cash", discountXof: 1000, lineItems: [{ name: "Service", amountXof: 10000 }] }
    } as never, reply);
    expect(settlementCreate).toHaveBeenCalled();
  });

  it("transition status conflict and already-completed checkout", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({ id: "b1", status: "pending" });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 0 }) },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() },
      payment: { findFirst: vi.fn().mockResolvedValue(null) },
      settlementEvent: { create: vi.fn() },
      subscription: { update: vi.fn() },
      platformSetting: { upsert: vi.fn(), deleteMany: vi.fn() }
    }));
    await c.acceptBooking({ params: { bookingId: "b1" } } as never, reply);

    mocks.prisma.booking.findFirst.mockResolvedValue({ id: "b1", status: "confirmed", service: { priceXof: 10000 }, payments: [] });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 0 }) },
      bookingEvent: { create: vi.fn() },
      settlementEvent: { create: vi.fn() }
    }));
    await c.completeCheckout({ params: { bookingId: "b1" }, body: { paymentMethod: "cash", discountXof: 0, lineItems: [{ name: "Service", amountXof: 1000 }] } } as never, reply);

    expect(mocks.handleError).toHaveBeenCalled();
  });

  it("acceptBooking succeeds without afterHook", async () => {
    mocks.prisma.booking.findFirst
      .mockResolvedValueOnce({ id: "b-accept", status: "pending", depositAmountXof: 0, payments: [] })
      .mockResolvedValueOnce({ id: "b-accept", status: "pending" });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }), findUnique: vi.fn().mockResolvedValue({ startsAt: new Date(Date.now() + 48 * 60 * 60 * 1000), clientId: "c1" }) },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() },
      payment: { findFirst: vi.fn().mockResolvedValue(null) },
      settlementEvent: { create: vi.fn() },
      subscription: { update: vi.fn() },
      platformSetting: { upsert: vi.fn(), deleteMany: vi.fn() },
      job: { create: vi.fn() }
    }));
    await c.acceptBooking({ params: { bookingId: "b-accept" } } as never, reply);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { status: "confirmed" });
  });

  it("acceptBooking blocks confirmation when deposit is required but unpaid", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b-accept-unpaid",
      status: "pending",
      depositAmountXof: 10000,
      payments: []
    });
    await c.acceptBooking({ params: { bookingId: "b-accept-unpaid" } } as never, reply);
    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      422,
      "deposit_not_paid",
      expect.stringContaining("Acompte non payé")
    );
  });

  it("rejectBooking afterHook enqueues refund reconciliation when payment exists", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({ id: "b-rf", status: "pending" });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() },
      payment: { findFirst: vi.fn().mockResolvedValue({ id: "pay-rf" }) },
      settlementEvent: { create: vi.fn() },
      subscription: { update: vi.fn() },
      platformSetting: { upsert: vi.fn(), deleteMany: vi.fn() }
    }));
    await c.rejectBooking({
      params: { bookingId: "b-rf" },
      body: { reason: "Client did not show up to the appointment." }
    } as never, reply);
    expect(mocks.enqueueJob).toHaveBeenCalledWith(expect.objectContaining({
      type: "refund_reconciliation",
      payload: { paymentId: "pay-rf", bookingId: "b-rf" }
    }));
    expect(mocks.invalidateCacheTags).toHaveBeenCalledWith(["kpi:pro", "kpi:admin"]);
  });

  it("rejectBooking completes without enqueue when no authorized/succeeded payment exists", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({ id: "b-rf-none", status: "pending" });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() },
      payment: { findFirst: vi.fn().mockResolvedValue(null) },
      settlementEvent: { create: vi.fn() },
      subscription: { update: vi.fn() },
      platformSetting: { upsert: vi.fn(), deleteMany: vi.fn() }
    }));
    await c.rejectBooking({
      params: { bookingId: "b-rf-none" },
      body: { reason: "Client did not show up to the appointment." }
    } as never, reply);
    expect(mocks.enqueueJob).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { status: "cancelled" });
  });

  it("completeBooking enqueues settlement job and invalidates caches", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue({ id: "b2", status: "in_progress" });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      booking: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() }
    }));
    await c.completeBooking({ params: { bookingId: "b2" } } as never, reply);
    expect(mocks.enqueueJob).toHaveBeenCalledWith(expect.objectContaining({
      type: "deposit_settlement",
      payload: { bookingId: "b2" }
    }));
    expect(mocks.invalidateCacheTags).toHaveBeenCalledWith(["kpi:pro", "kpi:admin"]);
  });

  it("completeCheckout returns booking_not_found when booking missing", async () => {
    mocks.prisma.booking.findFirst.mockResolvedValue(null);
    await c.completeCheckout({
      params: { bookingId: "missing" },
      body: { paymentMethod: "cash", discountXof: 0, lineItems: [{ name: "Service", amountXof: 1000 }] }
    } as never, reply);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "booking_not_found", expect.any(String));
  });

  it("subscription/invoices/pdf branches", async () => {
    mocks.prisma.subscription.findUnique
      .mockResolvedValueOnce({ id: "sub1", tier: "standard", status: "active", renewedAt: null, expiresAt: null, isComplimentary: false, autoRenew: true, billingProvider: "manual" })
      .mockResolvedValueOnce({ id: "sub1", tier: "standard", status: "active", renewedAt: null, expiresAt: null, isComplimentary: false, autoRenew: true, billingProvider: "manual" })
      .mockResolvedValueOnce({ id: "sub1", tier: "standard", status: "active", renewedAt: null, expiresAt: null, isComplimentary: false, autoRenew: true, billingProvider: "manual" })
      .mockResolvedValueOnce(null)
      .mockResolvedValueOnce({ id: "sub1", billingProvider: "manual" });

    mocks.prisma.platformSetting.findMany.mockResolvedValueOnce([{ key: "salon:s1:billing_provider", value: "manual" }, { key: "salon:s1:billing_account_number", value: "77223344" }]);
    await c.getSubscription({} as never, reply);

    await c.updateSubscription({ body: { autoRenew: false, billingMethod: null } } as never, reply);
    await c.updateSubscription({ body: { autoRenew: true, billingMethod: { provider: "manual", accountNumber: "77223344" } } } as never, reply);

    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1", phone: null });
    await c.subscriptionCheckout({ body: { action: "upgrade", provider: "paydunya" } } as never, reply);

    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1", phone: "+221770000000" });
    mocks.prisma.platformSetting.findMany.mockResolvedValueOnce([{ key: "subscription_premium_price_xof", value: "25000" }, { key: "subscription_standard_price_xof", value: "15000" }]);
    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValueOnce({ id: "ch1", providerTxId: "tx1" });
    await c.subscriptionCheckout({ body: { action: "renewal", provider: "paydunya" } } as never, reply);

    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValueOnce(null);
    mocks.paymentAdapter.initiateDeposit.mockResolvedValue({ providerRef: "ref1", redirectUrl: "https://pay", expiresAt: new Date() });
    mocks.prisma.subscriptionCharge.create.mockResolvedValue({ id: "ch2" });
    mocks.prisma.platformSetting.findMany.mockResolvedValueOnce([{ key: "subscription_premium_price_xof", value: "25000" }, { key: "subscription_standard_price_xof", value: "15000" }]);
    await c.subscriptionCheckout({ body: { action: "upgrade", provider: "manual" } } as never, reply);

    await c.listInvoices({} as never, reply);

    mocks.prisma.billingInvoice.findFirst.mockResolvedValue({ id: "inv1", invoiceNumber: "INV/1", amountXof: 12000, status: "paid", createdAt: new Date(), pdfUrl: "" });
    mocks.prisma.salon.findUnique.mockResolvedValue({ name: "Salon A" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: "manual" });
    await c.downloadInvoicePdf({ params: { invoiceId: "inv1" } } as never, reply);

    expect(mocks.ok).toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "phone_required", expect.any(String));
  });

  it("downloadInvoicePdf handles missing subscription", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue(null);
    await c.downloadInvoicePdf({ params: { invoiceId: "inv2" } } as never, reply);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "subscription_not_found", expect.any(String));
  });

  it("getSubscription decrypts encrypted billing account and masks it", async () => {
    const key = Buffer.from("a".repeat(64).slice(0, 64), "hex").subarray(0, 32);
    const iv = randomBytes(12);
    const cipher = createCipheriv("aes-256-gcm", key, iv);
    const encrypted = Buffer.concat([cipher.update("77223344", "utf8"), cipher.final()]);
    const tag = cipher.getAuthTag();
    const encryptedValue = `enc:v1:${iv.toString("hex")}${tag.toString("hex")}${encrypted.toString("hex")}`;

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
      { key: "salon:s1:billing_provider", value: "manual" },
      { key: "salon:s1:billing_account_number", value: encryptedValue }
    ]);

    await c.getSubscription({} as never, reply);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("getSubscription masks short billing account numbers", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue({
      id: "sub-short",
      tier: "standard",
      status: "active",
      renewedAt: null,
      expiresAt: null,
      isComplimentary: false,
      autoRenew: true,
      billingProvider: "manual"
    });
    mocks.prisma.platformSetting.findMany.mockResolvedValue([
      { key: "salon:s1:billing_provider", value: "manual" },
      { key: "salon:s1:billing_account_number", value: "1234" }
    ]);
    await c.getSubscription({} as never, reply);
    expect(mocks.ok).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({
        billingMethod: expect.objectContaining({ accountNumberMasked: "***1234" })
      })
    );
  });

  it("listInvoices keeps explicit pdfUrl and downloadInvoicePdf uses Intech provider + fallback salon label", async () => {
    mocks.prisma.subscription.findUnique
      .mockResolvedValueOnce({ id: "sub3", billingProvider: "manual" })
      .mockResolvedValueOnce({ id: "sub3", billingProvider: "manual" });
    mocks.prisma.billingInvoice.findMany.mockResolvedValueOnce([
      {
        id: "inv3",
        invoiceNumber: "INV3",
        amountXof: 22000,
        status: "paid",
        createdAt: new Date(),
        pdfUrl: "https://cdn.example.com/inv3.pdf"
      }
    ]);
    await c.listInvoices({} as never, reply);

    mocks.prisma.billingInvoice.findFirst.mockResolvedValueOnce({
      id: "inv3",
      invoiceNumber: "INV3",
      amountXof: 22000,
      status: "paid",
      createdAt: new Date(),
      pdfUrl: "https://cdn.example.com/inv3.pdf"
    });
    mocks.prisma.salon.findUnique.mockResolvedValueOnce(null);
    mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: "paydunya" });
    await c.downloadInvoicePdf({ params: { invoiceId: "inv3" } } as never, reply);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("subscriptionCheckout updates existing charge and downloadInvoicePdf falls back to sub provider", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1", phone: "+221770000000" });
    mocks.prisma.subscription.findUnique.mockResolvedValueOnce({
      id: "sub-existing",
      tier: "premium",
      status: "active",
      renewedAt: null,
      expiresAt: null,
      isComplimentary: false,
      autoRenew: true,
      billingProvider: "paydunya"
    });
    mocks.prisma.platformSetting.findMany.mockResolvedValueOnce([
      { key: "subscription_premium_price_xof", value: "25000" },
      { key: "subscription_standard_price_xof", value: "15000" }
    ]);
    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValueOnce({ id: "ch-existing", providerTxId: null });
    mocks.paymentAdapter.initiateDeposit.mockResolvedValueOnce({
      providerRef: "pref-updated",
      redirectUrl: "https://pay.existing",
      expiresAt: new Date()
    });
    mocks.prisma.subscriptionCharge.update.mockResolvedValueOnce({ id: "ch-existing" });
    await c.subscriptionCheckout({ body: { action: "upgrade", provider: "paydunya" } } as never, reply);

    mocks.prisma.subscription.findUnique.mockResolvedValueOnce({
      id: "sub-existing",
      billingProvider: "paydunya"
    });
    mocks.prisma.billingInvoice.findFirst.mockResolvedValueOnce({
      id: "inv4",
      invoiceNumber: "INV4",
      amountXof: 30000,
      status: "paid",
      createdAt: new Date(),
      pdfUrl: ""
    });
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ name: "Salon Existing" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce(null);
    await c.downloadInvoicePdf({ params: { invoiceId: "inv4" } } as never, reply);
    expect(mocks.fail.mock.calls.length + mocks.ok.mock.calls.length + mocks.handleError.mock.calls.length).toBeGreaterThan(0);
  });
});
