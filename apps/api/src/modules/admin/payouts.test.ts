import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const sendEmail = vi.fn();
  const sendNotification = vi.fn();
  const prisma = {
    salon: {
      findMany: vi.fn(),
      findUnique: vi.fn()
    },
    $transaction: vi.fn()
  };
  const tx = {
    salon: { update: vi.fn() },
    merchantPayout: { updateMany: vi.fn() },
    auditLog: { create: vi.fn() }
  };
  return { requireRole, fail, ok, sendEmail, sendNotification, prisma, tx };
});

vi.mock("../../config.js", () => ({
  config: {
    webOrigin: "https://beauteavenue.sn"
  }
}));
vi.mock("../../lib/auth/index.js", () => ({ requireRole: mocks.requireRole }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/email.js", () => ({ sendEmail: mocks.sendEmail }));
vi.mock("../../lib/email-html.js", () => ({ buildEmailHtml: vi.fn(() => "<p>email</p>") }));
vi.mock("../../lib/http.js", () => ({ fail: mocks.fail, ok: mocks.ok, handleError: vi.fn() }));
vi.mock("../../lib/logger.js", () => ({ logger: { warn: vi.fn(), error: vi.fn(), info: vi.fn() } }));
vi.mock("../../lib/payout-service.js", () => ({
  reconcilePayoutStatus: vi.fn(),
  submitPayout: vi.fn()
}));
vi.mock("../notifications/index.js", () => ({ sendNotification: mocks.sendNotification }));

import { listPayoutVerificationQueue, verifySalonPayoutSettings } from "./payouts.js";

describe("admin payout verification workflows", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "admin_1", role: "platform_admin" });
    mocks.sendNotification.mockResolvedValue(undefined);
    mocks.sendEmail.mockResolvedValue(undefined);
    mocks.prisma.$transaction.mockImplementation(async (callback: (tx: typeof mocks.tx) => Promise<void>) => callback(mocks.tx));
  });

  it("lists salons awaiting payout verification with impact counts", async () => {
    mocks.prisma.salon.findMany.mockResolvedValue([
      {
        id: "salon_1",
        name: "Salon Avenir",
        city: "Dakar",
        payoutMethod: "orange_money_senegal",
        payoutPhone: "+221771234567",
        payoutName: "Cheikh Ahmed",
        payoutVerificationStatus: "unverified",
        payoutVerifiedAt: null,
        updatedAt: new Date("2026-06-19T10:00:00.000Z"),
        staffMembers: [{ id: "owner_1", fullName: "Cheikh", email: "owner@test.sn" }],
        payouts: [
          { id: "p1", status: "blocked", safeFailureMessage: "salon_payout_details_unverified" },
          { id: "p2", status: "blocked", safeFailureMessage: "Coordonnées de paiement modifiées" },
          { id: "p3", status: "scheduled", safeFailureMessage: null }
        ]
      }
    ]);

    await listPayoutVerificationQueue({ query: { status: "all" } } as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(
      expect.anything(),
      expect.arrayContaining([
        expect.objectContaining({
          salonId: "salon_1",
          payoutPhoneMasked: "221*****4567",
          blockedPayoutCount: 2,
          blockedForVerificationCount: 2,
          totalPayoutCount: 3
        })
      ])
    );
  });

  it("verifies payout settings and notifies the salon owner", async () => {
    mocks.prisma.salon.findUnique.mockResolvedValue({
      id: "salon_1",
      name: "Salon Avenir",
      payoutPhone: "+221771234567",
      staffMembers: [{ id: "owner_1", fullName: "Cheikh Ahmed", email: "owner@test.sn" }]
    });

    await verifySalonPayoutSettings(
      {
        params: { salonId: "salon_1" },
        body: { status: "verified" }
      } as never,
      {} as never
    );

    expect(mocks.tx.salon.update).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { id: "salon_1" },
        data: expect.objectContaining({
          payoutVerificationStatus: "verified",
          payoutVerifiedBy: "admin_1"
        })
      })
    );
    expect(mocks.tx.merchantPayout.updateMany).toHaveBeenCalled();
    expect(mocks.sendNotification).toHaveBeenCalledWith(
      "owner_1",
      "Coordonnées de versement approuvées",
      expect.stringContaining("Salon Avenir")
    );
    expect(mocks.sendEmail).toHaveBeenCalledWith(
      expect.objectContaining({
        to: "owner@test.sn",
        subject: "Coordonnées de versement approuvées — Beauté Avenue"
      })
    );
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { status: "verified" });
  });
});
