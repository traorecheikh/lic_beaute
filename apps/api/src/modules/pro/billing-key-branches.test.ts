import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const handleError = vi.fn();
  const prisma = {
    user: { findUnique: vi.fn() },
    subscription: { findUnique: vi.fn(), update: vi.fn() },
    platformSetting: { findMany: vi.fn(), upsert: vi.fn(), deleteMany: vi.fn() },
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
vi.mock("../../lib/availability.js", () => ({ fetchAndComputeAvailableSlots: vi.fn() }));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: vi.fn() }));
vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: vi.fn(() => ({ initiateDeposit: vi.fn() })) }));
vi.mock("./data.js", () => ({ getProAnalytics: vi.fn(), getProDashboard: vi.fn() }));

describe("ProController billing key branches", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.$transaction.mockImplementation(async (cb: any) => cb({
      subscription: { update: vi.fn() },
      platformSetting: { upsert: vi.fn(), deleteMany: vi.fn() }
    }));
  });

  it("handles missing BILLING_ACCOUNT_SECRET in production via error path", async () => {
    vi.resetModules();
    vi.doMock("../../config.js", () => ({
      config: {
        paymentDriver: "paydunya",
        webOrigin: "http://localhost:5174",
        cacheTtlKpiSeconds: 60,
        paydunyaMasterKey: "master-key",
        paydunyaPrivateKey: "private-key",
        paydunyaToken: "token",
        paydunyaEnv: "sandbox",
        paydunyaBaseUrl: "https://sandbox.paydunya.com",
        billingAccountSecret: "",
        nodeEnv: "production"
      }
    }));
    const { ProController } = await import("./index.js");
    const c = new ProController();
    await c.updateSubscription({
      body: { billingMethod: { provider: "manual", accountNumber: "77223344" } }
    } as never, {} as never);
    expect(mocks.handleError).toHaveBeenCalled();
  });

  it("supports legacy plaintext and dev fallback key path when secret missing in non-prod", async () => {
    vi.resetModules();
    vi.doMock("../../config.js", () => ({
      config: {
        paymentDriver: "paydunya",
        webOrigin: "http://localhost:5174",
        cacheTtlKpiSeconds: 60,
        paydunyaMasterKey: "master-key",
        paydunyaPrivateKey: "private-key",
        paydunyaToken: "token",
        paydunyaEnv: "sandbox",
        paydunyaBaseUrl: "https://sandbox.paydunya.com",
        billingAccountSecret: "",
        nodeEnv: "test"
      }
    }));
    const { ProController } = await import("./index.js");
    const c = new ProController();

    await c.updateSubscription({
      body: { billingMethod: { provider: "manual", accountNumber: "77223344" } }
    } as never, {} as never);

    mocks.prisma.subscription.findUnique.mockResolvedValue({
      id: "sub1",
      tier: "standard",
      status: "active",
      renewedAt: null,
      expiresAt: null,
      isComplimentary: false,
      autoRenew: true,
      billingProvider: "manual"
    });
    mocks.prisma.platformSetting.findMany.mockResolvedValue([
      { key: "salon:s1:billing_provider", value: "manual" },
      { key: "salon:s1:billing_account_number", value: "77223344" }
    ]);
    await c.getSubscription({} as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("round-trips encrypted billing account through updateSubscription -> getSubscription", async () => {
    vi.resetModules();
    vi.doMock("../../config.js", () => ({
      config: {
        paymentDriver: "paydunya",
        webOrigin: "http://localhost:5174",
        cacheTtlKpiSeconds: 60,
        paydunyaMasterKey: "master-key",
        paydunyaPrivateKey: "private-key",
        paydunyaToken: "token",
        paydunyaEnv: "sandbox",
        paydunyaBaseUrl: "https://sandbox.paydunya.com",
        billingAccountSecret: "a".repeat(64),
        nodeEnv: "test"
      }
    }));
    const { ProController } = await import("./index.js");
    const c = new ProController();

    let storedAccount = "";
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: any) => cb({
      subscription: { update: vi.fn() },
      platformSetting: {
        upsert: vi.fn(async (args: any) => {
          if (String(args.where.key).includes("billing_account_number")) {
            storedAccount = args.create.value;
          }
          return {};
        }),
        deleteMany: vi.fn()
      }
    }));
    await c.updateSubscription({
      body: { billingMethod: { provider: "manual", accountNumber: "77223344" } }
    } as never, {} as never);

    mocks.prisma.subscription.findUnique.mockResolvedValue({
      id: "sub1",
      tier: "standard",
      status: "active",
      renewedAt: null,
      expiresAt: null,
      isComplimentary: false,
      autoRenew: true,
      billingProvider: "manual"
    });
    mocks.prisma.platformSetting.findMany.mockResolvedValue([
      { key: "salon:s1:billing_provider", value: "manual" },
      { key: "salon:s1:billing_account_number", value: storedAccount }
    ]);
    await c.getSubscription({} as never, {} as never);
    expect(storedAccount.startsWith("enc:v1:")).toBe(true);
    expect(mocks.ok).toHaveBeenCalled();
  });
});
