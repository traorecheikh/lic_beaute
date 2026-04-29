import type { FastifyReply, FastifyRequest } from "fastify";

import {
  proBlockedSlotCreateInputSchema,
  proHoursUpdateInputSchema,
  proManualBookingInputSchema,
  proReviewResponseInputSchema,
  proSalonUpdateInputSchema,
  proServiceCreateInputSchema,
  proServiceUpdateInputSchema,
  proStaffCreateInputSchema,
  proStaffUpdateInputSchema,
  proSubscriptionCheckoutInputSchema,
  proSubscriptionUpdateInputSchema
} from "@beauteavenue/contracts";

import { createPaymentAdapter } from "../adapters/index.js";
import { config } from "../config.js";
import { HttpAuthError, requireRole } from "../lib/auth.js";
import { fail, ok } from "../lib/http.js";
import { logger } from "../lib/logger.js";
import { prisma } from "../lib/prisma.js";
import { getProAnalytics, getProDashboard } from "./pro-data.js";

const paymentAdapter = createPaymentAdapter(config.paymentDriver);

async function ensurePro(request: FastifyRequest) {
  const { sub, role } = requireRole(request, ["salon_owner", "salon_staff"]);
  const user = await prisma.user.findUnique({ where: { id: sub }, select: { salonId: true } });
  if (!user?.salonId) throw new HttpAuthError(403, "not_in_salon", "Vous n'êtes associé à aucun salon.");
  return { userId: sub, salonId: user.salonId, role };
}

function ownerOnly(role: string, reply: FastifyReply): boolean {
  if (role !== "salon_owner") {
    fail(reply, 403, "owner_only", "Action réservée au propriétaire du salon.");
    return false;
  }
  return true;
}

function handleError(error: unknown, reply: FastifyReply) {
  if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
  logger.error("Pro error", { error: String(error) });
  fail(reply, 500, "internal_error", "Erreur interne.");
}

export class ProController {
  // ─── Dashboard ─────────────────────────────────────────────────────────────

  async dashboard(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      ok(reply, await getProDashboard(salonId, role));
    } catch (e) { handleError(e, reply); }
  }

  // ─── Salon profile ─────────────────────────────────────────────────────────

  async getSalon(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const salon = await prisma.salon.findUnique({
        where: { id: salonId },
        include: { gallery: { orderBy: { position: "asc" } }, salonHours: { orderBy: { dayOfWeek: "asc" } } }
      });
      if (!salon) { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }
      ok(reply, {
        id: salon.id, name: salon.name, description: salon.description, city: salon.city,
        address: salon.address, neighborhood: salon.neighborhood, averageRating: salon.averageRating,
        subscriptionTier: salon.subscriptionTier, isVisibleInMarketplace: salon.isVisibleInMarketplace,
        canReceiveBookings: salon.canReceiveBookings,
        gallery: salon.gallery.map((g) => g.url),
        hours: salon.salonHours.map((h) => ({ dayOfWeek: h.dayOfWeek, isOpen: h.isOpen, opensAt: h.opensAt, closesAt: h.closesAt }))
      });
    } catch (e) { handleError(e, reply); }
  }

  async updateSalon(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const body = proSalonUpdateInputSchema.parse(request.body);
      const salon = await prisma.salon.update({ where: { id: salonId }, data: body });
      await prisma.auditLog.create({
        data: { action: "pro_salon_updated", summary: `Salon ${salonId} mis à jour`, entityType: "Salon", entityId: salonId, actorName: "salon_owner", severity: "info", payloadJson: JSON.stringify(body) }
      });
      ok(reply, { id: salon.id, name: salon.name, city: salon.city, address: salon.address, description: salon.description });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Services ──────────────────────────────────────────────────────────────

  async listServices(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const services = await prisma.service.findMany({
        where: { salonId, isActive: true },
        orderBy: { displayOrder: "asc" }
      });
      ok(reply, services.map((s) => ({ id: s.id, name: s.name, durationMinutes: s.durationMinutes, priceXof: s.priceXof, depositMode: s.depositMode, depositAmountXof: s.depositAmountXof, depositPercent: s.depositPercent, isActive: s.isActive, displayOrder: s.displayOrder })));
    } catch (e) { handleError(e, reply); }
  }

  async createService(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const body = proServiceCreateInputSchema.parse(request.body);
      if (body.depositMode === "fixed" && !body.depositAmountXof) {
        fail(reply, 422, "invalid_deposit", "depositAmountXof requis pour depositMode=fixed."); return;
      }
      if (body.depositMode === "percent" && !body.depositPercent) {
        fail(reply, 422, "invalid_deposit", "depositPercent requis pour depositMode=percent."); return;
      }
      const count = await prisma.service.count({ where: { salonId } });
      const service = await prisma.service.create({
        data: { salonId, displayOrder: count, ...body }
      });
      ok(reply, { id: service.id, name: service.name, durationMinutes: service.durationMinutes, priceXof: service.priceXof, depositMode: service.depositMode, depositAmountXof: service.depositAmountXof, depositPercent: service.depositPercent, isActive: service.isActive, displayOrder: service.displayOrder }, 201);
    } catch (e) { handleError(e, reply); }
  }

  async updateService(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const params = request.params as { serviceId: string };
      const body = proServiceUpdateInputSchema.parse(request.body);
      const existing = await prisma.service.findFirst({ where: { id: params.serviceId, salonId } });
      if (!existing) { fail(reply, 404, "service_not_found", "Service introuvable."); return; }
      const service = await prisma.service.update({ where: { id: params.serviceId }, data: body });
      ok(reply, { id: service.id, name: service.name, durationMinutes: service.durationMinutes, priceXof: service.priceXof, depositMode: service.depositMode, depositAmountXof: service.depositAmountXof, depositPercent: service.depositPercent, isActive: service.isActive, displayOrder: service.displayOrder });
    } catch (e) { handleError(e, reply); }
  }

  async deleteService(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const params = request.params as { serviceId: string };
      const existing = await prisma.service.findFirst({ where: { id: params.serviceId, salonId } });
      if (!existing) { fail(reply, 404, "service_not_found", "Service introuvable."); return; }
      await prisma.service.update({ where: { id: params.serviceId }, data: { isActive: false } });
      ok(reply, { deleted: true });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Staff ─────────────────────────────────────────────────────────────────

  async listStaff(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const staff = await prisma.employee.findMany({
        where: { salonId },
        include: { specialties: { select: { serviceId: true } } }
      });
      ok(reply, staff.map((e) => ({ id: e.id, userId: e.userId, displayName: e.displayName, isActive: e.isActive, schedulingEnabled: e.schedulingEnabled, serviceIds: e.specialties.map((s) => s.serviceId) })));
    } catch (e) { handleError(e, reply); }
  }

  async createStaff(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const body = proStaffCreateInputSchema.parse(request.body);

      const result = await prisma.$transaction(async (tx) => {
        const existing = await tx.user.findUnique({ where: { phone: body.phone } });
        if (existing && existing.salonId && existing.salonId !== salonId) {
          throw new HttpAuthError(409, "user_in_other_salon", "Cet utilisateur appartient à un autre salon.");
        }

        const user = existing ?? await tx.user.create({
          data: { fullName: body.fullName, phone: body.phone, role: "salon_staff", salonId }
        });

        if (!existing) {
          await tx.user.update({ where: { id: user.id }, data: { salonId } });
        }

        const employee = await tx.employee.create({
          data: { salonId, userId: user.id, displayName: body.fullName }
        });

        if (body.serviceIds.length > 0) {
          await tx.employeeSpecialty.createMany({
            data: body.serviceIds.map((serviceId) => ({ employeeId: employee.id, serviceId }))
          });
        }

        return { employee, serviceIds: body.serviceIds };
      });

      ok(reply, { id: result.employee.id, displayName: result.employee.displayName, isActive: result.employee.isActive, schedulingEnabled: result.employee.schedulingEnabled, serviceIds: result.serviceIds }, 201);
    } catch (e) { handleError(e, reply); }
  }

  async updateStaff(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const params = request.params as { employeeId: string };
      const body = proStaffUpdateInputSchema.parse(request.body);
      const existing = await prisma.employee.findFirst({ where: { id: params.employeeId, salonId } });
      if (!existing) { fail(reply, 404, "employee_not_found", "Employé introuvable."); return; }

      await prisma.$transaction(async (tx) => {
        await tx.employee.update({
          where: { id: params.employeeId },
          data: { displayName: body.displayName, isActive: body.isActive, schedulingEnabled: body.schedulingEnabled }
        });
        if (body.serviceIds !== undefined) {
          await tx.employeeSpecialty.deleteMany({ where: { employeeId: params.employeeId } });
          if (body.serviceIds.length > 0) {
            await tx.employeeSpecialty.createMany({
              data: body.serviceIds.map((serviceId) => ({ employeeId: params.employeeId, serviceId }))
            });
          }
        }
      });

      ok(reply, { updated: true });
    } catch (e) { handleError(e, reply); }
  }

  async deleteStaff(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const params = request.params as { employeeId: string };
      const existing = await prisma.employee.findFirst({ where: { id: params.employeeId, salonId } });
      if (!existing) { fail(reply, 404, "employee_not_found", "Employé introuvable."); return; }
      await prisma.employee.update({ where: { id: params.employeeId }, data: { isActive: false } });
      ok(reply, { deleted: true });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Hours ─────────────────────────────────────────────────────────────────

  async getHours(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const hours = await prisma.salonHours.findMany({ where: { salonId }, orderBy: { dayOfWeek: "asc" } });
      ok(reply, hours.map((h) => ({ dayOfWeek: h.dayOfWeek, isOpen: h.isOpen, opensAt: h.opensAt, closesAt: h.closesAt })));
    } catch (e) { handleError(e, reply); }
  }

  async updateHours(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const body = proHoursUpdateInputSchema.parse(request.body);
      if (!body.some((h) => h.isOpen)) { fail(reply, 422, "no_open_day", "Au moins un jour doit être ouvert."); return; }

      await prisma.$transaction(
        body.map((h) =>
          prisma.salonHours.upsert({
            where: { salonId_dayOfWeek: { salonId, dayOfWeek: h.dayOfWeek } },
            create: { salonId, dayOfWeek: h.dayOfWeek, isOpen: h.isOpen, opensAt: h.opensAt ?? null, closesAt: h.closesAt ?? null },
            update: { isOpen: h.isOpen, opensAt: h.opensAt ?? null, closesAt: h.closesAt ?? null }
          })
        )
      );

      ok(reply, { updated: true });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Blocked slots ─────────────────────────────────────────────────────────

  async listBlockedSlots(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const slots = await prisma.blockedSlot.findMany({ where: { salonId }, orderBy: { startsAt: "asc" } });
      ok(reply, slots.map((s) => ({ id: s.id, startsAt: s.startsAt.toISOString(), endsAt: s.endsAt.toISOString(), reason: s.reason, scope: s.scope, employeeId: s.employeeId })));
    } catch (e) { handleError(e, reply); }
  }

  async createBlockedSlot(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, userId } = await ensurePro(request);
      const body = proBlockedSlotCreateInputSchema.parse(request.body);
      const slot = await prisma.blockedSlot.create({
        data: { salonId, startsAt: new Date(body.startsAt), endsAt: new Date(body.endsAt), reason: body.reason ?? null, scope: body.scope, employeeId: body.employeeId ?? null, createdByUserId: userId }
      });
      ok(reply, { id: slot.id, startsAt: slot.startsAt.toISOString(), endsAt: slot.endsAt.toISOString(), reason: slot.reason, scope: slot.scope, employeeId: slot.employeeId }, 201);
    } catch (e) { handleError(e, reply); }
  }

  async deleteBlockedSlot(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const params = request.params as { slotId: string };
      const existing = await prisma.blockedSlot.findFirst({ where: { id: params.slotId, salonId } });
      if (!existing) { fail(reply, 404, "slot_not_found", "Créneau bloqué introuvable."); return; }
      await prisma.blockedSlot.delete({ where: { id: params.slotId } });
      ok(reply, { deleted: true });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Bookings ──────────────────────────────────────────────────────────────

  async listBookings(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const q = request.query as { status?: string; date?: string; page?: string; pageSize?: string };
      const page = Math.max(0, parseInt(q.page ?? "0", 10));
      const pageSize = Math.min(50, Math.max(1, parseInt(q.pageSize ?? "20", 10)));

      const where: Record<string, unknown> = { salonId };
      if (q.status) where.status = q.status;
      if (q.date) {
        const d = new Date(q.date + "T00:00:00");
        const next = new Date(d); next.setDate(next.getDate() + 1);
        where.startsAt = { gte: d, lt: next };
      }

      const bookings = await prisma.booking.findMany({
        where,
        include: { client: { select: { fullName: true, phone: true } }, service: { select: { name: true } }, employee: { select: { displayName: true } }, payments: { take: 1, orderBy: { createdAt: "desc" } } },
        orderBy: [{ status: "asc" }, { startsAt: "asc" }],
        take: pageSize,
        skip: page * pageSize
      });

      ok(reply, bookings.map((b) => ({
        id: b.id, salonId: b.salonId, serviceId: b.serviceId, serviceName: b.service.name,
        employeeId: b.employeeId, employeeName: b.employee?.displayName ?? null,
        clientId: b.clientId, clientName: b.client?.fullName ?? null, clientPhone: b.client?.phone ?? null,
        startsAt: b.startsAt.toISOString(), endsAt: b.endsAt.toISOString(),
        status: b.status, source: b.source, depositAmountXof: b.depositAmountXof,
        createdAt: b.createdAt.toISOString()
      })));
    } catch (e) { handleError(e, reply); }
  }

  async getBooking(request: FastifyRequest, reply: FastifyReply) {
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
        payments: booking.payments.map((p) => ({ id: p.id, status: p.status, amountXof: p.amountXof, provider: p.provider })),
        events: booking.bookingEvents.map((e) => ({ eventType: e.eventType, fromStatus: e.fromStatus, toStatus: e.toStatus, createdAt: e.createdAt.toISOString() }))
      });
    } catch (e) { handleError(e, reply); }
  }

  private async transitionBooking(
    request: FastifyRequest, reply: FastifyReply,
    allowedFrom: string[], toStatus: string, eventType: string,
    afterHook?: (bookingId: string, tx: Parameters<Parameters<typeof prisma.$transaction>[0]>[0]) => Promise<void>
  ) {
    try {
      const { salonId, userId } = await ensurePro(request);
      const params = request.params as { bookingId: string };
      const booking = await prisma.booking.findFirst({ where: { id: params.bookingId, salonId } });
      if (!booking) { fail(reply, 404, "booking_not_found", "Réservation introuvable."); return; }
      if (!allowedFrom.includes(booking.status)) {
        fail(reply, 422, "invalid_status", `Transition invalide depuis ${booking.status}.`); return;
      }

      await prisma.$transaction(async (tx) => {
        await tx.booking.update({ where: { id: booking.id }, data: { status: toStatus as never } });
        await tx.bookingEvent.create({ data: { bookingId: booking.id, actorUserId: userId, eventType, fromStatus: booking.status, toStatus } });
        if (afterHook) await afterHook(booking.id, tx);
      });

      ok(reply, { status: toStatus });
    } catch (e) { handleError(e, reply); }
  }

  async acceptBooking(request: FastifyRequest, reply: FastifyReply) {
    await this.transitionBooking(request, reply, ["pending"], "confirmed", "accepted");
  }

  async rejectBooking(request: FastifyRequest, reply: FastifyReply) {
    const { salonId } = await ensurePro(request).catch(() => ({ salonId: "" }));
    await this.transitionBooking(request, reply, ["pending", "confirmed"], "cancelled", "rejected", async (bookingId, tx) => {
      const payment = await tx.payment.findFirst({ where: { bookingId, status: { in: ["authorized", "succeeded"] } } });
      if (payment) {
        await tx.job.create({
          data: { queue: "payments", type: "refund_reconciliation", payloadJson: JSON.stringify({ paymentId: payment.id, bookingId }), status: "pending" }
        });
      }
    });
  }

  async startBooking(request: FastifyRequest, reply: FastifyReply) {
    await this.transitionBooking(request, reply, ["confirmed"], "in_progress", "started");
  }

  async completeBooking(request: FastifyRequest, reply: FastifyReply) {
    await this.transitionBooking(request, reply, ["in_progress"], "completed", "completed", async (bookingId, tx) => {
      await tx.job.create({
        data: { queue: "payments", type: "deposit_settlement", payloadJson: JSON.stringify({ bookingId }), status: "pending" }
      });
    });
  }

  async createManualBooking(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, userId } = await ensurePro(request);
      const body = proManualBookingInputSchema.parse(request.body);

      const service = await prisma.service.findFirst({ where: { id: body.serviceId, salonId, isActive: true } });
      if (!service) { fail(reply, 404, "service_not_found", "Service introuvable."); return; }

      const startsAt = new Date(body.startsAt);
      const endsAt = new Date(startsAt.getTime() + service.durationMinutes * 60 * 1000);

      const booking = await prisma.$transaction(async (tx) => {
        const b = await tx.booking.create({
          data: {
            clientId: userId,
            salonId,
            serviceId: body.serviceId,
            employeeId: body.employeeId ?? null,
            startsAt,
            endsAt,
            status: "confirmed",
            source: "manual",
            depositAmountXof: 0,
            clientNote: body.clientName ? `Client: ${body.clientName}${body.clientPhone ? ` (${body.clientPhone})` : ""}` : null
          }
        });
        await tx.bookingEvent.create({ data: { bookingId: b.id, actorUserId: userId, eventType: "created_manual", toStatus: "confirmed" } });
        return b;
      });

      ok(reply, { id: booking.id, startsAt: booking.startsAt.toISOString(), endsAt: booking.endsAt.toISOString(), status: booking.status, source: booking.source }, 201);
    } catch (e) { handleError(e, reply); }
  }

  // ─── Reviews ───────────────────────────────────────────────────────────────

  async listReviews(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId } = await ensurePro(request);
      const reviews = await prisma.review.findMany({
        where: { salonId }, orderBy: { createdAt: "desc" },
        select: { id: true, rating: true, comment: true, createdAt: true, responseText: true, updatedAt: true, clientId: true }
      });
      ok(reply, reviews.map((r) => ({ id: r.id, rating: r.rating, comment: r.comment, createdAt: r.createdAt.toISOString(), responseText: r.responseText, responseAt: r.updatedAt.toISOString(), clientId: r.clientId })));
    } catch (e) { handleError(e, reply); }
  }

  async respondToReview(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, userId } = await ensurePro(request);
      const params = request.params as { reviewId: string };
      const body = proReviewResponseInputSchema.parse(request.body);
      const review = await prisma.review.findFirst({ where: { id: params.reviewId, salonId } });
      if (!review) { fail(reply, 404, "review_not_found", "Avis introuvable."); return; }
      await prisma.review.update({ where: { id: params.reviewId }, data: { responseText: body.responseText, responseByUserId: userId } });
      ok(reply, { updated: true });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Analytics ─────────────────────────────────────────────────────────────

  async analytics(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const q = request.query as { period?: string };
      const period = (["7d", "30d", "90d"].includes(q.period ?? "") ? q.period : "30d") as "7d" | "30d" | "90d";
      ok(reply, await getProAnalytics(salonId, period));
    } catch (e) { handleError(e, reply); }
  }

  // ─── Subscription ──────────────────────────────────────────────────────────

  async getSubscription(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const sub = await prisma.subscription.findUnique({ where: { salonId } });
      if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }
      ok(reply, { id: sub.id, tier: sub.tier, status: sub.status, renewsAt: sub.renewedAt?.toISOString() ?? null, expiresAt: sub.expiresAt?.toISOString() ?? null, isComplimentary: sub.isComplimentary, autoRenew: sub.autoRenew });
    } catch (e) { handleError(e, reply); }
  }

  async updateSubscription(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const body = proSubscriptionUpdateInputSchema.parse(request.body);
      await prisma.subscription.update({ where: { salonId }, data: { autoRenew: body.autoRenew } });
      ok(reply, { updated: true });
    } catch (e) { handleError(e, reply); }
  }

  async subscriptionCheckout(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const body = proSubscriptionCheckoutInputSchema.parse(request.body);

      const sub = await prisma.subscription.findUnique({ where: { salonId } });
      if (!sub) { fail(reply, 404, "subscription_not_found", "Abonnement introuvable."); return; }

      const priceRows = await prisma.platformSetting.findMany({
        where: { key: { in: ["subscription_premium_price_xof"] } }
      });
      const priceMap = Object.fromEntries(priceRows.map((r) => [r.key, r.value]));
      const amountXof = parseInt(priceMap["subscription_premium_price_xof"] ?? "25000", 10);
      const idempotencyKey = `sub-${sub.id}-${body.action}-${Date.now()}`;

      const charge = await prisma.subscriptionCharge.create({
        data: { subscriptionId: sub.id, provider: body.provider, amountXof, idempotencyKey, chargeType: body.action }
      });

      const result = await paymentAdapter.initiateDeposit({
        paymentId: charge.id,
        amountXof,
        description: `Abonnement ${body.action}`,
        callbackUrl: `${config.webOrigin}/pro/subscription/callback`,
        idempotencyKey
      });

      await prisma.subscriptionCharge.update({ where: { id: charge.id }, data: { providerTxId: result.providerRef } });

      ok(reply, { redirectUrl: result.redirectUrl, chargeId: charge.id });
    } catch (e) { handleError(e, reply); }
  }

  // ─── Payouts ───────────────────────────────────────────────────────────────

  async listPayouts(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const events = await prisma.settlementEvent.findMany({
        where: { booking: { salonId } },
        orderBy: { createdAt: "desc" }
      });
      ok(reply, events.map((e) => ({ id: e.id, bookingId: e.bookingId, eventType: e.eventType, amountXof: e.amountXof, createdAt: e.createdAt.toISOString() })));
    } catch (e) { handleError(e, reply); }
  }

  // ─── Invoices ──────────────────────────────────────────────────────────────

  async listInvoices(request: FastifyRequest, reply: FastifyReply) {
    try {
      const { salonId, role } = await ensurePro(request);
      if (!ownerOnly(role, reply)) return;
      const sub = await prisma.subscription.findUnique({ where: { salonId } });
      if (!sub) { ok(reply, []); return; }
      const invoices = await prisma.billingInvoice.findMany({
        where: { subscriptionId: sub.id },
        orderBy: { createdAt: "desc" }
      });
      ok(reply, invoices.map((i) => ({ id: i.id, invoiceNumber: i.invoiceNumber, amountXof: i.amountXof, status: i.status, createdAt: i.createdAt.toISOString() })));
    } catch (e) { handleError(e, reply); }
  }
}
