import type { FastifyReply, FastifyRequest } from "fastify";

import { availabilityQuerySchema } from "@beauteavenue/contracts";

import { HttpAuthError, requireRole } from "../lib/auth.js";
import { computeAvailableSlots } from "../lib/availability.js";
import { fail, ok } from "../lib/http.js";
import { prisma } from "../lib/prisma.js";

export class CatalogController {
  async list(request: FastifyRequest, reply: FastifyReply) {
    const q = request.query as {
      city?: string;
      category?: string;
      search?: string;
      page?: string;
      pageSize?: string;
    };
    const page = Math.max(0, parseInt(q.page ?? "0", 10));
    const pageSize = Math.min(50, Math.max(1, parseInt(q.pageSize ?? "20", 10)));

    const where = {
      approvalStatus: "approved" as const,
      isVisibleInMarketplace: true,
      ...(q.city && { city: q.city }),
      ...(q.category && { category: q.category }),
      ...(q.search && { name: { contains: q.search, mode: "insensitive" as const } })
    };

    const [items, total] = await Promise.all([
      prisma.salon.findMany({
        where,
        select: {
          id: true,
          name: true,
          category: true,
          city: true,
          neighborhood: true,
          averageRating: true,
          latitude: true,
          longitude: true,
          subscriptionTier: true
        },
        orderBy: [{ subscriptionTier: "desc" }, { averageRating: "desc" }],
        take: pageSize,
        skip: page * pageSize
      }),
      prisma.salon.count({ where })
    ]);

    ok(reply, {
      items: items.map((s) => ({ ...s, featured: s.subscriptionTier === "premium" })),
      total,
      page,
      pageSize
    });
  }

  async detail(request: FastifyRequest, reply: FastifyReply) {
    const params = request.params as { id: string };

    const salon = await prisma.salon.findFirst({
      where: { id: params.id, approvalStatus: "approved" },
      include: {
        services: { where: { isActive: true }, orderBy: { displayOrder: "asc" } },
        gallery: { orderBy: { position: "asc" } }
      }
    });

    if (!salon) {
      fail(reply, 404, "salon_not_found", "Salon introuvable.");
      return;
    }

    ok(reply, {
      id: salon.id,
      name: salon.name,
      category: salon.category,
      city: salon.city,
      neighborhood: salon.neighborhood,
      averageRating: salon.averageRating,
      latitude: salon.latitude,
      longitude: salon.longitude,
      subscriptionTier: salon.subscriptionTier,
      featured: salon.subscriptionTier === "premium",
      description: salon.description,
      address: salon.address,
      gallery: salon.gallery.map((g) => g.url),
      services: salon.services.map((s) => ({
        id: s.id,
        name: s.name,
        durationMinutes: s.durationMinutes,
        priceXof: s.priceXof,
        depositRequiredXof: s.depositMode !== "none" ? (s.depositAmountXof ?? null) : null
      }))
    });
  }

  async availability(request: FastifyRequest, reply: FastifyReply) {
    const params = request.params as { id: string };
    const query = availabilityQuerySchema.parse(request.query);

    const salon = await prisma.salon.findFirst({
      where: { id: params.id, approvalStatus: "approved" }
    });
    if (!salon) {
      fail(reply, 404, "salon_not_found", "Salon introuvable.");
      return;
    }

    const service = await prisma.service.findFirst({
      where: { id: query.serviceId, salonId: params.id, isActive: true }
    });
    if (!service) {
      fail(reply, 404, "service_not_found", "Service introuvable.");
      return;
    }

    const date = new Date(query.date + "T00:00:00");
    const dayOfWeek = date.getDay();
    const nextDay = new Date(date);
    nextDay.setDate(nextDay.getDate() + 1);

    const [salonHour, blockedSlots, existingBookings, employees] = await Promise.all([
      prisma.salonHours.findUnique({ where: { salonId_dayOfWeek: { salonId: params.id, dayOfWeek } } }),
      prisma.blockedSlot.findMany({
        where: { salonId: params.id, startsAt: { lt: nextDay }, endsAt: { gt: date } }
      }),
      prisma.booking.findMany({
        where: {
          salonId: params.id,
          status: { notIn: ["cancelled"] },
          startsAt: { lt: nextDay },
          endsAt: { gt: date }
        },
        select: { startsAt: true, endsAt: true, employeeId: true }
      }),
      prisma.employee.findMany({
        where: {
          salonId: params.id,
          isActive: true,
          schedulingEnabled: true,
          ...(query.employeeId && { id: query.employeeId })
        }
      })
    ]);

    if (!salonHour) {
      ok(reply, []);
      return;
    }

    const slots = computeAvailableSlots({
      hours: { isOpen: salonHour.isOpen, opensAt: salonHour.opensAt, closesAt: salonHour.closesAt },
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
      requestedEmployeeId: query.employeeId
    });

    ok(reply, slots);
  }

  async reviews(request: FastifyRequest, reply: FastifyReply) {
    const params = request.params as { id: string };
    const q = request.query as { page?: string; pageSize?: string };
    const page = Math.max(0, parseInt(q.page ?? "0", 10));
    const pageSize = Math.min(50, Math.max(1, parseInt(q.pageSize ?? "20", 10)));

    const [reviews, total] = await Promise.all([
      prisma.review.findMany({
        where: { salonId: params.id },
        orderBy: { createdAt: "desc" },
        take: pageSize,
        skip: page * pageSize,
        select: { id: true, rating: true, comment: true, createdAt: true, responseText: true, updatedAt: true }
      }),
      prisma.review.count({ where: { salonId: params.id } })
    ]);

    ok(reply, {
      items: reviews.map((r) => ({
        id: r.id,
        rating: r.rating,
        comment: r.comment,
        createdAt: r.createdAt.toISOString(),
        responseText: r.responseText,
        responseAt: r.updatedAt.toISOString()
      })),
      total
    });
  }

  async pricing(_request: FastifyRequest, reply: FastifyReply) {
    const keys = ["subscription_standard_price_xof", "subscription_premium_price_xof", "commission_rate_percent"];
    const rows = await prisma.platformSetting.findMany({ where: { key: { in: keys } } });
    const map = Object.fromEntries(rows.map((r) => [r.key, r.value]));

    ok(reply, {
      standard: {
        tier: "standard",
        priceXof: parseInt(map["subscription_standard_price_xof"] ?? "15000", 10),
        label: "Standard"
      },
      premium: {
        tier: "premium",
        priceXof: parseInt(map["subscription_premium_price_xof"] ?? "25000", 10),
        label: "Premium"
      },
      commissionPercent: parseFloat(map["commission_rate_percent"] ?? "5")
    });
  }

  async addFavorite(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const params = request.params as { salonId: string };

      const salon = await prisma.salon.findFirst({ where: { id: params.salonId, approvalStatus: "approved" } });
      if (!salon) { fail(reply, 404, "salon_not_found", "Salon introuvable."); return; }

      await prisma.favorite.create({ data: { userId: session.sub, salonId: params.salonId } });
      ok(reply, { added: true }, 201);
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      // P2002 = unique constraint — already favorited
      fail(reply, 409, "already_favorited", "Salon déjà en favoris.");
    }
  }

  async removeFavorite(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const params = request.params as { salonId: string };
      await prisma.favorite.deleteMany({ where: { userId: session.sub, salonId: params.salonId } });
      ok(reply, { removed: true });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }

  async listFavorites(request: FastifyRequest, reply: FastifyReply) {
    try {
      const session = requireRole(request, ["client"]);
      const favorites = await prisma.favorite.findMany({
        where: { userId: session.sub },
        include: {
          salon: {
            select: {
              id: true, name: true, category: true, city: true,
              neighborhood: true, averageRating: true, latitude: true,
              longitude: true, subscriptionTier: true
            }
          }
        },
        orderBy: { createdAt: "desc" }
      });
      ok(reply, favorites.map((f) => ({ ...f.salon, featured: f.salon.subscriptionTier === "premium" })));
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }
}
