import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const listSalons = vi.fn();
  const getPendingSalonDetail = vi.fn();
  const prisma = { user: { findUnique: vi.fn() } };
  return { requireRole, fail, ok, listSalons, getPendingSalonDetail, prisma };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ fail: mocks.fail, ok: mocks.ok }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("./data.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("./data.js")>();
  return {
    ...actual,
    listSalons: mocks.listSalons,
    getPendingSalonDetail: mocks.getPendingSalonDetail
  };
});

import { AdminController } from "./index.js";

describe("AdminController", () => {
  const controller = new AdminController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "admin_1", role: "platform_admin" });
    mocks.prisma.user.findUnique.mockResolvedValue({ fullName: "Admin" });
  });

  it("lists salons for admin", async () => {
    mocks.listSalons.mockResolvedValue({ items: [], total: 0 });
    await controller.listSalons({ query: {} } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { items: [], total: 0 });
  });

  it("returns 404 when salon detail not found", async () => {
    mocks.getPendingSalonDetail.mockResolvedValue(null);
    await controller.salonDetail({ params: { salonId: "s1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "salon_not_found", expect.any(String));
  });
});

