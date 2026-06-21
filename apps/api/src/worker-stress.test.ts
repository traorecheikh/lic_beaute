/**
 * ╔══════════════════════════════════════════════════════════════════════╗
 * ║                    WORKER STRESS TEST SUITE                        ║
 * ║          Payout · Payment · Reviews · Concurrency                  ║
 * ╚══════════════════════════════════════════════════════════════════════╝
 *
 * Run: npx vitest run src/worker-stress.test.ts
 */

import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

// ─── Hoisted shared state for Job Queue section ─────────────────────────
// These are created once at module load (vi.hoisted), always mocked via
// hoisted vi.mock, but overridable by per-describe vi.doMock calls.
const section3 = vi.hoisted(() => ({
  addMock: vi.fn(),
  configMock: {
    paymentDriver: "mock", webOrigin: "http://localhost:5174",
    merchantPayoutEnabled: true, merchantPayoutHoldHours: 24,
    paydunyaCallbackUrl: "https://example.com/webhook",
    paydunyaMasterKey: "mk", paydunyaPublicKey: "pk", paydunyaPrivateKey: "prk",
    paydunyaToken: "tok", paydunyaEnv: "sandbox", paydunyaBaseUrl: "https://app.paydunya.com",
    storageDriver: "local", storagePath: "/tmp", mediaPublicBaseUrl: "http://localhost:3000",
    subscriptionExpiryEnabled: true, subscriptionGracePeriodDays: 3,
    workerDriver: "db", workerBatchSize: 25,
    queueConcurrencyPayments: 3, queueConcurrencyNotifications: 8, queueConcurrencyMaintenance: 2,
    redisUrl: "",
  },
  getQueueRedisMock: vi.fn(async () => ({})),
  warnMock: vi.fn(),
  loggerMock: { warn: vi.fn(), error: vi.fn(), info: vi.fn() },
}));

// Top-level hoisted mocks — always active. Per-describe vi.doMock calls
// override these for the same path.
vi.mock("bullmq", () => ({
  Queue: class { add = section3.addMock; close = vi.fn(); constructor(...args: any[]) {} },
}));
vi.mock("./lib/redis.js", () => ({ getQueueRedis: section3.getQueueRedisMock }));
vi.mock("./config.js", () => ({ config: section3.configMock, validateConfig: vi.fn() }));
vi.mock("./lib/logger.js", () => ({ logger: section3.loggerMock }));

function buildAdapter() {
  return {
    requestRefund: vi.fn(), initiateDeposit: vi.fn(), verifyWebhookSignature: vi.fn(),
    parseWebhook: vi.fn(), fetchPaymentStatus: vi.fn(), normalizeStatus: vi.fn(),
    createDisbursementInvoice: vi.fn(), submitDisbursement: vi.fn(),
    checkDisbursementStatus: vi.fn(), getApproximateBalance: vi.fn(),
    resolveWithdrawMode: vi.fn((pm: string) => pm === "wave_senegal" ? "wave-senegal" : "orange-money-senegal"),
    delete: vi.fn(),
  };
}
function buildTx() {
  return {
    merchantPayout: { create: vi.fn(), update: vi.fn(), updateMany: vi.fn(), findUnique: vi.fn() },
    ledgerEntry: { create: vi.fn() }, auditLog: { create: vi.fn() },
    payment: { update: vi.fn() }, booking: { update: vi.fn(), findUnique: vi.fn() },
    bookingEvent: { create: vi.fn() },
    settlementEvent: { findFirst: vi.fn(), create: vi.fn() },
    subscriptionCharge: { update: vi.fn() },
    billingInvoice: { create: vi.fn().mockResolvedValue({ id: "inv_new" }) },
    subscription: { update: vi.fn(), findUnique: vi.fn() },
    salon: { update: vi.fn() },
    platformSetting: { findUnique: vi.fn(), upsert: vi.fn() },
  };
}
function buildPrisma(tx?: ReturnType<typeof buildTx>) {
  return {
    booking: { findUnique: vi.fn(), update: vi.fn() },
    payment: { findUnique: vi.fn(), update: vi.fn(), updateMany: vi.fn(), findFirst: vi.fn(), create: vi.fn() },
    settlementEvent: { findFirst: vi.fn(), create: vi.fn() },
    user: { findMany: vi.fn(), findUnique: vi.fn() },
    pushToken: { findMany: vi.fn() }, notification: { create: vi.fn(), findUnique: vi.fn() },
    merchantPayout: { findMany: vi.fn(), update: vi.fn(), updateMany: vi.fn(), findUnique: vi.fn(), findFirst: vi.fn(), create: vi.fn() },
    ledgerEntry: { create: vi.fn(), findMany: vi.fn() },
    job: { findFirst: vi.fn().mockResolvedValue(null), findMany: vi.fn().mockResolvedValue([]), create: vi.fn(), updateMany: vi.fn().mockResolvedValue({ count: 1 }), update: vi.fn() },
    platformSetting: { findUnique: vi.fn(), upsert: vi.fn() },
    subscriptionCharge: { findUnique: vi.fn(), findFirst: vi.fn() },
    billingInvoice: { create: vi.fn(), findFirst: vi.fn() },
    subscription: { findMany: vi.fn(), update: vi.fn(), findUnique: vi.fn() },
    salon: { update: vi.fn() },
    employee: { findMany: vi.fn() },
    $executeRaw: vi.fn(),
    $transaction: tx ? vi.fn(async (fn: (t: typeof tx) => Promise<any>) => fn(tx)) : vi.fn(),
  };
}
const BASE_CONFIG = {
  paymentDriver: "mock", webOrigin: "http://localhost:5174",
  merchantPayoutEnabled: true, merchantPayoutHoldHours: 24,
  paydunyaCallbackUrl: "https://example.com/webhook",
  paydunyaMasterKey: "mk", paydunyaPublicKey: "pk", paydunyaPrivateKey: "prk",
  paydunyaToken: "tok", paydunyaEnv: "sandbox", paydunyaBaseUrl: "https://app.paydunya.com",
  storageDriver: "local", storagePath: "/tmp", mediaPublicBaseUrl: "http://localhost:3000",
  subscriptionExpiryEnabled: true, subscriptionGracePeriodDays: 3,
  workerDriver: "db", workerBatchSize: 25,
  queueConcurrencyPayments: 3, queueConcurrencyNotifications: 8, queueConcurrencyMaintenance: 2,
};

// ─── =========================================================================
// 1. PAYOUT SERVICE — Concurrency & Race Conditions
// ─── =========================================================================

describe("Payout Service — Concurrency Stress", { timeout: 30000 }, () => {
  let adapter: ReturnType<typeof buildAdapter>;
  let tx: ReturnType<typeof buildTx>;
  let prisma: ReturnType<typeof buildPrisma>;
  let payoutService: typeof import("./lib/payout-service.js");
  let enqueueJobMock: ReturnType<typeof vi.fn>;

  beforeEach(async () => {
    vi.restoreAllMocks(); vi.resetModules();
    adapter = buildAdapter(); tx = buildTx(); prisma = buildPrisma(tx);
    enqueueJobMock = vi.fn();
    vi.doMock("./adapters/index.js", () => ({ getPaymentAdapter: () => adapter }));
    vi.doMock("./lib/db/prisma.js", () => ({ prisma }));
    vi.doMock("./lib/jobs.js", () => ({ enqueueJob: enqueueJobMock, queueForJob: vi.fn(), closeJobQueues: vi.fn(), shouldRunBull: vi.fn().mockReturnValue(false) }));
    vi.doMock("./lib/logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./config.js", () => ({ config: { ...BASE_CONFIG }, validateConfig: vi.fn() }));
    vi.doUnmock("./lib/payout-service.js");
    payoutService = await import("./lib/payout-service.js");
  });
  afterEach(() => { vi.restoreAllMocks(); });

  it("1/50 concurrent submitPayout calls wins the race", async () => {
    const payout = {
      id: "pay_s1", bookingId: "b_s1", paymentId: "p_s1", salonId: "s_s1",
      status: "scheduled", version: 1, merchantPayoutAmount: 5000,
      beneficiaryPhoneSnapshot: "+221771234567", payoutMethod: "wave_senegal",
      disburseId: "merchant_payout_pay_s1", disburseToken: null,
      salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified" },
    };
    // KEY: findUnique by id returns payout; findUnique by bookingId returns null (eligibility check bypass)
    let claimCountForUpdateMany = 0;
    prisma.merchantPayout.updateMany.mockImplementation(async () => ({ count: ++claimCountForUpdateMany === 1 ? 1 : 0 }));
    prisma.merchantPayout.findUnique.mockImplementation(async ({ where }: any) => {
      if (where.id) return payout;
      if (where.bookingId) return null; // eligibility check: no existing payout
      return null;
    });
    prisma.booking.findUnique.mockResolvedValue({
      id: "b_s1", status: "completed", depositAmountXof: 10000,
      payments: [{ id: "p_s1", status: "succeeded" }],
      salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
      isUnderFraudReview: false, refundRequested: false, disputeOpen: false,
    });
    adapter.getApproximateBalance.mockResolvedValue({ balance: 20000, currency: "XOF" });
    adapter.createDisbursementInvoice.mockResolvedValue({ disburseToken: "tok_s1" });
    adapter.submitDisbursement.mockResolvedValue({ status: "success", transactionId: "tx_s1" });

    const results = await Promise.all(
      Array.from({ length: 50 }, () => payoutService.submitPayout("pay_s1").catch((e: Error) => e.message))
    );
    const won = results.filter((r: any) => !String(r).includes("race condition"));
    expect(won).toHaveLength(1);
    expect(adapter.createDisbursementInvoice).toHaveBeenCalledTimes(1);
    expect(adapter.submitDisbursement).toHaveBeenCalledTimes(1);
  });

  it("100 concurrent checkPayoutEligibility calls", async () => {
    prisma.booking.findUnique.mockImplementation(async ({ where }: any) => ({
      id: where.id, status: "completed", depositAmountXof: 5000,
      payments: [{ id: `p_${where.id}`, status: "succeeded", amountXof: 5000 }],
      salon: { payoutMethod: "w", payoutPhone: "+221", payoutVerificationStatus: "verified", isSuspended: false },
      isUnderFraudReview: false, refundRequested: false, disputeOpen: false,
    }));
    prisma.merchantPayout.findUnique.mockResolvedValue(null);
    const results = await Promise.all(Array.from({ length: 100 }, (_, i) => payoutService.checkPayoutEligibility(`b_${i}`)));
    expect(results).toHaveLength(100);
    results.forEach((r: any) => expect(r.eligible).toBe(true));
    expect(prisma.booking.findUnique).toHaveBeenCalledTimes(100);
  });

  it("100 createPayoutForBooking — different bookings", async () => {
    prisma.booking.findUnique.mockImplementation(async ({ where }: any) => ({
      id: where.id, status: "completed", depositAmountXof: 10000,
      payments: [{ id: `p_${where.id}`, status: "succeeded", amountXof: 10000 }],
      salon: { id: `s_${where.id}`, payoutMethod: "w", payoutPhone: "+221", payoutName: "S", name: "S", payoutVerificationStatus: "verified", isSuspended: false },
      isUnderFraudReview: false, refundRequested: false, disputeOpen: false,
    }));
    prisma.merchantPayout.findUnique.mockResolvedValue(null);
    prisma.platformSetting.findUnique.mockResolvedValue({ value: "5" });
    let c = 0;
    tx.merchantPayout.create.mockImplementation(async () => ({ id: `pay_${++c}` }));
    tx.merchantPayout.update.mockImplementation(async ({ where }: any) => ({
      id: where.id, salonId: "s", bookingId: "b", paymentId: "p",
      payoutMethod: "w", beneficiaryPhoneSnapshot: "+221",
      grossAmount: 10000, platformCommissionAmount: 500, merchantPayoutAmount: 9500,
      status: "scheduled", disburseId: `merchant_payout_${where.id}`,
    }));
    await Promise.all(Array.from({ length: 100 }, (_, i) => payoutService.createPayoutForBooking(`b_${i}`)));
    expect(tx.ledgerEntry.create).toHaveBeenCalledTimes(300);
    expect(enqueueJobMock).toHaveBeenCalledTimes(100);
  });

  it("30 concurrent retries with existing disburseToken — one wins", async () => {
    const base = {
      id: "pay_rt", bookingId: "b_rt", paymentId: "p_rt", salonId: "s_rt",
      status: "failed_retryable", version: 1, merchantPayoutAmount: 5000,
      beneficiaryPhoneSnapshot: "+221771234567", payoutMethod: "wave_senegal",
      disburseId: "merchant_payout_rt", disburseToken: "tok_existing", transactionId: null,
      salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified" },
    };
    let claimCount = 0;
    prisma.merchantPayout.updateMany.mockImplementation(async () => ({ count: ++claimCount === 1 ? 1 : 0 }));
    prisma.merchantPayout.findUnique.mockImplementation(async ({ where }: any) => {
      if (where.id) return base;
      if (where.bookingId) return null;
      return null;
    });
    prisma.booking.findUnique.mockResolvedValue({
      id: "b_rt", status: "completed", depositAmountXof: 10000,
      payments: [{ id: "p_rt", status: "succeeded" }],
      salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
      isUnderFraudReview: false, refundRequested: false, disputeOpen: false,
    });
    adapter.getApproximateBalance.mockResolvedValue({ balance: 20000, currency: "XOF" });
    adapter.checkDisbursementStatus.mockResolvedValue({ status: "failed" });
    adapter.submitDisbursement.mockResolvedValue({ status: "success", transactionId: "tx_rt" });

    const results = await Promise.all(Array.from({ length: 30 }, () =>
      payoutService.submitPayout("pay_rt").catch((e: Error) => e.message)));
    const won = results.filter((r: any) => !String(r).includes("race condition"));
    expect(won).toHaveLength(1);
    expect(adapter.createDisbursementInvoice).not.toHaveBeenCalled();
    expect(adapter.submitDisbursement).toHaveBeenCalledTimes(1);
  });

  it("20 concurrent createPayoutForBooking — same booking, one wins", async () => {
    // Simulate the DB @unique constraint: only the first create succeeds,
    // subsequent ones throw P2002 (caught by createPayoutForBooking's transaction logic)
    prisma.booking.findUnique.mockResolvedValue({
      id: "b_dup", status: "completed", depositAmountXof: 10000,
      payments: [{ id: "p_dup", status: "succeeded", amountXof: 10000 }],
      salon: { id: "s_dup", payoutMethod: "w", payoutPhone: "+221", payoutName: "S", name: "S", payoutVerificationStatus: "verified", isSuspended: false },
      isUnderFraudReview: false, refundRequested: false, disputeOpen: false,
    });
    prisma.merchantPayout.findUnique.mockResolvedValue(null);
    prisma.platformSetting.findUnique.mockResolvedValue({ value: "5" });
    let created = false;
    prisma.$transaction = vi.fn(async (fn: any) => {
      // Simulate DB @unique: first create succeeds, later P2002
      tx.merchantPayout.create.mockImplementation(async () => {
        if (created) {
          const err = new Error("Unique constraint");
          (err as any).code = "P2002";
          throw err;
        }
        created = true;
        return { id: "pay_dup" };
      });
      tx.merchantPayout.update.mockResolvedValue({ id: "pay_dup", status: "scheduled", disburseId: "mp_pay_dup" });
      return fn(tx);
    });

    const results = await Promise.all(Array.from({ length: 20 }, () =>
      payoutService.createPayoutForBooking("b_dup").catch((e: Error) => e)));
    // Only 1 succeeded; the rest hit P2002 (caught by .catch)
    const successes = results.filter((r: any) => r && r.id);
    expect(successes).toHaveLength(1);
    expect(enqueueJobMock).toHaveBeenCalledTimes(1);
  });
});

// ─── =========================================================================
// 2. WORKER handleJob — Extreme load
// ─── =========================================================================

describe("Worker handleJob — Stress", { timeout: 30000 }, () => {
  let adapter: ReturnType<typeof buildAdapter>;
  let prisma: ReturnType<typeof buildPrisma>;
  let enqueueJobMock: ReturnType<typeof vi.fn>;
  let submitPayoutMock: ReturnType<typeof vi.fn>;
  let handleJob: any;

  beforeEach(async () => {
    vi.restoreAllMocks(); vi.resetModules();
    adapter = buildAdapter(); prisma = buildPrisma();
    enqueueJobMock = vi.fn(); submitPayoutMock = vi.fn();
    vi.doMock("./adapters/index.js", () => ({
      getPaymentAdapter: () => adapter,
      getStorageAdapter: () => ({ delete: vi.fn().mockResolvedValue(undefined) }),
    }));
    vi.doMock("./lib/db/prisma.js", () => ({ prisma }));
    vi.doMock("./lib/jobs.js", () => ({ enqueueJob: enqueueJobMock, closeJobQueues: vi.fn(), shouldRunBull: vi.fn().mockReturnValue(false) }));
    vi.doMock("./lib/logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./lib/email.js", () => ({ sendEmail: vi.fn() }));
    vi.doMock("./lib/push.js", () => ({ sendPushBatch: vi.fn() }));
    vi.doMock("./modules/notifications/index.js", () => ({ sendNotification: vi.fn() }));
    vi.doMock("./lib/payout-service.js", () => ({
      submitPayout: submitPayoutMock, reconcilePayoutStatus: vi.fn(), createPayoutForBooking: vi.fn(),
    }));
    vi.doMock("./config.js", () => ({ config: { ...BASE_CONFIG }, validateConfig: vi.fn() }));
    vi.doMock("bullmq", () => ({ Job: class {}, Worker: class {} }));
    vi.doMock("./lib/redis.js", () => ({ getQueueRedis: vi.fn() }));
    handleJob = (await import("./worker.js")).handleJob;
  });
  afterEach(() => { vi.restoreAllMocks(); });

  it("100 concurrent deposit_settlement jobs", async () => {
    prisma.booking.findUnique.mockImplementation(async ({ where }: any) => ({
      id: where.id,
      status: "completed",
      depositResolution: "pending",
      payments: [{ id: `p_${where.id}`, amountXof: 12000, providerTxId: `txn_${where.id}` }],
    }));
    prisma.settlementEvent.findFirst.mockResolvedValueOnce(null).mockResolvedValue({ platformFeeXof: 600, payoutAmountXof: 11400 });
    await Promise.all(Array.from({ length: 100 }, (_, i) => handleJob("deposit_settlement", { bookingId: `b_${i}` })));
    const creates = (prisma.settlementEvent.create as any).mock.calls;
    creates.forEach((c: any[]) => expect(c[0].data.eventType).toBe("released"));
  });

  it("dedup: 50 released + 50 new via booking key", async () => {
    const released = new Set(Array.from({ length: 50 }, (_, i) => `b_dd_${i}`));
    prisma.booking.findUnique.mockImplementation(async ({ where }: any) => ({
      id: where.id,
      status: "completed",
      depositResolution: "pending",
      payments: [{ id: `p_${where.id}`, amountXof: 12000, providerTxId: `txn_${where.id}` }],
    }));
    prisma.settlementEvent.findFirst.mockImplementation(async ({ where }: any) => {
      if (where.eventType === "released") {
        const bid = (where.paymentId as string)?.replace(/^p_/, "");
        return released.has(bid) ? { id: "existing_release" } : null;
      }
      return { platformFeeXof: 600, payoutAmountXof: 11400 };
    });
    await Promise.all(Array.from({ length: 100 }, (_, i) => handleJob("deposit_settlement", { bookingId: `b_dd_${i}` })));
    expect((prisma.settlementEvent.create as any).mock.calls).toHaveLength(50);
  });

  it("1/30 refund_reconciliation calls wins atomic claim", async () => {
    prisma.payment.findUnique.mockResolvedValue({
      id: "pay_rr", bookingId: "b_rr", amountXof: 12000, status: "succeeded", providerTxId: "txn_rr",
    });
    prisma.settlementEvent.findFirst.mockResolvedValue(null);
    let cc = 0;
    prisma.payment.updateMany.mockImplementation(async () => ({ count: ++cc > 1 ? 0 : 1 }));
    prisma.payment.update.mockResolvedValue({});
    adapter.requestRefund.mockResolvedValue({ refundRef: "rf" });

    await Promise.all(Array.from({ length: 30 }, () =>
      handleJob("refund_reconciliation", { paymentId: "pay_rr" }).catch((e: Error) => e.message)));
    // Check via adapter call count (not results length, since losers just return early)
    expect(adapter.requestRefund).toHaveBeenCalledTimes(1);
  });

  it("200 retryable payouts with exponential backoff", async () => {
    const now = Date.now(); vi.setSystemTime(now);
    prisma.merchantPayout.findMany
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce(Array.from({ length: 200 }, (_, i) => ({
        id: `pr_${i}`, attemptCount: i % 4, bookingId: `br_${i}`,
        status: "failed_retryable",
        nextRetryTime: i < 100 ? null : new Date(now - 1000),
      })));
    prisma.merchantPayout.updateMany.mockResolvedValue({ count: 200 });
    prisma.merchantPayout.update.mockResolvedValue({});

    enqueueJobMock.mockClear(); // clear seed-job calls from import
    await handleJob("payout_reconciliation", {});
    expect(enqueueJobMock).toHaveBeenCalledTimes(201);
    const updates = (prisma.merchantPayout.update as any).mock.calls;
    const overMax = updates.filter((c: any) => c[0].data.attemptCount > 5);
    expect(overMax).toHaveLength(0);
    const a1 = updates.find((c: any) => c[0].data.attemptCount === 1);
    if (a1) expect(a1[0].data.nextRetryTime.getTime() - now).toBe(10 * 60 * 1000);
    const a4 = updates.find((c: any) => c[0].data.attemptCount === 4);
    if (a4) expect(a4[0].data.nextRetryTime.getTime() - now).toBe(80 * 60 * 1000);
    vi.useRealTimers();
  });

  it("50 concurrent process_merchant_payout jobs", async () => {
    submitPayoutMock.mockResolvedValue({ id: "ok" });
    await Promise.all(Array.from({ length: 50 }, (_, i) => handleJob("process_merchant_payout", { payoutId: `p_${i}` })));
    expect(submitPayoutMock).toHaveBeenCalledTimes(50);
  });

  it("400 mixed-type jobs without crashing", async () => {
    prisma.booking.findUnique.mockResolvedValue({
      id: "bm", status: "completed", depositAmountXof: 10000,
      payments: [{ id: "pm", status: "succeeded", providerTxId: "txnm" }],
      client: { fullName: "T", email: "t@t.com", phone: "+221" },
      service: { name: "S" }, startsAt: new Date(), salonId: "sm",
    });
    prisma.payment.findUnique.mockResolvedValue({
      id: "pm", bookingId: "bm", amountXof: 10000, status: "succeeded", providerTxId: "txnm",
    });
    prisma.settlementEvent.findFirst.mockResolvedValue(null);
    prisma.payment.updateMany.mockResolvedValue({ count: 1 }); prisma.payment.update.mockResolvedValue({});
    prisma.merchantPayout.findMany.mockResolvedValue([]); prisma.merchantPayout.updateMany.mockResolvedValue({ count: 0 });
    prisma.notification.create.mockResolvedValue({}); prisma.pushToken.findMany.mockResolvedValue([]);
    prisma.user.findMany.mockResolvedValue([]); prisma.job.findMany.mockResolvedValue([]);
    prisma.notification.findUnique = vi.fn().mockResolvedValue({ id: "nm", userId: "um", title: "T", body: "B" });
    adapter.requestRefund.mockResolvedValue({ refundRef: "rf" }); submitPayoutMock.mockResolvedValue({});

    const TYPES = ["deposit_settlement", "refund_reconciliation", "process_merchant_payout",
      "payout_reconciliation", "notification_retry", "media_cleanup",
      "media_review_notify", "booking_reminder"] as const;
    const results = await Promise.all(Array.from({ length: 400 }, (_, i) => {
      const type = TYPES[i % TYPES.length];
      const p: Record<string, any> = {
        deposit_settlement: { bookingId: `b_${i}` }, refund_reconciliation: { paymentId: `p_${i}` },
        process_merchant_payout: { payoutId: `po_${i}` }, payout_reconciliation: {},
        notification_retry: { notificationId: `n_${i}` }, media_cleanup: { objectKey: `m_${i}` },
        media_review_notify: { mediaId: `m_${i}`, salonId: `s_${i}` }, booking_reminder: { bookingId: `b_${i}`, window: "1h" },
      };
      return handleJob(type, p[type]).catch((e: Error) => `ERR:${e.message}`);
    }));
    const errors = results.filter((r: any) => typeof r === "string");
    expect(errors.length).toBeLessThanOrEqual(60);
  });
});

// ─── =========================================================================
// 3. JOB QUEUE — Dedup & BullMQ
// ─── =========================================================================

describe("Job Queue — enqueueJob", { timeout: 15000 }, () => {
  beforeEach(async () => {
    vi.restoreAllMocks(); vi.resetModules();
    // Reset hoisted mocks to defaults
    section3.addMock.mockClear();
    section3.configMock.redisUrl = "";
    section3.configMock.workerDriver = "db";
    section3.getQueueRedisMock.mockClear();
    section3.getQueueRedisMock.mockResolvedValue({});
    section3.warnMock.mockClear();
    // Explicitly re-mock — overrides stale vi.doMock from other describe blocks
    // (vi.mock at top level is shadowed by later vi.doMock from sections 2,4,5,6)
    vi.doMock("bullmq", () => ({
      Queue: class { add = section3.addMock; close = vi.fn(); constructor(...args: any[]) {} },
    }));
    vi.doMock("./lib/redis.js", () => ({ getQueueRedis: section3.getQueueRedisMock }));
    vi.doMock("./config.js", () => ({ config: section3.configMock, validateConfig: vi.fn() }));
    vi.doMock("./lib/logger.js", () => ({ logger: section3.loggerMock }));
    // Only jobs.js must NOT be mocked — other sections mock it, we need the real one
    vi.doUnmock("./lib/jobs.js");
  });
  afterEach(() => { vi.restoreAllMocks(); });

  it("1000 identical calls → 1 DB insert", async () => {
    const { enqueueJob } = await import("./lib/jobs.js");
    let callOrder = 0;
    const dbCreate = vi.fn(async () => ({}));
    // Only the first caller gets null (no existing); all others find it
    const dbFindFirst = vi.fn(async () => (++callOrder === 1 ? null : { id: "existing" }));

    await Promise.all(Array.from({ length: 1000 }, () =>
      enqueueJob({
        type: "booking_reminder", payload: { bookingId: "b_same", window: "1h" },
        dbClient: { job: { create: dbCreate, findFirst: dbFindFirst, updateMany: vi.fn(async () => ({ count: 0 })) } },
      })
    ));
    expect(dbCreate).toHaveBeenCalledTimes(1);
    expect(dbFindFirst).toHaveBeenCalled();
  });

  it("650 jobs across 3 queues with routing", async () => {
    section3.configMock.redisUrl = "redis://ut"; section3.configMock.workerDriver = "hybrid";
    const { enqueueJob } = await import("./lib/jobs.js");
    const TYPES = ["deposit_settlement", "refund_reconciliation", "process_merchant_payout",
      "payout_reconciliation", "booking_reminder", "new_booking_salon", "salon_submitted_admin",
      "media_cleanup", "media_review_notify", "notification_retry",
      "subscription_expiry_check", "platform_settings_cleanup", "prestige_score_refresh"] as const;
    let c = 0;
    const dbCreate = vi.fn(async () => ({ id: `j-${++c}` }));

    await Promise.all(Array.from({ length: 650 }, (_, i) =>
      enqueueJob({
        type: TYPES[i % TYPES.length], payload: { k: `v${i}` },
        dbClient: { job: { create: dbCreate, findFirst: vi.fn(async () => null), updateMany: vi.fn(async () => ({ count: 0 })) } },
      })
    ));
    expect(c).toBe(650);
    expect(section3.addMock).toHaveBeenCalledTimes(650);
  });

  it("stable dedup across payload key order", async () => {
    const { enqueueJob } = await import("./lib/jobs.js");
    let createCount = 0;
    const dbCreate = vi.fn(async () => {
      if (++createCount > 1) {
        const err = new Error("Unique constraint");
        (err as any).code = "P2002";
        throw err;
      }
      return {};
    });
    const dbFindFirst = vi.fn(async () => null);
    // Both calls have the same payload (different key order — stableStringify normalizes it)
    await enqueueJob({ type: "deposit_settlement", payload: { a: 1, b: 2 },
      dbClient: { job: { create: dbCreate, findFirst: dbFindFirst, updateMany: vi.fn(async () => ({ count: 0 })) } } });
    await enqueueJob({ type: "deposit_settlement", payload: { b: 2, a: 1 },
      dbClient: { job: { create: dbCreate, findFirst: dbFindFirst, updateMany: vi.fn(async () => ({ count: 0 })) } } });
    // 2 create attempts: first succeeds, second throws P2002 (caught silently)
    expect(createCount).toBe(2);
    expect(dbCreate).toHaveBeenCalledTimes(2);
  });

  it("falls back to DB-only when Bull unavailable", async () => {
    section3.configMock.redisUrl = "redis://ut"; section3.configMock.workerDriver = "hybrid";
    // Override redis mock directly in test body (before import) to return null
    const warnSpy = vi.fn();
    vi.doMock("./lib/logger.js", () => ({ logger: { warn: warnSpy, error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./lib/redis.js", () => ({ getQueueRedis: vi.fn(async () => null) }));
    const { enqueueJob } = await import("./lib/jobs.js");
    const dbCreate = vi.fn(async () => ({}));
    await enqueueJob({
      type: "deposit_settlement", payload: { paymentId: "p1" },
      dbClient: { job: { create: dbCreate, findFirst: vi.fn(async () => null), updateMany: vi.fn(async () => ({ count: 0 })) } },
    });
    expect(warnSpy).toHaveBeenCalled();
    expect(dbCreate).toHaveBeenCalledTimes(1);
    expect(section3.addMock).not.toHaveBeenCalled();
  });
});

// ─── =========================================================================
// 4. PRESTIGE SCORE REFRESH
// ─── =========================================================================

describe("Prestige Score Refresh", { timeout: 15000 }, () => {
  let handleJob: any; let prisma: ReturnType<typeof buildPrisma>; let enqueueJobMock: ReturnType<typeof vi.fn>;
  beforeEach(async () => {
    vi.restoreAllMocks(); vi.resetModules();
    prisma = buildPrisma(); enqueueJobMock = vi.fn();
    vi.doMock("./adapters/index.js", () => ({
      getPaymentAdapter: () => buildAdapter(),
      getStorageAdapter: () => ({ delete: vi.fn().mockResolvedValue(undefined) }),
    }));
    vi.doMock("./lib/db/prisma.js", () => ({ prisma }));
    vi.doMock("./lib/jobs.js", () => ({ enqueueJob: enqueueJobMock, closeJobQueues: vi.fn(), shouldRunBull: vi.fn().mockReturnValue(true) }));
    vi.doMock("./lib/logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./lib/email.js", () => ({ sendEmail: vi.fn() }));
    vi.doMock("./lib/push.js", () => ({ sendPushBatch: vi.fn() }));
    vi.doMock("./modules/notifications/index.js", () => ({ sendNotification: vi.fn() }));
    vi.doMock("./lib/payout-service.js", () => ({ submitPayout: vi.fn(), reconcilePayoutStatus: vi.fn(), createPayoutForBooking: vi.fn() }));
    vi.doMock("./config.js", () => ({ config: { ...BASE_CONFIG, merchantPayoutEnabled: false }, validateConfig: vi.fn() }));
    vi.doMock("bullmq", () => ({ Job: class {}, Worker: class {} }));
    vi.doMock("./lib/redis.js", () => ({ getQueueRedis: vi.fn() }));
    handleJob = (await import("./worker.js")).handleJob;
  });
  afterEach(() => { vi.restoreAllMocks(); });

  it("updates 1000 salons", async () => {
    prisma.$executeRaw.mockResolvedValue(1000);
    await handleJob("prestige_score_refresh", {});
    expect(prisma.$executeRaw).toHaveBeenCalledTimes(1);
    expect(enqueueJobMock).toHaveBeenCalledWith(expect.objectContaining({ type: "prestige_score_refresh" }));
  });

  it("handles 100k salons", async () => {
    prisma.$executeRaw.mockResolvedValue(100000);
    await handleJob("prestige_score_refresh", {});
    expect(prisma.$executeRaw).toHaveBeenCalledTimes(1);
  });

  it("5 concurrent refreshes", async () => {
    enqueueJobMock.mockClear(); // clear seed-job calls from import
    prisma.$executeRaw.mockResolvedValue(500);
    await Promise.all(Array.from({ length: 5 }, () => handleJob("prestige_score_refresh", {})));
    expect(prisma.$executeRaw).toHaveBeenCalledTimes(5);
    // Each refresh reschedules itself
    expect(enqueueJobMock).toHaveBeenCalledTimes(5);
  });
});

// ─── =========================================================================
// 5. SUBSCRIPTION EXPIRY
// ─── =========================================================================

describe("Subscription Expiry", { timeout: 15000 }, () => {
  let handleJob: any; let prisma: any; let enqueueJobMock: ReturnType<typeof vi.fn>; let sendEmailMock: ReturnType<typeof vi.fn>;

  beforeEach(async () => {
    vi.restoreAllMocks(); vi.resetModules();
    prisma = buildPrisma(); enqueueJobMock = vi.fn(); sendEmailMock = vi.fn().mockResolvedValue(undefined);
    vi.doMock("./adapters/index.js", () => ({
      getPaymentAdapter: () => buildAdapter(),
      getStorageAdapter: () => ({ delete: vi.fn().mockResolvedValue(undefined) }),
    }));
    vi.doMock("./lib/db/prisma.js", () => ({ prisma }));
    vi.doMock("./lib/jobs.js", () => ({ enqueueJob: enqueueJobMock, closeJobQueues: vi.fn(), shouldRunBull: vi.fn().mockReturnValue(false) }));
    vi.doMock("./lib/logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./lib/email.js", () => ({ sendEmail: sendEmailMock }));
    vi.doMock("./lib/push.js", () => ({ sendPushBatch: vi.fn() }));
    vi.doMock("./modules/notifications/index.js", () => ({ sendNotification: vi.fn() }));
    vi.doMock("./lib/payout-service.js", () => ({ submitPayout: vi.fn(), reconcilePayoutStatus: vi.fn(), createPayoutForBooking: vi.fn() }));
    vi.doMock("./config.js", () => ({ config: { ...BASE_CONFIG, subscriptionExpiryEnabled: true, subscriptionGracePeriodDays: 3 }, validateConfig: vi.fn() }));
    vi.doMock("bullmq", () => ({ Job: class {}, Worker: class {} }));
    vi.doMock("./lib/redis.js", () => ({ getQueueRedis: vi.fn() }));
    vi.doMock("./lib/email-html.js", () => ({ buildEmailHtml: vi.fn(() => "<html></html>") }));
    handleJob = (await import("./worker.js")).handleJob;
  });
  afterEach(() => { vi.restoreAllMocks(); });

  it("moves 100 expired subscriptions to grace", async () => {
    const now = new Date();
    prisma.subscription.findMany = vi.fn()
      .mockResolvedValueOnce(Array.from({ length: 100 }, (_, i) => ({
        id: `sg_${i}`, salonId: `s_${i}`, status: "active",
        expiresAt: new Date(now.getTime() - 1000), gracePeriodEndsAt: null,
        salon: { id: `s_${i}`, staffMembers: i % 2 === 0 ? [{ email: `o${i}@t.com` }] : [] },
      })))
      .mockResolvedValueOnce([]);
    prisma.subscription.update = vi.fn().mockResolvedValue({});

    await handleJob("subscription_expiry_check", {});
    expect(prisma.subscription.update).toHaveBeenCalledTimes(100);
    expect(sendEmailMock).toHaveBeenCalledTimes(50);
    expect(enqueueJobMock).toHaveBeenCalledWith(expect.objectContaining({ type: "subscription_expiry_check" }));
  });

  it("expires 50 past_due subscriptions past grace", async () => {
    const now = new Date();
    prisma.subscription.findMany = vi.fn()
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce(Array.from({ length: 50 }, (_, i) => ({
        id: `se_${i}`, salonId: `s_${i}`, status: "past_due",
        gracePeriodEndsAt: new Date(now.getTime() - 1000),
        pendingTier: i % 3 === 0 ? "standard" : null,
        salon: { id: `s_${i}`, name: `S${i}`, staffMembers: [{ email: `o${i}@t.com` }] },
      })));
    // Worker uses array syntax: $transaction([update1, update2])
    prisma.$transaction = vi.fn(async (input: any) => {
      if (Array.isArray(input)) return Promise.all(input);
      return input({
        subscription: { update: vi.fn().mockResolvedValue({}) },
        salon: { update: vi.fn().mockResolvedValue({}) },
      });
    });

    await handleJob("subscription_expiry_check", {});
    expect(prisma.$transaction).toHaveBeenCalled();
  });
});

// ─── =========================================================================
// 6. ERROR RECOVERY
// ─── =========================================================================

describe("Worker Error Recovery", { timeout: 15000 }, () => {
  let submitPayoutMock: ReturnType<typeof vi.fn>; let handleJob: any;
  let adapter: ReturnType<typeof buildAdapter>; let prisma: ReturnType<typeof buildPrisma>;

  beforeEach(async () => {
    vi.restoreAllMocks(); vi.resetModules();
    submitPayoutMock = vi.fn(); adapter = buildAdapter(); prisma = buildPrisma();
    vi.doMock("./adapters/index.js", () => ({
      getPaymentAdapter: () => adapter,
      getStorageAdapter: () => ({ delete: vi.fn().mockResolvedValue(undefined) }),
    }));
    vi.doMock("./lib/db/prisma.js", () => ({ prisma }));
    vi.doMock("./lib/jobs.js", () => ({ enqueueJob: vi.fn(), closeJobQueues: vi.fn(), shouldRunBull: vi.fn().mockReturnValue(false) }));
    vi.doMock("./lib/logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./lib/email.js", () => ({ sendEmail: vi.fn() }));
    vi.doMock("./lib/push.js", () => ({ sendPushBatch: vi.fn() }));
    vi.doMock("./modules/notifications/index.js", () => ({ sendNotification: vi.fn() }));
    vi.doMock("./lib/payout-service.js", () => ({
      submitPayout: submitPayoutMock, reconcilePayoutStatus: vi.fn(), createPayoutForBooking: vi.fn(),
    }));
    vi.doMock("./config.js", () => ({ config: { ...BASE_CONFIG }, validateConfig: vi.fn() }));
    vi.doMock("bullmq", () => ({ Job: class {}, Worker: class {} }));
    vi.doMock("./lib/redis.js", () => ({ getQueueRedis: vi.fn() }));
    handleJob = (await import("./worker.js")).handleJob;
  });
  afterEach(() => { vi.restoreAllMocks(); });

  it("propagates submitPayout error for retry", async () => {
    submitPayoutMock.mockRejectedValue(new Error("timeout"));
    await expect(handleJob("process_merchant_payout", { payoutId: "p1" })).rejects.toThrow("timeout");
  });
  it("fail then succeed on retry", async () => {
    let a = 0;
    submitPayoutMock.mockImplementation(async () => { if (++a === 1) throw new Error("fail"); });
    await expect(handleJob("process_merchant_payout", { payoutId: "p2" })).rejects.toThrow("fail");
    await handleJob("process_merchant_payout", { payoutId: "p2" });
    expect(submitPayoutMock).toHaveBeenCalledTimes(2);
  });
  it("unknown job type is a no-op", async () => {
    await expect(handleJob("unknown" as any, {})).resolves.toBeUndefined();
  });
  it("rollback on refund provider failure", async () => {
    prisma.payment.findUnique.mockResolvedValue({
      id: "pay_rb", bookingId: "b_rb", amountXof: 12000, status: "succeeded", providerTxId: "txn_rb",
    });
    prisma.settlementEvent.findFirst.mockResolvedValue(null);
    prisma.payment.updateMany.mockResolvedValue({ count: 1 });
    prisma.payment.update.mockResolvedValue({});
    prisma.booking.findUnique.mockResolvedValue({ client: { phone: "+221" } });
    adapter.requestRefund.mockRejectedValue(new Error("timeout"));
    await expect(handleJob("refund_reconciliation", { paymentId: "pay_rb" })).rejects.toThrow("timeout");
    expect(prisma.payment.update).toHaveBeenCalledWith({ where: { id: "pay_rb" }, data: { status: "succeeded" } });
  });
});

// ─── =========================================================================
// 7. ALL PAYOUT ELIGIBILITY PATHS
// ─── =========================================================================

describe("Payout Eligibility — All Paths", { timeout: 15000 }, () => {
  let payoutService: typeof import("./lib/payout-service.js");
  let prisma: ReturnType<typeof buildPrisma>;
  beforeEach(async () => {
    vi.restoreAllMocks(); vi.resetModules();
    prisma = buildPrisma();
    vi.doMock("./adapters/index.js", () => ({ getPaymentAdapter: () => buildAdapter() }));
    vi.doMock("./lib/db/prisma.js", () => ({ prisma }));
    vi.doMock("./lib/jobs.js", () => ({ enqueueJob: vi.fn(), queueForJob: vi.fn(), closeJobQueues: vi.fn(), shouldRunBull: vi.fn().mockReturnValue(false) }));
    vi.doMock("./lib/logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));
    vi.doMock("./config.js", () => ({ config: { ...BASE_CONFIG }, validateConfig: vi.fn() }));
    vi.doUnmock("./lib/payout-service.js");
    payoutService = await import("./lib/payout-service.js");
  });
  afterEach(() => { vi.restoreAllMocks(); });

  it("11 rejection paths + 1 eligible path + cancelled re-create", async () => {
    const scenarios: Array<{ reason: string; setup: () => void }> = [
      { reason: "booking_not_found", setup: () => { prisma.booking.findUnique.mockResolvedValueOnce(null); } },
      { reason: "booking_not_settlement_eligible", setup: () => { prisma.booking.findUnique.mockResolvedValueOnce({ id: "b1", status: "pending", payments: [{ status: "succeeded" }] }); } },
      { reason: "payment_missing", setup: () => { prisma.booking.findUnique.mockResolvedValueOnce({ id: "b1", status: "completed", payments: [] }); } },
      { reason: "payment_not_succeeded", setup: () => { prisma.booking.findUnique.mockResolvedValueOnce({ id: "b1", status: "completed", payments: [{ status: "pending" }] }); } },
      { reason: "salon_payout_details_missing", setup: () => { prisma.booking.findUnique.mockResolvedValueOnce({ id: "b1", status: "completed", payments: [{ status: "succeeded" }], salon: { payoutMethod: null, payoutPhone: null } }); } },
      { reason: "salon_payout_details_unverified", setup: () => { prisma.booking.findUnique.mockResolvedValueOnce({ id: "b1", status: "completed", payments: [{ status: "succeeded" }], salon: { payoutMethod: "w", payoutPhone: "+221", payoutVerificationStatus: "unverified" } }); } },
      { reason: "salon_suspended", setup: () => { prisma.booking.findUnique.mockResolvedValueOnce({ id: "b1", status: "completed", payments: [{ status: "succeeded" }], salon: { payoutMethod: "w", payoutPhone: "+221", payoutVerificationStatus: "verified", isSuspended: true } }); } },
      { reason: "booking_under_fraud_review", setup: () => { prisma.booking.findUnique.mockResolvedValueOnce({ id: "b1", status: "completed", payments: [{ status: "succeeded" }], salon: { payoutMethod: "w", payoutPhone: "+221", payoutVerificationStatus: "verified", isSuspended: false }, isUnderFraudReview: true, refundRequested: false, disputeOpen: false }); } },
      { reason: "refund_request_open", setup: () => { prisma.booking.findUnique.mockResolvedValueOnce({ id: "b1", status: "completed", payments: [{ status: "succeeded" }], salon: { payoutMethod: "w", payoutPhone: "+221", payoutVerificationStatus: "verified", isSuspended: false }, isUnderFraudReview: false, refundRequested: true, disputeOpen: false }); } },
      { reason: "dispute_open", setup: () => { prisma.booking.findUnique.mockResolvedValueOnce({ id: "b1", status: "completed", payments: [{ status: "succeeded" }], salon: { payoutMethod: "w", payoutPhone: "+221", payoutVerificationStatus: "verified", isSuspended: false }, isUnderFraudReview: false, refundRequested: false, disputeOpen: true }); } },
      { reason: "payout_already_exists", setup: () => { prisma.booking.findUnique.mockResolvedValueOnce({ id: "b1", status: "completed", depositAmountXof: 5000, payments: [{ id: "p1", status: "succeeded" }], salon: { payoutMethod: "w", payoutPhone: "+221", payoutVerificationStatus: "verified", isSuspended: false }, isUnderFraudReview: false, refundRequested: false, disputeOpen: false }); prisma.merchantPayout.findFirst.mockResolvedValueOnce({ id: "e", status: "scheduled" }); } },
      { reason: "payout_amount_zero_or_negative", setup: () => { prisma.booking.findUnique.mockResolvedValueOnce({ id: "b1", status: "completed", depositAmountXof: 0, payments: [{ id: "p1", status: "succeeded" }], salon: { payoutMethod: "w", payoutPhone: "+221", payoutVerificationStatus: "verified", isSuspended: false }, isUnderFraudReview: false, refundRequested: false, disputeOpen: false }); prisma.merchantPayout.findFirst.mockResolvedValueOnce(null); } },
    ];
    for (const s of scenarios) { s.setup(); const r = await payoutService.checkPayoutEligibility("b1"); expect(r.eligible).toBe(false); expect(r.reason).toBe(s.reason); }
    // Eligible
    prisma.booking.findUnique.mockResolvedValueOnce({ id: "b1", status: "completed", depositAmountXof: 5000, payments: [{ id: "p1", status: "succeeded", amountXof: 5000 }], salon: { payoutMethod: "w", payoutPhone: "+221", payoutVerificationStatus: "verified", isSuspended: false }, isUnderFraudReview: false, refundRequested: false, disputeOpen: false });
    prisma.merchantPayout.findFirst.mockResolvedValueOnce(null);
    expect((await payoutService.checkPayoutEligibility("b1")).eligible).toBe(true);
    // Cancelled can re-create
    prisma.booking.findUnique.mockResolvedValueOnce({ id: "bc", status: "completed", depositAmountXof: 5000, payments: [{ id: "p1", status: "succeeded" }], salon: { payoutMethod: "w", payoutPhone: "+221", payoutVerificationStatus: "verified", isSuspended: false }, isUnderFraudReview: false, refundRequested: false, disputeOpen: false });
    prisma.merchantPayout.findFirst.mockResolvedValueOnce(null); // cancelled filtered by where clause
    expect((await payoutService.checkPayoutEligibility("bc")).eligible).toBe(true);
  });
});
