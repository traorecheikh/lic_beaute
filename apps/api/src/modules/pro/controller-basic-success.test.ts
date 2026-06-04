import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const handleError = vi.fn();
  const getOrSetCachedJson = vi.fn();
  const prisma = {
    user: { findUnique: vi.fn(), findFirst: vi.fn() },
    salon: { findUnique: vi.fn() },
    platformSetting: { findMany: vi.fn(), findUnique: vi.fn(), upsert: vi.fn(), deleteMany: vi.fn() },
    service: { findMany: vi.fn(), findFirst: vi.fn() },
    salonHours: { findMany: vi.fn() },
    blockedSlot: { findMany: vi.fn(), findFirst: vi.fn(), create: vi.fn(), delete: vi.fn() },
    booking: { findMany: vi.fn(), findFirst: vi.fn(), create: vi.fn(), updateMany: vi.fn() },
    review: { findMany: vi.fn(), findFirst: vi.fn(), update: vi.fn() },
    subscription: { findUnique: vi.fn(), update: vi.fn() },
    subscriptionCharge: { findFirst: vi.fn(), findUnique: vi.fn(), create: vi.fn(), update: vi.fn() },
    settlementEvent: { findMany: vi.fn(), create: vi.fn() },
    billingInvoice: { findMany: vi.fn(), findFirst: vi.fn() },
    payment: { findFirst: vi.fn() },
    bookingEvent: { create: vi.fn() },
    auditLog: { create: vi.fn() },
    $transaction: vi.fn()
  };
  const getProDashboard = vi.fn();
  const fetchAndComputeAvailableSlots = vi.fn();
  const enqueueJob = vi.fn();
  const invalidateCacheTags = vi.fn();
  const paymentAdapter = { initiateDeposit: vi.fn(), executePayment: vi.fn(), fetchPaymentStatus: vi.fn() };
  return { requireRole, fail, ok, handleError, getOrSetCachedJson, prisma, getProDashboard, fetchAndComputeAvailableSlots, enqueueJob, invalidateCacheTags, paymentAdapter };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/http.js")>();
  return { ...actual, fail: mocks.fail, ok: mocks.ok, handleError: mocks.handleError };
});
vi.mock("../../lib/cache.js", () => ({ getOrSetCachedJson: mocks.getOrSetCachedJson, invalidateCacheTags: mocks.invalidateCacheTags }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => mocks.paymentAdapter) }));
vi.mock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: mocks.fetchAndComputeAvailableSlots }));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: mocks.enqueueJob }));
vi.mock("./data.js", () => ({ getProDashboard: mocks.getProDashboard, getProAnalytics: vi.fn() }));

import { ProController } from "./index.js";

describe("ProController basic success", () => {
  const c = new ProController();
  const rep = { header: vi.fn() } as never;

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      booking: { create: vi.fn().mockResolvedValue({ id: "bnew", startsAt: new Date(), endsAt: new Date(), status: "confirmed", source: "manual" }), updateMany: vi.fn().mockResolvedValue({ count: 1 }) },
      bookingEvent: { create: vi.fn() },
      user: { findUnique: vi.fn().mockResolvedValue({ id: "c1", role: "client" }), create: vi.fn().mockResolvedValue({ id: "c1" }) },
      subscription: { update: vi.fn() },
      platformSetting: { upsert: vi.fn(), deleteMany: vi.fn() },
      settlementEvent: { create: vi.fn() },
      auditLog: { create: vi.fn() },
      payment: { findFirst: vi.fn() }
    }));
  });

  it("dashboard/getSalon/list methods succeed", async () => {
    mocks.getOrSetCachedJson.mockImplementation(async (input: any) => ({
      value: await input.load(),
      cacheStatus: "MISS"
    }));
    mocks.getProDashboard.mockResolvedValue({ kpi: 1 });
    mocks.prisma.salon.findUnique.mockResolvedValue({
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
      gallery: [{ url: "https://img" }],
      salonHours: [{ dayOfWeek: 1, isOpen: true, opensAt: "09:00", closesAt: "18:00" }]
    });
    mocks.prisma.user.findFirst.mockResolvedValue({ phone: "771234567" });
    mocks.prisma.platformSetting.findMany.mockResolvedValue([]);
    mocks.prisma.service.findMany.mockResolvedValue([
      { id: "svc1", name: "Coupe", category: "hair", durationMinutes: 30, priceXof: 10000, depositMode: "none", depositAmountXof: null, depositPercent: null, isActive: true, displayOrder: 0 }
    ]);
    mocks.prisma.salonHours.findMany.mockResolvedValue([{ dayOfWeek: 1, isOpen: true, opensAt: "09:00", closesAt: "18:00" }]);
    mocks.prisma.blockedSlot.findMany.mockResolvedValue([{ id: "sl1", startsAt: new Date(), endsAt: new Date(Date.now() + 3600_000), reason: null, scope: "salon", employeeId: null }]);
    mocks.prisma.booking.findMany.mockResolvedValue([
      {
        id: "b1", salonId: "s1", serviceId: "svc1", service: { name: "Coupe" }, employeeId: null, employee: null,
        clientId: "c1", client: { fullName: "Client", phone: "77" }, startsAt: new Date(), endsAt: new Date(),
        status: "pending", source: "marketplace", depositAmountXof: 0, createdAt: new Date(), payments: []
      }
    ]);
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b1", salonId: "s1", serviceId: "svc1", service: { name: "Coupe" }, employeeId: null, employee: null,
      clientId: "c1", client: { fullName: "Client", phone: "77" }, startsAt: new Date(), endsAt: new Date(),
      status: "pending", source: "marketplace", depositAmountXof: 0, createdAt: new Date(),
      payments: [], bookingEvents: []
    });

    await c.dashboard({} as never, rep);
    await c.getSalon({} as never, rep);
    await c.listServices({} as never, rep);
    await c.getHours({} as never, rep);
    await c.listBlockedSlots({} as never, rep);
    await c.listBookings({ query: {} } as never, rep);
    await c.getBooking({ params: { bookingId: "b1" } } as never, rep);

    expect(mocks.ok).toHaveBeenCalled();
  });

  it("covers more pro endpoints success and key errors", async () => {
    mocks.fetchAndComputeAvailableSlots.mockResolvedValue([{ startsAt: new Date(Date.now() + 7200_000).toISOString() }]);
    mocks.prisma.service.findFirst.mockResolvedValue({ id: "svc1", durationMinutes: 30, depositMode: "none", depositAmountXof: null, depositPercent: null, priceXof: 10000 });
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "b1",
      salonId: "s1",
      status: "confirmed",
      startsAt: new Date(Date.now() + 3600_000),
      service: { priceXof: 10000 },
      payments: [],
      employeeId: null
    });
    mocks.prisma.review.findMany.mockResolvedValue([]);
    mocks.prisma.review.findFirst.mockResolvedValue(null);
    mocks.prisma.subscription.findUnique.mockResolvedValue({ id: "sub1", salonId: "s1", tier: "standard", status: "active", renewedAt: null, expiresAt: null, isComplimentary: false, autoRenew: true, billingProvider: "manual" });
    mocks.prisma.platformSetting.findMany.mockResolvedValue([]);
    mocks.prisma.subscriptionCharge.findFirst.mockResolvedValue(null);
    mocks.prisma.subscriptionCharge.create.mockResolvedValue({ id: "sc1" });
    mocks.paymentAdapter.initiateDeposit.mockResolvedValue({ providerRef: "pref", redirectUrl: "https://pay", expiresAt: new Date() });
    mocks.prisma.settlementEvent.findMany.mockResolvedValue([]);
    mocks.prisma.billingInvoice.findMany.mockResolvedValue([{ id: "i1", invoiceNumber: "INV1", amountXof: 1000, status: "paid", createdAt: new Date(), pdfUrl: "" }]);
    mocks.prisma.billingInvoice.findFirst.mockResolvedValue({ id: "i1", invoiceNumber: "INV1", amountXof: 1000, status: "paid", createdAt: new Date(), pdfUrl: "" });
    mocks.prisma.salon.findUnique.mockResolvedValue({ id: "s1", name: "Salon A" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: "manual" });

    await c.createManualBooking({ body: { serviceId: "svc1", startsAt: new Date(Date.now() + 7200_000).toISOString(), clientId: "c1" } } as never, rep);
    await c.getCheckout({ params: { bookingId: "b1" } } as never, rep);
    await c.completeCheckout({ params: { bookingId: "b1" }, body: { paymentMethod: "cash", discountXof: 0, lineItems: [] } } as never, rep);
    await c.listReviews({} as never, rep);
    await c.respondToReview({ params: { reviewId: "r1" }, body: { responseText: "Merci" } } as never, rep);
    await c.getSubscription({} as never, rep);
    await c.updateSubscription({ body: { autoRenew: true } } as never, rep);
    await c.subscriptionCheckout({ body: { action: "upgrade", provider: "paydunya" } } as never, rep);
    await c.listPayouts({} as never, rep);
    await c.listInvoices({} as never, rep);
    const pdfReply = {
      header: vi.fn(() => pdfReply),
      code: vi.fn(() => pdfReply),
      send: vi.fn(() => pdfReply),
      status: vi.fn(() => pdfReply),
      type: vi.fn(() => ({ header: vi.fn(() => ({ send: vi.fn() })) }))
    } as never;
    await c.downloadInvoicePdf({ params: { invoiceId: "i1" } } as never, pdfReply);

    expect(mocks.ok).toHaveBeenCalled();
  });

  it("keeps redirect-based subscription charges awaiting webhook confirmation", async () => {
    const txSubscriptionChargeUpdate = vi.fn();
    const txBillingInvoiceCreate = vi.fn();
    const txSubscriptionUpdate = vi.fn();
    const txSalonUpdate = vi.fn();
    const txAuditLogCreate = vi.fn();

    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "ch_wave",
      status: "pending",
      amountXof: 30000,
      chargeType: "upgrade",
      idempotencyKey: "sub-sub1-upgrade-monthly-2026-06",
      providerTxId: "invoice_tok",
      subscriptionId: "sub1",
      subscription: { id: "sub1", salonId: "s1" }
    });
    mocks.paymentAdapter.executePayment.mockResolvedValue({
      success: true,
      status: "succeeded",
      providerTxId: "invoice_tok",
      url: "https://wave.example/checkout"
    });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      subscriptionCharge: { update: txSubscriptionChargeUpdate },
      billingInvoice: { create: txBillingInvoiceCreate },
      subscription: { findUnique: vi.fn(), update: txSubscriptionUpdate },
      salon: { update: txSalonUpdate },
      auditLog: { create: txAuditLogCreate }
    }));

    await c.executeSubscriptionPayment({
      params: { chargeId: "ch_wave" },
      body: { method: "wave_senegal", details: { phone: "770000000" } }
    } as never, rep);

    expect(txSubscriptionChargeUpdate).toHaveBeenCalledWith({
      where: { id: "ch_wave" },
      data: { status: "authorized", providerTxId: "invoice_tok" }
    });
    expect(txBillingInvoiceCreate).not.toHaveBeenCalled();
    expect(txSubscriptionUpdate).not.toHaveBeenCalled();
    expect(txSalonUpdate).not.toHaveBeenCalled();
    expect(txAuditLogCreate).toHaveBeenCalled();
  });

  it("keeps async message-only subscription charges awaiting confirmation", async () => {
    const txSubscriptionChargeUpdate = vi.fn();
    const txBillingInvoiceCreate = vi.fn();
    const txSubscriptionUpdate = vi.fn();
    const txSalonUpdate = vi.fn();
    const txAuditLogCreate = vi.fn();

    mocks.prisma.subscriptionCharge.findUnique.mockResolvedValue({
      id: "ch_sms",
      status: "pending",
      amountXof: 30000,
      chargeType: "renewal",
      idempotencyKey: "sub-sub1-renewal-monthly-2026-06",
      providerTxId: "invoice_sms",
      subscriptionId: "sub1",
      subscription: { id: "sub1", salonId: "s1" }
    });
    mocks.paymentAdapter.executePayment.mockResolvedValue({
      success: true,
      status: "authorized",
      providerTxId: "invoice_sms",
      message: "Votre paiement est en cours de traitement. Merci de valider le paiement après reception de sms pour le compléter."
    });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      subscriptionCharge: { update: txSubscriptionChargeUpdate },
      billingInvoice: { create: txBillingInvoiceCreate },
      subscription: { findUnique: vi.fn(), update: txSubscriptionUpdate },
      salon: { update: txSalonUpdate },
      auditLog: { create: txAuditLogCreate }
    }));

    await c.executeSubscriptionPayment({
      params: { chargeId: "ch_sms" },
      body: { method: "expresso_sn", details: { phone: "770000000" } }
    } as never, rep);

    expect(txSubscriptionChargeUpdate).toHaveBeenCalledWith({
      where: { id: "ch_sms" },
      data: { status: "authorized", providerTxId: "invoice_sms" }
    });
    expect(txBillingInvoiceCreate).not.toHaveBeenCalled();
    expect(txSubscriptionUpdate).not.toHaveBeenCalled();
    expect(txSalonUpdate).not.toHaveBeenCalled();
    expect(txAuditLogCreate).toHaveBeenCalled();
  });

  it("reconciles pending charge status from provider during polling", async () => {
    const txSubscriptionChargeUpdate = vi.fn();
    const txBillingInvoiceCreate = vi.fn().mockResolvedValue({ id: "inv_sub_1" });
    const txSubscriptionUpdate = vi.fn();
    const txSalonUpdate = vi.fn();
    const txAuditLogCreate = vi.fn();

    mocks.prisma.subscription.findUnique.mockResolvedValueOnce({
      id: "sub1",
      salonId: "s1",
      tier: "standard",
      status: "inactive",
      expiresAt: null
    });
    mocks.prisma.subscriptionCharge.findUnique
      .mockResolvedValueOnce({
        id: "ch_poll",
        status: "authorized",
        amountXof: 30000,
        chargeType: "renewal",
        idempotencyKey: "sub-sub1-renewal-monthly-2026-06",
        provider: "paydunya",
        providerTxId: "invoice_tok",
        subscriptionId: "sub1",
        subscription: { status: "inactive", tier: "standard", expiresAt: null }
      })
      .mockResolvedValueOnce({
        id: "ch_poll",
        status: "succeeded",
        amountXof: 30000,
        chargeType: "renewal",
        provider: "paydunya",
        providerTxId: "invoice_tok",
        subscriptionId: "sub1",
        subscription: { status: "active", tier: "standard", expiresAt: new Date("2026-07-01T00:00:00.000Z") }
      });
    mocks.paymentAdapter.fetchPaymentStatus.mockResolvedValue("succeeded");
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) => cb({
      subscriptionCharge: { update: txSubscriptionChargeUpdate },
      billingInvoice: { create: txBillingInvoiceCreate },
      subscription: {
        findUnique: vi.fn().mockResolvedValue({ salonId: "s1", tier: "standard", expiresAt: null, pendingTier: null }),
        update: txSubscriptionUpdate
      },
      salon: { update: txSalonUpdate },
      auditLog: { create: txAuditLogCreate }
    }));

    await c.getChargeStatus({ params: { chargeId: "ch_poll" } } as never, rep);

    expect(mocks.paymentAdapter.fetchPaymentStatus).toHaveBeenCalledWith({ providerToken: "invoice_tok" });
    expect(txSubscriptionChargeUpdate).toHaveBeenCalledWith({
      where: { id: "ch_poll" },
      data: { status: "succeeded", providerTxId: "invoice_tok" }
    });
    expect(txBillingInvoiceCreate).toHaveBeenCalled();
    expect(txSubscriptionUpdate).toHaveBeenCalled();
    expect(txSalonUpdate).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({
      chargeId: "ch_poll",
      status: "succeeded",
      subscriptionStatus: "active"
    }));
  });
});
