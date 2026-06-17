import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const prisma = {
    user: { findUnique: vi.fn(), create: vi.fn(), findFirst: vi.fn(), update: vi.fn() },
    session: {
      create: vi.fn(),
      findFirst: vi.fn(),
      delete: vi.fn(),
      findMany: vi.fn(),
      deleteMany: vi.fn()
    },
    otpChallenge: {
      upsert: vi.fn(),
      findUnique: vi.fn(),
      deleteMany: vi.fn(),
      update: vi.fn()
    },
    platformSetting: { findUnique: vi.fn(), upsert: vi.fn(), update: vi.fn(), deleteMany: vi.fn() },
    salon: { create: vi.fn() },
    service: { createMany: vi.fn() },
    salonHours: { createMany: vi.fn() },
    clientProfile: { upsert: vi.fn() },
    mediaAsset: { findUnique: vi.fn() },
    $transaction: vi.fn(async (arg: any) => (typeof arg === "function" ? arg({
      user: { update: vi.fn() },
      session: { deleteMany: vi.fn() },
      clientProfile: { upsert: vi.fn() }
    }) : Promise.all(arg)))
  };

  const ok = vi.fn();
  const fail = vi.fn();
  const requireRole = vi.fn();

  return { prisma, ok, fail, requireRole };
});

vi.mock("../../adapters/index.js", () => ({
  createOtpAdapter: () => ({ send: vi.fn(), verify: vi.fn() }),
  getStorageAdapter: vi.fn()
}));

vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/auth/session.js", () => ({
  signSession: () => ({ accessToken: "a", refreshToken: "r", expiresInSeconds: 900 }),
  verifyRefreshToken: () => ({ sub: "u1" })
}));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});

import { AuthController } from "./index.js";

describe("Auth session security", () => {
  const controller = new AuthController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.prisma.session.findMany.mockResolvedValue([]);
  });

  it("rejects refresh from mismatched user-agent binding", async () => {
    mocks.prisma.session.findFirst.mockResolvedValue({
      id: "sess_1",
      userId: "u1",
      refreshToken: "hashed",
      clientType: "web",
      userAgentHash: "expected_hash",
      expiresAt: new Date(Date.now() + 60_000)
    });
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", role: "client" });

    await controller.refresh({
      body: { refreshToken: "rtok_1" },
      headers: { "user-agent": "different-ua" }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      401,
      "device_mismatch",
      "Refresh interdit depuis un client différent."
    );
  });

  it("logout without valid refresh body does not delete all sessions", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });

    await controller.logout({
      body: { invalid: "shape" }
    } as never, {} as never);

    expect(mocks.prisma.session.deleteMany).not.toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { revoked: true });
  });
});
