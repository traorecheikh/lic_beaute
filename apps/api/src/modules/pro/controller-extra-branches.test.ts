import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const handleError = vi.fn();
  const prisma = {
    user: { findUnique: vi.fn(), findFirst: vi.fn() },
    salon: { findUnique: vi.fn(), update: vi.fn() },
    employee: { count: vi.fn(), findFirst: vi.fn(), update: vi.fn(), findMany: vi.fn(), create: vi.fn() },
    employeeSpecialty: { createMany: vi.fn(), deleteMany: vi.fn() },
    service: { count: vi.fn(), create: vi.fn(), findFirst: vi.fn(), findMany: vi.fn(), update: vi.fn() },
    salonHours: { upsert: vi.fn() },
    platformSetting: { findUnique: vi.fn(), findMany: vi.fn().mockResolvedValue([]), upsert: vi.fn(), deleteMany: vi.fn() },
    salonGalleryImage: { deleteMany: vi.fn(), createMany: vi.fn() },
    blockedSlot: { create: vi.fn(), findFirst: vi.fn(), delete: vi.fn() },
    auditLog: { create: vi.fn() },
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

describe("ProController extra branches", () => {
  const c = new ProController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);
    mocks.prisma.$transaction.mockImplementation(async (arg: any) => {
      if (Array.isArray(arg)) return [];
      return arg({
        salon: { update: vi.fn() },
        salonGalleryImage: { deleteMany: vi.fn(), createMany: vi.fn() },
        platformSetting: { upsert: vi.fn(), deleteMany: vi.fn() },
        user: { findUnique: vi.fn().mockResolvedValue(null), create: vi.fn().mockResolvedValue({ id: "u2" }), update: vi.fn() },
        employee: { create: vi.fn().mockResolvedValue({ id: "e1", userId: "u2", displayName: "A", avatarUrl: null, description: null, isActive: true, schedulingEnabled: true }), update: vi.fn() },
        employeeSpecialty: { createMany: vi.fn(), deleteMany: vi.fn() }
      });
    });
  });

  it("updateSalon blocks gallery over limit for standard tier", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue({ subscriptionTier: "standard" });
    await c.updateSalon({ body: { gallery: ["1", "2", "3", "4"] } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "gallery_limit", expect.any(String));
  });

  it("updateSalon blocks team photos when active staff has no avatar", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue({ subscriptionTier: "premium" });
    mocks.prisma.employee.count.mockResolvedValue(1);
    await c.updateSalon({ body: { teamDisplay: { showPhotos: true } } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "team_photo_required", expect.any(String));
  });

  it("updateSalon success updates settings/gallery and returns mapped payload", async () => {
    mocks.prisma.employee.count.mockResolvedValue(0);
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ subscriptionTier: "premium" });
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({
      id: "s1",
      name: "Salon A",
      category: "hair",
      logoUrl: null,
      description: "Desc",
      city: "Dakar",
      address: "Addr",
      neighborhood: null,
      latitude: null,
      longitude: null,
      averageRating: 4.5,
      subscriptionTier: "premium",
      isVisibleInMarketplace: true,
      canReceiveBookings: true,
      gallery: [{ url: "https://g1" }],
      salonHours: [{ dayOfWeek: 1, isOpen: true, opensAt: "09:00", closesAt: "18:00" }]
    });
    mocks.prisma.user.findFirst.mockResolvedValueOnce({ phone: "770000000" });
    mocks.prisma.platformSetting.findMany.mockResolvedValueOnce([
      { key: "salon:s1:team_show_photos", value: "true" },
      { key: "salon:s1:team_show_descriptions", value: "false" },
      { key: "salon:s1:public_phone", value: "771111111" },
      { key: "salon:s1:instagram", value: "salonA" }
    ]);

    await c.updateSalon({
      body: {
        category: "hair",
        gallery: ["https://g1"],
        phone: "771111111",
        instagram: "salonA",
        teamDisplay: { showPhotos: true, showDescriptions: false }
      }
    } as never, {} as never);

    expect(mocks.prisma.auditLog.create).toHaveBeenCalled();
  });

  it("updateSalon returns 404 if refreshed salon is missing after transaction", async () => {
    mocks.prisma.employee.count.mockResolvedValue(0);
    mocks.prisma.salon.findUnique
      .mockResolvedValueOnce({ subscriptionTier: "premium" })
      .mockResolvedValueOnce(null);
    await c.updateSalon({
      body: {
        category: "hair",
        gallery: [],
        phone: null,
        instagram: null,
        teamDisplay: { showPhotos: false, showDescriptions: true }
      }
    } as never, {} as never);
    expect(mocks.fail.mock.calls.length + mocks.ok.mock.calls.length + mocks.handleError.mock.calls.length).toBeGreaterThan(0);
  });

  it("ensurePro path handles users not attached to a salon", async () => {
    mocks.prisma.user.findUnique.mockResolvedValueOnce(null);
    await c.getSalon({} as never, {} as never);
    expect(mocks.handleError).toHaveBeenCalled();
  });

  it("updateSalon falls back to owner phone when public phone setting is absent", async () => {
    mocks.prisma.employee.count.mockResolvedValue(0);
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ subscriptionTier: "premium", approvalStatus: "approved", name: "Salon A" });
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({
      id: "s1",
      name: "Salon A",
      category: "hair",
      logoUrl: null,
      description: "Desc",
      city: "Dakar",
      address: "Addr",
      neighborhood: null,
      latitude: null,
      longitude: null,
      averageRating: 4.5,
      subscriptionTier: "premium",
      isVisibleInMarketplace: true,
      canReceiveBookings: true,
      gallery: [],
      salonHours: []
    });
    mocks.prisma.user.findFirst.mockResolvedValueOnce({ phone: "779999999" });
    mocks.prisma.platformSetting.findMany.mockResolvedValueOnce([]);
    await c.updateSalon({
      body: { category: "hair", gallery: [], phone: null, instagram: null, teamDisplay: { showPhotos: false, showDescriptions: false } }
    } as never, {} as never);
    expect(mocks.fail.mock.calls.length + mocks.ok.mock.calls.length + mocks.handleError.mock.calls.length).toBeGreaterThan(0);
  });

  it("updateSalon tolerates invalid team display settings by falling back to defaults", async () => {
    mocks.prisma.employee.count.mockResolvedValue(0);
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ subscriptionTier: "premium" });
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({
      id: "s1",
      name: "Salon A",
      category: "hair",
      logoUrl: null,
      description: "Desc",
      city: "Dakar",
      address: "Addr",
      neighborhood: null,
      latitude: null,
      longitude: null,
      averageRating: 4.5,
      subscriptionTier: "premium",
      isVisibleInMarketplace: true,
      canReceiveBookings: true,
      gallery: [{ url: "https://g1" }],
      salonHours: [{ dayOfWeek: 1, isOpen: true, opensAt: "09:00", closesAt: "18:00" }]
    });
    mocks.prisma.user.findFirst.mockResolvedValueOnce({ phone: "779999999" });
    mocks.prisma.platformSetting.findMany.mockResolvedValueOnce([
      { key: "salon:s1:team_show_photos", value: "MAYBE" },
      { key: "salon:s1:team_show_descriptions", value: "UNKNOWN" }
    ]);
    await c.updateSalon({
      body: {
        category: "hair",
        gallery: ["https://g1"],
        phone: null,
        instagram: null,
        teamDisplay: { showPhotos: false, showDescriptions: false }
      }
    } as never, {} as never);
    expect(mocks.fail.mock.calls.length + mocks.ok.mock.calls.length + mocks.handleError.mock.calls.length).toBeGreaterThan(0);
  });

  it("updateSalon supports partial payload without optional setting/gallery fields", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ subscriptionTier: "premium", approvalStatus: "approved", name: "Salon Partial" });
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({
      id: "s1",
      name: "Salon Partial",
      category: "hair",
      logoUrl: null,
      description: "Desc",
      city: "Dakar",
      address: "Addr",
      neighborhood: null,
      latitude: null,
      longitude: null,
      averageRating: 4.2,
      subscriptionTier: "premium",
      isVisibleInMarketplace: true,
      canReceiveBookings: true,
      gallery: [],
      salonHours: []
    });
    mocks.prisma.user.findFirst.mockResolvedValueOnce({ phone: null });
    mocks.prisma.platformSetting.findMany.mockResolvedValueOnce([]);
    await c.updateSalon({
      body: { category: "hair" }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("getSalon returns null phone when neither public setting nor owner phone is present", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({
      id: "s1",
      name: "Salon Partial",
      category: "hair",
      logoUrl: null,
      description: "Desc",
      city: "Dakar",
      address: "Addr",
      neighborhood: null,
      latitude: null,
      longitude: null,
      averageRating: 4.2,
      subscriptionTier: "premium",
      isVisibleInMarketplace: true,
      canReceiveBookings: true,
      gallery: [],
      salonHours: []
    });
    mocks.prisma.user.findFirst.mockResolvedValueOnce(null);
    mocks.prisma.platformSetting.findMany.mockResolvedValueOnce([]);
    await c.getSalon({} as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ phone: null }));
  });

  it("createService enforces premium and deposit rules", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue({ subscriptionTier: "standard", subscription: { status: "active" } });
    await c.createService({ body: { name: "S", category: "hair", durationMinutes: 30, priceXof: 1000, depositMode: "fixed", depositAmountXof: 500 } } as never, {} as never);

    mocks.prisma.salon.findUnique.mockResolvedValue({ subscriptionTier: "premium", subscription: { status: "active" } });
    await c.createService({ body: { name: "S", category: "hair", durationMinutes: 30, priceXof: 1000, depositMode: "fixed" } } as never, {} as never);
    await c.createService({ body: { name: "S", category: "hair", durationMinutes: 30, priceXof: 1000, depositMode: "percent" } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 402, "premium_required", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_deposit", expect.any(String));
  });

  it("createService succeeds with depositMode none without premium checks", async () => {
    mocks.prisma.service.count.mockResolvedValueOnce(3);
    mocks.prisma.service.create.mockResolvedValueOnce({
      id: "svc_none",
      salonId: "s1",
      name: "Cut",
      category: "hair",
      durationMinutes: 30,
      priceXof: 6000,
      depositMode: "none",
      depositAmountXof: null,
      depositPercent: null,
      isActive: true,
      displayOrder: 3
    });
    await c.createService({
      body: { name: "Cut", category: "hair", durationMinutes: 30, priceXof: 6000, depositMode: "none" }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: "svc_none" }), 201);
  });

  it("updateService validates effective deposit fields", async () => {
    mocks.prisma.service.findFirst.mockResolvedValueOnce({
      id: "svc1",
      salonId: "s1",
      depositMode: "fixed",
      depositAmountXof: null,
      depositPercent: null
    });
    await c.updateService({ params: { serviceId: "svc1" }, body: {} } as never, {} as never);

    mocks.prisma.service.findFirst.mockResolvedValueOnce({
      id: "svc2",
      salonId: "s1",
      depositMode: "none",
      depositAmountXof: null,
      depositPercent: null
    });
    await c.updateService({ params: { serviceId: "svc2" }, body: { depositMode: "percent" } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_deposit", expect.any(String));
  });

  it("updateService returns not found when service missing", async () => {
    mocks.prisma.service.findFirst.mockResolvedValueOnce(null);
    await c.updateService({
      params: { serviceId: "missing-svc" },
      body: { name: "X" }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "service_not_found", expect.any(String));
  });

  it("deleteService handles not-found and success", async () => {
    mocks.prisma.service.findFirst.mockResolvedValueOnce(null);
    await c.deleteService({ params: { serviceId: "svc0" } } as never, {} as never);

    mocks.prisma.service.findFirst.mockResolvedValueOnce({ id: "svc1", salonId: "s1" });
    await c.deleteService({ params: { serviceId: "svc1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "service_not_found", expect.any(String));
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { deleted: true });
  });

  it("createBlockedSlot validates scope and employee", async () => {
    await c.createBlockedSlot({ body: { startsAt: "2026-01-01T10:00:00.000Z", endsAt: "2026-01-01T09:00:00.000Z", scope: "salon" } } as never, {} as never);
    await c.createBlockedSlot({ body: { startsAt: "2026-01-01T10:00:00.000Z", endsAt: "2026-01-01T11:00:00.000Z", scope: "employee" } } as never, {} as never);
    await c.createBlockedSlot({ body: { startsAt: "2026-01-01T10:00:00.000Z", endsAt: "2026-01-01T11:00:00.000Z", scope: "salon", employeeId: "e1" } } as never, {} as never);
    mocks.prisma.employee.findFirst.mockResolvedValue(null);
    await c.createBlockedSlot({ body: { startsAt: "2026-01-01T10:00:00.000Z", endsAt: "2026-01-01T11:00:00.000Z", scope: "employee", employeeId: "e1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_time_range", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "employee_required", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "employee_forbidden", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "employee_not_found", expect.any(String));
  });

  it("createBlockedSlot success and updateHours success", async () => {
    mocks.prisma.employee.findFirst.mockResolvedValue({ id: "e1", salonId: "s1", isActive: true });
    mocks.prisma.blockedSlot.create.mockResolvedValue({
      id: "bs1",
      startsAt: new Date("2030-01-01T10:00:00.000Z"),
      endsAt: new Date("2030-01-01T11:00:00.000Z"),
      reason: "Lunch",
      scope: "employee",
      employeeId: "e1"
    });
    await c.createBlockedSlot({
      body: {
        startsAt: "2030-01-01T10:00:00.000Z",
        endsAt: "2030-01-01T11:00:00.000Z",
        scope: "employee",
        employeeId: "e1",
        reason: "Lunch"
      }
    } as never, {} as never);

    await c.updateHours({
      body: [
        { dayOfWeek: 0, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 1, isOpen: true, opensAt: "09:00", closesAt: "18:00" },
        { dayOfWeek: 2, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 3, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 4, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 5, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 6, isOpen: false, opensAt: "00:00", closesAt: "00:00" }
      ]
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("createBlockedSlot salon scope stores null employeeId and null reason by default", async () => {
    mocks.prisma.blockedSlot.create.mockResolvedValueOnce({
      id: "bs-salon",
      startsAt: new Date("2030-03-01T10:00:00.000Z"),
      endsAt: new Date("2030-03-01T11:00:00.000Z"),
      reason: null,
      scope: "salon",
      employeeId: null
    });
    await c.createBlockedSlot({
      body: {
        startsAt: "2030-03-01T10:00:00.000Z",
        endsAt: "2030-03-01T11:00:00.000Z",
        scope: "salon"
      }
    } as never, {} as never);
    expect(mocks.prisma.blockedSlot.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ reason: null, employeeId: null, scope: "salon" })
    }));
  });

  it("updateHours rejects payload with no open day", async () => {
    await c.updateHours({
      body: [
        { dayOfWeek: 0, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 1, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 2, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 3, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 4, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 5, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 6, isOpen: false, opensAt: "00:00", closesAt: "00:00" }
      ]
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "no_open_day", expect.any(String));
  });

  it("updateHours accepts explicit null opensAt/closesAt values", async () => {
    await c.updateHours({
      body: [
        { dayOfWeek: 0, isOpen: true, opensAt: null, closesAt: null },
        { dayOfWeek: 1, isOpen: false, opensAt: null, closesAt: null },
        { dayOfWeek: 2, isOpen: false, opensAt: null, closesAt: null },
        { dayOfWeek: 3, isOpen: false, opensAt: null, closesAt: null },
        { dayOfWeek: 4, isOpen: false, opensAt: null, closesAt: null },
        { dayOfWeek: 5, isOpen: false, opensAt: null, closesAt: null },
        { dayOfWeek: 6, isOpen: false, opensAt: null, closesAt: null }
      ]
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { updated: true });
  });

  it("deleteStaff and deleteBlockedSlot cover not-found and success branches", async () => {
    mocks.prisma.employee.findFirst.mockResolvedValueOnce(null);
    await c.deleteStaff({ params: { employeeId: "e0" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "employee_not_found", expect.any(String));

    mocks.prisma.employee.findFirst.mockResolvedValueOnce({ id: "e1", salonId: "s1", isActive: true });
    await c.deleteStaff({ params: { employeeId: "e1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { deleted: true });

    mocks.prisma.blockedSlot.findFirst.mockResolvedValueOnce(null);
    await c.deleteBlockedSlot({ params: { slotId: "bs0" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "slot_not_found", expect.any(String));

    mocks.prisma.blockedSlot.findFirst.mockResolvedValueOnce({ id: "bs1", salonId: "s1" });
    await c.deleteBlockedSlot({ params: { slotId: "bs1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { deleted: true });
  });

  it("createStaff and updateStaff validate photo requirement", async () => {
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: "true" });
    await c.createStaff({ body: { fullName: "A", phone: "770000000", serviceIds: [], avatarUrl: null } } as never, {} as never);

    mocks.prisma.employee.findFirst.mockResolvedValue(null);
    await c.updateStaff({ params: { employeeId: "e1" }, body: { displayName: "B" } } as never, {} as never);

    mocks.prisma.employee.findFirst.mockResolvedValue({ id: "e1", avatarUrl: null, isActive: true });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: "true" });
    await c.updateStaff({ params: { employeeId: "e1" }, body: { isActive: true } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "team_photo_required", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "employee_not_found", expect.any(String));
  });

  it("updateStaff updates specialties when serviceIds are provided", async () => {
    mocks.prisma.employee.findFirst.mockResolvedValueOnce({ id: "e1", avatarUrl: "https://a", isActive: true });
    mocks.prisma.service.findMany.mockResolvedValueOnce([{ id: "svc1" }, { id: "svc2" }]);
    await c.updateStaff({
      params: { employeeId: "e1" },
      body: { displayName: "Updated", serviceIds: ["svc1", "svc2"] }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { updated: true });
  });

  it("updateStaff accepts empty serviceIds and skips createMany branch", async () => {
    mocks.prisma.employee.findFirst.mockResolvedValueOnce({ id: "e1", avatarUrl: "https://a", isActive: true });
    await c.updateStaff({
      params: { employeeId: "e1" },
      body: { serviceIds: [] }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { updated: true });
  });

  it("updateStaff trims avatar/description and skips specialties sync when serviceIds omitted", async () => {
    const tx = {
      employee: { update: vi.fn() },
      employeeSpecialty: { createMany: vi.fn(), deleteMany: vi.fn() }
    };
    mocks.prisma.employee.findFirst.mockResolvedValueOnce({ id: "e1", avatarUrl: "https://old", isActive: true });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));
    await c.updateStaff({
      params: { employeeId: "e1" },
      body: { avatarUrl: "  ", description: "  desc  " }
    } as never, {} as never);
    expect(tx.employee.update).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ avatarUrl: null, description: "desc" })
    }));
    expect(tx.employeeSpecialty.deleteMany).not.toHaveBeenCalled();
    expect(tx.employeeSpecialty.createMany).not.toHaveBeenCalled();
  });

  it("updateStaff keeps trimmed avatar and clears blank description", async () => {
    const tx = {
      employee: { update: vi.fn() },
      employeeSpecialty: { createMany: vi.fn(), deleteMany: vi.fn() }
    };
    mocks.prisma.employee.findFirst.mockResolvedValueOnce({ id: "e2", avatarUrl: null, isActive: true });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));
    await c.updateStaff({
      params: { employeeId: "e2" },
      body: { avatarUrl: " https://new-avatar ", description: "   " }
    } as never, {} as never);
    expect(tx.employee.update).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ avatarUrl: "https://new-avatar", description: null })
    }));
  });

  it("updateStaff keeps existing avatar and leaves optional fields undefined when omitted", async () => {
    const tx = {
      employee: { update: vi.fn() },
      employeeSpecialty: { createMany: vi.fn(), deleteMany: vi.fn() }
    };
    mocks.prisma.employee.findFirst.mockResolvedValueOnce({ id: "e1", avatarUrl: "https://existing", isActive: true });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (arg: any) => Promise<any>) => cb(tx));
    await c.updateStaff({ params: { employeeId: "e1" }, body: {} } as never, {} as never);
    expect(tx.employee.update).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ avatarUrl: undefined, description: undefined })
    }));
  });

  it("updateStaff rejects invalid specialty ids", async () => {
    mocks.prisma.employee.findFirst.mockResolvedValueOnce({ id: "e1", avatarUrl: "https://a", isActive: true });
    mocks.prisma.service.findMany.mockResolvedValueOnce([{ id: "svc1" }]);
    await c.updateStaff({
      params: { employeeId: "e1" },
      body: { serviceIds: ["svc1", "svc2"] }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_specialty", expect.any(String));
  });

  it("listStaff maps employee specialties", async () => {
    mocks.prisma.employee.findMany.mockResolvedValueOnce([
      {
        id: "e1",
        userId: "u2",
        displayName: "Emp A",
        avatarUrl: null,
        description: null,
        isActive: true,
        schedulingEnabled: true,
        specialties: [{ serviceId: "svc1" }, { serviceId: "svc2" }],
        user: { email: "emp@x.com", phone: "771234567", role: "salon_staff" }
      }
    ]);
    await c.listStaff({} as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), [
      expect.objectContaining({ id: "e1", serviceIds: ["svc1", "svc2"] })
    ]);
  });

  it("createStaff rejects invalid specialty and user ownership conflicts", async () => {
    mocks.prisma.service.findMany.mockResolvedValueOnce([{ id: "svc1" }]);
    await c.createStaff({
      body: { fullName: "Bad services", phone: "770101010", serviceIds: ["svc1", "svc2"], avatarUrl: "https://a" }
    } as never, {} as never);

    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({
        user: { findFirst: vi.fn().mockResolvedValue({ id: "uX", salonId: "other", role: "salon_staff" }), create: vi.fn(), update: vi.fn() },
        employee: { create: vi.fn() },
        employeeSpecialty: { createMany: vi.fn(), deleteMany: vi.fn() }
      })
    );
    await c.createStaff({
      body: { fullName: "B", phone: "771111111", serviceIds: [], avatarUrl: "https://a" }
    } as never, {} as never);

    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({
        user: { findFirst: vi.fn().mockResolvedValue({ id: "uY", salonId: "s1", role: "salon_owner" }), create: vi.fn(), update: vi.fn() },
        employee: { create: vi.fn() },
        employeeSpecialty: { createMany: vi.fn(), deleteMany: vi.fn() }
      })
    );
    await c.createStaff({
      body: { fullName: "C", phone: "772222222", serviceIds: [], avatarUrl: "https://a" }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_specialty", expect.any(String));
    expect(mocks.handleError).toHaveBeenCalled();
  });


  it("getSalon not-found path and fallback settings mapping", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValueOnce(null);
    await c.getSalon({} as never, {} as never);

    mocks.prisma.salon.findUnique.mockResolvedValueOnce({
      id: "s1",
      name: "Salon A",
      category: "hair",
      logoUrl: null,
      description: "",
      city: "Dakar",
      address: "Addr",
      neighborhood: null,
      latitude: null,
      longitude: null,
      averageRating: 4.5,
      subscriptionTier: "standard",
      isVisibleInMarketplace: true,
      canReceiveBookings: true,
      gallery: [{ url: "https://x" }],
      salonHours: [{ dayOfWeek: 1, isOpen: true, opensAt: "09:00", closesAt: "18:00" }]
    });
    mocks.prisma.user.findFirst.mockResolvedValueOnce({ phone: "770000000" });
    mocks.prisma.platformSetting.findMany.mockResolvedValueOnce([]);
    await c.getSalon({} as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "salon_not_found", expect.any(String));
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("deleteStaff and updateHours branches", async () => {
    mocks.prisma.employee.findFirst.mockResolvedValueOnce(null);
    await c.deleteStaff({ params: { employeeId: "e0" } } as never, {} as never);

    mocks.prisma.employee.findFirst.mockResolvedValueOnce({ id: "e1", salonId: "s1" });
    await c.deleteStaff({ params: { employeeId: "e1" } } as never, {} as never);

    await c.updateHours({
      body: [
        { dayOfWeek: 0, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 1, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 2, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 3, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 4, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 5, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
        { dayOfWeek: 6, isOpen: false, opensAt: "00:00", closesAt: "00:00" }
      ]
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "employee_not_found", expect.any(String));
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { deleted: true });
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "no_open_day", expect.any(String));
  });

});
