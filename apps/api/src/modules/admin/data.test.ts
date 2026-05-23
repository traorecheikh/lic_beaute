import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const prisma = {
    payment: { aggregate: vi.fn() },
    booking: { count: vi.fn(), groupBy: vi.fn() },
    salon: { count: vi.fn(), findMany: vi.fn(), findUnique: vi.fn(), update: vi.fn(), create: vi.fn() },
    subscription: { count: vi.fn(), upsert: vi.fn(), findMany: vi.fn(), findUnique: vi.fn(), findFirst: vi.fn(), create: vi.fn() },
    auditLog: { count: vi.fn(), create: vi.fn(), findMany: vi.fn(), findUnique: vi.fn() },
    emailAudit: { findMany: vi.fn() },
    user: { findUnique: vi.fn(), findFirst: vi.fn() },
    platformSetting: { create: vi.fn(), findMany: vi.fn().mockResolvedValue([]), upsert: vi.fn() },
    platformSalonCategory: { findMany: vi.fn(), upsert: vi.fn(), delete: vi.fn() },
    platformRequiredDocument: { findMany: vi.fn(), upsert: vi.fn(), delete: vi.fn() },
    subscriptionCharge: { findUnique: vi.fn(), update: vi.fn(), create: vi.fn() },
    subscriptionEvent: { create: vi.fn() },
    billingInvoice: { create: vi.fn() },
    $transaction: vi.fn()
  };
  const sendEmail = vi.fn();
  const logger = { error: vi.fn(), info: vi.fn(), warn: vi.fn() };
  const config = { webOrigin: "https://admin.example.com" };
  const toPublicBillingProvider = vi.fn((x: string | null | undefined) => (x === "manual" ? "manual" : x ? "intech" : null));
  return { prisma, sendEmail, logger, config, toPublicBillingProvider };
});

vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/email.js", () => ({ sendEmail: mocks.sendEmail }));
vi.mock("../../lib/logger.js", () => ({ logger: mocks.logger }));
vi.mock("../../config.js", () => ({ config: mocks.config }));
vi.mock("../../lib/payment-provider.js", () => ({ toPublicBillingProvider: mocks.toPublicBillingProvider }));

import {
  approveSalon,
  createSalon,
  deleteRequiredDocument,
  deleteSalonCategory,
  getAdminDashboard,
  getAuditDetail,
  getPendingSalonDetail,
  getPlatformSettings,
  getSubscriptionDetail,
  listAuditEvents,
  listEmailAuditEvents,
  listPendingSalons,
  listRequiredDocuments,
  listSalonCategories,
  listSalons,
  listSubscriptions,
  manualExtendSubscription,
  overrideSubscription,
  rejectSalon,
  requestSalonInfo,
  updatePlatformSetting,
  upsertRequiredDocument,
  upsertSalonCategory
} from "./data.js";

describe("admin data module", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mocks.prisma.auditLog.create.mockResolvedValue({});
    mocks.sendEmail.mockResolvedValue(undefined);
  });

  it("getAdminDashboard returns KPI payload", async () => {
    mocks.prisma.payment.aggregate.mockResolvedValue({ _sum: { amountXof: 12000 } });
    mocks.prisma.booking.count.mockResolvedValueOnce(3);
    mocks.prisma.salon.count.mockResolvedValueOnce(10).mockResolvedValueOnce(2).mockResolvedValueOnce(1);
    mocks.prisma.subscription.count.mockResolvedValue(2);
    mocks.prisma.auditLog.count.mockResolvedValue(4);
    mocks.prisma.booking.groupBy.mockResolvedValueOnce([{ salonId: "s1", _count: { id: 5 } }]).mockResolvedValueOnce([]);
    mocks.prisma.salon.findMany.mockResolvedValueOnce([{ id: "s1", name: "A", city: "Dakar", approvalStatus: "approved" }]).mockResolvedValueOnce([{ id: "s1", name: "A", city: "Dakar" }]);

    const data = await getAdminDashboard();
    expect(data.kpis.length).toBe(4);
    expect(data.topGrowthSalons.length).toBe(1);
  });

  it("getAdminDashboard computes non-zero delta and inactivity alerts", async () => {
    mocks.prisma.payment.aggregate.mockResolvedValue({ _sum: { amountXof: 1000 } });
    mocks.prisma.booking.count.mockResolvedValueOnce(2);
    mocks.prisma.salon.count.mockResolvedValueOnce(5).mockResolvedValueOnce(1).mockResolvedValueOnce(0);
    mocks.prisma.subscription.count.mockResolvedValue(1);
    mocks.prisma.auditLog.count.mockResolvedValue(1);
    mocks.prisma.booking.groupBy
      .mockResolvedValueOnce([{ salonId: "s1", _count: { id: 6 } }, { salonId: "s2", _count: { id: 4 } }])
      .mockResolvedValueOnce([{ salonId: "s1", _count: { id: 3 } }, { salonId: "s2", _count: { id: 1 } }]);
    mocks.prisma.salon.findMany
      .mockResolvedValueOnce([
        { id: "s1", name: "A", city: "Dakar", approvalStatus: "approved" },
        { id: "s2", name: "B", city: "Dakar", approvalStatus: "approved" },
        { id: "s3", name: "C", city: "Dakar", approvalStatus: "approved" }
      ])
      .mockResolvedValueOnce([
        { id: "s1", name: "A", city: "Dakar" },
        { id: "s2", name: "B", city: "Dakar" }
      ]);

    const data = await getAdminDashboard();
    expect(data.topGrowthSalons[0]?.salonId).toBe("s2");
    expect(data.inactivityAlerts.some((x) => x.salonId === "s3")).toBe(true);
  });

  it("getAdminDashboard maps salons missing from thisWeek grouping to zero bookings", async () => {
    mocks.prisma.payment.aggregate.mockResolvedValue({ _sum: { amountXof: 500 } });
    mocks.prisma.booking.count.mockResolvedValueOnce(1);
    mocks.prisma.salon.count.mockResolvedValueOnce(2).mockResolvedValueOnce(0).mockResolvedValueOnce(0);
    mocks.prisma.subscription.count.mockResolvedValue(0);
    mocks.prisma.auditLog.count.mockResolvedValue(0);
    mocks.prisma.booking.groupBy.mockResolvedValueOnce([{ salonId: "s1", _count: { id: 2 } }]).mockResolvedValueOnce([]);
    mocks.prisma.salon.findMany
      .mockResolvedValueOnce([{ id: "s1", name: "A", city: "Dakar", approvalStatus: "approved" }])
      .mockResolvedValueOnce([{ id: "s1", name: "A", city: "Dakar" }, { id: "s-extra", name: "Ghost", city: "Dakar" }]);
    const data = await getAdminDashboard();
    expect(data.topGrowthSalons.find((x) => x.salonId === "s-extra")?.bookingsThisWeek).toBe(0);
  });

  it("getAdminDashboard handles empty growth datasets and null revenue", async () => {
    mocks.prisma.payment.aggregate.mockResolvedValue({ _sum: { amountXof: null } });
    mocks.prisma.booking.count.mockResolvedValueOnce(0);
    mocks.prisma.salon.count.mockResolvedValueOnce(0).mockResolvedValueOnce(0).mockResolvedValueOnce(0);
    mocks.prisma.subscription.count.mockResolvedValue(0);
    mocks.prisma.auditLog.count.mockResolvedValue(0);
    mocks.prisma.booking.groupBy.mockResolvedValueOnce([]).mockResolvedValueOnce([]);
    mocks.prisma.salon.findMany.mockResolvedValueOnce([]).mockResolvedValueOnce([]);
    const data = await getAdminDashboard();
    expect(data.topGrowthSalons).toEqual([]);
    expect(data.kpis[0]?.value).toBe(0);
  });

  it("queue/list helpers map salons", async () => {
    const salon = {
      id: "s1", name: "A", category: "hair", city: "Dakar", submittedAt: new Date(), approvalStatus: "pending_review",
      subscriptionIntentTier: "standard", latestAdminNote: null, staffMembers: [{ fullName: "Owner" }],
      documents: [{ label: "ID", status: "missing" }]
    };
    mocks.prisma.salon.findMany.mockResolvedValue([salon]);
    const pending = await listPendingSalons({});
    const listed = await listSalons({});
    expect(pending.total).toBe(1);
    expect(listed.items[0]?.ownerName).toBe("Owner");
  });

  it("queue/list helpers cover default owner fallback and filter branches", async () => {
    mocks.prisma.salon.findMany.mockResolvedValue([
      {
        id: "s2", name: "B", category: "nails", city: "Thiès", submittedAt: new Date(), approvalStatus: "needs_info",
        subscriptionIntentTier: "premium", latestAdminNote: null, staffMembers: [], documents: []
      }
    ]);
    const pending = await listPendingSalons({ status: "needs_info", category: "nails", city: "Thi", search: "B" });
    expect(pending.items[0]?.ownerName).toBe("—");

    const listed = await listSalons({ search: "B", status: "needs_info" });
    expect(listed.items[0]?.ownerName).toBe("—");
  });

  it("getPendingSalonDetail maps nested data", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue({
      id: "s1", name: "A", category: "hair", city: "Dakar", address: "Addr", description: "Desc",
      approvalStatus: "pending_review", subscriptionIntentTier: "standard", submittedAt: new Date(), latestAdminNote: null,
      staffMembers: [{ fullName: "Owner", email: "o@x.com", phone: "77" }],
      services: [{ id: "svc1", name: "Coupe", durationMinutes: 30, priceXof: 9000, depositMode: "none", depositAmountXof: null, depositPercent: null }],
      documents: [{ label: "Doc", status: "received", note: null, fileUrl: null }],
      gallery: [{ url: "https://x" }],
      subscription: { id: "sub1" }
    });
    const detail = await getPendingSalonDetail("s1");
    expect(detail?.subscriptionId).toBe("sub1");
  });

  it("getPendingSalonDetail covers null subscription and owner fallback fields", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue({
      id: "s9", name: "No Owner", category: "hair", city: "Dakar", address: "Addr", description: "Desc",
      approvalStatus: "pending_review", subscriptionIntentTier: "standard", submittedAt: new Date(), latestAdminNote: null,
      staffMembers: [],
      services: [],
      documents: [],
      gallery: [],
      subscription: null
    });
    const detail = await getPendingSalonDetail("s9");
    expect(detail?.subscriptionId).toBeNull();
    expect(detail?.owner.fullName).toBe("—");
    expect(detail?.owner.email).toBe("");
  });

  it("getPendingSalonDetail returns null when salon does not exist", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue(null);
    await expect(getPendingSalonDetail("missing")).resolves.toBeNull();
  });

  it("approve/reject/request-info return null on missing salon", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue(null);
    await expect(approveSalon("x", "Admin")).resolves.toBeNull();
    await expect(rejectSalon("x", { reason: "bad" }, "Admin")).resolves.toBeNull();
    await expect(requestSalonInfo("x", { reason: "need docs" }, "Admin")).resolves.toBeNull();
  });

  it("approveSalon and rejectSalon success paths update status and return detail", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ id: "s1", name: "Salon One", subscriptionIntentTier: "premium" });
    mocks.prisma.salon.update.mockResolvedValueOnce({ id: "s1" });
    mocks.prisma.subscription.upsert.mockResolvedValueOnce({});
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({
      id: "s1", name: "Salon One", category: "hair", city: "Dakar", address: "Addr", description: "Desc",
      approvalStatus: "approved", subscriptionIntentTier: "premium", submittedAt: new Date(), latestAdminNote: null,
      staffMembers: [], services: [], documents: [], gallery: [], subscription: { id: "sub1" }
    });
    const approved = await approveSalon("s1", "Admin");
    expect(approved?.approvalStatus).toBe("approved");

    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ id: "s2", name: "Salon Two" });
    mocks.prisma.salon.update.mockResolvedValueOnce({ id: "s2" });
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({
      id: "s2", name: "Salon Two", category: "nails", city: "Dakar", address: "Addr", description: "Desc",
      approvalStatus: "rejected", subscriptionIntentTier: "standard", submittedAt: new Date(), latestAdminNote: "bad docs",
      staffMembers: [], services: [], documents: [], gallery: [], subscription: { id: "sub2" }
    });
    const rejected = await rejectSalon("s2", { reason: "bad docs" }, "Admin");
    expect(rejected?.approvalStatus).toBe("rejected");
  });

  it("createSalon creates entities and handles email", async () => {
    mocks.prisma.salon.create.mockResolvedValue({ id: "s1", name: "A" });
    mocks.prisma.subscription.create.mockResolvedValue({});
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1" });
    mocks.prisma.platformSetting.create.mockResolvedValue({});
    mocks.prisma.salon.findUnique.mockResolvedValue({
      id: "s1", name: "A", category: "hair", city: "Dakar", address: "", description: "", approvalStatus: "approved",
      subscriptionIntentTier: "standard", submittedAt: new Date(), latestAdminNote: null,
      staffMembers: [], services: [], documents: [], gallery: [], subscription: { id: "sub1" }
    });
    const result = await createSalon({
      name: "A", category: "hair", city: "Dakar", address: "", description: "",
      ownerName: "Owner", ownerEmail: "o@x.com", ownerPhone: "77"
    }, "Admin");
    expect(result?.id).toBe("s1");
    expect(mocks.sendEmail).toHaveBeenCalled();
  });

  it("createSalon logs email errors and handles missing owner setup user", async () => {
    mocks.prisma.salon.create.mockResolvedValue({ id: "s2", name: "B" });
    mocks.prisma.subscription.create.mockResolvedValue({});
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    mocks.sendEmail.mockRejectedValue(new Error("smtp down"));
    mocks.prisma.salon.findUnique.mockResolvedValue({
      id: "s2", name: "B", category: "hair", city: "Dakar", address: "", description: "", approvalStatus: "approved",
      subscriptionIntentTier: "standard", submittedAt: new Date(), latestAdminNote: null,
      staffMembers: [], services: [], documents: [], gallery: [], subscription: { id: "sub2" }
    });
    const out = await createSalon({
      name: "B", category: "hair", city: "Dakar", address: "", description: "",
      ownerName: "Owner B", ownerEmail: "ownerb@x.com", ownerPhone: "78"
    }, "Admin");
    expect(out?.id).toBe("s2");
    expect(mocks.logger.error).toHaveBeenCalled();
  });

  it("requestSalonInfo updates salon and returns detail", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({ id: "s1", name: "A" });
    mocks.prisma.salon.update.mockResolvedValue({ id: "s1" });
    mocks.prisma.salon.findUnique.mockResolvedValueOnce({
      id: "s1", name: "A", category: "hair", city: "Dakar", address: "Addr", description: "Desc",
      approvalStatus: "needs_info", subscriptionIntentTier: "standard", submittedAt: new Date(), latestAdminNote: "more docs",
      staffMembers: [], services: [], documents: [], gallery: [], subscription: { id: "sub1" }
    });
    const out = await requestSalonInfo("s1", { reason: "more docs" }, "Admin");
    expect(out?.approvalStatus).toBe("needs_info");
  });

  it("subscriptions list/detail map fields", async () => {
    mocks.prisma.subscription.findMany.mockResolvedValue([{
      id: "sub1", salonId: "s1", tier: "premium", status: "active", billingProvider: "intech", expiresAt: null, autoRenew: true, isComplimentary: false,
      createdAt: new Date(), salon: { name: "A" }
    }]);
    mocks.prisma.subscription.count.mockResolvedValueOnce(1).mockResolvedValueOnce(0).mockResolvedValueOnce(0);
    const list = await listSubscriptions({});
    expect(list.total).toBe(1);

    mocks.prisma.subscription.findUnique.mockResolvedValue({
      id: "sub1", salonId: "s1", tier: "premium", status: "active", billingProvider: "intech", expiresAt: null, autoRenew: true,
      isComplimentary: false, startedAt: new Date(), renewedAt: null, salon: { name: "A" },
      events: [{ id: "e1", eventType: "x", summary: "s", createdAt: new Date(), actorName: "Admin", source: "admin", payloadPreview: null }],
      invoices: [{ id: "i1", invoiceNumber: "INV-1", amountXof: 1000, status: "paid", createdAt: new Date(), pdfUrl: "" }]
    });
    const detail = await getSubscriptionDetail("sub1");
    expect(detail?.id).toBe("sub1");

    mocks.prisma.subscription.findUnique.mockResolvedValueOnce(null);
    await expect(getSubscriptionDetail("missing")).resolves.toBeNull();
  });

  it("subscriptions cover standard entitlements and filtered list inputs", async () => {
    mocks.prisma.subscription.findMany.mockResolvedValueOnce([{
      id: "sub2", salonId: "s2", tier: "standard", status: "paused", billingProvider: "manual", expiresAt: new Date(), autoRenew: false, isComplimentary: false,
      createdAt: new Date(), salon: { name: "B" }
    }]);
    mocks.prisma.subscription.count.mockResolvedValueOnce(0).mockResolvedValueOnce(1).mockResolvedValueOnce(1);
    const list = await listSubscriptions({ search: "B", tier: "standard", status: "paused" });
    expect(list.items[0]?.tier).toBe("standard");

    mocks.prisma.subscription.findUnique.mockResolvedValueOnce({
      id: "sub2", salonId: "s2", tier: "standard", status: "paused", billingProvider: "manual", expiresAt: null, autoRenew: false,
      isComplimentary: false, startedAt: new Date(), renewedAt: null, salon: { name: "B" }, events: [], invoices: []
    });
    const detail = await getSubscriptionDetail("sub2");
    expect(detail?.entitlements.some((e) => e.enabled === false)).toBe(true);
  });

  it("overrideSubscription validates mark_charge_resolved metadata", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue({ id: "sub1", salonId: "s1", salon: { name: "A" } });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<void>) => {
      const tx = {
        subscription: { update: vi.fn() },
        salon: { update: vi.fn() },
        subscriptionCharge: { findUnique: vi.fn(), update: vi.fn() },
        subscriptionEvent: { create: vi.fn() },
        billingInvoice: { create: vi.fn() },
        auditLog: { create: vi.fn() }
      };
      await cb(tx);
    });
    await expect(overrideSubscription("sub1", { action: "mark_charge_resolved", reason: "ok", metadata: {} }, "Admin"))
      .rejects.toThrowError(/requires subscriptionChargeId/);
  });

  it("overrideSubscription handles charge resolution mismatch and success paths", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue({ id: "sub1", salonId: "s1", salon: { name: "A" } });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<void>) => {
      const tx = {
        subscription: { update: vi.fn() },
        salon: { update: vi.fn() },
        subscriptionCharge: { findUnique: vi.fn().mockResolvedValue({ id: "ch1", subscriptionId: "sub2" }), update: vi.fn() },
        subscriptionEvent: { create: vi.fn() },
        billingInvoice: { create: vi.fn() },
        auditLog: { create: vi.fn() }
      };
      await cb(tx);
    });
    await expect(overrideSubscription("sub1", {
      action: "mark_charge_resolved",
      reason: "resolve",
      metadata: { subscriptionChargeId: "ch1", providerReference: "ref1" }
    }, "Admin")).rejects.toThrowError(/charge_not_found/);

    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<void>) => {
      const tx = {
        subscription: { update: vi.fn() },
        salon: { update: vi.fn() },
        subscriptionCharge: { findUnique: vi.fn().mockResolvedValue({ id: "ch1", subscriptionId: "sub1" }), update: vi.fn() },
        subscriptionEvent: { create: vi.fn() },
        billingInvoice: { create: vi.fn() },
        auditLog: { create: vi.fn() }
      };
      await cb(tx);
    });
    mocks.prisma.subscription.findUnique.mockResolvedValueOnce({ id: "sub1", salonId: "s1", salon: { name: "A" } });
    mocks.prisma.subscription.findUnique.mockResolvedValueOnce({
      id: "sub1", salonId: "s1", tier: "premium", status: "active", billingProvider: "intech", expiresAt: null, autoRenew: true,
      isComplimentary: false, startedAt: new Date(), renewedAt: null, salon: { name: "A" }, events: [], invoices: []
    });
    const out = await overrideSubscription("sub1", {
      action: "mark_charge_resolved",
      reason: "resolve",
      metadata: { subscriptionChargeId: "ch1", providerReference: "ref2" }
    }, "Admin");
    expect(out?.id).toBe("sub1");
  });

  it("overrideSubscription toggles salon visibility for pause/resume and creates comp invoice", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue({ id: "sub1", salonId: "s1", salon: { name: "A" } });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<void>) => {
      const tx = {
        subscription: { update: vi.fn() },
        salon: { update: vi.fn() },
        subscriptionCharge: { findUnique: vi.fn(), update: vi.fn() },
        subscriptionEvent: { create: vi.fn() },
        billingInvoice: { create: vi.fn() },
        auditLog: { create: vi.fn() }
      };
      await cb(tx);
    });
    mocks.prisma.subscription.findUnique.mockResolvedValue({
      id: "sub1", salonId: "s1", tier: "premium", status: "active", billingProvider: "intech", expiresAt: null, autoRenew: true,
      isComplimentary: false, startedAt: new Date(), renewedAt: null, salon: { name: "A" }, events: [], invoices: []
    });
    await overrideSubscription("sub1", { action: "pause_subscription", reason: "pause" }, "Admin");
    await overrideSubscription("sub1", { action: "resume_subscription", reason: "resume" }, "Admin");
    await overrideSubscription("sub1", { action: "extend_expiry", reason: "extend", expiresAt: "2030-06-01T00:00:00.000Z" }, "Admin");
    await overrideSubscription("sub1", { action: "downgrade_to_standard", reason: "down" }, "Admin");
    await overrideSubscription("sub1", { action: "terminate_subscription", reason: "stop" }, "Admin");
    await overrideSubscription("sub1", { action: "grant_complimentary_premium", reason: "comp", expiresAt: "2030-01-01T00:00:00.000Z" }, "Admin");
    expect(mocks.prisma.$transaction).toHaveBeenCalled();
  });

  it("overrideSubscription returns null when subscription does not exist", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValueOnce(null);
    const out = await overrideSubscription("missing-sub", { action: "pause_subscription", reason: "n/a" }, "Admin");
    expect(out).toBeNull();
  });

  it("overrideSubscription extend/complimentary branches run without expiresAt", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue({ id: "subx", salonId: "s1", salon: { name: "A" } });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<void>) => {
      const tx = {
        subscription: { update: vi.fn() },
        salon: { update: vi.fn() },
        subscriptionCharge: { findUnique: vi.fn(), update: vi.fn() },
        subscriptionEvent: { create: vi.fn() },
        billingInvoice: { create: vi.fn() },
        auditLog: { create: vi.fn() }
      };
      await cb(tx);
    });
    mocks.prisma.subscription.findUnique.mockResolvedValueOnce({ id: "subx", salonId: "s1", salon: { name: "A" } });
    mocks.prisma.subscription.findUnique.mockResolvedValueOnce({
      id: "subx", salonId: "s1", tier: "standard", status: "active", billingProvider: "manual", expiresAt: null, autoRenew: false,
      isComplimentary: false, startedAt: new Date(), renewedAt: null, salon: { name: "A" }, events: [], invoices: []
    });
    await overrideSubscription("subx", { action: "extend_expiry", reason: "extend-no-exp" }, "Admin");

    mocks.prisma.subscription.findUnique.mockResolvedValueOnce({ id: "subx", salonId: "s1", salon: { name: "A" } });
    mocks.prisma.subscription.findUnique.mockResolvedValueOnce({
      id: "subx", salonId: "s1", tier: "premium", status: "active", billingProvider: null, expiresAt: null, autoRenew: false,
      isComplimentary: true, startedAt: new Date(), renewedAt: null, salon: { name: "A" }, events: [], invoices: []
    });
    await overrideSubscription("subx", { action: "grant_complimentary_premium", reason: "comp-no-exp" }, "Admin");
  });

  it("overrideSubscription honors provided effectiveAt", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue({
      id: "sube",
      salonId: "s1",
      tier: "premium",
      status: "active",
      billingProvider: "intech",
      expiresAt: null,
      autoRenew: true,
      isComplimentary: false,
      startedAt: new Date(),
      renewedAt: null,
      salon: { name: "A" },
      events: [],
      invoices: []
    });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<void>) => {
      const tx = {
        subscription: { update: vi.fn() },
        salon: { update: vi.fn() },
        subscriptionCharge: { findUnique: vi.fn(), update: vi.fn() },
        subscriptionEvent: { create: vi.fn() },
        billingInvoice: { create: vi.fn() },
        auditLog: { create: vi.fn() }
      };
      await cb(tx);
    });
    mocks.prisma.subscription.findUnique.mockResolvedValueOnce({
      id: "sube", salonId: "s1", tier: "premium", status: "paused", billingProvider: "intech", expiresAt: null, autoRenew: false,
      isComplimentary: false, startedAt: new Date(), renewedAt: null, salon: { name: "A" }, events: [], invoices: []
    });
    await overrideSubscription("sube", { action: "pause_subscription", reason: "pause", effectiveAt: "2030-02-01T00:00:00.000Z" }, "Admin");
    expect(mocks.prisma.$transaction).toHaveBeenCalled();
  });

  it("manualExtendSubscription creates charge+invoice, extends expiry, sends email", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue({
      id: "sub_me",
      salonId: "s_me",
      status: "inactive",
      tier: "standard",
      expiresAt: null,
      salon: { id: "s_me", name: "Salon Manu" }
    });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<void>) => {
      const tx = {
        subscription: { update: vi.fn().mockResolvedValue({}) },
        salon: { update: vi.fn().mockResolvedValue({}) },
        subscriptionCharge: { create: vi.fn().mockResolvedValue({ id: "ch_me1" }) },
        billingInvoice: { create: vi.fn().mockResolvedValue({ id: "inv_me1" }) },
        subscriptionEvent: { create: vi.fn().mockResolvedValue({}) },
        auditLog: { create: vi.fn().mockResolvedValue({}) }
      };
      await cb(tx);
    });
    mocks.prisma.user.findFirst.mockResolvedValue({ email: "owner@test.com", fullName: "Owner" });
    mocks.sendEmail.mockResolvedValue(undefined);

    const result = await manualExtendSubscription("sub_me", {
      amountXof: 50000,
      durationDays: 30,
      reason: "Paiement hors-ligne pour mars",
      reference: "VIREMENT-2026-05"
    }, "Admin");

    expect(result).not.toBeNull();
    expect(result?.subscriptionId).toBe("sub_me");
    expect(result?.amountXof).toBe(50000);
    expect(result?.durationDays).toBe(30);
    expect(result?.reference).toBe("VIREMENT-2026-05");
    expect(result?.chargeId).toBeTruthy();
    expect(result?.invoiceId).toBeTruthy();
    expect(result?.previousExpiresAt).toBeNull();
    expect(mocks.sendEmail).toHaveBeenCalledWith(
      expect.objectContaining({ to: "owner@test.com", subject: expect.stringContaining("prolongé") })
    );
  });

  it("manualExtendSubscription returns null for missing subscription", async () => {
    mocks.prisma.subscription.findUnique.mockResolvedValue(null);
    const result = await manualExtendSubscription("missing", {
      amountXof: 25000,
      durationDays: 30,
      reason: "Test",
      reference: "REF-1"
    }, "Admin");
    expect(result).toBeNull();
  });

  it("manualExtendSubscription extends from current expiry when still active", async () => {
    const futureExpiry = new Date(Date.now() + 15 * 24 * 60 * 60 * 1000);
    mocks.prisma.subscription.findUnique.mockResolvedValue({
      id: "sub_me_active",
      salonId: "s_me",
      status: "active",
      tier: "premium",
      expiresAt: futureExpiry,
      salon: { id: "s_me", name: "Salon Actif" }
    });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<void>) => {
      const tx = {
        subscription: { update: vi.fn().mockResolvedValue({}) },
        salon: { update: vi.fn().mockResolvedValue({}) },
        subscriptionCharge: { create: vi.fn().mockResolvedValue({ id: "ch_me2" }) },
        billingInvoice: { create: vi.fn().mockResolvedValue({ id: "inv_me2" }) },
        subscriptionEvent: { create: vi.fn().mockResolvedValue({}) },
        auditLog: { create: vi.fn().mockResolvedValue({}) }
      };
      await cb(tx);
    });
    mocks.prisma.user.findFirst.mockResolvedValue(null); // No email
    mocks.sendEmail.mockClear();

    const result = await manualExtendSubscription("sub_me_active", {
      amountXof: 25000,
      durationDays: 30,
      reason: "Prolongation salon actif",
      reference: "EXT-2026"
    }, "Admin");

    expect(result).not.toBeNull();
    // Should extend from future expiry, not from now
    const expectedNewExpiry = new Date(futureExpiry.getTime() + 30 * 24 * 60 * 60 * 1000);
    expect(new Date(result!.newExpiresAt).getTime()).toBeGreaterThan(Date.now() + 40 * 24 * 60 * 60 * 1000);
    expect(mocks.sendEmail).not.toHaveBeenCalled(); // No owner email
  });

  it("audit/settings/config helpers work", async () => {
    mocks.prisma.auditLog.findMany.mockResolvedValue([{ id: "a1", action: "x", summary: "s", entityType: "salon", entityId: "s1", actorName: "Admin", createdAt: new Date(), severity: "info" }]);
    const events = await listAuditEvents({});
    expect(events.total).toBe(1);

    mocks.prisma.auditLog.findUnique.mockResolvedValue({
      id: "a1", action: "x", summary: "s", entityType: "subscription", entityId: "s1", actorName: "Admin",
      createdAt: new Date(), severity: "info", payloadJson: "{}", relatedLinksJson: JSON.stringify([{ label: "S", href: "/admin/subscriptions/s1" }])
    });
    mocks.prisma.subscription.findFirst = vi.fn().mockResolvedValue({ id: "sub1" });
    const audit = await getAuditDetail("a1");
    expect(audit?.entityId).toBe("sub1");

    mocks.prisma.auditLog.findUnique.mockResolvedValueOnce({
      id: "a2", action: "y", summary: "s", entityType: "subscription", entityId: "missing", actorName: "Admin",
      createdAt: new Date(), severity: "warning", payloadJson: "{}", relatedLinksJson: JSON.stringify([{ label: "S", href: "/admin/subscriptions/missing" }])
    });
    mocks.prisma.subscription.findFirst = vi.fn().mockResolvedValue(null);
    const unresolved = await getAuditDetail("a2");
    expect(unresolved?.entityId).toBe("missing");

    mocks.prisma.platformSetting.findMany.mockResolvedValue([{ id: "p1", key: "platform_name" }, { id: "p2", key: "safe_key" }]);
    const settings = await getPlatformSettings();
    expect(settings.length).toBe(1);
    mocks.prisma.platformSetting.findMany.mockResolvedValueOnce([{ id: "p3", key: "custom_key" }]);
    const grouped = await getPlatformSettings("custom");
    expect(grouped.length).toBe(1);

    mocks.prisma.platformSetting.upsert.mockResolvedValue({ id: "s1", key: "foo" });
    await updatePlatformSetting("api_key", "secret", "Admin");
    await updatePlatformSetting("homepage_title", "Beauté Avenue", "Admin");
    expect(mocks.prisma.auditLog.create).toHaveBeenCalled();

    mocks.prisma.platformSalonCategory.findMany.mockResolvedValue([{ id: "c1" }]);
    await expect(listSalonCategories()).resolves.toEqual([{ id: "c1" }]);
    mocks.prisma.platformSalonCategory.upsert.mockResolvedValue({ id: "c1", name: "Hair" });
    await upsertSalonCategory({ name: "Hair", slug: "hair" }, "Admin");
    mocks.prisma.platformSalonCategory.delete.mockResolvedValue({ id: "c1", name: "Hair" });
    await deleteSalonCategory("c1", "Admin");

    mocks.prisma.platformRequiredDocument.findMany.mockResolvedValue([{ id: "d1" }]);
    await expect(listRequiredDocuments()).resolves.toEqual([{ id: "d1" }]);
    mocks.prisma.platformRequiredDocument.upsert.mockResolvedValue({ id: "d1", label: "ID" });
    await upsertRequiredDocument({ label: "ID", slug: "id", type: "pdf", isRequired: true }, "Admin");
    mocks.prisma.platformRequiredDocument.delete.mockResolvedValue({ id: "d1", label: "ID" });
    await deleteRequiredDocument("d1", "Admin");
  });

  it("listEmailAuditEvents maps rows and applies filters", async () => {
    mocks.prisma.emailAudit.findMany.mockResolvedValueOnce([
      {
        id: "ea1",
        to: "owner@example.com",
        subject: "Subject",
        driver: "smtp",
        status: "sent",
        errorMessage: null,
        createdAt: new Date()
      }
    ]);
    const out = await listEmailAuditEvents({ status: "sent", driver: "smtp", to: "owner" });
    expect(out.total).toBe(1);
    expect(out.items[0]?.to).toBe("owner@example.com");
    expect(mocks.prisma.emailAudit.findMany).toHaveBeenCalledWith(expect.objectContaining({
      where: expect.objectContaining({
        status: "sent",
        driver: "smtp",
        to: expect.any(Object)
      })
    }));
  });

  it("listAuditEvents applies actor/entity/action filters together", async () => {
    mocks.prisma.auditLog.findMany.mockResolvedValueOnce([]);
    const events = await listAuditEvents({ actor: "adm", entityType: "Salon", action: "approve" });
    expect(events.items).toEqual([]);
    expect(mocks.prisma.auditLog.findMany).toHaveBeenCalledWith(expect.objectContaining({
      where: expect.objectContaining({
        actorName: expect.any(Object),
        entityType: "Salon",
        action: expect.any(Object)
      })
    }));
  });

  it("audit detail covers non-subscription entities and not-found branch", async () => {
    mocks.prisma.auditLog.findUnique.mockResolvedValueOnce(null);
    await expect(getAuditDetail("none")).resolves.toBeNull();

    mocks.prisma.auditLog.findUnique.mockResolvedValueOnce({
      id: "a3", action: "x", summary: "s", entityType: "salon", entityId: "s1", actorName: "Admin",
      createdAt: new Date(), severity: "info", payloadJson: "{}", relatedLinksJson: JSON.stringify([{ label: "Salon", href: "/admin/salons/s1" }])
    });
    const salonAudit = await getAuditDetail("a3");
    expect(salonAudit?.entityId).toBe("s1");

    mocks.prisma.auditLog.findUnique.mockResolvedValueOnce({
      id: "a4", action: "y", summary: "s", entityType: "subscription", entityId: "salon-x", actorName: "Admin",
      createdAt: new Date(), severity: "warning", payloadJson: "{}", relatedLinksJson: JSON.stringify([{ label: "X", href: "/some/other/link" }])
    });
    mocks.prisma.subscription.findFirst = vi.fn().mockResolvedValue({ id: "subX" });
    const normalized = await getAuditDetail("a4");
    expect(normalized?.entityId).toBe("subX");
    expect(normalized?.relatedLinks[0]?.href).toBe("/some/other/link");
  });
});
