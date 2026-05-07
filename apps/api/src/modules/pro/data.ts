import { prisma } from "../../lib/db/prisma.js";

function startOfToday() {
  const d = new Date();
  d.setHours(0, 0, 0, 0);
  return d;
}

function endOfToday() {
  const d = new Date();
  d.setHours(23, 59, 59, 999);
  return d;
}

export async function getProDashboard(salonId: string, role: string) {
  const today = startOfToday();
  const todayEnd = endOfToday();

  const [pendingBookingCount, todayBookingCount, completedPayments] = await Promise.all([
    prisma.booking.count({ where: { salonId, status: "pending" } }),
    prisma.booking.count({ where: { salonId, startsAt: { gte: today, lte: todayEnd } } }),
    role === "salon_owner"
      ? prisma.payment.aggregate({
          where: { booking: { salonId }, status: "succeeded" },
          _sum: { amountXof: true }
        })
      : null
  ]);

  return {
    pendingBookingCount,
    todayBookingCount,
    totalRevenueXof: completedPayments?._sum.amountXof ?? null
  };
}

export async function getProAnalytics(
  salonId: string,
  period: "7d" | "30d" | "90d",
  from?: Date,
  to?: Date
) {
  const now = new Date();
  const days = period === "7d" ? 7 : period === "30d" ? 30 : 90;
  const start = from ?? new Date(now.getTime() - days * 24 * 60 * 60 * 1000);
  const end = to ?? now;

  const [bookings, completedBookings, payments, topServices] = await Promise.all([
    prisma.booking.count({ where: { salonId, createdAt: { gte: start, lte: end } } }),
    prisma.booking.count({ where: { salonId, status: "completed", createdAt: { gte: start, lte: end } } }),
    prisma.payment.aggregate({
      where: { booking: { salonId }, status: "succeeded", createdAt: { gte: start, lte: end } },
      _sum: { amountXof: true }
    }),
    prisma.booking.groupBy({
      by: ["serviceId"],
      where: { salonId, createdAt: { gte: start, lte: end } },
      _count: { id: true },
      orderBy: { _count: { id: "desc" } },
      take: 5
    })
  ]);

  const serviceIds = topServices.map((s) => s.serviceId);
  const services = await prisma.service.findMany({
    where: { id: { in: serviceIds } },
    select: { id: true, name: true }
  });
  const serviceMap = new Map(services.map((s) => [s.id, s.name]));

  // Approximate occupancy: assume 8-hour workday, 15-min slots
  const totalAvailableSlots = days * 8 * 4;
  const occupancyPercent = totalAvailableSlots > 0
    ? Math.min(100, Math.round((completedBookings / totalAvailableSlots) * 100))
    : 0;

  return {
    period,
    bookingCount: bookings,
    completedCount: completedBookings,
    occupancyPercent,
    totalRevenueXof: payments._sum.amountXof ?? 0,
    topServices: topServices.map((s) => ({
      serviceId: s.serviceId,
      serviceName: serviceMap.get(s.serviceId) ?? "Service inconnu",
      bookingCount: s._count.id
    }))
  };
}
