import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const handleError = vi.fn();
  const prisma = {
    user: { findUnique: vi.fn() },
    service: { findMany: vi.fn() },
    salon: { findUnique: vi.fn().mockResolvedValue({ subscription: { status: "active" } }) },
    platformSetting: { findUnique: vi.fn() },
    $transaction: vi.fn()
  };
  return { requireRole, fail, ok, handleError, prisma };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/http.js")>();
  return { ...actual, fail: mocks.fail, ok: mocks.ok, handleError: mocks.handleError };
});
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/cache.js", () => ({ getOrSetCachedJson: vi.fn(), invalidateCacheTags: vi.fn() }));
vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => ({ initiateDeposit: vi.fn() })) }));
vi.mock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: vi.fn() }));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: vi.fn() }));
vi.mock("./data.js", () => ({ getProAnalytics: vi.fn(), getProDashboard: vi.fn() }));

import { ProController } from "./index.js";

describe("ProController createStaff success branches", () => {
  const c = new ProController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "owner_1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);
    mocks.prisma.service.findMany.mockResolvedValue([{ id: "svc1" }, { id: "svc2" }]);
  });

  it("creates staff by updating existing same-salon user", async () => {
    const tx = {
      user: {
        findFirst: vi.fn().mockResolvedValue({ id: "u_existing", salonId: "s1", role: "salon_staff" }),
        update: vi.fn().mockResolvedValue({ id: "u_existing" }),
        create: vi.fn()
      },
      employee: {
        create: vi.fn().mockResolvedValue({
          id: "e1",
          userId: "u_existing",
          displayName: "Emp",
          avatarUrl: "https://a",
          description: "desc",
          isActive: true,
          schedulingEnabled: true
        })
      },
      employeeSpecialty: { createMany: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));

    await c.createStaff({
      body: { fullName: "Emp", phone: "771111111", avatarUrl: "https://a", description: "desc", serviceIds: ["svc1", "svc2"] }
    } as never, {} as never);

    expect(tx.user.update).toHaveBeenCalled();
    expect(tx.employeeSpecialty.createMany).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: "e1", serviceIds: ["svc1", "svc2"] }), 201);
  });

  it("creates staff by creating a new user when phone does not exist", async () => {
    const tx = {
      user: {
        findFirst: vi.fn().mockResolvedValue(null),
        update: vi.fn(),
        create: vi.fn().mockResolvedValue({ id: "u_new" })
      },
      employee: {
        create: vi.fn().mockResolvedValue({
          id: "e2",
          userId: "u_new",
          displayName: "Emp2",
          avatarUrl: null,
          description: null,
          isActive: true,
          schedulingEnabled: true
        })
      },
      employeeSpecialty: { createMany: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));

    await c.createStaff({
      body: { fullName: "Emp2", phone: "772222222", avatarUrl: null, description: null, serviceIds: [] }
    } as never, {} as never);

    expect(tx.user.create).toHaveBeenCalled();
    expect(tx.employeeSpecialty.createMany).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: "e2", serviceIds: [] }), 201);
  });

  it("maps conflict when existing phone belongs to another salon", async () => {
    const tx = {
      user: {
        findFirst: vi.fn().mockResolvedValue({ id: "uX", salonId: "other", role: "salon_staff" }),
        update: vi.fn(),
        create: vi.fn()
      },
      employee: { create: vi.fn() },
      employeeSpecialty: { createMany: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));

    await c.createStaff({
      body: { fullName: "Emp", phone: "773333333", avatarUrl: "https://a", description: null, serviceIds: [] }
    } as never, {} as never);
    expect(mocks.handleError).toHaveBeenCalled();
  });

  it("maps conflict when existing phone belongs to salon owner", async () => {
    const tx = {
      user: {
        findFirst: vi.fn().mockResolvedValue({ id: "uY", salonId: "s1", role: "salon_owner" }),
        update: vi.fn(),
        create: vi.fn()
      },
      employee: { create: vi.fn() },
      employeeSpecialty: { createMany: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));

    await c.createStaff({
      body: { fullName: "Emp", phone: "774444444", avatarUrl: "https://a", description: null, serviceIds: [] }
    } as never, {} as never);
    expect(mocks.handleError).toHaveBeenCalled();
  });

  it("rejects createStaff when team photo is required and avatar is missing", async () => {
    mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: "true" });
    await c.createStaff({
      body: { fullName: "No Photo", phone: "775555555", avatarUrl: null, description: null, serviceIds: [] }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "team_photo_required", expect.any(String));
  });
});
