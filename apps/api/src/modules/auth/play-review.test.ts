import { afterAll, beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const prisma = {
    user: {
      findUnique: vi.fn(),
      create: vi.fn(),
      findFirst: vi.fn(),
      update: vi.fn()
    },
    session: {
      create: vi.fn(),
      findMany: vi.fn(),
      deleteMany: vi.fn()
    },
    emailOtpChallenge: {
      findUnique: vi.fn(),
      upsert: vi.fn(),
      deleteMany: vi.fn(),
      update: vi.fn()
    },
    platformSetting: {
      findUnique: vi.fn(),
      deleteMany: vi.fn()
    },
    clientProfile: { upsert: vi.fn() },
    $transaction: vi.fn()
  };
  const ok = vi.fn();
  const fail = vi.fn();
  const signSession = vi.fn();
  const sendEmail = vi.fn().mockResolvedValue(undefined);

  return { prisma, ok, fail, signSession, sendEmail };
});

vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/auth/session.js", () => ({
  signSession: mocks.signSession
}));
vi.mock("../../lib/email.js", () => ({ sendEmail: mocks.sendEmail }));
vi.mock("../../adapters/index.js", () => ({
  createOtpAdapter: vi.fn(() => ({ send: vi.fn(), verify: vi.fn() })),
  getStorageAdapter: vi.fn()
}));
vi.mock("../../lib/rate-limit.js", () => ({
  checkRateLimit: vi.fn().mockResolvedValue({ allowed: true }),
  checkAccountRateLimit: vi.fn().mockResolvedValue({ allowed: true })
}));

const mockConfig = vi.hoisted(() => ({
  jwtAccessSecret: "test-secret",
  jwtRefreshSecret: "test-refresh-secret",
  jwtRefreshTtlSeconds: 2592000,
  jwtAccessTtlSeconds: 7200,
  nodeEnv: "test",
  webOrigin: "http://localhost:5174",
  playReviewEnabled: true,
  playReviewEmail: "reviewer@test.com",
  playReviewOtp: "482731"
}));

vi.mock("../../config.js", () => ({
  config: mockConfig,
  validateConfig: () => {}
}));

import { AuthController } from "./index.js";

describe("Play Store reviewer bypass", () => {
  const controller = new AuthController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.signSession.mockReturnValue({
      accessToken: "test-access",
      refreshToken: "test-refresh",
      expiresInSeconds: 900
    });
    mocks.prisma.session.findMany.mockResolvedValue([]);
    mocks.prisma.session.create.mockResolvedValue({ id: "sess_1" });
    mocks.prisma.session.deleteMany.mockResolvedValue({ count: 0 });
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    mocks.prisma.user.create.mockResolvedValue({ id: "reviewer_u1", role: "client" });
    mocks.prisma.emailOtpChallenge.findUnique.mockResolvedValue(null);
    mocks.prisma.emailOtpChallenge.upsert.mockResolvedValue({});
    mocks.prisma.emailOtpChallenge.deleteMany.mockResolvedValue({ count: 1 });
  });

  // ── requestEmailOtp ─────────────────────────────────────────────────

  it("accepts reviewer email in requestEmailOtp and does not send email", async () => {
    await controller.requestEmailOtp(
      { body: { email: "reviewer@test.com" }, headers: {} } as never,
      { code: vi.fn().mockReturnThis(), send: vi.fn() } as never
    );

    // No OTP email sent
    expect(mocks.sendEmail).not.toHaveBeenCalled();
    // No OTP challenge persisted
    expect(mocks.prisma.emailOtpChallenge.upsert).not.toHaveBeenCalled();
  });

  it("still sends email for non-reviewer accounts", async () => {
    await controller.requestEmailOtp(
      { body: { email: "normal@user.com" }, headers: {} } as never,
      { code: vi.fn().mockReturnThis(), send: vi.fn() } as never
    );

    expect(mocks.sendEmail).toHaveBeenCalled();
    expect(mocks.prisma.emailOtpChallenge.upsert).toHaveBeenCalled();
  });

  // ── verifyEmailOtp ──────────────────────────────────────────────────

  it("accepts reviewer with correct static OTP", async () => {
    await controller.verifyEmailOtp(
      {
        body: { email: "reviewer@test.com", code: "482731" },
        headers: { "user-agent": "test-agent/1.0" }
      } as never,
      {} as never
    );

    expect(mocks.prisma.user.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          email: "reviewer@test.com",
          fullName: "Compte test"
        })
      })
    );
    expect(mocks.signSession).toHaveBeenCalled();
    expect(mocks.prisma.session.create).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalled();
    expect(mocks.fail).not.toHaveBeenCalled();
  });

  it("rejects reviewer with wrong static OTP", async () => {
    await controller.verifyEmailOtp(
      {
        body: { email: "reviewer@test.com", code: "999999" },
        headers: { "user-agent": "test-agent/1.0" }
      } as never,
      {} as never
    );

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      401,
      "invalid_otp",
      expect.any(String)
    );
    expect(mocks.ok).not.toHaveBeenCalled();
  });

  it("does not allow non-reviewer accounts to use the static OTP", async () => {
    await controller.verifyEmailOtp(
      {
        body: { email: "normal@user.com", code: "482731" },
        headers: { "user-agent": "test-agent/1.0" }
      } as never,
      {} as never
    );

    // Normal flow falls through — no challenge exists → invalid_otp
    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      401,
      "invalid_otp",
      expect.any(String)
    );
    expect(mocks.ok).not.toHaveBeenCalled();
  });

  it("normalizes email (lowercase) before comparing case variations", async () => {
    await controller.verifyEmailOtp(
      {
        body: { email: "Reviewer@Test.COM", code: "482731" },
        headers: { "user-agent": "test-agent/1.0" }
      } as never,
      {} as never
    );

    expect(mocks.prisma.user.create).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("normalizes email in requestEmailOtp with case variations", async () => {
    await controller.requestEmailOtp(
      { body: { email: "REVIEWER@test.com" }, headers: {} } as never,
      { code: vi.fn().mockReturnThis(), send: vi.fn() } as never
    );

    expect(mocks.sendEmail).not.toHaveBeenCalled();
    expect(mocks.prisma.emailOtpChallenge.upsert).not.toHaveBeenCalled();
  });

  it("matches reviewer email exactly after normalization", async () => {
    // Using uppercase email that should match the lowercase config value
    await controller.verifyEmailOtp(
      {
        body: { email: "REVIEWER@TEST.COM", code: "482731" },
        headers: { "user-agent": "test-agent/1.0" }
      } as never,
      {} as never
    );

    expect(mocks.prisma.user.create).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalled();
  });

  // ── Edge cases ──────────────────────────────────────────────────────

  it("creates a new user if reviewer does not exist yet", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    mocks.prisma.user.create.mockResolvedValue({ id: "new_reviewer", role: "client" });

    await controller.verifyEmailOtp(
      {
        body: { email: "reviewer@test.com", code: "482731" },
        headers: { "user-agent": "test-agent/1.0" }
      } as never,
      {} as never
    );

    expect(mocks.prisma.user.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          email: "reviewer@test.com",
          role: "client",
          fullName: "Compte test"
        })
      })
    );
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("signs in existing reviewer user without creating", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue({
      id: "existing_reviewer",
      role: "client",
      fullName: "Reviewer Name"
    });

    await controller.verifyEmailOtp(
      {
        body: { email: "reviewer@test.com", code: "482731" },
        headers: { "user-agent": "test-agent/1.0" }
      } as never,
      {} as never
    );

    expect(mocks.prisma.user.create).not.toHaveBeenCalled();
    expect(mocks.signSession).toHaveBeenCalledWith("existing_reviewer", "client", undefined);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("repairs existing reviewer users with an empty full name", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue({
      id: "existing_reviewer",
      role: "client",
      tokenVersion: 3,
      fullName: "   "
    });
    mocks.prisma.user.update.mockResolvedValue({
      id: "existing_reviewer",
      role: "client",
      tokenVersion: 3,
      fullName: "Compte test"
    });

    await controller.verifyEmailOtp(
      {
        body: { email: "reviewer@test.com", code: "482731" },
        headers: { "user-agent": "test-agent/1.0" }
      } as never,
      {} as never
    );

    expect(mocks.prisma.user.update).toHaveBeenCalledWith({
      where: { id: "existing_reviewer" },
      data: { fullName: "Compte test" }
    });
    expect(mocks.signSession).toHaveBeenCalledWith(
      "existing_reviewer",
      "client",
      3
    );
  });

  it("does not leak reviewer status in error response", async () => {
    mocks.fail.mockClear();

    await controller.verifyEmailOtp(
      {
        body: { email: "reviewer@test.com", code: "000000" },
        headers: { "user-agent": "test-agent/1.0" }
      } as never,
      {} as never
    );

    const failCall = mocks.fail.mock.calls[0];
    // Error should be identical to normal OTP failure — no hint about reviewer
    expect(failCall[3]).toBe("Code OTP invalide ou expiré.");
  });
});

describe("Play Store reviewer bypass disabled", () => {
  const controller = new AuthController();

  beforeEach(() => {
    vi.clearAllMocks();
    // Override config for disabled state
    mockConfig.playReviewEnabled = false;
    mockConfig.playReviewEmail = "reviewer@test.com";
    mockConfig.playReviewOtp = "482731";
    mocks.prisma.session.findMany.mockResolvedValue([]);
    mocks.prisma.session.create.mockResolvedValue({ id: "sess_1" });
    mocks.prisma.emailOtpChallenge.findUnique.mockResolvedValue(null);
  });

  afterAll(() => {
    mockConfig.playReviewEnabled = true;
  });

  it("rejects reviewer when PLAY_REVIEW_ENABLED=false", async () => {
    // No persisted challenge → normal flow returns invalid_otp
    await controller.verifyEmailOtp(
      {
        body: { email: "reviewer@test.com", code: "482731" },
        headers: { "user-agent": "test-agent/1.0" }
      } as never,
      {} as never
    );

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      401,
      "invalid_otp",
      expect.any(String)
    );
    expect(mocks.ok).not.toHaveBeenCalled();
  });

  it("sends email for reviewer when PLAY_REVIEW_ENABLED=false", async () => {
    await controller.requestEmailOtp(
      { body: { email: "reviewer@test.com" }, headers: {} } as never,
      { code: vi.fn().mockReturnThis(), send: vi.fn() } as never
    );

    expect(mocks.sendEmail).toHaveBeenCalled();
    expect(mocks.prisma.emailOtpChallenge.upsert).toHaveBeenCalled();
  });
});
