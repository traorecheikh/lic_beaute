import { beforeEach, describe, expect, it, vi } from "vitest";
import { createHash } from "node:crypto";

const mocks = vi.hoisted(() => {
  const prisma = {
    user: { findFirst: vi.fn(), findUnique: vi.fn(), create: vi.fn() },
    session: { create: vi.fn(), findMany: vi.fn(), deleteMany: vi.fn(), findFirst: vi.fn(), delete: vi.fn() },
    otpChallenge: { upsert: vi.fn(), findUnique: vi.fn(), deleteMany: vi.fn(), update: vi.fn() },
    platformSetting: { findUnique: vi.fn(), update: vi.fn(), upsert: vi.fn(), deleteMany: vi.fn() },
    mediaAsset: { findUnique: vi.fn() },
    clientProfile: { upsert: vi.fn() },
    $transaction: vi.fn()
  };
  const ok = vi.fn();
  const fail = vi.fn();
  const requireRole = vi.fn();
  const signSession = vi.fn();
  const verifyRefreshToken = vi.fn();
  const otpSend = vi.fn();
  const argon2 = { hash: vi.fn(), verify: vi.fn() };
  return { prisma, ok, fail, requireRole, signSession, verifyRefreshToken, otpSend, argon2 };
});

vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/auth/session.js", () => ({
  signSession: mocks.signSession,
  verifyRefreshToken: mocks.verifyRefreshToken
}));
vi.mock("argon2", () => ({ default: mocks.argon2 }));
vi.mock("../../adapters/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../adapters/index.js")>();
  return {
    ...actual,
    createOtpAdapter: vi.fn(() => ({ send: mocks.otpSend, verify: vi.fn() })),
    getR2Adapter: vi.fn(() => null),
    getStorageAdapter: vi.fn(() => ({}))
  };
});
vi.mock("../../lib/email.js", () => ({ sendEmail: vi.fn().mockResolvedValue(undefined) }));

import { AuthController } from "./index.js";

describe("AuthController", () => {
  const c = new AuthController();

  beforeEach(() => {
    vi.resetAllMocks();
    mocks.signSession.mockReturnValue({ accessToken: "a", refreshToken: "r", expiresInSeconds: 900 });
    mocks.prisma.session.findMany.mockResolvedValue([]);
    mocks.prisma.session.create.mockResolvedValue({});
  });

  it("register client success", async () => {
    mocks.prisma.user.findFirst.mockResolvedValue(null);
    mocks.argon2.hash.mockResolvedValue("h");
    mocks.prisma.user.create.mockResolvedValue({ id: "u1" });
    await c.register({ body: { type: "client", fullName: "Alice", email: "a@x.com", password: "Passw0rd!", phone: "771234567" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ accessToken: "a" }), 201);
  });

  it("register client validates identity requirements and duplicate account", async () => {
    await c.register({
      body: { type: "client", fullName: "Alice", password: "Passw0rd!" }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "email_or_phone_required", expect.any(String));

    mocks.prisma.user.findFirst.mockResolvedValueOnce({ id: "existing" });
    await c.register({
      body: { type: "client", fullName: "Alice", email: "a@x.com", phone: "771234567", password: "Passw0rd!" }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "already_exists", expect.any(String));
  });

  it("register client supports email-only and phone-only lookup branches", async () => {
    mocks.prisma.user.findFirst.mockResolvedValueOnce(null);
    mocks.argon2.hash.mockResolvedValueOnce("h-email");
    mocks.prisma.user.create.mockResolvedValueOnce({ id: "u-email" });
    await c.register({
      body: { type: "client", fullName: "Email Only", email: "email-only@x.com", password: "Passw0rd!" }
    } as never, {} as never);
    expect(mocks.prisma.user.findFirst).toHaveBeenLastCalledWith(expect.objectContaining({
      where: expect.objectContaining({ OR: [{ email: "email-only@x.com" }] })
    }));

    mocks.prisma.user.findFirst.mockResolvedValueOnce(null);
    mocks.argon2.hash.mockResolvedValueOnce("h-phone");
    mocks.prisma.user.create.mockResolvedValueOnce({ id: "u-phone" });
    await c.register({
      body: { type: "client", fullName: "Phone Only", phone: "770000123", password: "Passw0rd!" }
    } as never, {} as never);
    expect(mocks.prisma.user.findFirst).toHaveBeenLastCalledWith(expect.objectContaining({
      where: expect.objectContaining({ OR: [{ phone: "770000123" }] })
    }));
  });

  it("register salon owner success and duplicate branch", async () => {
    mocks.prisma.user.findFirst.mockResolvedValueOnce({ id: "existing" });
    await c.register({
      body: {
        type: "salon_owner",
        fullName: "Owner",
        email: "o@x.com",
        phone: "771111111",
        password: "Passw0rd!",
        salon: { name: "Salon A", category: "hair", city: "Dakar", address: "Rue 1", description: "Desc" },
        services: [{ name: "Coupe", durationMinutes: 30, priceXof: 10000, depositMode: "none" }],
        hours: [
          { dayOfWeek: 0, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
          { dayOfWeek: 1, isOpen: true, opensAt: "09:00", closesAt: "18:00" },
          { dayOfWeek: 2, isOpen: true, opensAt: "09:00", closesAt: "18:00" },
          { dayOfWeek: 3, isOpen: true, opensAt: "09:00", closesAt: "18:00" },
          { dayOfWeek: 4, isOpen: true, opensAt: "09:00", closesAt: "18:00" },
          { dayOfWeek: 5, isOpen: true, opensAt: "09:00", closesAt: "18:00" },
          { dayOfWeek: 6, isOpen: false, opensAt: "00:00", closesAt: "00:00" }
        ]
      },
      headers: { "user-agent": "ua-owner-2" }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "already_exists", expect.any(String));

    mocks.prisma.user.findFirst.mockResolvedValueOnce(null);
    mocks.argon2.hash.mockResolvedValueOnce("owner-h");
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({
        user: {
          create: vi.fn().mockResolvedValue({ id: "owner1" }),
          update: vi.fn().mockResolvedValue({})
        },
        salon: { create: vi.fn().mockResolvedValue({ id: "s1" }) },
        service: { createMany: vi.fn().mockResolvedValue({ count: 1 }) },
        salonHours: { createMany: vi.fn().mockResolvedValue({ count: 1 }) }
      })
    );
    mocks.prisma.session.findMany.mockResolvedValueOnce([]);
    await c.register({
      body: {
        type: "salon_owner",
        fullName: "Owner",
        email: "o2@x.com",
        phone: "772222222",
        password: "Passw0rd!",
        salon: { name: "Salon B", category: "hair", city: "Dakar", address: "Rue 2", description: "" },
        services: [{ name: "Brushing", durationMinutes: 45, priceXof: 15000, depositMode: "none" }],
        hours: [
          { dayOfWeek: 0, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
          { dayOfWeek: 1, isOpen: true, opensAt: "10:00", closesAt: "19:00" },
          { dayOfWeek: 2, isOpen: true, opensAt: "10:00", closesAt: "19:00" },
          { dayOfWeek: 3, isOpen: true, opensAt: "10:00", closesAt: "19:00" },
          { dayOfWeek: 4, isOpen: true, opensAt: "10:00", closesAt: "19:00" },
          { dayOfWeek: 5, isOpen: true, opensAt: "10:00", closesAt: "19:00" },
          { dayOfWeek: 6, isOpen: false, opensAt: "00:00", closesAt: "00:00" }
        ]
      },
      headers: { "user-agent": "ua-owner" }
    } as never, {} as never);
    expect(mocks.prisma.session.create).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ accessToken: "a" }), 201);
  });

  it("register salon owner maps null hours and missing description", async () => {
    mocks.prisma.user.findFirst.mockResolvedValueOnce(null);
    mocks.argon2.hash.mockResolvedValueOnce("owner-h2");
    const salonCreate = vi.fn().mockResolvedValue({ id: "s2" });
    const salonHoursCreateMany = vi.fn().mockResolvedValue({ count: 1 });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({
        user: { create: vi.fn().mockResolvedValue({ id: "owner2" }), update: vi.fn().mockResolvedValue({}) },
        salon: { create: salonCreate },
        service: { createMany: vi.fn().mockResolvedValue({ count: 1 }) },
        salonHours: { createMany: salonHoursCreateMany }
      })
    );
    await c.register({
      body: {
        type: "salon_owner",
        fullName: "Owner 2",
        email: "o3@x.com",
        phone: "773333333",
        password: "Passw0rd!",
        salon: { name: "Salon C", category: "hair", city: "Dakar", address: "Rue 3" },
        services: [{ name: "Color", durationMinutes: 60, priceXof: 20000, depositMode: "none" }],
        hours: [
          { dayOfWeek: 0, isOpen: false, opensAt: "00:00", closesAt: "00:00" },
          { dayOfWeek: 1, isOpen: true, opensAt: "09:00", closesAt: "18:00" },
          { dayOfWeek: 2, isOpen: true, opensAt: "09:00", closesAt: "18:00" },
          { dayOfWeek: 3, isOpen: true, opensAt: "09:00", closesAt: "18:00" },
          { dayOfWeek: 4, isOpen: true, opensAt: "09:00", closesAt: "18:00" },
          { dayOfWeek: 5, isOpen: true, opensAt: "09:00", closesAt: "18:00" },
          { dayOfWeek: 6, isOpen: false, opensAt: "00:00", closesAt: "00:00" }
        ]
      },
      headers: { "user-agent": "ua-owner-2" }
    } as never, {} as never);
    expect(salonCreate).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ description: "" })
    }));
    expect(salonHoursCreateMany).toHaveBeenCalled();
  });

  it("register salon owner normalizes undefined opens/closes to null via parsed payload", async () => {
    const contracts = await import("@beauteavenue/contracts");
    const parseSpy = vi.spyOn(contracts.registerInputSchema, "parse").mockReturnValueOnce({
      type: "salon_owner",
      fullName: "Owner Parsed",
      email: "parsed@x.com",
      phone: "774444444",
      password: "Passw0rd!",
      salon: { name: "Salon Parsed", category: "hair", city: "Dakar", address: "Rue 4", description: "" },
      services: [{ name: "Cut", durationMinutes: 30, priceXof: 9000, depositMode: "none" }],
      hours: [
        { dayOfWeek: 0, isOpen: false, opensAt: undefined as unknown as string, closesAt: undefined as unknown as string },
        { dayOfWeek: 1, isOpen: true, opensAt: undefined as unknown as string, closesAt: undefined as unknown as string },
        { dayOfWeek: 2, isOpen: true, opensAt: undefined as unknown as string, closesAt: undefined as unknown as string },
        { dayOfWeek: 3, isOpen: true, opensAt: undefined as unknown as string, closesAt: undefined as unknown as string },
        { dayOfWeek: 4, isOpen: true, opensAt: undefined as unknown as string, closesAt: undefined as unknown as string },
        { dayOfWeek: 5, isOpen: true, opensAt: undefined as unknown as string, closesAt: undefined as unknown as string },
        { dayOfWeek: 6, isOpen: false, opensAt: undefined as unknown as string, closesAt: undefined as unknown as string }
      ]
    } as never);
    mocks.prisma.user.findFirst.mockResolvedValueOnce(null);
    mocks.argon2.hash.mockResolvedValueOnce("owner-h3");
    const salonHoursCreateMany = vi.fn().mockResolvedValue({ count: 1 });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({
        user: { create: vi.fn().mockResolvedValue({ id: "owner3" }), update: vi.fn().mockResolvedValue({}) },
        salon: { create: vi.fn().mockResolvedValue({ id: "s3" }) },
        service: { createMany: vi.fn().mockResolvedValue({ count: 1 }) },
        salonHours: { createMany: salonHoursCreateMany }
      })
    );
    await c.register({ body: { any: "payload" }, headers: { "user-agent": "ua-owner-3" } } as never, {} as never);
    expect(salonHoursCreateMany).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.arrayContaining([expect.objectContaining({ opensAt: null, closesAt: null })])
    }));
    parseSpy.mockRestore();
  });

  it("login invalid credentials", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    await c.login({ body: { email: "a@x.com", password: "password123" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "invalid_credentials", expect.any(String));
  });

  it("login returns account_locked when lockout active", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", passwordHash: "h", role: "client" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({
      value: JSON.stringify({ lockedUntil: Date.now() + 10 * 60_000 })
    });
    await c.login({ body: { email: "a@x.com", password: "password123" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 423, "account_locked", expect.any(String));
  });

  it("login invalid password increments attempts", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", passwordHash: "h", role: "client" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: JSON.stringify({ attempts: 1 }) });
    mocks.argon2.verify.mockResolvedValue(false);
    await c.login({ body: { email: "a@x.com", password: "password123" } } as never, {} as never);
    expect(mocks.prisma.platformSetting.upsert).toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "invalid_credentials", expect.any(String));
  });

  it("login invalid password handles missing lockout payload", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", passwordHash: "h", role: "client" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);
    mocks.argon2.verify.mockResolvedValue(false);
    await c.login({ body: { email: "missing-lock@x.com", password: "password123" } } as never, {} as never);
    expect(mocks.prisma.platformSetting.upsert).toHaveBeenCalledWith(expect.objectContaining({
      update: { value: JSON.stringify({ attempts: 1 }) }
    }));
  });

  it("login invalid password parses existing lockout payload with missing attempts", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", passwordHash: "h", role: "client" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: JSON.stringify({}) });
    mocks.argon2.verify.mockResolvedValue(false);
    await c.login({ body: { email: "a@x.com", password: "password123" } } as never, {} as never);
    expect(mocks.prisma.platformSetting.upsert).toHaveBeenCalled();
  });

  it("login tolerates malformed lockout payload and continues auth checks", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", passwordHash: "h", role: "client" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: "{not-json" });
    mocks.argon2.verify.mockResolvedValue(false);
    await c.login({ body: { email: "a@x.com", password: "password123" } } as never, {} as never);
    expect(mocks.prisma.platformSetting.upsert).toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "invalid_credentials", expect.any(String));
  });

  it("login locks account when max attempts reached", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", passwordHash: "h", role: "client" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: JSON.stringify({ attempts: 4 }) });
    mocks.argon2.verify.mockResolvedValue(false);
    await c.login({ body: { email: "a@x.com", password: "password123" } } as never, {} as never);
    expect(mocks.prisma.platformSetting.upsert).toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 423, "account_locked", expect.any(String));
  });

  it("login success returns tokens", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", passwordHash: "h", role: "client" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);
    mocks.argon2.verify.mockResolvedValue(true);
    await c.login({ body: { email: "a@x.com", password: "password123" }, headers: { "user-agent": "ua1" } } as never, {} as never);
    expect(mocks.prisma.platformSetting.deleteMany).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ accessToken: "a" }));
  });

  it("login prunes excess sessions and stores null user-agent hash when missing", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", passwordHash: "h", role: "client" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);
    mocks.argon2.verify.mockResolvedValue(true);
    mocks.prisma.session.findMany.mockResolvedValue([
      { id: "s1" }, { id: "s2" }, { id: "s3" }, { id: "s4" }, { id: "s5" },
      { id: "s6" }, { id: "s7" }, { id: "s8" }, { id: "s9" }, { id: "s10" }
    ]);
    await c.login({ body: { email: "a@x.com", password: "password123" }, headers: {} } as never, {} as never);
    expect(mocks.prisma.session.deleteMany).toHaveBeenCalled();
    expect(mocks.prisma.session.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ userAgentHash: null })
    }));
  });

  it("requestOtp blocked for pro account", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", role: "salon_owner" });
    await c.requestOtp({ body: { phone: "771234567" } } as never, { code: vi.fn(() => ({ send: vi.fn() })) } as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "client_role_required", expect.any(String));
  });

  it("requestOtp rate-limited", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({
      value: JSON.stringify({ count: 3, windowStart: Date.now() - 1000 })
    });
    await c.requestOtp({ body: { phone: "771234567" } } as never, { code: vi.fn(() => ({ send: vi.fn() })) } as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 429, "otp_rate_limited", expect.any(String));
  });

  it("requestOtp success responds 202", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);
    const send = vi.fn();
    const code = vi.fn(() => ({ send }));
    await c.requestOtp({ body: { phone: "771234567" } } as never, { code } as never);
    expect(mocks.prisma.otpChallenge.upsert).toHaveBeenCalled();
    expect(mocks.otpSend).toHaveBeenCalled();
    expect(code).toHaveBeenCalledWith(202);
    expect(send).toHaveBeenCalled();
  });

  it("requestOtp increments in-window rate-limit counter and still sends OTP", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({
      value: JSON.stringify({ count: 1, windowStart: Date.now() - 1000 })
    });
    const send = vi.fn();
    const code = vi.fn(() => ({ send }));
    await c.requestOtp({ body: { phone: "771234567" } } as never, { code } as never);
    expect(mocks.prisma.platformSetting.update).toHaveBeenCalled();
    expect(mocks.otpSend).toHaveBeenCalled();
  });

  it("requestOtp resets expired rate-limit window and continues", async () => {
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({
      value: JSON.stringify({ count: 3, windowStart: Date.now() - 16 * 60 * 1000 })
    });
    const send = vi.fn();
    const code = vi.fn(() => ({ send }));
    await c.requestOtp({ body: { phone: "771111999" } } as never, { code } as never);
    expect(mocks.prisma.platformSetting.update).not.toHaveBeenCalled();
    expect(mocks.prisma.platformSetting.upsert).toHaveBeenCalled();
    expect(send).toHaveBeenCalled();
  });

  it("verifyOtp invalid code", async () => {
    mocks.prisma.otpChallenge.findUnique.mockResolvedValue({
      codeHash: "other", expiresAt: new Date(Date.now() + 10000), failedAttempts: 0
    });
    await c.verifyOtp({ body: { phone: "771234567", code: "000000" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "invalid_otp", expect.any(String));
  });

  it("verifyOtp rejects missing and expired challenges", async () => {
    mocks.prisma.otpChallenge.findUnique.mockResolvedValueOnce(null);
    await c.verifyOtp({ body: { phone: "771234567", code: "123456" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "invalid_otp", expect.any(String));

    mocks.prisma.otpChallenge.findUnique.mockResolvedValueOnce({
      codeHash: "h",
      expiresAt: new Date(Date.now() - 1000),
      failedAttempts: 0
    });
    await c.verifyOtp({ body: { phone: "771234567", code: "123456" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "invalid_otp", expect.any(String));
  });

  it("verifyOtp locks after max failed attempts", async () => {
    mocks.prisma.otpChallenge.findUnique.mockResolvedValue({
      codeHash: "other", expiresAt: new Date(Date.now() + 10000), failedAttempts: 4
    });
    await c.verifyOtp({ body: { phone: "771234567", code: "000000" } } as never, {} as never);
    expect(mocks.prisma.otpChallenge.deleteMany).toHaveBeenCalled();
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 429, "otp_locked", expect.any(String));
  });

  it("verifyOtp success for existing client", async () => {
    const phone = "771234567";
    const codeValue = "123456";
    const codeHash = createHash("sha256").update(`${phone}:${codeValue}:dev-access-secret`).digest("hex");
    mocks.prisma.otpChallenge.findUnique.mockResolvedValue({
      codeHash,
      expiresAt: new Date(Date.now() + 10000),
      failedAttempts: 0
    });
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", role: "client" });
    await c.verifyOtp({ body: { phone, code: codeValue }, headers: { "user-agent": "ua1" } } as never, {} as never);
    expect(mocks.prisma.otpChallenge.deleteMany).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ accessToken: "a" }));
  });

  it("verifyOtp rejects pro account", async () => {
    const phone = "771234567";
    const codeValue = "123456";
    const codeHash = createHash("sha256").update(`${phone}:${codeValue}:dev-access-secret`).digest("hex");
    mocks.prisma.otpChallenge.findUnique.mockResolvedValue({
      codeHash,
      expiresAt: new Date(Date.now() + 10000),
      failedAttempts: 0
    });
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", role: "salon_owner" });
    await c.verifyOtp({ body: { phone, code: codeValue } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "client_role_required", expect.any(String));
  });

  it("refresh rejects invalid token", async () => {
    mocks.verifyRefreshToken.mockImplementation(() => {
      throw new Error("bad");
    });
    await c.refresh({ body: { refreshToken: "bad" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "invalid_refresh_token", expect.any(String));
  });

  it("refresh rejects expired session", async () => {
    mocks.verifyRefreshToken.mockReturnValue({ sub: "u1" });
    mocks.prisma.session.findFirst.mockResolvedValue(null);
    await c.refresh({ body: { refreshToken: "r1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "session_expired", expect.any(String));
  });

  it("refresh rejects device mismatch", async () => {
    mocks.verifyRefreshToken.mockReturnValue({ sub: "u1" });
    mocks.prisma.session.findFirst.mockResolvedValue({
      id: "s1",
      expiresAt: new Date(Date.now() + 10000),
      userAgentHash: "other",
      clientType: "web"
    });
    await c.refresh({ body: { refreshToken: "r1" }, headers: { "user-agent": "ua1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "device_mismatch", expect.any(String));
  });

  it("refresh success rotates session", async () => {
    const uaHash = createHash("sha256").update("ua1").digest("hex");
    mocks.verifyRefreshToken.mockReturnValue({ sub: "u1" });
    mocks.prisma.session.findFirst.mockResolvedValue({
      id: "s1",
      expiresAt: new Date(Date.now() + 10000),
      userAgentHash: uaHash,
      clientType: "web"
    });
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", role: "client" });
    await c.refresh({ body: { refreshToken: "r1" }, headers: { "user-agent": "ua1" } } as never, {} as never);
    expect(mocks.prisma.session.delete).toHaveBeenCalled();
    expect(mocks.prisma.session.create).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("refresh success without user-agent binding skips device check", async () => {
    mocks.verifyRefreshToken.mockReturnValue({ sub: "u1" });
    mocks.prisma.session.findFirst.mockResolvedValue({
      id: "s1",
      expiresAt: new Date(Date.now() + 10000),
      userAgentHash: null,
      clientType: "web"
    });
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "u1", role: "client" });
    await c.refresh({ body: { refreshToken: "r1" }, headers: {} } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("refresh rejects when user no longer exists", async () => {
    const uaHash = createHash("sha256").update("ua1").digest("hex");
    mocks.verifyRefreshToken.mockReturnValue({ sub: "u1" });
    mocks.prisma.session.findFirst.mockResolvedValue({
      id: "s1",
      expiresAt: new Date(Date.now() + 10000),
      userAgentHash: uaHash,
      clientType: "web"
    });
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    await c.refresh({ body: { refreshToken: "r1" }, headers: { "user-agent": "ua1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "user_not_found", expect.any(String));
  });

  it("logout revokes targeted session", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    await c.logout({ body: { refreshToken: "r" } } as never, {} as never);
    expect(mocks.prisma.session.deleteMany).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { revoked: true });
  });

  it("logout still succeeds without valid refresh payload", async () => {
    mocks.requireRole.mockImplementation(() => {
      throw new Error("auth err");
    });
    await c.logout({ body: { bad: "payload" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { revoked: true });
  });

  it("me returns 404 when user missing", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    await c.me({} as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "user_not_found", expect.any(String));
  });

  it("me returns current user when found", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.user.findUnique.mockResolvedValue({
      id: "u1",
      fullName: "User",
      email: "u@example.com",
      phone: "770000000",
      role: "client",
      salonId: null,
      clientProfile: {
        city: "Dakar",
        avatarUrl: null,
        avatarMediaId: null,
        preferredContactChannel: "phone",
        pushOptIn: true,
        marketingOptIn: false,
        preferredLanguage: "fr"
      }
    });
    await c.me({} as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("me resolves avatar from media public URL and from presigned object key fallback", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.user.findUnique
      .mockResolvedValueOnce({
        id: "u1",
        fullName: "User",
        email: "u@example.com",
        phone: "770000000",
        role: "client",
        salonId: null,
        clientProfile: {
          city: "Dakar",
          avatarUrl: null,
          avatarMediaId: "m1",
          preferredContactChannel: "sms",
          pushOptIn: true,
          marketingOptIn: false,
          preferredLanguage: "fr"
        }
      })
      .mockResolvedValueOnce({
        id: "u1",
        fullName: "User",
        email: "u@example.com",
        phone: "770000000",
        role: "client",
        salonId: null,
        clientProfile: {
          city: "Dakar",
          avatarUrl: null,
          avatarMediaId: "m2",
          preferredContactChannel: "phone",
          pushOptIn: true,
          marketingOptIn: false,
          preferredLanguage: "fr"
        }
      });
    mocks.prisma.mediaAsset.findUnique
      .mockResolvedValueOnce({
        publicUrl: "https://cdn.example.com/a.jpg",
        objectKey: "a.jpg",
        finalObjectKey: null,
        ownerType: "user",
        ownerId: "u1",
        deletedAt: null
      })
      .mockResolvedValueOnce({
        publicUrl: null,
        objectKey: "private/b.jpg",
        finalObjectKey: null,
        ownerType: "user",
        ownerId: "u1",
        deletedAt: null
      });

    const adapters = await import("../../adapters/index.js");
    const r2 = { presignGet: vi.fn().mockResolvedValue("https://signed.example.com/private/b.jpg") };
    vi.mocked(adapters.getR2Adapter).mockReturnValue(r2 as never);

    await c.me({} as never, {} as never);
    await c.me({} as never, {} as never);
    expect(r2.presignGet).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("me handles deleted/non-user media and nullish defaults", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.user.findUnique
      .mockResolvedValueOnce({
        id: "u1",
        fullName: "User",
        email: null,
        phone: undefined,
        role: "client",
        salonId: null,
        clientProfile: { city: null, avatarUrl: null, avatarMediaId: "m-del", preferredContactChannel: null, pushOptIn: null, marketingOptIn: null, preferredLanguage: undefined }
      })
      .mockResolvedValueOnce({
        id: "u1",
        fullName: "User",
        email: null,
        phone: null,
        role: "client",
        salonId: null,
        clientProfile: { city: null, avatarUrl: null, avatarMediaId: "m-not-owner", preferredContactChannel: "phone", pushOptIn: true, marketingOptIn: false, preferredLanguage: "en" }
      })
      .mockResolvedValueOnce({
        id: "u1",
        fullName: "User",
        email: null,
        phone: null,
        role: "client",
        salonId: null,
        clientProfile: { city: null, avatarUrl: null, avatarMediaId: "m-no-key", preferredContactChannel: "phone", pushOptIn: true, marketingOptIn: false, preferredLanguage: "fr" }
      });
    mocks.prisma.mediaAsset.findUnique
      .mockResolvedValueOnce({ publicUrl: null, objectKey: "a.jpg", finalObjectKey: null, ownerType: "user", ownerId: "u1", deletedAt: new Date() })
      .mockResolvedValueOnce({ publicUrl: null, objectKey: "b.jpg", finalObjectKey: null, ownerType: "salon", ownerId: "s1", deletedAt: null })
      .mockResolvedValueOnce({ publicUrl: null, objectKey: null, finalObjectKey: null, ownerType: "user", ownerId: "u1", deletedAt: null });
    const adapters = await import("../../adapters/index.js");
    vi.mocked(adapters.getR2Adapter).mockReturnValue({ presignGet: vi.fn() } as never);
    await c.me({} as never, {} as never);
    await c.me({} as never, {} as never);
    await c.me({} as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("me maps internal errors", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.user.findUnique.mockRejectedValue(new Error("boom"));
    await c.me({} as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("updateMe rejects invalid avatar ownership", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({ id: "m1", deletedAt: null, ownerType: "user", ownerId: "u2" });
    await c.updateMe({ body: { avatarMediaId: "m1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "invalid_avatar", expect.any(String));
  });

  it("updateMe requires both password fields", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    await c.updateMe({ body: { currentPassword: "oldOnly" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "password_fields_required", expect.any(String));
  });

  it("updateMe handles password flows and profile upsert", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.user.findUnique
      .mockResolvedValueOnce({ passwordHash: null, email: null, fullName: "A" })
      .mockResolvedValueOnce({ passwordHash: "h", email: null, fullName: "A" });
    mocks.argon2.verify.mockResolvedValueOnce(false);

    await c.updateMe({ body: { currentPassword: "old", newPassword: "newpass123" } } as never, {} as never);
    await c.updateMe({ body: { currentPassword: "old", newPassword: "newpass123" } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "no_password_set", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 401, "invalid_current_password", expect.any(String));
  });

  it("updateMe succeeds for profile-only update", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue(null);
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) =>
      cb({
        user: { update: vi.fn() },
        session: { deleteMany: vi.fn() },
        clientProfile: { upsert: vi.fn() }
      })
    );
    mocks.prisma.user.findUnique.mockResolvedValue({
      id: "u1",
      fullName: "Updated",
      email: "u@example.com",
      phone: "770000000",
      role: "client",
      salonId: null,
      clientProfile: {
        city: "Dakar",
        avatarUrl: null,
        avatarMediaId: null,
        preferredContactChannel: "phone",
        pushOptIn: true,
        marketingOptIn: false,
        preferredLanguage: "fr"
      }
    });
    await c.updateMe({ body: { fullName: "Updated", city: "Dakar" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("updateMe with fullName only skips clientProfile upsert branch", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    const tx = {
      user: { update: vi.fn() },
      session: { deleteMany: vi.fn() },
      clientProfile: { upsert: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementation(async (cb: (txArg: any) => Promise<any>) => cb(tx));
    mocks.prisma.user.findUnique.mockResolvedValue({
      id: "u1",
      fullName: "Only Name",
      email: "u@example.com",
      phone: "770000000",
      role: "client",
      salonId: null,
      clientProfile: null
    });
    await c.updateMe({ body: { fullName: "Only Name" } } as never, {} as never);
    expect(tx.user.update).toHaveBeenCalled();
    expect(tx.clientProfile.upsert).not.toHaveBeenCalled();
  });

  it("updateMe succeeds with password rotation flow", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.user.findUnique
      .mockResolvedValueOnce({ passwordHash: "old-h", email: "u@example.com", fullName: "User A" })
      .mockResolvedValueOnce({
        id: "u1",
        fullName: "User A",
        email: "u@example.com",
        phone: "770000000",
        role: "client",
        salonId: null,
        clientProfile: {
          city: "Dakar",
          avatarUrl: null,
          avatarMediaId: null,
          preferredContactChannel: "phone",
          pushOptIn: true,
          marketingOptIn: false,
          preferredLanguage: "fr"
        }
      });
    mocks.argon2.verify.mockResolvedValue(true);
    mocks.argon2.hash.mockResolvedValue("new-h");
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) =>
      cb({
        user: { update: vi.fn() },
        session: { deleteMany: vi.fn() },
        clientProfile: { upsert: vi.fn() }
      })
    );

    await c.updateMe({ body: { currentPassword: "oldpass", newPassword: "newpass123", city: "Dakar" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("updateMe sends security email when password changed and email exists", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.user.findUnique
      .mockResolvedValueOnce({ passwordHash: "old-h", email: "u@example.com", fullName: "User A" })
      .mockResolvedValueOnce({
        id: "u1",
        fullName: "User A",
        email: "u@example.com",
        phone: "770000000",
        role: "client",
        salonId: null,
        clientProfile: null
      });
    mocks.argon2.verify.mockResolvedValue(true);
    mocks.argon2.hash.mockResolvedValue("new-h");
    const tx = {
      user: { update: vi.fn() },
      session: { deleteMany: vi.fn() },
      clientProfile: { upsert: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementation(async (cb: (txArg: any) => Promise<any>) => cb(tx));
    const email = await import("../../lib/email.js");

    await c.updateMe({ body: { currentPassword: "oldpass", newPassword: "newpass123" } } as never, {} as never);
    expect(email.sendEmail).toHaveBeenCalledWith(expect.objectContaining({
      to: "u@example.com"
    }));
  });

  it("updateMe password change skips security email when email is null", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.user.findUnique
      .mockResolvedValueOnce({ passwordHash: "old-h", email: null, fullName: "User A" })
      .mockResolvedValueOnce({
        id: "u1",
        fullName: "User A",
        email: null,
        phone: "770000000",
        role: "client",
        salonId: null,
        clientProfile: null
      });
    mocks.argon2.verify.mockResolvedValue(true);
    mocks.argon2.hash.mockResolvedValue("new-h");
    const tx = {
      user: { update: vi.fn() },
      session: { deleteMany: vi.fn() },
      clientProfile: { upsert: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementation(async (cb: (txArg: any) => Promise<any>) => cb(tx));
    const email = await import("../../lib/email.js");

    await c.updateMe({ body: { currentPassword: "oldpass", newPassword: "newpass123" } } as never, {} as never);
    expect(email.sendEmail).not.toHaveBeenCalled();
  });

  it("updateMe password change sends email with empty fullName fallback", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.user.findUnique
      .mockResolvedValueOnce({ passwordHash: "old-h", email: "u@example.com", fullName: null })
      .mockResolvedValueOnce({
        id: "u1",
        fullName: null,
        email: "u@example.com",
        phone: "770000000",
        role: "client",
        salonId: null,
        clientProfile: null
      });
    mocks.argon2.verify.mockResolvedValue(true);
    mocks.argon2.hash.mockResolvedValue("new-h");
    const tx = {
      user: { update: vi.fn() },
      session: { deleteMany: vi.fn() },
      clientProfile: { upsert: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementation(async (cb: (txArg: any) => Promise<any>) => cb(tx));
    const email = await import("../../lib/email.js");

    await c.updateMe({ body: { currentPassword: "oldpass", newPassword: "newpass123" } } as never, {} as never);
    expect(email.sendEmail).toHaveBeenCalledWith(expect.objectContaining({
      to: "u@example.com",
      text: expect.stringContaining("Bonjour ,")
    }));
  });

  it("updateMe upserts clientProfile with explicit update fields", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m1",
      deletedAt: null,
      ownerType: "user",
      ownerId: "u1",
      publicUrl: "https://cdn.example.com/a.jpg"
    });
    const tx = {
      user: { update: vi.fn() },
      session: { deleteMany: vi.fn() },
      clientProfile: { upsert: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementation(async (cb: (txArg: any) => Promise<any>) => cb(tx));
    mocks.prisma.user.findUnique.mockResolvedValue({
      id: "u1",
      fullName: "User",
      email: "u@example.com",
      phone: "770000000",
      role: "client",
      salonId: null,
      clientProfile: null
    });

    await c.updateMe({
      body: {
        avatarMediaId: "m1",
        city: "Dakar",
        preferredContactChannel: "sms",
        pushOptIn: false,
        marketingOptIn: true,
        preferredLanguage: "en"
      }
    } as never, {} as never);
    expect(tx.clientProfile.upsert).toHaveBeenCalled();
  });

  it("updateMe upserts with undefined city/avatar update branches when only toggles are provided", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    const tx = {
      user: { update: vi.fn() },
      session: { deleteMany: vi.fn() },
      clientProfile: { upsert: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementation(async (cb: (txArg: any) => Promise<any>) => cb(tx));
    mocks.prisma.user.findUnique.mockResolvedValue({
      id: "u1",
      fullName: "User",
      email: "u@example.com",
      phone: "770000000",
      role: "client",
      salonId: null,
      clientProfile: null
    });

    await c.updateMe({
      body: {
        pushOptIn: true,
        marketingOptIn: false
      }
    } as never, {} as never);
    expect(tx.clientProfile.upsert).toHaveBeenCalled();
  });

  it("updateMe sets avatarUrl null when media has no publicUrl", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.mediaAsset.findUnique.mockResolvedValue({
      id: "m2",
      deletedAt: null,
      ownerType: "user",
      ownerId: "u1",
      publicUrl: null
    });
    const tx = {
      user: { update: vi.fn() },
      session: { deleteMany: vi.fn() },
      clientProfile: { upsert: vi.fn() }
    };
    mocks.prisma.$transaction.mockImplementation(async (cb: (txArg: any) => Promise<any>) => cb(tx));
    mocks.prisma.user.findUnique.mockResolvedValue({
      id: "u1",
      fullName: "User",
      email: "u@example.com",
      phone: "770000000",
      role: "client",
      salonId: null,
      clientProfile: null
    });
    await c.updateMe({ body: { avatarMediaId: "m2" } } as never, {} as never);
    expect(tx.clientProfile.upsert).toHaveBeenCalled();
  });

  it("updateMe maps unexpected internal error", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1" });
    mocks.prisma.$transaction.mockRejectedValue(new Error("tx_fail"));
    await c.updateMe({ body: { fullName: "X" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });
});
