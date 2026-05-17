import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const prisma = { user: { findUnique: vi.fn() } };
  return { requireRole, fail, ok, prisma };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ fail: mocks.fail, ok: mocks.ok }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/cache.js", () => ({ getOrSetCachedJson: vi.fn(), invalidateCacheTags: vi.fn() }));
vi.mock("./data.js", () => ({
  approveSalon: vi.fn(),
  deleteRequiredDocument: vi.fn(),
  deleteSalonCategory: vi.fn(),
  getAdminDashboard: vi.fn(),
  getAuditDetail: vi.fn(),
  getPendingSalonDetail: vi.fn(),
  getPlatformSettings: vi.fn(),
  getSubscriptionDetail: vi.fn(),
  listAuditEvents: vi.fn(),
  listPendingSalons: vi.fn(),
  listRequiredDocuments: vi.fn(),
  listSalonCategories: vi.fn(),
  listSalons: vi.fn(),
  listSubscriptions: vi.fn(),
  overrideSubscription: vi.fn(),
  rejectSalon: vi.fn(),
  requestSalonInfo: vi.fn(),
  updatePlatformSetting: vi.fn(),
  upsertRequiredDocument: vi.fn(),
  upsertSalonCategory: vi.fn(),
  createSalon: vi.fn()
}));

import { HttpAuthError } from "../../lib/auth/index.js";
import { AdminController } from "./index.js";

describe("AdminController auth failures", () => {
  const c = new AdminController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockImplementation(() => {
      throw new HttpAuthError(401, "missing_auth", "No auth");
    });
  });

  it("blocks all endpoints without admin auth", async () => {
    const rep = {} as never;
    await c.dashboard({ query: {} } as never, rep);
    await c.listPendingSalons({ query: {} } as never, rep);
    await c.listSalons({ query: {} } as never, rep);
    await c.salonDetail({ params: { salonId: "s1" } } as never, rep);
    await c.approveSalon({ params: { salonId: "s1" } } as never, rep);
    await c.rejectSalon({ params: { salonId: "s1" }, body: { reason: "x" } } as never, rep);
    await c.requestSalonInfo({ params: { salonId: "s1" }, body: { reason: "x" } } as never, rep);
    await c.createSalon({ body: {} } as never, rep);
    await c.listSubscriptions({ query: {} } as never, rep);
    await c.subscriptionDetail({ params: { subscriptionId: "sub1" } } as never, rep);
    await c.overrideSubscription({ params: { subscriptionId: "sub1" }, body: {} } as never, rep);
    await c.listAudit({ query: {} } as never, rep);
    await c.auditDetail({ params: { auditId: "a1" } } as never, rep);
    await c.listSettings({ query: {} } as never, rep);
    await c.updateSetting({ params: { key: "x" }, body: { value: "v" } } as never, rep);
    await c.listCategories({} as never, rep);
    await c.upsertCategory({ body: {} } as never, rep);
    await c.deleteCategory({ params: { id: "c1" } } as never, rep);
    await c.listDocuments({} as never, rep);
    await c.upsertDocument({ body: {} } as never, rep);
    await c.deleteDocument({ params: { id: "d1" } } as never, rep);
    expect(mocks.fail).toHaveBeenCalled();
  });

  it("maps unexpected auth errors to invalid_token", async () => {
    mocks.requireRole.mockImplementation(() => {
      throw new Error("boom");
    });
    await c.dashboard({ query: {} } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "invalid_token", "Session invalide.");
  });
});
