import type { FastifyReply, FastifyRequest } from "fastify";

import { availabilityQuerySchema } from "@beauteavenue/contracts";

import { HttpAuthError, requireRole } from "../lib/auth.js";
import { computeAvailableSlots } from "../lib/availability.js";
import { fail, ok } from "../lib/http.js";
import { prisma } from "../lib/prisma.js";

function salonTeamShowPhotosKey(salonId: string) {
  return `salon:${salonId}:team_show_photos`;
}

function salonTeamShowDescriptionsKey(salonId: string) {
  return `salon:${salonId}:team_show_descriptions`;
}

function parseBooleanSetting(value: string | undefined, fallback: boolean) {
  if (!value) return fallback;
  const normalized = value.trim().toLowerCase();
  if (normalized === "true" || normalized === "1" || normalized === "yes") return true;
  if (normalized === "false" || normalized === "0" || normalized === "no") return false;
  return fallback;
}

export class CatalogController {
  async list(request: FastifyRequest, reply: FastifyReply) {
    const q = request.query as {
      city?: string;
      category?: string;
      search?: string;
      page?: string;
      pageSize?: string;
      lat?: string;
      lng?: string;
      sort?: string;
    };
    const page = Math.max(0, parseInt(q.page ?? "0", 10));
    const pageSize = Math.min(50, Math.max(1, parseInt(q.pageSize ?? "20", 10)));
    const lat = q.lat != null ? parseFloat(q.lat) : null;
    const lng = q.lng != null ? parseFloat(q.lng) : null;
    const sort = q.sort ?? "rating";

    // ── Nearby: Haversine raw SQL, 5 km hard filter ──────────────────────────
    if (sort === "nearby" && lat != null && lng != null && !isNaN(lat) && !isNaN(lng)) {
      const cityFilter = q.city ? `AND city = '${q.city.replace(/'/g, "''")}'` : "";
      const categoryFilter = q.category ? `AND category = '${q.category.replace(/'/g, "''")}'` : "";

      type NearbyRow = {
        id: string; name: string; category: string; logoUrl: string | null;
        city: string; neighborhood: string | null; averageRating: number;
        latitude: number; longitude: number; subscriptionTier: string;
        isPrestige: boolean; prestigeScore: number | null;
        distance_km: number; total_count: bigint;
      };

      const rows = await prisma.$queryRaw<NearbyRow[]>`
        SELECT id, name, category, "logoUrl", city, neighborhood,
               "averageRating", latitude, longitude, "subscriptionTier",
               "isPrestige", "prestigeScore",
               6371 * acos(LEAST(1.0,
                 cos(radians(${lat})) * cos(radians(latitude)) *
                 cos(radians(longitude) - radians(${lng})) +
                 sin(radians(${lat})) * sin(radians(latitude))
               )) AS distance_km,
               COUNT(*) OVER() AS total_count
        FROM "Salon"
        WHERE "approvalStatus" = 'approved'
          AND "isVisibleInMarketplace" = true
          AND latitude IS NOT NULL
          AND longitude IS NOT NULL
          AND 6371 * acos(LEAST(1.0,
                cos(radians(${lat})) * cos(radians(latitude)) *
                cos(radians(longitude) - radians(${lng})) +
                sin(radians(${lat})) * sin(radians(latitude))
              )) <= 5
        ORDER BY distance_km ASC
        LIMIT ${pageSize} OFFSET ${page * pageSize}
      `;

      const total = rows.length > 0 ? Number(rows[0].total_count) : 0;
      return ok(reply, {
        items: rows.map((r) => ({
          id: r.id, name: r.name, category: r.category, logoUrl: r.logoUrl,
          city: r.city, neighborhood: r.neighborhood, averageRating: Number(r.averageRating),
          latitude: r.latitude, longitude: r.longitude,
          subscriptionTier: r.subscriptionTier,
          featured: r.subscriptionTier === "premium",
          isPrestige: r.isPrestige,
          prestigeScore: r.prestigeScore != null ? Number(r.prestigeScore) : null,
          distanceKm: Math.round(Number(r.distance_km) * 10) / 10
        })),
        total, page, pageSize
      });
    }

    // ── Trending: sorted by booking count (last 30 days) ────────────────────
    if (sort === "trending") {
      type TrendingRow = {
        id: string; name: string; category: string; logoUrl: string | null;
        city: string; neighborhood: string | null; averageRating: number;
        latitude: number | null; longitude: number | null; subscriptionTier: string;
        isPrestige: boolean; prestigeScore: number | null;
        booking_count: bigint; total_count: bigint;
      };

      const rows = await prisma.$queryRaw<TrendingRow[]>`
        SELECT s.id, s.name, s.category, s."logoUrl", s.city, s.neighborhood,
               s."averageRating", s.latitude, s.longitude, s."subscriptionTier",
               s."isPrestige", s."prestigeScore",
               COUNT(b.id) AS booking_count,
               COUNT(*) OVER() AS total_count
        FROM "Salon" s
        LEFT JOIN "Booking" b ON b."salonId" = s.id
          AND b."createdAt" > NOW() - INTERVAL '30 days'
        WHERE s."approvalStatus" = 'approved'
          AND s."isVisibleInMarketplace" = true
        GROUP BY s.id
        ORDER BY booking_count DESC, s."averageRating" DESC
        LIMIT ${pageSize} OFFSET ${page * pageSize}
      `;

      const total = rows.length > 0 ? Number(rows[0].total_count) : 0;
      return ok(reply, {
        items: rows.map((r) => ({
          id: r.id, name: r.name, category: r.category, logoUrl: r.logoUrl,
          city: r.city, neighborhood: r.neighborhood, averageRating: Number(r.averageRating),
          latitude: r.latitude, longitude: r.longitude,
          subscriptionTier: r.subscriptionTier,
          featured: r.subscriptionTier === "premium",
          isPrestige: r.isPrestige,
          prestigeScore: r.prestigeScore != null ? Number(r.prestigeScore) : null,
          distanceKm: null
        })),
        total, page, pageSize
      });
    }

    // ── Default: sort by rating (with optional city/category/search filters) ─
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
          id: true, name: true, category: true, logoUrl: true, city: true,
          neighborhood: true, averageRating: true, latitude: true, longitude: true,
          subscriptionTier: true, isPrestige: true, prestigeScore: true
        },
        orderBy: [{ subscriptionTier: "desc" }, { averageRating: "desc" }],
        take: pageSize,
        skip: page * pageSize
      }),
      prisma.salon.count({ where })
    ]);

    ok(reply, {
      items: items.map((s) => ({
        ...s,
        featured: s.subscriptionTier === "premium",
        distanceKm: null
      })),
      total, page, pageSize
    });
  }

  async detail(request: FastifyRequest, reply: FastifyReply) {
    const params = request.params as { id: string };

    const salon = await prisma.salon.findFirst({
      where: { id: params.id, approvalStatus: "approved" },
      include: {
        services: { where: { isActive: true }, orderBy: { displayOrder: "asc" } },
        gallery: { orderBy: { position: "asc" } },
        employees: {
          where: { isActive: true, schedulingEnabled: true },
          orderBy: { displayName: "asc" },
          include: { specialties: { select: { serviceId: true } } }
        }
      }
    });

    if (!salon) {
      fail(reply, 404, "salon_not_found", "Salon introuvable.");
      return;
    }

    const teamSettingRows = await prisma.platformSetting.findMany({
      where: {
        key: {
          in: [
            salonTeamShowPhotosKey(salon.id),
            salonTeamShowDescriptionsKey(salon.id)
          ]
        }
      },
      select: { key: true, value: true }
    });
    const settingMap = Object.fromEntries(teamSettingRows.map((row) => [row.key, row.value]));
    const showPhotos = parseBooleanSetting(settingMap[salonTeamShowPhotosKey(salon.id)], false);
    const showDescriptions = parseBooleanSetting(settingMap[salonTeamShowDescriptionsKey(salon.id)], false);

    ok(reply, {
      id: salon.id,
      name: salon.name,
      category: salon.category,
      logoUrl: salon.logoUrl,
      city: salon.city,
      neighborhood: salon.neighborhood,
      averageRating: salon.averageRating,
      latitude: salon.latitude,
      longitude: salon.longitude,
      subscriptionTier: salon.subscriptionTier,
      featured: salon.subscriptionTier === "premium",
      isPrestige: salon.isPrestige,
      prestigeScore: salon.prestigeScore,
      distanceKm: null,
      description: salon.description,
      address: salon.address,
      gallery: salon.gallery.map((g) => g.url),
      teamDisplay: { showPhotos, showDescriptions },
      staff: salon.employees.map((employee) => ({
        id: employee.id,
        displayName: employee.displayName,
        avatarUrl: showPhotos ? employee.avatarUrl : null,
        description: showDescriptions ? employee.description : null,
        serviceIds: employee.specialties.map((specialty) => specialty.serviceId)
      })),
      services: salon.services.map((s) => ({
        id: s.id,
        name: s.name,
        category: s.category,
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
              id: true, name: true, category: true, logoUrl: true, city: true,
              neighborhood: true, averageRating: true, latitude: true,
              longitude: true, subscriptionTier: true, isPrestige: true, prestigeScore: true
            }
          }
        },
        orderBy: { createdAt: "desc" }
      });
      ok(reply, favorites.map((f) => ({
        ...f.salon,
        featured: f.salon.subscriptionTier === "premium",
        distanceKm: null
      })));
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }
}
