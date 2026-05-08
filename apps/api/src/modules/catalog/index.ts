import { Prisma } from "../../generated/prisma/client.js";
import type { FastifyReply, FastifyRequest } from "fastify";

import { availabilityQuerySchema } from "@beauteavenue/contracts";

import { HttpAuthError, requireRole } from "../../lib/auth/index.js";
import { fetchAndComputeAvailableSlots } from "../../lib/availability.js";
import { fail, ok } from "../../lib/http.js";
import { prisma } from "../../lib/db/prisma.js";

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
      minPrice?: string;
      maxPrice?: string;
    };
    const page = Math.max(0, parseInt(q.page ?? "0", 10));
    const pageSize = Math.min(50, Math.max(1, parseInt(q.pageSize ?? "20", 10)));
    const lat = q.lat != null ? parseFloat(q.lat) : null;
    const lng = q.lng != null ? parseFloat(q.lng) : null;
    const sort = q.sort ?? "rating";
    const minPrice = q.minPrice != null ? parseInt(q.minPrice, 10) : null;
    const maxPrice = q.maxPrice != null ? parseInt(q.maxPrice, 10) : null;

    // ── Nearby: Haversine raw SQL, 5 km hard filter ──────────────────────────
    if (sort === "nearby" && lat != null && lng != null && !isNaN(lat) && !isNaN(lng)) {
      type NearbyRow = {
        id: string; name: string; category: string; logoUrl: string | null;
        city: string; neighborhood: string | null; averageRating: number;
        latitude: number; longitude: number; subscriptionTier: string;
        isPrestige: boolean; prestigeScore: number | null;
        distance_km: number; total_count: bigint;
      };

      const cityParam = q.city ?? null;
      const categoryParam = q.category ?? null;
      const searchParam = q.search ?? null;

      const rows = await prisma.$queryRaw<NearbyRow[]>(Prisma.sql`
        SELECT DISTINCT s.id, s.name, s.category, s."logoUrl", s.city, s.neighborhood,
               s."averageRating", s.latitude, s.longitude, s."subscriptionTier",
               s."isPrestige", s."prestigeScore",
               6371 * acos(LEAST(1.0,
                 cos(radians(${lat})) * cos(radians(s.latitude)) *
                 cos(radians(s.longitude) - radians(${lng})) +
                 sin(radians(${lat})) * sin(radians(s.latitude))
               )) AS distance_km,
               COUNT(*) OVER() AS total_count
        FROM "Salon" s
        ${minPrice != null || maxPrice != null ? Prisma.sql`JOIN "Service" srv ON srv."salonId" = s.id AND srv."isActive" = true` : Prisma.empty}
        WHERE s."approvalStatus" = 'approved'
          AND s."isVisibleInMarketplace" = true
          AND s.latitude IS NOT NULL
          AND s.longitude IS NOT NULL
          ${cityParam ? Prisma.sql`AND s.city = ${cityParam}` : Prisma.empty}
          ${categoryParam ? Prisma.sql`AND s.category = ${categoryParam}` : Prisma.empty}
          ${minPrice != null ? Prisma.sql`AND srv."priceXof" >= ${minPrice}` : Prisma.empty}
          ${maxPrice != null ? Prisma.sql`AND srv."priceXof" <= ${maxPrice}` : Prisma.empty}
          ${searchParam ? Prisma.sql`AND (s.name ILIKE ${"%" + searchParam + "%"} OR EXISTS (SELECT 1 FROM "Service" svc WHERE svc."salonId" = s.id AND svc."isActive" = true AND svc.name ILIKE ${"%" + searchParam + "%"}))` : Prisma.empty}
          AND 6371 * acos(LEAST(1.0,
                cos(radians(${lat})) * cos(radians(s.latitude)) *
                cos(radians(s.longitude) - radians(${lng})) +
                sin(radians(${lat})) * sin(radians(s.latitude))
              )) <= 5
        ORDER BY distance_km ASC
        LIMIT ${pageSize} OFFSET ${page * pageSize}
      `);

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

      const cityParam = q.city ?? null;
      const categoryParam = q.category ?? null;
      const searchParam = q.search ?? null;

      const rows = await prisma.$queryRaw<TrendingRow[]>(Prisma.sql`
        SELECT DISTINCT s.id, s.name, s.category, s."logoUrl", s.city, s.neighborhood,
               s."averageRating", s.latitude, s.longitude, s."subscriptionTier",
               s."isPrestige", s."prestigeScore",
               COUNT(b.id) AS booking_count,
               COUNT(*) OVER() AS total_count
        FROM "Salon" s
        ${minPrice != null || maxPrice != null ? Prisma.sql`JOIN "Service" srv ON srv."salonId" = s.id AND srv."isActive" = true` : Prisma.empty}
        LEFT JOIN "Booking" b ON b."salonId" = s.id
          AND b."createdAt" > NOW() - INTERVAL '30 days'
        WHERE s."approvalStatus" = 'approved'
          AND s."isVisibleInMarketplace" = true
          ${cityParam ? Prisma.sql`AND s.city = ${cityParam}` : Prisma.empty}
          ${categoryParam ? Prisma.sql`AND s.category = ${categoryParam}` : Prisma.empty}
          ${minPrice != null ? Prisma.sql`AND srv."priceXof" >= ${minPrice}` : Prisma.empty}
          ${maxPrice != null ? Prisma.sql`AND srv."priceXof" <= ${maxPrice}` : Prisma.empty}
          ${searchParam ? Prisma.sql`AND (s.name ILIKE ${"%" + searchParam + "%"} OR EXISTS (SELECT 1 FROM "Service" svc WHERE svc."salonId" = s.id AND svc."isActive" = true AND svc.name ILIKE ${"%" + searchParam + "%"}))` : Prisma.empty}
        GROUP BY s.id
        ORDER BY booking_count DESC, s."averageRating" DESC
        LIMIT ${pageSize} OFFSET ${page * pageSize}
      `);

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
      ...((minPrice != null || maxPrice != null) && {
        services: {
          some: {
            isActive: true,
            ...(minPrice != null && { priceXof: { gte: minPrice } }),
            ...(maxPrice != null && { priceXof: { lte: maxPrice } })
          }
        }
      })
    };

    const whereWithSearch = q.search
      ? {
          AND: [
            where,
            {
              OR: [
                { name: { contains: q.search, mode: "insensitive" as const } },
                { services: { some: { name: { contains: q.search, mode: "insensitive" as const }, isActive: true } } }
              ]
            }
          ]
        }
      : where;

    const [items, total] = await Promise.all([
      prisma.salon.findMany({
        where: whereWithSearch,
        select: {
          id: true, name: true, category: true, logoUrl: true, city: true,
          neighborhood: true, averageRating: true, latitude: true, longitude: true,
          subscriptionTier: true, isPrestige: true, prestigeScore: true
        },
        orderBy: [{ subscriptionTier: "desc" }, { averageRating: "desc" }],
        take: pageSize,
        skip: page * pageSize
      }),
      prisma.salon.count({ where: whereWithSearch })
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
      where: { id: params.id, approvalStatus: "approved", isVisibleInMarketplace: true },
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
      where: { id: params.id, approvalStatus: "approved", isVisibleInMarketplace: true, canReceiveBookings: true }
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

    const slots = await fetchAndComputeAvailableSlots(prisma, {
      salonId: params.id,
      date,
      durationMinutes: service.durationMinutes,
      employeeId: query.employeeId
    });

    ok(reply, slots);
  }

  async reviews(request: FastifyRequest, reply: FastifyReply) {
    const params = request.params as { id: string };
    const q = request.query as { page?: string; pageSize?: string };
    const page = Math.max(0, parseInt(q.page ?? "0", 10));
    const pageSize = Math.min(50, Math.max(1, parseInt(q.pageSize ?? "20", 10)));

    const salon = await prisma.salon.findFirst({
      where: { id: params.id, approvalStatus: "approved", isVisibleInMarketplace: true },
      select: { id: true }
    });
    if (!salon) {
      fail(reply, 404, "salon_not_found", "Salon introuvable.");
      return;
    }

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
        responseAt: r.responseText ? r.updatedAt.toISOString() : null
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
      ok(reply, { items: favorites.map((f) => ({
        ...f.salon,
        featured: f.salon.subscriptionTier === "premium",
        distanceKm: null
      })) });
    } catch (error) {
      if (error instanceof HttpAuthError) { fail(reply, error.statusCode, error.code, error.message); return; }
      fail(reply, 500, "internal_error", "Erreur interne.");
    }
  }
}
