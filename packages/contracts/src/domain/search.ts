import { z } from "zod";

import { subscriptionTierSchema } from "./enums.js";

// ── Shared ──────────────────────────────────────────────────────────────────

const searchSalonSummarySchema = z.object({
  id: z.string(),
  name: z.string(),
  category: z.string(),
  logoUrl: z.string().nullable(),
  city: z.string(),
  neighborhood: z.string().nullable(),
  averageRating: z.number(),
  latitude: z.number().nullable(),
  longitude: z.number().nullable(),
  subscriptionTier: subscriptionTierSchema,
  featured: z.boolean(),
  isPrestige: z.boolean(),
  prestigeScore: z.number().nullable(),
  distanceKm: z.number().nullable(),
  matchType: z.enum(["exact", "prefix", "service", "fuzzy", "location"]).optional(),
  matchedService: z.string().nullable().optional(),
  isOpenNow: z.boolean().optional(),
  minPriceXof: z.number().nullable().optional(),
});

// ── GET /api/v1/search/suggestions ──────────────────────────────────────────

export const searchSuggestionsQuerySchema = z.object({
  q: z.string().min(1).max(200),
  lat: z.coerce.number().min(-90).max(90).optional(),
  lng: z.coerce.number().min(-180).max(180).optional(),
  category: z.string().optional(),
  city: z.string().optional(),
});

export const suggestionItemSchema = z.object({
  text: z.string(),
  type: z.enum(["salon", "service", "category", "neighborhood", "city", "recent"]),
  salonId: z.string().nullable().optional(),
  logoUrl: z.string().nullable().optional(),
  subtitle: z.string().nullable().optional(),
});

export const entityHintSchema = z.object({
  type: z.enum(["category", "city", "neighborhood"]),
  value: z.string(),
  count: z.number().int(),
});

export const searchSuggestionsResponseSchema = z.object({
  normalizedQuery: z.string(),
  didYouMean: z.string().nullable(),
  suggestions: z.array(suggestionItemSchema),
  entityHints: z.array(entityHintSchema),
  topMatches: z.array(searchSalonSummarySchema),
});

export type SearchSuggestionsQuery = z.infer<typeof searchSuggestionsQuerySchema>;
export type SearchSuggestionsResponse = z.infer<typeof searchSuggestionsResponseSchema>;

// ── GET /api/v1/search/salons ───────────────────────────────────────────────

export const searchSalonsQuerySchema = z.object({
  q: z.string().min(1).max(200),
  lat: z.coerce.number().min(-90).max(90).optional(),
  lng: z.coerce.number().min(-180).max(180).optional(),
  category: z.string().optional(),
  city: z.string().optional(),
  neighborhood: z.string().optional(),
  minPrice: z.coerce.number().int().min(0).optional(),
  maxPrice: z.coerce.number().int().min(0).optional(),
  openNow: z.coerce.boolean().optional(),
  bookableSoon: z.coerce.boolean().optional(),
  sort: z.enum(["relevance", "nearby", "trending", "prestige", "price_asc", "price_desc"]).default("relevance"),
  cursor: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(50).default(20),
});

export const searchFacetBucketSchema = z.object({
  value: z.string(),
  count: z.number().int(),
  active: z.boolean().optional(),
});

export const searchFacetsSchema = z.object({
  categories: z.array(searchFacetBucketSchema),
  cities: z.array(searchFacetBucketSchema),
  neighborhoods: z.array(searchFacetBucketSchema),
  priceRanges: z.array(searchFacetBucketSchema),
  openNowCount: z.number().int(),
  bookableSoonCount: z.number().int(),
});

export const searchModuleSchema = z.object({
  type: z.enum(["near_you", "bookable_now", "prestige_for_query", "trending_for_query", "continue_exploring"]),
  title: z.string(),
  items: z.array(searchSalonSummarySchema),
});

export const searchQueryInfoSchema = z.object({
  normalized: z.string(),
  corrected: z.string().nullable(),
  interpretedEntities: z.array(entityHintSchema),
});

export const searchPageInfoSchema = z.object({
  nextCursor: z.string().nullable(),
  totalApprox: z.number().int(),
  hasMore: z.boolean(),
});

export const searchSalonsResponseSchema = z.object({
  query: searchQueryInfoSchema,
  facets: searchFacetsSchema,
  results: z.array(searchSalonSummarySchema),
  modules: z.array(searchModuleSchema),
  pageInfo: searchPageInfoSchema,
});

export type SearchSalonsQuery = z.infer<typeof searchSalonsQuerySchema>;
export type SearchSalonsResponse = z.infer<typeof searchSalonsResponseSchema>;

// ── POST /api/v1/search/events ──────────────────────────────────────────────

export const searchEventTypeSchema = z.enum([
  "search_submitted",
  "suggestion_tapped",
  "filter_applied",
  "result_opened",
  "module_item_opened",
]);

export const searchEventSchema = z.object({
  sessionKey: z.string().min(1),
  eventType: searchEventTypeSchema,
  query: z.string().nullable().optional(),
  salonId: z.string().nullable().optional(),
  category: z.string().nullable().optional(),
  city: z.string().nullable().optional(),
  position: z.number().int().nullable().optional(),
  metadata: z.record(z.unknown()).nullable().optional(),
});

export const searchEventsRequestSchema = z.object({
  events: z.array(searchEventSchema).min(1).max(50),
});

export const searchEventsResponseSchema = z.object({
  accepted: z.number().int(),
});

export type SearchEventInput = z.infer<typeof searchEventSchema>;
export type SearchEventsRequest = z.infer<typeof searchEventsRequestSchema>;
export type SearchEventsResponse = z.infer<typeof searchEventsResponseSchema>;
