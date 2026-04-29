import type { FastifyReply, FastifyRequest } from "fastify";

import { bookingCreateSchema, bookingRescheduleSchema, reviewCreateInputSchema } from "@beauteavenue/contracts";

import { createPaymentAdapter } from "../adapters/index.js";
import { config } from "../config.js";
import { HttpAuthError, requireRole } from "../lib/auth.js";
import { computeAvailableSlots } from "../lib/availability.js";
import { fail, ok } from "../lib/http.js";
import { prisma } from "../lib/prisma.js";

const paymentAdapter = createPaymentAdapter(config.paymentDriver);

function calcDepositAmount(service: {
  depositMode: string;
  depositAmountXof: number | null;
  depositPercent: number | null;
  priceXof: number;
}): number {
  if (service.depositMode === "fixed") return service.depositAmountXof ?? 0;
  if (service.depositMode === "percent") {
    return Math.round(((service.depositPercent ?? 0) / 100) * service.priceXof);
  }
  return 0;
}

function bookingSummary(booking: {
  id: string;
  salonId: string;
  salon: { name: string };
  serviceId: string;
  service: { name: string };
  startsAt: Date;
  endsAt: Date;
  status: string;
  source: string;
  depositAmountXof: number;
  depositPaymentStatus: string;
  paymentProvider: string | null;
  payments: Array<{ id: string }>;
}) {
  return {
    id: booking.id,
    salonId: booking.salonId,
    salonName: booking.salon.name,
    serviceId: booking.serviceId,
    serviceName: booking.service.name,
    startsAt: booking.startsAt.toISOString(),
    endsAt: booking.endsAt.toISOString(),
    status: booking.status,
    source: booking.source,
    depositAmountXof: booking.depositAmountXof,
    depositPaymentStatus: booking.depositPaymentStatus,
    paymentProvider: booking.paymentProvider,
    paymentId: booking.payments[0]?.id ?? null
  };
}

export class BookingController {
  async create(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const body = bookingCreateSchema.parse(request.body);

      const service = await prisma.service.findFirst({
        where: { id: body.serviceId, isActive: true }
      });
      if (!service) { fail(reply, 404, "service_not_found", "Service introuvable."); return; }

      const salon = await prisma.salon.findUnique({ where: { id: body.salonId } });
      if (!salon) { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }
      if (!salon.canReceiveBookings) {
        fail(reply, 422, "salon_not_accepting", "Ce salon n'accepte pas les réservations pour l'instant.");
        return;
      }

      const startsAt = new Date(body.startsAt);
      const endsAt = new Date(startsAt.getTime() + service.durationMinutes * 60 * 1000);
      const date = new Date(startsAt.getFullYear(), startsAt.getMonth(), startsAt.getDate());
      const dayOfWeek = startsAt.getDay();
      const nextDay = new Date(date);
      nextDay.setDate(nextDay.getDate() + 1);

      const [salonHour, blockedSlots, existingBookings, employees] = await Promise.all([
        prisma.salonHours.findUnique({ where: { salonId_dayOfWeek: { salonId: body.salonId, dayOfWeek } } }),
        prisma.blockedSlot.findMany({
          where: { salonId: body.salonId, startsAt: { lt: nextDay }, endsAt: { gt: date } }
        }),
        prisma.booking.findMany({
          where: {
            salonId: body.salonId,
            status: { notIn: ["cancelled"] },
            startsAt: { lt: nextDay },
            endsAt: { gt: date }
          },
          select: { startsAt: true, endsAt: true, employeeId: true }
        }),
        prisma.employee.findMany({
          where: { salonId: body.salonId, isActive: true, schedulingEnabled: true }
        })
      ]);

      const availableSlots = computeAvailableSlots({
        hours: salonHour
          ? { isOpen: salonHour.isOpen, opensAt: salonHour.opensAt, closesAt: salonHour.closesAt }
          : { isOpen: false, opensAt: null, closesAt: null },
        service: { durationMinutes: service.durationMinutes },
        date,
        blockedSlots: blockedSlots.map((b) => ({
          startsAt: b.startsAt,
          endsAt: b.endsAt,
          scope: b.scope as "salon" | "employee",
          employeeId: b.employeeId
        })),
        existingBookings,
        employees,
        requestedEmployeeId: body.employeeId
      });

      const slotAvailable = availableSlots.some(
        (s) => new Date(s.startsAt).getTime() === startsAt.getTime()
      );
      if (!slotAvailable) {
        fail(reply, 422, "slot_unavailable", "Ce créneau n'est plus disponible.");
        return;
      }

      const depositAmountXof = calcDepositAmount(service);

      const result = await prisma.$transaction(async (tx) => {
        const booking = await tx.booking.create({
          data: {
            clientId: session.sub,
            salonId: body.salonId,
            serviceId: body.serviceId,
            employeeId: body.employeeId ?? null,
            startsAt,
            endsAt,
            status: "pending",
            source: "marketplace",
            depositAmountXof,
            depositPaymentStatus: "pending",
            clientNote: body.clientNote ?? null
          }
        });

        const payment = await tx.payment.create({
          data: {
            bookingId: booking.id,
            provider: body.provider ?? "wave",
            status: "pending",
            amountXof: depositAmountXof,
            idempotencyKey: `booking-${booking.id}-deposit`
          }
        });

        await tx.bookingEvent.create({
          data: {
            bookingId: booking.id,
            actorUserId: session.sub,
            eventType: "created",
            toStatus: "pending"
          }
        });

        return { booking, payment };
      });

      const full = await prisma.booking.findUnique({
        where: { id: result.booking.id },
        include: { salon: true, service: true, payments: { take: 1 } }
      });

      ok(reply, bookingSummary(full!), 201);
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async list(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const bookings = await prisma.booking.findMany({
        where: { clientId: session.sub },
        include: { salon: true, service: true, payments: { take: 1 } },
        orderBy: { startsAt: "desc" }
      });
      ok(reply, { items: bookings.map(bookingSummary), total: bookings.length });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async detail(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const params = request.params as { bookingId: string };
      const booking = await prisma.booking.findFirst({
        where: { id: params.bookingId, clientId: session.sub },
        include: { salon: true, service: true, payments: true }
      });
      if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable."); return; }
      ok(reply, bookingSummary({ ...booking, payments: booking.payments.slice(0, 1) }));
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async cancel(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const params = request.params as { bookingId: string };
      const booking = await prisma.booking.findFirst({
        where: { id: params.bookingId, clientId: session.sub },
        include: { payments: { where: { status: { in: ["authorized", "succeeded"] } }, take: 1 } }
      });
      if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable."); return; }
      if (!["pending", "confirmed"].includes(booking.status)) {
        fail(reply, 422, "invalid_status", "Cette réservation ne peut plus être annulée.");
        return;
      }

      await prisma.$transaction(async (tx) => {
        await tx.booking.update({ where: { id: booking.id }, data: { status: "cancelled" } });
        await tx.bookingEvent.create({
          data: { bookingId: booking.id, actorUserId: session.sub, eventType: "cancelled", fromStatus: booking.status, toStatus: "cancelled" }
        });

        if (booking.payments.length > 0) {
          await tx.job.create({
            data: {
              queue: "payments",
              type: "refund_reconciliation",
              payloadJson: JSON.stringify({ paymentId: booking.payments[0].id, bookingId: booking.id }),
              status: "pending"
            }
          });
        }
      });

      ok(reply, { cancelled: true });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async reschedule(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const params = request.params as { bookingId: string };
      const body = bookingRescheduleSchema.parse(request.body);

      const booking = await prisma.booking.findFirst({
        where: { id: params.bookingId, clientId: session.sub },
        include: { service: true, salon: true, payments: { take: 1 } }
      });
      if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable."); return; }
      if (!["pending", "confirmed"].includes(booking.status)) {
        fail(reply, 422, "invalid_status", "Cette réservation ne peut plus être replanifiée.");
        return;
      }

      const newStart = new Date(body.startsAt);
      const newEnd = new Date(newStart.getTime() + booking.service.durationMinutes * 60 * 1000);
      const date = new Date(newStart.getFullYear(), newStart.getMonth(), newStart.getDate());
      const dayOfWeek = newStart.getDay();
      const nextDay = new Date(date);
      nextDay.setDate(nextDay.getDate() + 1);

      const [salonHour, blockedSlots, existingBookings, employees] = await Promise.all([
        prisma.salonHours.findUnique({ where: { salonId_dayOfWeek: { salonId: booking.salonId, dayOfWeek } } }),
        prisma.blockedSlot.findMany({ where: { salonId: booking.salonId, startsAt: { lt: nextDay }, endsAt: { gt: date } } }),
        prisma.booking.findMany({
          where: { salonId: booking.salonId, status: { notIn: ["cancelled"] }, id: { not: booking.id }, startsAt: { lt: nextDay }, endsAt: { gt: date } },
          select: { startsAt: true, endsAt: true, employeeId: true }
        }),
        prisma.employee.findMany({ where: { salonId: booking.salonId, isActive: true, schedulingEnabled: true } })
      ]);

      const slots = computeAvailableSlots({
        hours: salonHour ? { isOpen: salonHour.isOpen, opensAt: salonHour.opensAt, closesAt: salonHour.closesAt } : { isOpen: false, opensAt: null, closesAt: null },
        service: { durationMinutes: booking.service.durationMinutes },
        date,
        blockedSlots: blockedSlots.map((b) => ({ startsAt: b.startsAt, endsAt: b.endsAt, scope: b.scope as "salon" | "employee", employeeId: b.employeeId })),
        existingBookings,
        employees
      });

      if (!slots.some((s) => new Date(s.startsAt).getTime() === newStart.getTime())) {
        fail(reply, 422, "slot_unavailable", "Ce créneau n'est plus disponible.");
        return;
      }

      await prisma.$transaction(async (tx) => {
        await tx.booking.update({ where: { id: booking.id }, data: { startsAt: newStart, endsAt: newEnd } });
        await tx.bookingEvent.create({
          data: { bookingId: booking.id, actorUserId: session.sub, eventType: "rescheduled", payloadJson: JSON.stringify({ newStartsAt: newStart }) }
        });
      });

      const updated = await prisma.booking.findUnique({ where: { id: booking.id }, include: { salon: true, service: true, payments: { take: 1 } } });
      ok(reply, bookingSummary(updated!));
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async submitReview(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const params = request.params as { bookingId: string };
      const body = reviewCreateInputSchema.parse(request.body);

      const booking = await prisma.booking.findFirst({
        where: { id: params.bookingId, clientId: session.sub, status: "completed" }
      });
      if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable ou non terminée."); return; }

      const existing = await prisma.review.findUnique({ where: { bookingId: params.bookingId } });
      if (existing) { fail(reply, 409, "review_exists", "Avis déjà soumis pour cette réservation."); return; }

      const review = await prisma.review.create({
        data: {
          bookingId: params.bookingId,
          salonId: booking.salonId,
          clientId: session.sub,
          rating: body.rating,
          comment: body.comment ?? null
        }
      });

      // Update salon average rating
      const agg = await prisma.review.aggregate({ where: { salonId: booking.salonId }, _avg: { rating: true } });
      await prisma.salon.update({ where: { id: booking.salonId }, data: { averageRating: agg._avg.rating ?? 0 } });

      ok(reply, { id: review.id, rating: review.rating, comment: review.comment, createdAt: review.createdAt.toISOString() }, 201);
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }
}
