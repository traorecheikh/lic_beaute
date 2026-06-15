import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const prisma = {
    salon: { findFirst: vi.fn(), findMany: vi.fn(), count: vi.fn() },
    service: { findFirst: vi.fn() },
    searchEvent: { createMany: vi.fn() },
    searchProfile: { findUnique: vi.fn(), update: vi.fn(), create: vi.fn() },
    $queryRaw: vi.fn(),
  };
  const fail = vi.fn();
  const ok = vi.fn();
  const getCachedJson = vi.fn();
  const setCachedJsonWithTags = vi.fn();
  const requireRole = vi.fn();
  const config = { cacheTtlCatalogSeconds: 45 };
  return { prisma, fail, ok, getCachedJson, setCachedJsonWithTags, requireRole, config };
});

vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/http.js", () => ({ fail: mocks.fail, ok: mocks.ok }));
vi.mock("../../lib/cache.js", () => ({
  getCachedJson: mocks.getCachedJson,
  setCachedJsonWithTags: mocks.setCachedJsonWithTags,
}));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../config.js", () => ({ config: mocks.config }));

import { SearchController } from "./index.js";

describe("SearchController", () => {
  const controller = new SearchController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.getCachedJson.mockResolvedValue(null);
    mocks.setCachedJsonWithTags.mockResolvedValue(undefined);
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
  });

  // ── Suggestions ───────────────────────────────────────────────────────

  describe("suggestions", () => {
    it("returns cached suggestions on HIT", async () => {
      const header = vi.fn();
      mocks.getCachedJson.mockResolvedValueOnce({
        normalizedQuery: "coiffure",
        didYouMean: null,
        suggestions: [],
        entityHints: [],
        topMatches: [],
      });
      await controller.suggestions(
        { query: { q: "coiffure" } } as never,
        { header } as never,
      );
      expect(header).toHaveBeenCalledWith("x-cache", "HIT");
    });

    it("returns salon and service suggestions", async () => {
      const header = vi.fn();
      // 6 parallel queries in suggestions: salonHits, serviceHits, categoryHits, neighborhoodHits, cityHits, didYouMean
      mocks.prisma.$queryRaw
        .mockResolvedValueOnce([{ id: "s1", name: "Coiffure Dakar", category: "hair", logoUrl: null, city: "Dakar", neighborhood: null, score: 0.8 }])
        .mockResolvedValueOnce([{ salon_id: "s1", salon_name: "Coiffure Dakar", service_name: "Coupe femme", logoUrl: null, city: "Dakar", neighborhood: null, category: "hair" }])
        .mockResolvedValueOnce([{ value: "hair", count: 5 }])
        .mockResolvedValueOnce([])
        .mockResolvedValueOnce([{ value: "Dakar", count: 10 }])
        .mockResolvedValueOnce([]);

      await controller.suggestions(
        { query: { q: "coif" } } as never,
        { header } as never,
      );

      expect(header).toHaveBeenCalledWith("x-cache", "MISS");
      const payload = mocks.ok.mock.calls[0][1] as any;
      expect(payload.suggestions.length).toBeGreaterThan(0);
      expect(payload.suggestions[0].type).toBe("salon");
      expect(payload.entityHints.length).toBeGreaterThan(0);
    });
  });

  // ── Search ────────────────────────────────────────────────────────────

  describe("search", () => {
    it("returns cached results on HIT", async () => {
      const header = vi.fn();
      mocks.getCachedJson.mockResolvedValueOnce({
        query: { normalized: "braids", corrected: null, interpretedEntities: [] },
        facets: { categories: [], cities: [], neighborhoods: [], priceRanges: [], openNowCount: 0, bookableSoonCount: 0 },
        results: [],
        modules: [],
        pageInfo: { nextCursor: null, totalApprox: 0, hasMore: false },
      });
      await controller.search(
        { query: { q: "braids", limit: 20, sort: "relevance" } } as never,
        { header } as never,
      );
      expect(header).toHaveBeenCalledWith("x-cache", "HIT");
    });

    it("returns ranked results with facets and modules", async () => {
      const header = vi.fn();
      // 9 $queryRaw calls: main, cat, city, hood, openCount, bookCount, trend, prestige, didYouMean
      mocks.prisma.$queryRaw
        .mockResolvedValueOnce([{
          id: "s1", name: "Braids Salon", category: "braids", logoUrl: null,
          city: "Dakar", neighborhood: null, averageRating: 4.5,
          latitude: null, longitude: null, subscriptionTier: "standard",
          isPrestige: false, prestigeScore: null, distance_km: null,
          match_type: "exact", matched_service: null, is_open_now: true,
          min_price_xof: 5000, trending_score: 0, exact_match: 1, min_price: 5000,
          total_count: BigInt(1),
        }])
        .mockResolvedValueOnce([{ value: "braids", count: 1 }])
        .mockResolvedValueOnce([{ value: "Dakar", count: 1 }])
        .mockResolvedValueOnce([])
        .mockResolvedValueOnce([{ count: 1 }])
        .mockResolvedValueOnce([{ count: 0 }])
        .mockResolvedValueOnce([])
        .mockResolvedValueOnce([])
        .mockResolvedValueOnce([]);

      await controller.search(
        { query: { q: "braids", limit: 20, sort: "relevance" } } as never,
        { header } as never,
      );

      expect(header).toHaveBeenCalledWith("x-cache", "MISS");
      const payload = mocks.ok.mock.calls[0][1] as any;
      expect(payload.results).toHaveLength(1);
      expect(payload.results[0].matchType).toBe("exact");
      expect(payload.facets.categories).toHaveLength(1);
      expect(payload.pageInfo.hasMore).toBe(false);
    });

    it("encodes cursor for pagination", async () => {
      const header = vi.fn();
      mocks.prisma.$queryRaw
        .mockResolvedValueOnce([{
          id: "s1", name: "S1", category: "hair", logoUrl: null,
          city: "Dakar", neighborhood: null, averageRating: 4,
          latitude: null, longitude: null, subscriptionTier: "standard",
          isPrestige: false, prestigeScore: null, distance_km: null,
          match_type: "fuzzy", matched_service: null, is_open_now: false,
          min_price_xof: null, trending_score: 0, exact_match: 0, min_price: null,
          total_count: BigInt(50),
        }])
        .mockResolvedValueOnce([])
        .mockResolvedValueOnce([])
        .mockResolvedValueOnce([])
        .mockResolvedValueOnce([{ count: 0 }])
        .mockResolvedValueOnce([{ count: 0 }])
        .mockResolvedValueOnce([])
        .mockResolvedValueOnce([])
        .mockResolvedValueOnce([]);

      await controller.search(
        { query: { q: "test", limit: 20, sort: "relevance" } } as never,
        { header } as never,
      );

      const payload = mocks.ok.mock.calls[0][1] as any;
      expect(payload.pageInfo.hasMore).toBe(true);
      expect(payload.pageInfo.nextCursor).toBeTruthy();
      const decoded = Buffer.from(payload.pageInfo.nextCursor, "base64").toString("utf-8");
      expect(decoded).toBe("20");
    });
  });

  // ── Events ────────────────────────────────────────────────────────────

  describe("trackEvents", () => {
    it("creates search events and returns accepted count", async () => {
      mocks.prisma.searchEvent.createMany.mockResolvedValue({ count: 2 });
      mocks.prisma.searchProfile.findUnique.mockResolvedValue(null);
      mocks.prisma.searchProfile.create.mockResolvedValue({});

      await controller.trackEvents(
        {
          body: {
            events: [
              { sessionKey: "sk1", eventType: "search_submitted", query: "braids" },
              { sessionKey: "sk1", eventType: "result_opened", salonId: "s1", query: "braids" },
            ],
          },
        } as never,
        {} as never,
      );

      expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { accepted: 2 });
    });

    it("updates search profile with category and city", async () => {
      mocks.prisma.searchEvent.createMany.mockResolvedValue({ count: 1 });
      mocks.prisma.searchProfile.findUnique.mockResolvedValue({
        sessionKey: "sk1",
        preferredCategories: "[]",
        preferredCities: "[]",
        preferredNeighborhoods: "[]",
        lastQueries: "[]",
        interactionCount: 0,
      });
      mocks.prisma.searchProfile.update.mockResolvedValue({});

      await controller.trackEvents(
        {
          body: {
            events: [
              { sessionKey: "sk1", eventType: "filter_applied", category: "braids", city: "Dakar" },
            ],
          },
        } as never,
        {} as never,
      );

      expect(mocks.prisma.searchProfile.update).toHaveBeenCalled();
    });

    it("creates new profile when none exists", async () => {
      mocks.prisma.searchEvent.createMany.mockResolvedValue({ count: 1 });
      mocks.prisma.searchProfile.findUnique.mockResolvedValue(null);
      mocks.prisma.searchProfile.create.mockResolvedValue({});

      await controller.trackEvents(
        {
          body: {
            events: [
              { sessionKey: "sk_new", eventType: "search_submitted", query: "manucure" },
            ],
          },
        } as never,
        {} as never,
      );

      expect(mocks.prisma.searchProfile.create).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({
            sessionKey: "sk_new",
            lastQueries: JSON.stringify(["manucure"]),
          }),
        }),
      );
    });

    it("appends to existing profile categories and queries", async () => {
      mocks.prisma.searchEvent.createMany.mockResolvedValue({ count: 1 });
      mocks.prisma.searchProfile.findUnique.mockResolvedValue({
        sessionKey: "sk1",
        preferredCategories: JSON.stringify(["hair"]),
        preferredCities: JSON.stringify(["Dakar"]),
        preferredNeighborhoods: "[]",
        lastQueries: JSON.stringify(["coiffure"]),
        interactionCount: 5,
      });
      mocks.prisma.searchProfile.update.mockResolvedValue({});

      await controller.trackEvents(
        {
          body: {
            events: [
              { sessionKey: "sk1", eventType: "filter_applied", category: "braids", city: "Thiès" },
            ],
          },
        } as never,
        {} as never,
      );

      expect(mocks.prisma.searchProfile.update).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({
            preferredCategories: JSON.stringify(["hair", "braids"]),
            preferredCities: JSON.stringify(["Dakar", "Thiès"]),
            interactionCount: 6,
          }),
        }),
      );
    });

    it("works for unauthenticated users (guest tracking)", async () => {
      mocks.requireRole.mockImplementation(() => { throw new Error("no auth"); });
      mocks.prisma.searchEvent.createMany.mockResolvedValue({ count: 1 });
      mocks.prisma.searchProfile.findUnique.mockResolvedValue(null);
      mocks.prisma.searchProfile.create.mockResolvedValue({});

      await controller.trackEvents(
        {
          body: {
            events: [
              { sessionKey: "guest_sk", eventType: "search_submitted", query: "test" },
            ],
          },
        } as never,
        {} as never,
      );

      expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { accepted: 1 });
      expect(mocks.prisma.searchEvent.createMany).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.arrayContaining([
            expect.objectContaining({ userId: null, sessionKey: "guest_sk" }),
          ]),
        }),
      );
    });
  });
});
