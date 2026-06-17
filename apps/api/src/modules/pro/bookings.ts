import type { FastifyReply, FastifyRequest } from "fastify";
import type { Prisma } from "../../generated/prisma/client.js";

import { HttpAuthError } from "../../lib/auth/index.js";
import { fetchAndComputeAvailableSlots } from "../../lib/availability.js";
import { invalidateCacheTags } from "../../lib/cache.js";
import { enqueueJob } from "../../lib/jobs.js";
import { fail, handleError, ok } from "../../lib/http.js";
import { toPublicGatewayProvider } from "../../lib/payment-provider.js";
import { prisma } from "../../lib/db/prisma.js";

import { proManualBookingInputSchema } from "@beauteavenue/contracts";

import {
  ensurePro,
  ensureProWriteAccess,
  calcDepositAmount
} from "./shared.js";

async function transitionBooking(
  request: FastifyRequest, reply: FastifyReply,
  allowedFrom: string[], toStatus: string, eventType: string,
  afterHook?: (bookingId: string, tx: Parameters<Parameters<typeof prisma.$transaction>[0]>[0]) => Promise<void>
) {
  try {
    const { salonId, userId } = await ensurePro(request);
    if (!(await ensureProWriteAccess(salonId, reply))) return;
    const params = request.params as { bookingId: string };
    const booking = await prisma.booking.findFirst({ where: { id: params.bookingId, salonId } });
    if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable."); return; }
    if (!allowedFrom.includes(booking.status)) {
      fail(reply, 422, "invalid_status", `Transition invalide depuis ${booking.status}.`); return;
    }

    await prisma.$transaction(async (tx) => {
      const claimed = await tx.booking.updateMany({
        where: { id: booking.id, status: { in: allowedFrom as never[] } },
        data: { status: toStatus as never }
      });
      if (claimed.count === 0) {
        throw new HttpAuthError(409, "status_conflict", "Statut modifié en parallèle. Réessayez.");
      }
      await tx.bookingEvent.create({ data: { bookingId: booking.id, actorUserId: userId, eventType, fromStatus: booking.status, toStatus } });
      await tx.auditLog.create({
        data: {
          action: `booking_${eventType}`,
          summary: `Transition ${booking.id}: ${booking.status} -> ${toStatus}`,
          entityType: "Booking",
          entityId: booking.id,
          actorName: "pro",
          actorUserId: userId,
          severity: toStatus === "cancelled" ? "warn" : "info",
          payloadJson: JSON.stringify({
            bookingId: booking.id,
            salonId,
            fromStatus: booking.status,
            toStatus,
            eventType
          })
        }
      });
      if (afterHook) await afterHook(booking.id, tx);
    });

    ok(reply, { status: toStatus });
  } catch (e) { handleError(e, reply); }
}

export async function listBookings(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, userId, role } = await ensurePro(request);
    const q = request.query as { status?: string; date?: string; page?: string; pageSize?: string };
    const page = Math.max(0, parseInt(q.page ?? "0", 10));
    const pageSize = Math.min(50, Math.max(1, parseInt(q.pageSize ?? "20", 10)));

    const where: Prisma.BookingWhereInput = { salonId };

    if (role === "salon_staff") {
      const employee = await prisma.employee.findFirst({ where: { userId, salonId } });
      if (employee) {
        where.employeeId = employee.id;
      } else {
        where.id = "none";
      }
    }

    if (q.status) where.status = q.status as any;
    if (q.date) {
      const d = new Date(q.date + "T00:00:00");
      const next = new Date(d); next.setDate(next.getDate() + 1);
      where.startsAt = { gte: d, lt: next };
    }

    const [total, bookings] = await Promise.all([
      prisma.booking.count({ where }),
      prisma.booking.findMany({
        where,
        include: { client: { select: { fullName: true, phone: true } }, service: { select: { name: true } }, employee: { select: { displayName: true } }, payments: { take: 1, orderBy: { createdAt: "desc" } } },
        orderBy: [{ status: "asc" }, { startsAt: "asc" }],
        take: pageSize,
        skip: page * pageSize
      })
    ]);

    ok(reply, {
      items: bookings.map((b) => ({
        id: b.id, salonId: b.salonId, serviceId: b.serviceId, serviceName: b.service.name,
        employeeId: b.employeeId, employeeName: b.employee?.displayName ?? null,
        clientId: b.clientId, clientName: b.client?.fullName ?? null, clientPhone: b.client?.phone ?? null,
        startsAt: b.startsAt.toISOString(), endsAt: b.endsAt.toISOString(),
        status: b.status, source: b.source, depositAmountXof: b.depositAmountXof,
        createdAt: b.createdAt.toISOString()
      })),
      total,
      page,
      pageSize
    });
  } catch (e) { handleError(e, reply); }
}

export async function getBooking(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId } = await ensurePro(request);
    const params = request.params as { bookingId: string };
    const booking = await prisma.booking.findFirst({
      where: { id: params.bookingId, salonId },
      include: {
        client: { select: { fullName: true, phone: true } },
        service: { select: { name: true } },
        employee: { select: { displayName: true } },
        payments: { orderBy: { createdAt: "desc" } },
        bookingEvents: { orderBy: { createdAt: "asc" } }
      }
    });
    if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable."); return; }
    ok(reply, {
      id: booking.id, salonId: booking.salonId, serviceId: booking.serviceId, serviceName: booking.service.name,
      employeeId: booking.employeeId, employeeName: booking.employee?.displayName ?? null,
      clientId: booking.clientId, clientName: booking.client?.fullName ?? null, clientPhone: booking.client?.phone ?? null,
      startsAt: booking.startsAt.toISOString(), endsAt: booking.endsAt.toISOString(),
      status: booking.status, source: booking.source, depositAmountXof: booking.depositAmountXof,
      createdAt: booking.createdAt.toISOString(),
      payments: booking.payments.map((p) => ({ id: p.id, status: p.status, amountXof: p.amountXof, provider: toPublicGatewayProvider(p.provider) })),
      events: booking.bookingEvents.map((e) => ({ eventType: e.eventType, fromStatus: e.fromStatus, toStatus: e.toStatus, createdAt: e.createdAt.toISOString() }))
    });
  } catch (e) { handleError(e, reply); }
}

export async function acceptBooking(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId } = await ensurePro(request);
    const params = request.params as { bookingId: string };
    const booking = await prisma.booking.findFirst({
      where: { id: params.bookingId, salonId },
      include: {
        payments: {
          where: { status: { in: ["authorized", "succeeded"] } },
          take: 1
        }
      }
    });
    if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable."); return; }
    if (booking.depositAmountXof > 0 && booking.payments.length === 0) {
      fail(
        reply,
        422,
        "deposit_not_paid",
        "Acompte non payé. La réservation reste en attente jusqu'au paiement."
      );
      return;
    }
  } catch (e) {
    handleError(e, reply);
    return;
  }
  await transitionBooking(request, reply, ["pending"], "confirmed", "accepted", async (bookingId, tx) => {
    const b = await tx.booking.findUnique({ where: { id: bookingId }, select: { startsAt: true, clientId: true } });
    if (!b) return;
    const now = Date.now();
    const runAfter24h = new Date(b.startsAt.getTime() - 24 * 60 * 60 * 1000);
    const runAfter1h = new Date(b.startsAt.getTime() - 60 * 60 * 1000);
    if (runAfter24h.getTime() > now) {
      await enqueueJob({ type: "booking_reminder", payload: { bookingId, window: "24h" }, bookingId, runAfter: runAfter24h, dbClient: tx });
    }
    if (runAfter1h.getTime() > now) {
      await enqueueJob({ type: "booking_reminder", payload: { bookingId, window: "1h" }, bookingId, runAfter: runAfter1h, dbClient: tx });
    }
  });
}

export async function rejectBooking(request: FastifyRequest, reply: FastifyReply) {
  await transitionBooking(request, reply, ["pending", "confirmed"], "cancelled", "rejected", async (bookingId, tx) => {
    const payment = await tx.payment.findFirst({ where: { bookingId, status: { in: ["authorized", "succeeded"] } } });
    if (payment) {
      await enqueueJob({
        type: "refund_reconciliation",
        payload: { paymentId: payment.id, bookingId },
        dbClient: tx
      });
    }
  });
  await invalidateCacheTags(["kpi:pro", "kpi:admin"]);
}

export async function startBooking(request: FastifyRequest, reply: FastifyReply) {
  await transitionBooking(request, reply, ["confirmed"], "in_progress", "started");
}

export async function completeBooking(request: FastifyRequest, reply: FastifyReply) {
  await transitionBooking(request, reply, ["in_progress"], "completed", "completed", async (bookingId, tx) => {
    await enqueueJob({ type: "deposit_settlement", payload: { bookingId }, dbClient: tx });
  });
  await invalidateCacheTags(["kpi:pro", "kpi:admin"]);
}

export async function createManualBooking(request: FastifyRequest, reply: FastifyReply) {
  try {
    const { salonId, userId } = await ensurePro(request);
    if (!(await ensureProWriteAccess(salonId, reply))) return;
    const body = proManualBookingInputSchema.parse(request.body);

    const service = await prisma.service.findFirst({ where: { id: body.serviceId, salonId, isActive: true } });
    if (!service) { fail(reply, 422, "service_not_found", "Service introuvable."); return; }

    const startsAt = new Date(body.startsAt);
    if (startsAt.getTime() <= Date.now()) {
      fail(reply, 422, "invalid_start_time", "La réservation doit être planifiée dans le futur.");
      return;
    }
    const endsAt = new Date(startsAt.getTime() + service.durationMinutes * 60 * 1000);

    if (body.employeeId) {
      const employee = await prisma.employee.findFirst({
        where: { id: body.employeeId, salonId, isActive: true, schedulingEnabled: true },
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

    const availableSlots = await fetchAndComputeAvailableSlots(prisma, {
      salonId,
      date: new Date(startsAt.getFullYear(), startsAt.getMonth(), startsAt.getDate()),
      durationMinutes: service.durationMinutes,
      employeeId: body.employeeId
    });

    const slotAvailable = availableSlots.some((s) => new Date(s.startsAt).getTime() === startsAt.getTime());
    if (!slotAvailable) {
      fail(reply, 422, "slot_unavailable", "Ce créneau n'est plus disponible.");
      return;
    }

    const booking = await prisma.$transaction(async (tx) => {
      let resolvedClientId = body.clientId;

      if (!resolvedClientId) {
        if (!body.clientPhone) {
          throw new HttpAuthError(422, "client_required", "Client ou numéro de téléphone requis.");
        }

        const existingClient = await tx.user.findUnique({
          where: { phone: body.clientPhone }
        });

        if (existingClient) {
          if (existingClient.role !== "client") {
            throw new HttpAuthError(422, "client_role_invalid", "Le contact fourni n'est pas un compte client.");
          }
          resolvedClientId = existingClient.id;
        } else {
          const newClient = await tx.user.create({
            data: {
              fullName: body.clientName || body.clientPhone,
              phone: body.clientPhone,
              role: "client"
            }
          });
          resolvedClientId = newClient.id;
        }
      } else {
        const clientExists = await tx.user.findUnique({ where: { id: resolvedClientId } });
        if (!clientExists) throw new HttpAuthError(404, "client_not_found", "Client introuvable.");
        if (clientExists.role !== "client") {
          throw new HttpAuthError(422, "client_role_invalid", "Le client sélectionné est invalide.");
        }
      }

      const depositAmountXof = calcDepositAmount(service);
      const b = await tx.booking.create({
        data: {
          clientId: resolvedClientId,
          salonId,
          serviceId: body.serviceId,
          employeeId: body.employeeId ?? null,
          startsAt,
          endsAt,
          status: "confirmed",
          source: "manual",
          depositAmountXof,
          depositPaymentStatus: depositAmountXof > 0 ? "succeeded" : "pending",
          clientNote: body.clientName && !body.clientId ? `Nouveau client: ${body.clientName}` : null
        }
      });
      if (depositAmountXof > 0) {
        await tx.payment.create({
          data: {
            bookingId: b.id,
            provider: "manual",
            status: "succeeded",
            amountXof: depositAmountXof,
            idempotencyKey: `manual-${b.id}-deposit`
          }
        });
      }
      await tx.bookingEvent.create({ data: { bookingId: b.id, actorUserId: userId, eventType: "created_manual", toStatus: "confirmed" } });
      return b;
    });

    ok(reply, { id: booking.id, startsAt: booking.startsAt.toISOString(), endsAt: booking.endsAt.toISOString(), status: booking.status, source: booking.source }, 201);
  } catch (e) { handleError(e, reply); }
}
