import { Prisma } from "../../generated/prisma/client.js";
import type { FastifyReply, FastifyRequest } from "fastify";

import {
  searchSuggestionsQuerySchema,
  searchSalonsQuerySchema,
  searchEventsRequestSchema,
} from "@beauteavenue/contracts";

import { HttpAuthError, requireRole } from "../../lib/auth/index.js";
import { getCachedJson, setCachedJsonWithTags } from "../../lib/cache.js";
import { config } from "../../config.js";
import { fail, ok } from "../../lib/http.js";
import { prisma } from "../../lib/db/prisma.js";

// ── Helpers ─────────────────────────────────────────────────────────────────

function buildPrefixQuery(raw: string): string {
  const words = raw
    .trim()
    .split(/\s+/)
    .map((w) => w.replace(/[':&|!<>()]/g, "").trim())
    .filter((w) => w.length >= 2);
  if (!words.length) return "";
  return [...words.slice(0, -1), `${words[words.length - 1]}:*`].join(" & ");
}

function buildSearchVecAndQuery(searchParam: string) {
  const prefix = buildPrefixQuery(searchParam);
  const vec = Prisma.sql`(
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(s.name,''))), 'A') ||
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(s.category,''))), 'B') ||
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(s.description,''))), 'C') ||
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(s.neighborhood,'') || ' ' || COALESCE(s.city,''))), 'D')
  )`;
  const tsq = prefix
    ? Prisma.sql`(websearch_to_tsquery('french', immutable_unaccent(${searchParam})) || to_tsquery('french', immutable_unaccent(${prefix})))`
    : Prisma.sql`websearch_to_tsquery('french', immutable_unaccent(${searchParam}))`;
  return { vec, tsq };
}

function searchFilterWhere(searchParam: string, tableAlias = "s") {
  const { vec, tsq } = buildSearchVecAndQuery(searchParam);
  const like = `%${searchParam}%`;
  // Use the provided table alias for tsvector
  const aliasedVec = Prisma.raw(`(
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(${tableAlias}.name,''))), 'A') ||
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(${tableAlias}.category,''))), 'B') ||
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(${tableAlias}.description,''))), 'C') ||
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(${tableAlias}.neighborhood,'') || ' ' || COALESCE(${tableAlias}.city,''))), 'D')
  )`);
  return Prisma.sql`(
    ${aliasedVec} @@ ${tsq}
    OR similarity(immutable_unaccent(${Prisma.raw(`${tableAlias}.name`)}), immutable_unaccent(${searchParam})) > 0.2
    OR ${Prisma.raw(`${tableAlias}.name`)}         ILIKE ${like}
    OR ${Prisma.raw(`${tableAlias}.description`)}  ILIKE ${like}
    OR ${Prisma.raw(`${tableAlias}.neighborhood`)} ILIKE ${like}
    OR ${Prisma.raw(`${tableAlias}.category`)}     ILIKE ${like}
    OR EXISTS (
      SELECT 1 FROM "Service" svc
      WHERE svc."salonId" = ${Prisma.raw(`${tableAlias}.id`)} AND svc."isActive" = true
      AND (
        svc.name ILIKE ${like}
        OR to_tsvector('french', immutable_unaccent(svc.name)) @@ websearch_to_tsquery('french', immutable_unaccent(${searchParam}))
      )
    )
  )`;
}

function searchRankExpr(searchParam: string, tableAlias = "s") {
  const { tsq } = buildSearchVecAndQuery(searchParam);
  const aliasedVec = Prisma.raw(`(
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(${tableAlias}.name,''))), 'A') ||
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(${tableAlias}.category,''))), 'B') ||
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(${tableAlias}.description,''))), 'C') ||
    setweight(to_tsvector('french', immutable_unaccent(COALESCE(${tableAlias}.neighborhood,'') || ' ' || COALESCE(${tableAlias}.city,''))), 'D')
  )`);
  return Prisma.sql`ts_rank_cd(${aliasedVec}, ${tsq})`;
}

// Normalize query: trim, lowercase, collapse whitespace
function normalizeQuery(q: string): string {
  return q.trim().replace(/\s+/g, " ").toLowerCase();
}

// Simple Levenshtein-based spell check using trigram similarity
async function findDidYouMean(raw: string): Promise<string | null> {
  if (raw.length < 3) return null;
  try {
    const rows = await prisma.$queryRaw<{ suggestion: string; score: number }[]>(Prisma.sql`
      SELECT DISTINCT s.name AS suggestion,
        similarity(immutable_unaccent(s.name), immutable_unaccent(${raw})) AS score
      FROM "Salon" s
      WHERE s."approvalStatus" = 'approved'
        AND s."isVisibleInMarketplace" = true
        AND similarity(immutable_unaccent(s.name), immutable_unaccent(${raw})) BETWEEN 0.15 AND 0.6
      ORDER BY score DESC
      LIMIT 1
    `);
    if (rows.length > 0 && rows[0].score > 0.15) return rows[0].suggestion;
  } catch {}
  return null;
}

// Map salon row to response shape
function mapSalonRow(r: any) {
  return {
    id: r.id,
    name: r.name,
    category: r.category,
    logoUrl: r.logoUrl,
    city: r.city,
    neighborhood: r.neighborhood,
    averageRating: Number(r.averageRating),
    reviewCount: Number(r.reviewCount),
    latitude: r.latitude,
    longitude: r.longitude,
    subscriptionTier: r.subscriptionTier,
    featured: r.subscriptionTier === "premium",
    isPrestige: r.isPrestige,
    prestigeScore: r.prestigeScore != null ? Number(r.prestigeScore) : null,
    distanceKm: r.distance_km != null ? Math.round(Number(r.distance_km) * 10) / 10 : null,
    matchType: r.match_type ?? undefined,
    matchedService: r.matched_service ?? null,
    isOpenNow: r.is_open_now ?? undefined,
    minPriceXof: r.min_price_xof != null ? Number(r.min_price_xof) : null,
  };
}

// Base visibility filters for salons
const BASE_SALON_WHERE = Prisma.sql`
  s."approvalStatus" = 'approved'
  AND s."isVisibleInMarketplace" = true
  AND s."canReceiveBookings" = true
  AND s."logoUrl" IS NOT NULL
  AND EXISTS (SELECT 1 FROM "Service" sv WHERE sv."salonId" = s.id AND sv."isActive" = true)
  AND EXISTS (SELECT 1 FROM "Employee" e WHERE e."salonId" = s.id AND e."isActive" = true)
`;

// ── Controller ──────────────────────────────────────────────────────────────

export class SearchController {

  // ── GET /api/v1/search/suggestions ──────────────────────────────────────

  async suggestions(request: FastifyRequest, reply: FastifyReply) {
    const q = searchSuggestionsQuerySchema.parse(request.query);
    const raw = q.q;
    if (raw.length < 1) {
      return ok(reply, {
        normalizedQuery: raw,
        didYouMean: null,
        suggestions: [],
        entityHints: [],
        topMatches: [],
      });
    }

    const normalized = normalizeQuery(raw);
    const cacheKey = `search:suggest:${normalized}:${q.category ?? ""}:${q.city ?? ""}`;
    const cached = await getCachedJson<unknown>(cacheKey);
    if (cached) {
      reply.header("x-cache", "HIT");
      return ok(reply, cached);
    }

    // 1-char: only provide entity hints and top matches, no full search
    const doFullSearch = raw.length >= 2;

    const like = `%${raw}%`;

    // Run queries in parallel
    const [salonHits, serviceHits, categoryHits, neighborhoodHits, cityHits, didYouMean] = await Promise.all([
      // Top salons by name match
      doFullSearch
        ? prisma.$queryRaw<{ id: string; name: string; category: string; logoUrl: string | null; city: string; neighborhood: string | null; score: number }[]>(Prisma.sql`
            SELECT s.id, s.name, s.category, s."logoUrl", s.city, s.neighborhood,
              similarity(immutable_unaccent(s.name), immutable_unaccent(${raw})) AS score
            FROM "Salon" s
            WHERE ${BASE_SALON_WHERE}
              AND (s.name ILIKE ${like} OR similarity(immutable_unaccent(s.name), immutable_unaccent(${raw})) > 0.15)
            ORDER BY score DESC, s."averageRating" DESC
            LIMIT 5
          `)
        : Promise.resolve([]),

      // Service matches → return salon + matched service name
      doFullSearch
        ? prisma.$queryRaw<{ salon_id: string; salon_name: string; service_name: string; logoUrl: string | null; city: string; neighborhood: string | null; category: string }[]>(Prisma.sql`
            SELECT DISTINCT ON (s.id)
              s.id AS salon_id, s.name AS salon_name, svc.name AS service_name,
              s."logoUrl", s.city, s.neighborhood, s.category
            FROM "Service" svc
            JOIN "Salon" s ON s.id = svc."salonId"
            WHERE svc."isActive" = true
              AND s."approvalStatus" = 'approved'
              AND s."isVisibleInMarketplace" = true
              AND s."canReceiveBookings" = true
              AND (svc.name ILIKE ${like}
                OR to_tsvector('french', immutable_unaccent(svc.name)) @@ websearch_to_tsquery('french', immutable_unaccent(${raw})))
            ORDER BY s.id, s."averageRating" DESC
            LIMIT 5
          `)
        : Promise.resolve([]),

      // Category facets
      prisma.$queryRaw<{ value: string; count: number }[]>(Prisma.sql`
        SELECT s.category AS value, COUNT(*)::int AS count
        FROM "Salon" s
        WHERE ${BASE_SALON_WHERE}
          AND s.category ILIKE ${like}
        GROUP BY s.category
        ORDER BY count DESC
        LIMIT 5
      `),

      // Neighborhood facets
      prisma.$queryRaw<{ value: string; count: number }[]>(Prisma.sql`
        SELECT s.neighborhood AS value, COUNT(*)::int AS count
        FROM "Salon" s
        WHERE ${BASE_SALON_WHERE}
          AND s.neighborhood IS NOT NULL
          AND s.neighborhood ILIKE ${like}
        GROUP BY s.neighborhood
        ORDER BY count DESC
        LIMIT 5
      `),

      // City facets
      prisma.$queryRaw<{ value: string; count: number }[]>(Prisma.sql`
        SELECT s.city AS value, COUNT(*)::int AS count
        FROM "Salon" s
        WHERE ${BASE_SALON_WHERE}
          AND s.city ILIKE ${like}
        GROUP BY s.city
        ORDER BY count DESC
        LIMIT 5
      `),

      // Spell check
      findDidYouMean(raw),
    ]);

    // Build suggestions list
    const suggestions: Array<{
      text: string;
      type: string;
      salonId?: string | null;
      logoUrl?: string | null;
      subtitle?: string | null;
    }> = [];

    for (const s of salonHits) {
      suggestions.push({
        text: s.name,
        type: "salon" as const,
        salonId: s.id,
        logoUrl: s.logoUrl,
        subtitle: `${s.category} · ${s.city}`,
      });
    }

    for (const s of serviceHits) {
      suggestions.push({
        text: s.service_name,
        type: "service" as const,
        salonId: s.salon_id,
        logoUrl: s.logoUrl,
        subtitle: `${s.salon_name} · ${s.city}`,
      });
    }

    for (const c of categoryHits) {
      suggestions.push({ text: c.value, type: "category" as const, subtitle: `${c.count} salons` });
    }

    for (const n of neighborhoodHits) {
      suggestions.push({ text: n.value, type: "neighborhood" as const, subtitle: `${n.count} salons` });
    }

    for (const c of cityHits) {
      suggestions.push({ text: c.value, type: "city" as const, subtitle: `${c.count} salons` });
    }

    // Build entity hints
    const entityHints = [
      ...categoryHits.map((c) => ({ type: "category" as const, value: c.value, count: c.count })),
      ...neighborhoodHits.map((n) => ({ type: "neighborhood" as const, value: n.value, count: n.count })),
      ...cityHits.map((c) => ({ type: "city" as const, value: c.value, count: c.count })),
    ];

    // Top matches for preview (limited data)
    const topMatches = salonHits.slice(0, 3).map((s) => ({
      id: s.id,
      name: s.name,
      category: s.category,
      logoUrl: s.logoUrl,
      city: s.city,
      neighborhood: s.neighborhood,
      averageRating: 0,
      reviewCount: 0,
      latitude: null,
      longitude: null,
      subscriptionTier: "standard" as const,
      featured: false,
      isPrestige: false,
      prestigeScore: null,
      distanceKm: null,
    }));

    const payload = {
      normalizedQuery: normalized,
      didYouMean,
      suggestions: suggestions.slice(0, 10),
      entityHints,
      topMatches,
    };

    await setCachedJsonWithTags({
      key: cacheKey,
      value: payload,
      ttlSeconds: 30,
      tags: ["search:suggest"],
    });
    reply.header("x-cache", "MISS");
    ok(reply, payload);
  }

  // ── GET /api/v1/search/salons ──────────────────────────────────────────

  async search(request: FastifyRequest, reply: FastifyReply) {
    const q = searchSalonsQuerySchema.parse(request.query);
    const raw = q.q;
    const normalized = normalizeQuery(raw);
    const limit = q.limit;
    const cursorOffset = q.cursor ? parseInt(Buffer.from(q.cursor, "base64").toString("utf-8"), 10) : 0;

    const cacheKey = `search:full:${normalized}:${q.category ?? ""}:${q.city ?? ""}:${q.neighborhood ?? ""}:${q.sort}:${q.openNow ?? ""}:${q.bookableSoon ?? ""}:${q.minPrice ?? ""}:${q.maxPrice ?? ""}:${cursorOffset}:${limit}`;
    const cached = await getCachedJson<unknown>(cacheKey);
    if (cached) {
      reply.header("x-cache", "HIT");
      return ok(reply, cached);
    }

    const searchParam = raw === "*" ? "" : raw;
    const isWildcard = searchParam === "";
    const like = isWildcard ? "%%" : `%${searchParam}%`;

    // ── Personalization boost (if session profile exists) ────────────────
    const sessionKey = (request.query as any).sessionKey as string | undefined;
    let profileBoosts: {
      preferredCategories: string[];
      preferredCities: string[];
      preferredNeighborhoods: string[];
      prestigeAffinity: number;
      distanceToleranceKm: number;
    } | null = null;

    if (sessionKey) {
      try {
        const profile = await prisma.searchProfile.findUnique({
          where: { sessionKey },
        });
        if (profile) {
          profileBoosts = {
            preferredCategories: JSON.parse(profile.preferredCategories as string),
            preferredCities: JSON.parse(profile.preferredCities as string),
            preferredNeighborhoods: JSON.parse(profile.preferredNeighborhoods as string),
            prestigeAffinity: profile.prestigeAffinity,
            distanceToleranceKm: profile.distanceToleranceKm,
          };
        }
      } catch {}
    }

    // ── Main ranked results ─────────────────────────────────────────────
    const cityFilter = q.city ? Prisma.sql`AND s.city = ${q.city}` : Prisma.empty;
    const neighborhoodFilter = q.neighborhood ? Prisma.sql`AND s.neighborhood = ${q.neighborhood}` : Prisma.empty;
    const categoryFilter = q.category ? Prisma.sql`AND s.category = ${q.category}` : Prisma.empty;
    const nearbyCoordFilter = q.sort === "nearby"
      ? Prisma.sql`AND s.latitude IS NOT NULL AND s.longitude IS NOT NULL`
      : Prisma.empty;
    const priceJoin = q.minPrice != null || q.maxPrice != null
      ? Prisma.sql`JOIN "Service" price_svc ON price_svc."salonId" = s.id AND price_svc."isActive" = true`
      : Prisma.empty;
    const priceWhere = [
      q.minPrice != null ? Prisma.sql`AND price_svc."priceXof" >= ${q.minPrice}` : Prisma.empty,
      q.maxPrice != null ? Prisma.sql`AND price_svc."priceXof" <= ${q.maxPrice}` : Prisma.empty,
    ];

    // Open-now subquery
    const openNowJoin = q.openNow
      ? Prisma.sql`
          JOIN "SalonHours" sh ON sh."salonId" = s.id
            AND sh."dayOfWeek" = EXTRACT(DOW FROM NOW() AT TIME ZONE 'Africa/Dakar')::int
            AND sh."isOpen" = true
            AND sh."opensAt" IS NOT NULL
            AND sh."closesAt" IS NOT NULL
            AND TO_CHAR(NOW() AT TIME ZONE 'Africa/Dakar', 'HH24:MI') BETWEEN sh."opensAt" AND sh."closesAt"
        `
      : Prisma.empty;

    // Bookable-soon subquery (next 48h has at least one available slot)
    const bookableSoonJoin = q.bookableSoon
      ? Prisma.sql`
          JOIN "Booking" book_check ON book_check."salonId" = s.id
            AND book_check."startsAt" BETWEEN NOW() AND NOW() + INTERVAL '48 hours'
            AND book_check.status IN ('confirmed', 'pending')
        `
      : Prisma.empty;

    // Personalization boost expression
    let personalizationBoost = Prisma.sql`0`;
    if (profileBoosts) {
      const catBoosts = profileBoosts.preferredCategories.length > 0
        ? Prisma.sql`CASE WHEN s.category = ANY(${profileBoosts.preferredCategories}) THEN 0.05 ELSE 0 END`
        : Prisma.sql`0`;
      const cityBoosts = profileBoosts.preferredCities.length > 0
        ? Prisma.sql`CASE WHEN s.city = ANY(${profileBoosts.preferredCities}) THEN 0.03 ELSE 0 END`
        : Prisma.sql`0`;
      const prestigeBoost = profileBoosts.prestigeAffinity > 0.3
        ? Prisma.sql`CASE WHEN s."isPrestige" THEN 0.02 ELSE 0 END`
        : Prisma.sql`0`;
      personalizationBoost = Prisma.sql`(${catBoosts} + ${cityBoosts} + ${prestigeBoost})`;
    }

    // Build ranking expression (skip text search for wildcard queries)
    const textRank = isWildcard ? Prisma.sql`0` : searchRankExpr(searchParam);
    const searchWhere = isWildcard ? Prisma.sql`1=1` : searchFilterWhere(searchParam);

    // Service match detection subquery for match_type
    const matchTypeExpr = Prisma.sql`
      CASE
        WHEN immutable_unaccent(s.name) = immutable_unaccent(${searchParam}) THEN 'exact'
        WHEN immutable_unaccent(s.name) ILIKE ${searchParam} || '%' THEN 'prefix'
        WHEN EXISTS (
          SELECT 1 FROM "Service" svc_mt WHERE svc_mt."salonId" = s.id AND svc_mt."isActive" = true
          AND (svc_mt.name ILIKE ${like} OR to_tsvector('french', immutable_unaccent(svc_mt.name)) @@ websearch_to_tsquery('french', immutable_unaccent(${searchParam})))
        ) THEN 'service'
        ELSE 'fuzzy'
      END
    `;

    // Matched service name subquery
    const matchedServiceExpr = Prisma.sql`(
      SELECT svc_ms.name FROM "Service" svc_ms
      WHERE svc_ms."salonId" = s.id AND svc_ms."isActive" = true
      AND (svc_ms.name ILIKE ${like} OR to_tsvector('french', immutable_unaccent(svc_ms.name)) @@ websearch_to_tsquery('french', immutable_unaccent(${searchParam})))
      LIMIT 1
    )`;

    // Open-now flag
    const isOpenNowExpr = Prisma.sql`(
      SELECT EXISTS (
        SELECT 1 FROM "SalonHours" sh2
        WHERE sh2."salonId" = s.id
          AND sh2."dayOfWeek" = EXTRACT(DOW FROM NOW() AT TIME ZONE 'Africa/Dakar')::int
          AND sh2."isOpen" = true
          AND sh2."opensAt" IS NOT NULL
          AND sh2."closesAt" IS NOT NULL
          AND TO_CHAR(NOW() AT TIME ZONE 'Africa/Dakar', 'HH24:MI') BETWEEN sh2."opensAt" AND sh2."closesAt"
      )
    )`;

    // Min price subquery
    const minPriceExpr = Prisma.sql`(
      SELECT MIN(svc_mp."priceXof") FROM "Service" svc_mp
      WHERE svc_mp."salonId" = s.id AND svc_mp."isActive" = true
    )`;

    // Sort order
    let orderBy: Prisma.Sql;
    switch (q.sort) {
      case "nearby":
        orderBy = Prisma.sql`distance_km ASC NULLS LAST`;
        break;
      case "trending":
        orderBy = Prisma.sql`trending_score DESC, s."averageRating" DESC`;
        break;
      case "prestige":
        orderBy = Prisma.sql`s."prestigeScore" DESC NULLS LAST, s."averageRating" DESC`;
        break;
      case "price_asc":
        orderBy = Prisma.sql`min_price ASC NULLS LAST`;
        break;
      case "price_desc":
        orderBy = Prisma.sql`min_price DESC NULLS LAST`;
        break;
      case "rating":
        orderBy = Prisma.sql`
          CASE s."subscriptionTier" WHEN 'premium' THEN 0 ELSE 1 END ASC,
          s."averageRating" DESC
        `;
        break;
      default: // relevance
        orderBy = Prisma.sql`
          text_rank DESC,
          exact_match DESC,
          subscription_priority,
          personalization_boost DESC,
          s."averageRating" DESC
        `;
    }

    type SearchResultRow = {
      id: string; name: string; category: string; logoUrl: string | null;
      city: string; neighborhood: string | null; averageRating: number; reviewCount: number;
      latitude: number | null; longitude: number | null; subscriptionTier: string;
      isPrestige: boolean; prestigeScore: number | null;
      distance_km: number | null; match_type: string; matched_service: string | null;
      is_open_now: boolean; min_price_xof: number | null;
      trending_score: number; exact_match: number; min_price: number | null;
      text_rank: number; personalization_boost: number; subscription_priority: number;
      total_count: bigint;
    };

    // Distance expression
    const distExpr = q.lat != null && q.lng != null
      ? Prisma.sql`
          6371 * acos(LEAST(1.0,
            cos(radians(${q.lat})) * cos(radians(s.latitude)) *
            cos(radians(s.longitude) - radians(${q.lng})) +
            sin(radians(${q.lat})) * sin(radians(s.latitude))
          ))
        `
      : Prisma.sql`NULL`;

    const rows = await prisma.$queryRaw<SearchResultRow[]>(Prisma.sql`
      SELECT DISTINCT s.id, s.name, s.category, s."logoUrl", s.city, s.neighborhood,
             s."averageRating", s."reviewCount", s.latitude, s.longitude, s."subscriptionTier",
             s."isPrestige", s."prestigeScore",
             ${distExpr} AS distance_km,
             ${matchTypeExpr} AS match_type,
             ${matchedServiceExpr} AS matched_service,
             ${isOpenNowExpr}::boolean AS is_open_now,
             ${minPriceExpr}::int AS min_price_xof,
             COALESCE(t.score, 0)::float AS trending_score,
             CASE WHEN immutable_unaccent(s.name) = immutable_unaccent(${searchParam}) THEN 1 ELSE 0 END AS exact_match,
             ${minPriceExpr}::int AS min_price,
             ${textRank}::float AS text_rank,
             ${personalizationBoost}::float AS personalization_boost,
             CASE s."subscriptionTier" WHEN 'premium' THEN 0 ELSE 1 END AS subscription_priority,
             COUNT(*) OVER() AS total_count
      FROM "Salon" s
      ${priceJoin}
      ${openNowJoin}
      ${bookableSoonJoin}
      LEFT JOIN (
        SELECT "salonId",
          SUM(CASE WHEN "createdAt" > NOW() - INTERVAL '7 days' THEN 3 ELSE 1 END) AS score
        FROM "Booking"
        WHERE "createdAt" > NOW() - INTERVAL '30 days'
          AND status NOT IN ('cancelled')
        GROUP BY "salonId"
      ) t ON t."salonId" = s.id
      WHERE ${BASE_SALON_WHERE}
        AND ${searchWhere}
        ${cityFilter}
        ${neighborhoodFilter}
        ${categoryFilter}
        ${nearbyCoordFilter}
        ${priceWhere[0]}
        ${priceWhere[1]}
      ORDER BY ${orderBy}
      LIMIT ${limit} OFFSET ${cursorOffset}
    `);

    const totalApprox = rows.length > 0 ? Number(rows[0].total_count) : 0;

    // ── Facets ──────────────────────────────────────────────────────────
    const [facetCategories, facetCities, facetNeighborhoods, openNowCount, bookableSoonCount] = await Promise.all([
      prisma.$queryRaw<{ value: string; count: number }[]>(Prisma.sql`
        SELECT s.category AS value, COUNT(*)::int AS count
        FROM "Salon" s WHERE ${BASE_SALON_WHERE} AND ${searchWhere} ${cityFilter} ${neighborhoodFilter}
        GROUP BY s.category ORDER BY count DESC LIMIT 10
      `),
      prisma.$queryRaw<{ value: string; count: number }[]>(Prisma.sql`
        SELECT s.city AS value, COUNT(*)::int AS count
        FROM "Salon" s WHERE ${BASE_SALON_WHERE} AND ${searchWhere} ${categoryFilter} ${neighborhoodFilter}
        GROUP BY s.city ORDER BY count DESC LIMIT 10
      `),
      prisma.$queryRaw<{ value: string; count: number }[]>(Prisma.sql`
        SELECT s.neighborhood AS value, COUNT(*)::int AS count
        FROM "Salon" s WHERE ${BASE_SALON_WHERE} AND s.neighborhood IS NOT NULL AND ${searchWhere} ${cityFilter} ${categoryFilter}
        GROUP BY s.neighborhood ORDER BY count DESC LIMIT 10
      `),
      // Open now count
      prisma.$queryRaw<{ count: number }[]>(Prisma.sql`
        SELECT COUNT(DISTINCT s.id)::int AS count
        FROM "Salon" s
        JOIN "SalonHours" sh ON sh."salonId" = s.id
          AND sh."dayOfWeek" = EXTRACT(DOW FROM NOW() AT TIME ZONE 'Africa/Dakar')::int
          AND sh."isOpen" = true
          AND sh."opensAt" IS NOT NULL AND sh."closesAt" IS NOT NULL
          AND TO_CHAR(NOW() AT TIME ZONE 'Africa/Dakar', 'HH24:MI') BETWEEN sh."opensAt" AND sh."closesAt"
        WHERE ${BASE_SALON_WHERE} AND ${searchWhere} ${cityFilter} ${categoryFilter}
      `),
      // Bookable soon count (salons with confirmed/pending bookings in next 48h)
      prisma.$queryRaw<{ count: number }[]>(Prisma.sql`
        SELECT COUNT(DISTINCT s.id)::int AS count
        FROM "Salon" s
        WHERE ${BASE_SALON_WHERE} AND ${searchWhere} ${cityFilter} ${categoryFilter}
          AND EXISTS (
            SELECT 1 FROM "Booking" bk WHERE bk."salonId" = s.id
              AND bk."startsAt" BETWEEN NOW() AND NOW() + INTERVAL '48 hours'
              AND bk.status IN ('confirmed', 'pending')
          )
      `),
    ]);

    // ── Discovery modules ───────────────────────────────────────────────
    const modules: Array<{
      type: string;
      title: string;
      items: ReturnType<typeof mapSalonRow>[];
    }> = [];

    // Near you module (only if lat/lng provided)
    if (q.lat != null && q.lng != null) {
      try {
        const nearRows = await prisma.$queryRaw<any[]>(Prisma.sql`
          SELECT s.id, s.name, s.category, s."logoUrl", s.city, s.neighborhood,
                 s."averageRating", s."reviewCount", s.latitude, s.longitude, s."subscriptionTier",
                 s."isPrestige", s."prestigeScore",
                 6371 * acos(LEAST(1.0,
                   cos(radians(${q.lat})) * cos(radians(s.latitude)) *
                   cos(radians(s.longitude) - radians(${q.lng})) +
                   sin(radians(${q.lat})) * sin(radians(s.latitude))
                 )) AS distance_km
          FROM "Salon" s
          WHERE ${BASE_SALON_WHERE}
            AND s.latitude IS NOT NULL AND s.longitude IS NOT NULL
            ${categoryFilter}
          ORDER BY distance_km ASC
          LIMIT 4
        `);
        if (nearRows.length > 0) {
          modules.push({
            type: "near_you",
            title: "Proche de vous",
            items: nearRows.map(mapSalonRow),
          });
        }
      } catch {}
    }

    // Trending module
    try {
      const trendRows = await prisma.$queryRaw<any[]>(Prisma.sql`
        SELECT s.id, s.name, s.category, s."logoUrl", s.city, s.neighborhood,
               s."averageRating", s."reviewCount", s.latitude, s.longitude, s."subscriptionTier",
               s."isPrestige", s."prestigeScore",
               COALESCE(t.score, 0)::float AS trending_score
        FROM "Salon" s
        LEFT JOIN (
          SELECT "salonId",
            SUM(CASE WHEN "createdAt" > NOW() - INTERVAL '7 days' THEN 3 ELSE 1 END) AS score
          FROM "Booking"
          WHERE "createdAt" > NOW() - INTERVAL '30 days' AND status NOT IN ('cancelled')
          GROUP BY "salonId"
        ) t ON t."salonId" = s.id
        WHERE ${BASE_SALON_WHERE}
          ${categoryFilter}
        ORDER BY trending_score DESC, s."averageRating" DESC
        LIMIT 4
      `);
      if (trendRows.length > 0) {
        modules.push({
          type: "trending_for_query",
          title: "Tendances",
          items: trendRows.map((r: any) => ({
            ...mapSalonRow(r),
            distance_km: r.distance_km ?? null,
          })),
        });
      }
    } catch {}

    // Prestige module
    try {
      const prestigeRows = await prisma.$queryRaw<any[]>(Prisma.sql`
        SELECT s.id, s.name, s.category, s."logoUrl", s.city, s.neighborhood,
               s."averageRating", s."reviewCount", s.latitude, s.longitude, s."subscriptionTier",
               s."isPrestige", s."prestigeScore"
        FROM "Salon" s
        WHERE ${BASE_SALON_WHERE}
          AND s."isPrestige" = true
          ${categoryFilter}
        ORDER BY s."prestigeScore" DESC NULLS LAST, s."averageRating" DESC
        LIMIT 4
      `);
      if (prestigeRows.length > 0) {
        modules.push({
          type: "prestige_for_query",
          title: "Salons prestigieux",
          items: prestigeRows.map(mapSalonRow),
        });
      }
    } catch {}

    // ── Build response ──────────────────────────────────────────────────
    const nextOffset = cursorOffset + limit;
    const hasMore = nextOffset < totalApprox;
    const nextCursor = hasMore ? Buffer.from(String(nextOffset)).toString("base64") : null;

    const didYouMean = await findDidYouMean(raw);

    const payload = {
      query: {
        normalized: normalized,
        corrected: didYouMean,
        interpretedEntities: [] as Array<{ type: string; value: string; count: number }>,
      },
      facets: {
        categories: facetCategories.map((c) => ({ value: c.value, count: c.count, active: c.value === q.category })),
        cities: facetCities.map((c) => ({ value: c.value, count: c.count, active: c.value === q.city })),
        neighborhoods: facetNeighborhoods.map((n) => ({ value: n.value, count: n.count, active: n.value === q.neighborhood })),
        priceRanges: [
          { value: "0-5000", count: 0, active: q.maxPrice != null && q.maxPrice <= 5000 },
          { value: "5000-15000", count: 0, active: q.minPrice != null && q.minPrice >= 5000 && q.maxPrice != null && q.maxPrice <= 15000 },
          { value: "15000-30000", count: 0, active: q.minPrice != null && q.minPrice >= 15000 && q.maxPrice != null && q.maxPrice <= 30000 },
          { value: "30000+", count: 0, active: q.minPrice != null && q.minPrice >= 30000 },
        ],
        openNowCount: openNowCount[0]?.count ?? 0,
        bookableSoonCount: bookableSoonCount[0]?.count ?? 0,
      },
      results: rows.map(mapSalonRow),
      modules,
      pageInfo: {
        nextCursor,
        totalApprox,
        hasMore,
      },
    };

    await setCachedJsonWithTags({
      key: cacheKey,
      value: payload,
      ttlSeconds: 20,
      tags: ["search:salons"],
    });
    reply.header("x-cache", "MISS");
    ok(reply, payload);
  }

  // ── POST /api/v1/search/events ────────────────────────────────────────

  async trackEvents(request: FastifyRequest, reply: FastifyReply) {
    const body = searchEventsRequestSchema.parse(request.body);

    // Get userId from auth if available
    let userId: string | null = null;
    try {
      const session = requireRole(request, ["client", "salon_owner", "salon_staff", "salon_manager", "platform_admin"]);
      userId = session.sub;
    } catch {}

    const events = body.events.map((e) => ({
      userId,
      sessionKey: e.sessionKey,
      eventType: e.eventType as any,
      query: e.query ?? null,
      salonId: e.salonId ?? null,
      category: e.category ?? null,
      city: e.city ?? null,
      position: e.position ?? null,
      metadata: (e.metadata ?? undefined) as any,
    }));

    await prisma.searchEvent.createMany({ data: events as any });

    // Update search profile asynchronously (best-effort)
    const uniqueSessionKeys = [...new Set(events.map((e) => e.sessionKey))];
    for (const sk of uniqueSessionKeys) {
      this._updateSearchProfile(sk, userId, events.filter((e) => e.sessionKey === sk)).catch(() => {});
    }

    ok(reply, { accepted: events.length });
  }

  // ── Profile updater ───────────────────────────────────────────────────

  private async _updateSearchProfile(sessionKey: string, userId: string | null, events: Array<{ category?: string | null; city?: string | null; query?: string | null }> ) {
    const existing = await prisma.searchProfile.findUnique({ where: { sessionKey } });

    const preferredCategories = existing ? JSON.parse(existing.preferredCategories as string) as string[] : [];
    const preferredCities = existing ? JSON.parse(existing.preferredCities as string) as string[] : [];
    const preferredNeighborhoods = existing ? JSON.parse(existing.preferredNeighborhoods as string) as string[] : [];
    const lastQueries = existing ? JSON.parse(existing.lastQueries as string) as string[] : [];

    for (const event of events) {
      if (event.category && !preferredCategories.includes(event.category)) {
        preferredCategories.push(event.category);
        if (preferredCategories.length > 10) preferredCategories.shift();
      }
      if (event.city && !preferredCities.includes(event.city)) {
        preferredCities.push(event.city);
        if (preferredCities.length > 10) preferredCities.shift();
      }
      if (event.query) {
        lastQueries.push(event.query);
        if (lastQueries.length > 20) lastQueries.shift();
      }
    }

    const data = {
      userId: userId ?? existing?.userId ?? null,
      preferredCategories: JSON.stringify(preferredCategories),
      preferredCities: JSON.stringify(preferredCities),
      preferredNeighborhoods: JSON.stringify(preferredNeighborhoods),
      lastQueries: JSON.stringify(lastQueries),
      interactionCount: (existing?.interactionCount ?? 0) + events.length,
    };

    if (existing) {
      await prisma.searchProfile.update({ where: { sessionKey }, data });
    } else {
      await prisma.searchProfile.create({ data: { sessionKey, ...data } });
    }
  }
}
