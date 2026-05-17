import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const getOrSetCachedJson = vi.fn();
  const invalidateCacheTags = vi.fn();
  const prisma = { user: { findUnique: vi.fn() } };
  const data = {
    getAdminDashboard: vi.fn(),
    listPendingSalons: vi.fn(),
    listSalons: vi.fn(),
    getPendingSalonDetail: vi.fn(),
    approveSalon: vi.fn(),
    rejectSalon: vi.fn(),
    requestSalonInfo: vi.fn(),
    createSalon: vi.fn(),
    listSubscriptions: vi.fn(),
    getSubscriptionDetail: vi.fn(),
    overrideSubscription: vi.fn(),
    listAuditEvents: vi.fn(),
    getAuditDetail: vi.fn(),
    getPlatformSettings: vi.fn(),
    updatePlatformSetting: vi.fn(),
    listSalonCategories: vi.fn(),
    upsertSalonCategory: vi.fn(),
    deleteSalonCategory: vi.fn(),
    listRequiredDocuments: vi.fn(),
    upsertRequiredDocument: vi.fn(),
    deleteRequiredDocument: vi.fn()
  };
  return { requireRole, fail, ok, getOrSetCachedJson, invalidateCacheTags, prisma, data };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ fail: mocks.fail, ok: mocks.ok }));
vi.mock("../../lib/cache.js", () => ({
  getOrSetCachedJson: mocks.getOrSetCachedJson,
  invalidateCacheTags: mocks.invalidateCacheTags
}));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("./data.js", () => mocks.data);

import { AdminController } from "./index.js";

describe("AdminController success paths", () => {
  const c = new AdminController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "admin_1", role: "platform_admin" });
    mocks.prisma.user.findUnique.mockResolvedValue({ fullName: "Admin User" });
  });

  it("covers dashboard/list/detail and decision actions", async () => {
    const rep = { header: vi.fn() } as never;
    mocks.getOrSetCachedJson.mockImplementation(async (input: any) => ({
      value: await input.load(),
      cacheStatus: "MISS"
    }));
    mocks.data.getAdminDashboard.mockResolvedValue({ kpis: [] });
    mocks.data.listPendingSalons.mockResolvedValue({ items: [], total: 0 });
    mocks.data.listSalons.mockResolvedValue({ items: [], total: 0 });
    mocks.data.getPendingSalonDetail.mockResolvedValue({ id: "s1" });
    mocks.data.approveSalon.mockResolvedValue({ id: "s1" });
    mocks.data.rejectSalon.mockResolvedValue({ id: "s1" });
    mocks.data.requestSalonInfo.mockResolvedValue({ id: "s1" });
    mocks.data.createSalon.mockResolvedValue({ id: "s1" });

    await c.dashboard({ query: {} } as never, rep);
    await c.listPendingSalons({ query: {} } as never, rep);
    await c.listSalons({ query: {} } as never, rep);
    await c.salonDetail({ params: { salonId: "s1" } } as never, rep);
    await c.approveSalon({ params: { salonId: "s1" } } as never, rep);
    await c.rejectSalon({ params: { salonId: "s1" }, body: { reason: "Bad docs" } } as never, rep);
    await c.requestSalonInfo({ params: { salonId: "s1" }, body: { reason: "Need details" } } as never, rep);
    await c.createSalon({
      body: {
        name: "Salon A",
        category: "hair",
        city: "Dakar",
        address: "Rue 10 Dakar",
        description: "Description complete salon",
        ownerEmail: "owner@example.com",
        ownerPhone: "771234567",
        ownerName: "Owner A"
      }
    } as never, rep);

    expect(mocks.ok).toHaveBeenCalled();
    expect(mocks.invalidateCacheTags).toHaveBeenCalled();
  });

  it("covers subscription/audit/config endpoints", async () => {
    const rep = { header: vi.fn() } as never;
    mocks.data.listSubscriptions.mockResolvedValue({ items: [], total: 0, summary: {} });
    mocks.data.getSubscriptionDetail.mockResolvedValue({ id: "sub1" });
    mocks.data.overrideSubscription.mockResolvedValue({ id: "sub1" });
    mocks.data.listAuditEvents.mockResolvedValue({ items: [], total: 0 });
    mocks.data.getAuditDetail.mockResolvedValue({ id: "a1" });
    mocks.data.getPlatformSettings.mockResolvedValue([]);
    mocks.data.updatePlatformSetting.mockResolvedValue({ key: "k", value: "v" });
    mocks.data.listSalonCategories.mockResolvedValue([]);
    mocks.data.upsertSalonCategory.mockResolvedValue({ id: "c1" });
    mocks.data.deleteSalonCategory.mockResolvedValue({ id: "c1" });
    mocks.data.listRequiredDocuments.mockResolvedValue([]);
    mocks.data.upsertRequiredDocument.mockResolvedValue({ id: "d1" });
    mocks.data.deleteRequiredDocument.mockResolvedValue({ id: "d1" });

    await c.listSubscriptions({ query: {} } as never, rep);
    await c.subscriptionDetail({ params: { subscriptionId: "sub1" } } as never, rep);
    await c.overrideSubscription({
      params: { subscriptionId: "sub1" },
      body: {
        action: "pause_subscription",
        reason: "Ops pause",
        effectiveAt: new Date().toISOString()
      }
    } as never, rep);
    await c.listAudit({ query: {} } as never, rep);
    await c.auditDetail({ params: { auditId: "a1" } } as never, rep);
    await c.listSettings({ query: {} } as never, rep);
    await c.updateSetting({ params: { key: "site_title" }, body: { value: "BA" } } as never, rep);
    await c.listCategories({} as never, rep);
    await c.upsertCategory({ body: { name: "Hair", slug: "hair", enabled: true } } as never, rep);
    await c.deleteCategory({ params: { id: "c1" } } as never, rep);
    await c.listDocuments({} as never, rep);
    await c.upsertDocument({ body: { label: "ID", slug: "id", type: "pdf", isRequired: true, enabled: true } } as never, rep);
    await c.deleteDocument({ params: { id: "d1" } } as never, rep);

    expect(mocks.ok).toHaveBeenCalled();
  });

  it("updateSetting blocks reserved key prefixes", async () => {
    await c.updateSetting({ params: { key: "security:otp:lock" }, body: { value: "x" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      403,
      "reserved_key",
      "Cette clé est réservée au système et ne peut pas être modifiée via l'API."
    );
  });

  it("returns not-found errors for detail endpoints when entities are missing", async () => {
    mocks.data.getPendingSalonDetail.mockResolvedValue(null);
    mocks.data.getSubscriptionDetail.mockResolvedValue(null);
    mocks.data.overrideSubscription.mockResolvedValue(null);
    mocks.data.getAuditDetail.mockResolvedValue(null);
    await c.salonDetail({ params: { salonId: "s-miss" } } as never, {} as never);
    await c.subscriptionDetail({ params: { subscriptionId: "sub-miss" } } as never, {} as never);
    await c.overrideSubscription({
      params: { subscriptionId: "sub-miss" },
      body: { action: "pause_subscription", reason: "ops", effectiveAt: new Date().toISOString() }
    } as never, {} as never);
    await c.auditDetail({ params: { auditId: "audit-miss" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalled();
  });

  it("covers actor-name fallback and not-found branches on decision endpoints", async () => {
    mocks.prisma.user.findUnique.mockResolvedValueOnce(null);
    mocks.data.approveSalon.mockResolvedValueOnce(null);
    await c.approveSalon({ params: { salonId: "s-miss-approve" } } as never, {} as never);

    mocks.prisma.user.findUnique.mockResolvedValueOnce(null);
    mocks.data.rejectSalon.mockResolvedValueOnce(null);
    await c.rejectSalon({ params: { salonId: "s-miss-reject" }, body: { reason: "bad docs" } } as never, {} as never);

    mocks.prisma.user.findUnique.mockResolvedValueOnce(null);
    mocks.data.requestSalonInfo.mockResolvedValueOnce(null);
    await c.requestSalonInfo({ params: { salonId: "s-miss-info" }, body: { reason: "need docs" } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "salon_not_found", expect.any(String));
  });
});
