import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const prisma = {
    booking: {
      count: vi.fn(),
      groupBy: vi.fn()
    },
    payment: {
      aggregate: vi.fn()
    },
    service: {
      findMany: vi.fn()
    },
    employee: {
      findFirst: vi.fn().mockResolvedValue(null)
    }
  };
  return { prisma };
});

vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));

import { getProAnalytics, getProDashboard } from "./data.js";

describe("pro data", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("getProDashboard returns counts for owner with revenue", async () => {
    mocks.prisma.booking.count.mockResolvedValueOnce(2).mockResolvedValueOnce(5);
    mocks.prisma.payment.aggregate.mockResolvedValue({ _sum: { amountXof: 25000 } });

    const result = await getProDashboard("s1", "salon_owner", "u1");

    expect(result).toEqual({
      pendingBookingCount: 2,
      todayBookingCount: 5,
      totalRevenueXof: 25000
    });
  });

  it("getProDashboard skips revenue for non-owner", async () => {
    mocks.prisma.booking.count.mockResolvedValueOnce(1).mockResolvedValueOnce(3);

    const result = await getProDashboard("s1", "salon_staff", "u1");

    expect(result.totalRevenueXof).toBeNull();
    expect(mocks.prisma.payment.aggregate).not.toHaveBeenCalled();
  });

  it("getProAnalytics computes occupancy and top services", async () => {
    mocks.prisma.booking.count.mockResolvedValueOnce(20).mockResolvedValueOnce(8);
    mocks.prisma.payment.aggregate.mockResolvedValue({ _sum: { amountXof: 120000 } });
    mocks.prisma.booking.groupBy.mockResolvedValue([
      { serviceId: "svc_1", _count: { id: 5 } },
      { serviceId: "svc_2", _count: { id: 3 } }
    ]);
    mocks.prisma.service.findMany.mockResolvedValue([
      { id: "svc_1", name: "Coupe" }
    ]);

    const result = await getProAnalytics("s1", "7d");

    expect(result.bookingCount).toBe(20);
    expect(result.completedCount).toBe(8);
    expect(result.totalRevenueXof).toBe(120000);
    expect(result.occupancyPercent).toBeGreaterThanOrEqual(0);
    expect(result.topServices).toEqual([
      { serviceId: "svc_1", serviceName: "Coupe", bookingCount: 5 },
      { serviceId: "svc_2", serviceName: "Service inconnu", bookingCount: 3 }
    ]);
  });

  it("getProAnalytics covers 30d/90d period branches and null sums", async () => {
    mocks.prisma.booking.count.mockResolvedValueOnce(0).mockResolvedValueOnce(0);
    mocks.prisma.payment.aggregate.mockResolvedValueOnce({ _sum: { amountXof: null } });
    mocks.prisma.booking.groupBy.mockResolvedValueOnce([]);
    mocks.prisma.service.findMany.mockResolvedValueOnce([]);
    const r30 = await getProAnalytics("s1", "30d");
    expect(r30.period).toBe("30d");
    expect(r30.totalRevenueXof).toBe(0);
    expect(r30.occupancyPercent).toBe(0);

    mocks.prisma.booking.count.mockResolvedValueOnce(4000).mockResolvedValueOnce(4000);
    mocks.prisma.payment.aggregate.mockResolvedValueOnce({ _sum: { amountXof: 1 } });
    mocks.prisma.booking.groupBy.mockResolvedValueOnce([]);
    mocks.prisma.service.findMany.mockResolvedValueOnce([]);
    const r90 = await getProAnalytics("s1", "90d", new Date("2030-01-01T00:00:00.000Z"), new Date("2030-01-01T00:00:00.000Z"));
    expect(r90.period).toBe("90d");
    expect(r90.occupancyPercent).toBe(100);
  });
});
