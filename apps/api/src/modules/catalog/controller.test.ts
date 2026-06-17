import { beforeEach, describe, expect, it, vi } from "vitest";
import { HttpAuthError } from "../../lib/auth/index.js";

const mocks = vi.hoisted(() => {
  const prisma = {
    salon: {
      findFirst: vi.fn(),
      findMany: vi.fn(),
      count: vi.fn()
    },
    service: {
      findFirst: vi.fn()
    },
    review: {
      findMany: vi.fn(),
      count: vi.fn()
    },
    favorite: {
      create: vi.fn(),
      deleteMany: vi.fn(),
      findMany: vi.fn()
    },
    platformSetting: {
      findMany: vi.fn()
    },
    $queryRaw: vi.fn()
  };
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const getCachedJson = vi.fn();
  const setCachedJsonWithTags = vi.fn();
  const getOrSetCachedJson = vi.fn();
  const fetchAndComputeAvailableSlots = vi.fn();
  const config = { cacheTtlCatalogSeconds: 45 };
  return { prisma, requireRole, fail, ok, getCachedJson, setCachedJsonWithTags, getOrSetCachedJson, fetchAndComputeAvailableSlots, config };
});

vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ fail: mocks.fail, ok: mocks.ok }));
vi.mock("../../lib/cache.js", () => ({
  getCachedJson: mocks.getCachedJson,
  setCachedJsonWithTags: mocks.setCachedJsonWithTags,
  getOrSetCachedJson: mocks.getOrSetCachedJson
}));
vi.mock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: mocks.fetchAndComputeAvailableSlots }));
vi.mock("../../config.js", () => ({ config: mocks.config }));

import { CatalogController } from "./index.js";

describe("CatalogController", () => {
  const controller = new CatalogController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.getCachedJson.mockResolvedValue(null);
    mocks.setCachedJsonWithTags.mockResolvedValue(undefined);
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
  });

  it("list returns cached payload on HIT", async () => {
    const header = vi.fn();
    mocks.getCachedJson.mockResolvedValueOnce({ items: [], total: 0, page: 0, pageSize: 20 });

    await controller.list({ query: {} } as never, { header } as never);

    expect(header).toHaveBeenCalledWith("x-cache", "HIT");
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("list default branch returns db payload on MISS", async () => {
    const header = vi.fn();
    mocks.prisma.$queryRaw.mockResolvedValue([
      {
        id: "s1",
        name: "Salon A",
        category: "hair",
        logoUrl: null,
        city: "Dakar",
        neighborhood: null,
        averageRating: 4.6,
        latitude: null,
        longitude: null,
        subscriptionTier: "premium",
        isPrestige: false,
        prestigeScore: null,
        total_count: BigInt(1)
      }
    ]);

    await controller.list({ query: { page: "0", pageSize: "20" } } as never, { header } as never);

    expect(header).toHaveBeenCalledWith("x-cache", "MISS");
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("list nearby branch uses raw query and returns rounded distance", async () => {
    const header = vi.fn();
    mocks.prisma.$queryRaw.mockResolvedValue([
      {
        id: "s1",
        name: "Salon A",
        category: "hair",
        logoUrl: null,
        city: "Dakar",
        neighborhood: "Almadies",
        averageRating: 4.8,
        latitude: 14.7,
        longitude: -17.4,
        subscriptionTier: "premium",
        isPrestige: true,
        prestigeScore: 90,
        distance_km: 1.26,
        total_count: BigInt(1)
      }
    ]);
    await controller.list(
      { query: { sort: "nearby", lat: "14.7", lng: "-17.4", minPrice: "1000", maxPrice: "20000" } } as never,
      { header } as never
    );
    expect(mocks.prisma.$queryRaw).toHaveBeenCalled();
    expect(header).toHaveBeenCalledWith("x-cache", "MISS");
  });

  it("list nearby maps null prestige score branch", async () => {
    const header = vi.fn();
    mocks.prisma.$queryRaw.mockResolvedValueOnce([
      {
        id: "s2",
        name: "Salon B",
        category: "hair",
        logoUrl: null,
        city: "Dakar",
        neighborhood: null,
        averageRating: 4.1,
        latitude: 14.7,
        longitude: -17.4,
        subscriptionTier: "standard",
        isPrestige: false,
        prestigeScore: null,
        distance_km: 2.2,
        total_count: BigInt(1)
      }
    ]);
    await controller.list({ query: { sort: "nearby", lat: "14.7", lng: "-17.4" } } as never, { header } as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("list nearby handles empty rows and optional query filters", async () => {
    const header = vi.fn();
    mocks.prisma.$queryRaw.mockResolvedValueOnce([]);
    await controller.list(
      { query: { sort: "nearby", lat: "14.7", lng: "-17.4", city: "Dakar", category: "hair", search: "a" } } as never,
      { header } as never
    );
    expect(header).toHaveBeenCalledWith("x-cache", "MISS");
  });

  it("list trending branch uses raw query", async () => {
    const header = vi.fn();
    mocks.prisma.$queryRaw.mockResolvedValue([
      {
        id: "s1",
        name: "Salon A",
        category: "hair",
        logoUrl: null,
        city: "Dakar",
        neighborhood: null,
        averageRating: 4.4,
        latitude: null,
        longitude: null,
        subscriptionTier: "standard",
        isPrestige: false,
        prestigeScore: null,
        booking_count: BigInt(4),
        total_count: BigInt(1)
      }
    ]);
    await controller.list({ query: { sort: "trending" } } as never, { header } as never);
    expect(mocks.prisma.$queryRaw).toHaveBeenCalled();
    expect(header).toHaveBeenCalledWith("x-cache", "MISS");
  });

  it("list trending maps non-null prestige score branch", async () => {
    const header = vi.fn();
    mocks.prisma.$queryRaw.mockResolvedValueOnce([
      {
        id: "s9",
        name: "Salon Trend",
        category: "hair",
        logoUrl: null,
        city: "Dakar",
        neighborhood: null,
        averageRating: 4.9,
        latitude: null,
        longitude: null,
        subscriptionTier: "premium",
        isPrestige: true,
        prestigeScore: 88,
        booking_count: BigInt(10),
        total_count: BigInt(1)
      }
    ]);
    await controller.list({ query: { sort: "trending" } } as never, { header } as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("list trending handles empty rows and optional SQL-filter branches", async () => {
    const header = vi.fn();
    mocks.prisma.$queryRaw.mockResolvedValueOnce([]);
    await controller.list(
      { query: { sort: "trending", city: "Dakar", category: "hair", search: "x", minPrice: "1", maxPrice: "2" } } as never,
      { header } as never
    );
    expect(header).toHaveBeenCalledWith("x-cache", "MISS");
  });

  it("list falls back from invalid nearby coordinates to default DB branch", async () => {
    const header = vi.fn();
    mocks.prisma.$queryRaw.mockResolvedValue([]);
    await controller.list({ query: { sort: "nearby", lat: "NaN", lng: "-17.4" } } as never, { header } as never);
    expect(mocks.prisma.$queryRaw).toHaveBeenCalled();
    expect(header).toHaveBeenCalledWith("x-cache", "MISS");
  });

  it("list default branch handles search and price filters", async () => {
    const header = vi.fn();
    mocks.prisma.$queryRaw.mockResolvedValue([]);
    await controller.list({
      query: { search: "coupe", minPrice: "1000", maxPrice: "20000", city: "Dakar", category: "hair" }
    } as never, { header } as never);
    expect(mocks.prisma.$queryRaw).toHaveBeenCalled();
    expect(header).toHaveBeenCalledWith("x-cache", "MISS");
  });

  it("detail returns 404 when salon missing", async () => {
    mocks.prisma.salon.findFirst.mockResolvedValue(null);
    await controller.detail({ params: { id: "s1" } } as never, { header: vi.fn() } as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "salon_not_found", expect.any(String));
  });

  it("detail returns cached payload on HIT", async () => {
    const header = vi.fn();
    mocks.getCachedJson.mockResolvedValueOnce({ id: "s1", name: "Cached" });
    await controller.detail({ params: { id: "s1" } } as never, { header } as never);
    expect(header).toHaveBeenCalledWith("x-cache", "HIT");
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { id: "s1", name: "Cached" });
  });

  it("detail maps team display flags and services", async () => {
    const header = vi.fn();
    mocks.prisma.salon.findFirst.mockResolvedValue({
      id: "s1",
      name: "Salon A",
      category: "hair",
      logoUrl: null,
      city: "Dakar",
      neighborhood: null,
      averageRating: 4.6,
      latitude: null,
      longitude: null,
      subscriptionTier: "standard",
      isPrestige: false,
      prestigeScore: null,
      description: "Desc",
      address: "Addr",
      gallery: [{ url: "https://x" }],
      employees: [{
        id: "e1",
        displayName: "Emp",
        avatarUrl: "https://a",
        description: "bio",
        specialties: [{ serviceId: "svc1" }]
      }],
      services: [{
        id: "svc1",
        name: "Coupe",
        category: "hair",
        durationMinutes: 30,
        priceXof: 10000,
        depositMode: "percent",
        depositPercent: 20,
        depositAmountXof: null
      }]
    });
    mocks.prisma.platformSetting.findMany.mockResolvedValue([
      { key: "salon:s1:team_show_photos", value: "true" },
      { key: "salon:s1:team_show_descriptions", value: "no" }
    ]);

    await controller.detail({ params: { id: "s1" } } as never, { header } as never);

    expect(mocks.ok).toHaveBeenCalled();
    expect(header).toHaveBeenCalledWith("x-cache", "MISS");
  });

  it("detail maps hidden photo and visible description branches", async () => {
    const header = vi.fn();
    mocks.prisma.salon.findFirst.mockResolvedValue({
      id: "s2",
      name: "Salon B",
      category: "hair",
      logoUrl: null,
      city: "Dakar",
      neighborhood: null,
      averageRating: 4.2,
      latitude: null,
      longitude: null,
      subscriptionTier: "premium",
      isPrestige: false,
      prestigeScore: null,
      description: "Desc",
      address: "Addr",
      gallery: [],
      employees: [{ id: "e2", displayName: "Emp2", avatarUrl: "https://a2", description: "bio2", specialties: [] }],
      services: [{
        id: "svc2", name: "S2", category: "hair", durationMinutes: 30, priceXof: 5000,
        depositMode: "fixed", depositPercent: null, depositAmountXof: 1000
      }]
    });
    mocks.prisma.platformSetting.findMany.mockResolvedValue([
      { key: "salon:s2:team_show_photos", value: "unknown" },
      { key: "salon:s2:team_show_descriptions", value: "yes" }
    ]);
    await controller.detail({ params: { id: "s2" } } as never, { header } as never);
    expect(mocks.ok).toHaveBeenCalled();
    expect(header).toHaveBeenCalledWith("x-cache", "MISS");
  });

  it("detail maps fixed and none deposit branches", async () => {
    const header = vi.fn();
    mocks.prisma.salon.findFirst.mockResolvedValue({
      id: "s3",
      name: "Salon C",
      category: "hair",
      logoUrl: null,
      city: "Dakar",
      neighborhood: null,
      averageRating: 4.1,
      latitude: null,
      longitude: null,
      subscriptionTier: "standard",
      isPrestige: false,
      prestigeScore: null,
      description: "Desc",
      address: "Addr",
      gallery: [],
      employees: [],
      services: [
        { id: "svcF", name: "SF", category: "hair", durationMinutes: 30, priceXof: 10000, depositMode: "fixed", depositPercent: null, depositAmountXof: null },
        { id: "svcN", name: "SN", category: "hair", durationMinutes: 30, priceXof: 8000, depositMode: "none", depositPercent: null, depositAmountXof: null }
      ]
    });
    mocks.prisma.platformSetting.findMany.mockResolvedValue([]);
    await controller.detail({ params: { id: "s3" } } as never, { header } as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("availability returns 404 when service missing", async () => {
    mocks.prisma.salon.findFirst.mockResolvedValue({ id: "s1" });
    mocks.prisma.service.findFirst.mockResolvedValue(null);
    await controller.availability({
      params: { id: "s1" },
      query: { serviceId: "svc1", date: "2026-01-01" }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "service_not_found", expect.any(String));
  });

  it("availability returns 404 when salon missing", async () => {
    mocks.prisma.salon.findFirst.mockResolvedValue(null);
    await controller.availability({
      params: { id: "s404" },
      query: { serviceId: "svc1", date: "2026-01-01" }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "salon_not_found", expect.any(String));
  });

  it("availability returns computed slots", async () => {
    mocks.prisma.salon.findFirst.mockResolvedValue({ id: "s1" });
    mocks.prisma.service.findFirst.mockResolvedValue({ id: "svc1", durationMinutes: 45 });
    mocks.fetchAndComputeAvailableSlots.mockResolvedValue([{ startAt: "2026-01-01T10:00:00.000Z" }]);

    await controller.availability({
      params: { id: "s1" },
      query: { serviceId: "svc1", date: "2026-01-01" }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("reviews returns cached payload on HIT", async () => {
    const header = vi.fn();
    mocks.getCachedJson.mockResolvedValueOnce({ items: [], total: 0 });
    await controller.reviews({ params: { id: "s1" }, query: {} } as never, { header } as never);
    expect(header).toHaveBeenCalledWith("x-cache", "HIT");
  });

  it("reviews MISS returns not_found and success payload", async () => {
    const header = vi.fn();
    mocks.getCachedJson.mockResolvedValueOnce(null);
    mocks.prisma.salon.findFirst.mockResolvedValueOnce(null);
    await controller.reviews({ params: { id: "s404" }, query: { page: "0", pageSize: "2" } } as never, { header } as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "salon_not_found", expect.any(String));

    mocks.prisma.salon.findFirst.mockResolvedValueOnce({ id: "s1" });
    mocks.prisma.review.findMany.mockResolvedValueOnce([
      { id: "r1", rating: 5, comment: "Top", createdAt: new Date(0), responseText: "Merci", updatedAt: new Date(1000) }
    ]);
    mocks.prisma.review.count.mockResolvedValueOnce(1);
    await controller.reviews({ params: { id: "s1" }, query: { page: "0", pageSize: "2" } } as never, { header } as never);
    expect(header).toHaveBeenCalledWith("x-cache", "MISS");
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("reviews maps responseAt null when salon response is absent", async () => {
    const header = vi.fn();
    mocks.getCachedJson.mockResolvedValueOnce(null);
    mocks.prisma.salon.findFirst.mockResolvedValueOnce({ id: "s1" });
    mocks.prisma.review.findMany.mockResolvedValueOnce([
      { id: "r2", rating: 4, comment: "ok", createdAt: new Date(0), responseText: null, updatedAt: new Date(1000) }
    ]);
    mocks.prisma.review.count.mockResolvedValueOnce(1);
    await controller.reviews({ params: { id: "s1" }, query: { page: "0", pageSize: "1" } } as never, { header } as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("pricing returns value from cache helper", async () => {
    const header = vi.fn();
    mocks.getOrSetCachedJson.mockResolvedValue({
      value: { standard: { tier: "standard", priceXof: 15000, label: "Standard" } },
      cacheStatus: "MISS"
    });
    await controller.pricing({} as never, { header } as never);
    expect(header).toHaveBeenCalledWith("x-cache", "MISS");
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("pricing load computes values from platform settings map", async () => {
    const header = vi.fn();
    mocks.prisma.platformSetting.findMany.mockResolvedValue([
      { key: "subscription_standard_price_xof", value: "17000" },
      { key: "subscription_premium_price_xof", value: "29000" },
      { key: "commission_rate_percent", value: "7.5" }
    ]);
    mocks.getOrSetCachedJson.mockImplementation(async (input: any) => ({
      value: await input.load(),
      cacheStatus: "MISS"
    }));
    await controller.pricing({} as never, { header } as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({
      standard: expect.objectContaining({ priceXof: 17000 }),
      premium: expect.objectContaining({ priceXof: 29000 }),
      commissionPercent: 7.5
    }));
  });

  it("pricing load falls back to default values when settings missing", async () => {
    const header = vi.fn();
    mocks.prisma.platformSetting.findMany.mockResolvedValueOnce([]);
    mocks.getOrSetCachedJson.mockImplementationOnce(async (input: any) => ({
      value: await input.load(),
      cacheStatus: "MISS"
    }));
    await controller.pricing({} as never, { header } as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({
      standard: expect.objectContaining({ priceXof: 200 }),
      premium: expect.objectContaining({ priceXof: 300 }),
      commissionPercent: 5
    }));
  });

  it("addFavorite returns 404 when salon missing", async () => {
    mocks.prisma.salon.findFirst.mockResolvedValue(null);
    await controller.addFavorite({ params: { salonId: "s1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "salon_not_found", expect.any(String));
  });

  it("addFavorite creates favorite", async () => {
    mocks.prisma.salon.findFirst.mockResolvedValue({ id: "s1" });
    mocks.prisma.favorite.create.mockResolvedValue({});
    await controller.addFavorite({ params: { salonId: "s1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { added: true }, 201);
  });

  it("addFavorite maps auth error", async () => {
    mocks.requireRole.mockImplementation(() => {
      throw new HttpAuthError(401, "missing_auth", "missing");
    });
    await controller.addFavorite({ params: { salonId: "s1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "missing_auth", "missing");
  });

  it("addFavorite maps unique conflict", async () => {
    mocks.prisma.salon.findFirst.mockResolvedValue({ id: "s1" });
    mocks.prisma.favorite.create.mockRejectedValue(new Error("p2002"));
    await controller.addFavorite({ params: { salonId: "s1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "already_favorited", expect.any(String));
  });

  it("addFavorite maps unexpected non-auth errors to already_favorited conflict", async () => {
    mocks.prisma.salon.findFirst.mockResolvedValue({ id: "s1" });
    mocks.prisma.favorite.create.mockRejectedValue(new Error("random"));
    await controller.addFavorite({ params: { salonId: "s1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "already_favorited", expect.any(String));
  });

  it("removeFavorite succeeds", async () => {
    mocks.prisma.favorite.deleteMany.mockResolvedValue({ count: 1 });
    await controller.removeFavorite({ params: { salonId: "s1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { removed: true });
  });

  it("removeFavorite maps internal error", async () => {
    mocks.prisma.favorite.deleteMany.mockRejectedValue(new Error("boom"));
    await controller.removeFavorite({ params: { salonId: "s1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("removeFavorite maps auth error", async () => {
    mocks.requireRole.mockImplementation(() => {
      throw new HttpAuthError(401, "missing_auth", "missing");
    });
    await controller.removeFavorite({ params: { salonId: "s1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "missing_auth", "missing");
  });

  it("listFavorites maps featured", async () => {
    mocks.prisma.favorite.findMany.mockResolvedValue([
      {
        salon: {
          id: "s1",
          name: "S",
          category: "hair",
          logoUrl: null,
          city: "Dakar",
          neighborhood: null,
          averageRating: 4,
          latitude: null,
          longitude: null,
          subscriptionTier: "premium",
          isPrestige: false,
          prestigeScore: null
        }
      }
    ]);
    await controller.listFavorites({} as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("listFavorites maps auth error", async () => {
    mocks.requireRole.mockImplementation(() => {
      throw new HttpAuthError(403, "forbidden", "forbidden");
    });
    await controller.listFavorites({} as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", "forbidden");
  });

  it("listFavorites maps unexpected internal error", async () => {
    mocks.prisma.favorite.findMany.mockRejectedValue(new Error("boom"));
    await controller.listFavorites({} as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });
});
