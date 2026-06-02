import type { FastifyReply, FastifyRequest } from "fastify";

import { bookingCreateSchema, bookingRescheduleSchema, reviewCreateInputSchema } from "@beauteavenue/contracts";

import { getPaymentAdapter } from "../../adapters/index.js";
import { config } from "../../config.js";
import { HttpAuthError, requireRole } from "../../lib/auth/index.js";
import { fetchAndComputeAvailableSlots } from "../../lib/availability.js";
import { invalidateCacheTags } from "../../lib/cache.js";
import { fail, ok } from "../../lib/http.js";
import { enqueueJob } from "../../lib/jobs.js";
import { logger } from "../../lib/logger.js";
import { toDbProvider, toPublicGatewayProvider } from "../../lib/payment-provider.js";
import { prisma } from "../../lib/db/prisma.js";

const paymentAdapter = getPaymentAdapter(config.paymentDriver, {
  baseOrigin: config.webOrigin,
  paydunyaMasterKey: config.paydunyaMasterKey,
  paydunyaPrivateKey: config.paydunyaPrivateKey,
  paydunyaToken: config.paydunyaToken,
  paydunyaEnv: config.paydunyaEnv,
  paydunyaBaseUrl: config.paydunyaBaseUrl
});

async function scheduleReminders(bookingId: string, startsAt: Date) {
  const windows = [
    { label: "24h", offsetMs: 24 * 60 * 60 * 1000 },
    { label: "1h", offsetMs: 60 * 60 * 1000 }
  ];

  for (const w of windows) {
    const runAfter = new Date(startsAt.getTime() - w.offsetMs);
    if (runAfter.getTime() > Date.now()) {
      await enqueueJob({
        type: "booking_reminder",
        payload: { bookingId, window: w.label },
        bookingId,
        runAfter
      });
    }
  }
}

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
  payments: Array<{ id: string; status?: string; amountXof?: number; provider?: string }>;
}) {
  const latestPayment = booking.payments[0];
  const depositPaidXof = booking.payments
    .filter((p) => p.status === "authorized" || p.status === "succeeded")
    .reduce((sum, p) => sum + (p.amountXof ?? 0), 0);

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
    depositPaidXof,
    depositPaymentStatus: booking.depositPaymentStatus,
    paymentProvider: booking.paymentProvider
      ? toPublicGatewayProvider(booking.paymentProvider)
      : (latestPayment?.provider ? toPublicGatewayProvider(latestPayment.provider) : null),
    paymentId: latestPayment?.id ?? null
  };
}

export class BookingController {
  async create(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const body = bookingCreateSchema.parse(request.body);

      const service = await prisma.service.findFirst({
        where: { id: body.serviceId, salonId: body.salonId, isActive: true }
      });
      if (!service) { fail(reply, 404, "service_not_found", "Service introuvable."); return; }

      const salon = await prisma.salon.findUnique({ where: { id: body.salonId } });
      if (!salon) { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }
      if (salon.approvalStatus !== "approved") {
        fail(reply, 422, "salon_not_approved", "Ce salon n'est pas encore approuvé.");
        return;
      }
      if (!salon.canReceiveBookings) {
        fail(reply, 422, "salon_not_accepting", "Ce salon n'accepte pas les réservations pour l'instant.");
        return;
      }

      const startsAt = new Date(body.startsAt);
      if (startsAt.getTime() <= Date.now()) {
        fail(reply, 422, "invalid_start_time", "La réservation doit être planifiée dans le futur.");
        return;
      }
      const endsAt = new Date(startsAt.getTime() + service.durationMinutes * 60 * 1000);

      if (body.employeeId) {
        const employee = await prisma.employee.findFirst({
          where: { id: body.employeeId, salonId: body.salonId, isActive: true, schedulingEnabled: true },
          include: { specialties: { select: { serviceId: true } } }
        });
        if (!employee) {
          fail(reply, 422, "employee_not_available", "Employé introuvable ou indisponible.");
          return;
        }
        if (employee.specialties.length > 0 && !employee.specialties.some((s) => s.serviceId === body.serviceId)) {
          fail(reply, 422, "employee_service_mismatch", "Cet employé ne propose pas ce service.");
          return;
        }
      }

      const date = new Date(startsAt.getFullYear(), startsAt.getMonth(), startsAt.getDate());

      const availableSlots = await fetchAndComputeAvailableSlots(prisma, {
        salonId: body.salonId,
        date,
        durationMinutes: service.durationMinutes,
        employeeId: body.employeeId
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
        // Re-check slot availability inside transaction to close TOCTOU window
        const conflicts = await tx.booking.count({
          where: {
            salonId: body.salonId,
            status: { in: ["pending", "confirmed", "in_progress"] },
            startsAt: { lt: endsAt },
            endsAt: { gt: startsAt },
            ...(body.employeeId ? { employeeId: body.employeeId } : {})
          }
        });
        if (conflicts > 0) {
          throw new HttpAuthError(422, "slot_unavailable", "Ce créneau n'est plus disponible.");
        }

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

        let payment = null;
        if (depositAmountXof > 0) {
          payment = await tx.payment.create({
            data: {
              bookingId: booking.id,
              provider: toDbProvider(body.provider ?? "paydunya") ?? "paydunya",
              status: "pending",
              amountXof: depositAmountXof,
              idempotencyKey: `booking-${booking.id}-deposit`
            }
          });
        }

        await tx.bookingEvent.create({
          data: {
            bookingId: booking.id,
            actorUserId: session.sub,
            eventType: "created",
            toStatus: "pending"
          }
        });

        return { booking, payment };
      }, { isolationLevel: "Serializable" });

      const full = await prisma.booking.findUnique({
        where: { id: result.booking.id },
        include: { salon: true, service: true, payments: { orderBy: { createdAt: "desc" } } }
      });

      try {
        await scheduleReminders(result.booking.id, result.booking.startsAt);
      } catch (error) {
        logger.error("booking.create: reminder scheduling failed", {
          bookingId: result.booking.id,
          error
        });
      }

      void enqueueJob({
        type: "new_booking_salon",
        payload: { bookingId: result.booking.id },
        bookingId: result.booking.id
      }).catch((err) => logger.warn("booking.create: new_booking_salon enqueue failed", { err }));

      ok(reply, bookingSummary(full!), 201);
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      logger.error("booking.create failed", { error });
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async list(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const bookings = await prisma.booking.findMany({
        where: { clientId: session.sub },
        include: { salon: true, service: true, payments: { orderBy: { createdAt: "desc" } } },
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
        include: { salon: true, service: true, payments: { orderBy: { createdAt: "desc" } } }
      });
      if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable."); return; }
      ok(reply, bookingSummary(booking));
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

      const windowSetting = await prisma.platformSetting.findUnique({ where: { key: "cancellation_window_hours" } });
      const windowHours = windowSetting ? parseInt(windowSetting.value, 10) : 24;
      if (windowHours > 0) {
        const cutoff = new Date(booking.startsAt.getTime() - windowHours * 3600_000);
        if (new Date() > cutoff) {
          fail(reply, 422, "cancellation_window_closed", `L'annulation n'est plus possible. Délai de ${windowHours}h avant la prestation écoulé.`);
          return;
        }
      }

      await prisma.$transaction(async (tx) => {
        const claimed = await tx.booking.updateMany({
          where: { id: booking.id, status: { in: ["pending", "confirmed"] } },
          data: { status: "cancelled" }
        });
        if (claimed.count === 0) {
          throw new HttpAuthError(409, "status_conflict", "Statut modifié en parallèle. Réessayez.");
        }
        await tx.bookingEvent.create({
          data: { bookingId: booking.id, actorUserId: session.sub, eventType: "cancelled", fromStatus: booking.status, toStatus: "cancelled" }
        });
        await tx.job.updateMany({
          where: { type: "booking_reminder", bookingId: booking.id, status: "pending" },
          data: { status: "cancelled" }
        });

        if (booking.payments.length > 0) {
          await enqueueJob({
            type: "refund_reconciliation",
            payload: { paymentId: booking.payments[0].id, bookingId: booking.id },
            bookingId: booking.id,
            dbClient: tx
          });
        }

        await tx.auditLog.create({
          data: {
            action: "booking_cancelled_by_client",
            summary: `Annulation client ${booking.id}`,
            entityType: "Booking",
            entityId: booking.id,
            actorName: "client",
            actorUserId: session.sub,
            severity: "info",
            payloadJson: JSON.stringify({
              fromStatus: booking.status,
              toStatus: "cancelled",
              paymentLinked: booking.payments.length > 0,
              paymentId: booking.payments[0]?.id ?? null
            })
          }
        });
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
      if (newStart.getTime() <= Date.now()) {
        fail(reply, 422, "invalid_start_time", "La réservation doit être planifiée dans le futur.");
        return;
      }
      const newEnd = new Date(newStart.getTime() + booking.service.durationMinutes * 60 * 1000);
      const date = new Date(newStart.getFullYear(), newStart.getMonth(), newStart.getDate());

      const slots = await fetchAndComputeAvailableSlots(prisma, {
        salonId: booking.salonId,
        date,
        durationMinutes: booking.service.durationMinutes,
        employeeId: booking.employeeId ?? undefined,
        excludeBookingId: booking.id
      });

      if (!slots.some((s) => new Date(s.startsAt).getTime() === newStart.getTime())) {
        fail(reply, 422, "slot_unavailable", "Ce créneau n'est plus disponible.");
        return;
      }

      await prisma.$transaction(async (tx) => {
        const claimed = await tx.booking.updateMany({
          where: { id: booking.id, status: { in: ["pending", "confirmed"] } },
          data: { startsAt: newStart, endsAt: newEnd }
        });
        if (claimed.count === 0) {
          throw new HttpAuthError(409, "status_conflict", "Statut modifié en parallèle. Réessayez.");
        }
        await tx.bookingEvent.create({
          data: { bookingId: booking.id, actorUserId: session.sub, eventType: "rescheduled", payloadJson: JSON.stringify({ newStartsAt: newStart }) }
        });
        await tx.job.updateMany({
          where: { type: "booking_reminder", bookingId: booking.id, status: "pending" },
          data: { status: "cancelled" }
        });
      });

      await scheduleReminders(booking.id, newStart);

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

      const review = await prisma.$transaction(async (tx) => {
        const created = await tx.review.create({
          data: {
            bookingId: params.bookingId,
            salonId: booking.salonId,
            clientId: session.sub,
            rating: body.rating,
            comment: body.comment ?? null
          }
        });
        const agg = await tx.review.aggregate({ where: { salonId: booking.salonId }, _avg: { rating: true } });
        await tx.salon.update({ where: { id: booking.salonId }, data: { averageRating: agg._avg.rating ?? 0 } });
        return created;
      });
      await invalidateCacheTags([
        "catalog:list",
        `catalog:salon:${booking.salonId}`,
        `catalog:reviews:${booking.salonId}`,
        "kpi:pro",
        "kpi:admin"
      ]);

      ok(reply, { id: review.id, rating: review.rating, comment: review.comment, createdAt: review.createdAt.toISOString() }, 201);
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }
}
