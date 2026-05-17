import { createHash } from "node:crypto";

import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const otpSend = vi.fn();
  const prisma = {
    user: {
      findUnique: vi.fn(),
      create: vi.fn(),
      findFirst: vi.fn(),
      update: vi.fn()
    },
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
    platformSetting: {
      findUnique: vi.fn(),
      upsert: vi.fn(),
      update: vi.fn(),
      deleteMany: vi.fn()
    },
    salon: { create: vi.fn() },
    service: { createMany: vi.fn() },
    salonHours: { createMany: vi.fn() },
    clientProfile: { upsert: vi.fn() },
    $transaction: vi.fn()
  };

  const ok = vi.fn();
  const fail = vi.fn();

  return { otpSend, prisma, ok, fail };
});

vi.mock("../../adapters/index.js", () => ({
  createOtpAdapter: () => ({
    send: (phone: string, code: string) => mocks.otpSend(phone, code),
    verify: async () => true
  }),
  getR2Adapter: () => null,
  getStorageAdapter: vi.fn()
}));

vi.mock("../../lib/db/prisma.js", () => ({
  prisma: mocks.prisma
}));

vi.mock("../../lib/http.js", () => ({
  ok: mocks.ok,
  fail: mocks.fail
}));

import { AuthController } from "./index.js";

describe("AuthController OTP persistence", () => {
  const controller = new AuthController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    mocks.prisma.otpChallenge.upsert.mockResolvedValue({});
    mocks.prisma.otpChallenge.deleteMany.mockResolvedValue({ count: 1 });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);
    mocks.prisma.platformSetting.upsert.mockResolvedValue({});
    mocks.prisma.platformSetting.update.mockResolvedValue({});
    mocks.prisma.platformSetting.deleteMany.mockResolvedValue({ count: 0 });
    mocks.prisma.session.create.mockResolvedValue({ id: "sess_1" });
    mocks.prisma.session.findMany.mockResolvedValue([]);
    mocks.prisma.session.deleteMany.mockResolvedValue({ count: 0 });
  });

  it("persists OTP challenge in OtpChallenge table", async () => {
    await controller.requestOtp({ body: { phone: "+221770000001" }, headers: {} } as never, {
      code: vi.fn().mockReturnThis(),
      send: vi.fn()
    } as never);

    expect(mocks.prisma.otpChallenge.upsert).toHaveBeenCalled();
    const upsertArg = mocks.prisma.otpChallenge.upsert.mock.calls.at(-1)![0];
    // phone is hashed (sha256) before storage
    expect(upsertArg.where.phone).toHaveLength(64);
    expect(upsertArg.create.codeHash).toHaveLength(64);
    expect(upsertArg.create.expiresAt).toBeInstanceOf(Date);
    expect(upsertArg.create.failedAttempts).toBe(0);
    expect(mocks.otpSend).toHaveBeenCalledTimes(1);
  });

  it("verifies OTP challenge from OtpChallenge table and clears it", async () => {
    const phone = "+221770000002";
    const code = "123456";
    const hashedPhone = createHash("sha256").update(phone).digest("hex");
    const codeHash = createHash("sha256")
      .update(`${phone}:${code}:dev-access-secret`)
      .digest("hex");

    mocks.prisma.otpChallenge.findUnique.mockResolvedValue({
      id: "otp_1",
      phone: hashedPhone,
      codeHash,
      expiresAt: new Date(Date.now() + 60_000),
      failedAttempts: 0,
      createdAt: new Date()
    });
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "client_1", role: "client", phone });

    await controller.verifyOtp({ body: { phone, code }, headers: { "user-agent": "test-agent/1.0" } } as never, {} as never);

    expect(mocks.prisma.otpChallenge.deleteMany).toHaveBeenCalledTimes(1);
    expect(mocks.prisma.session.create).toHaveBeenCalledTimes(1);
    expect(mocks.ok).toHaveBeenCalledTimes(1);
    expect(mocks.fail).not.toHaveBeenCalled();
  });

  it("rejects invalid OTP when no persistent challenge exists", async () => {
    mocks.prisma.otpChallenge.findUnique.mockResolvedValue(null);

    await controller.verifyOtp({ body: { phone: "+221770000003", code: "000000" }, headers: {} } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      401,
      "invalid_otp",
      "Code OTP invalide ou expiré."
    );
  });

  it("creates client account on OTP verify when user is missing", async () => {
    const phone = "+221770000004";
    const code = "123456";
    const codeHash = createHash("sha256")
      .update(`${phone}:${code}:dev-access-secret`)
      .digest("hex");
    mocks.prisma.otpChallenge.findUnique.mockResolvedValue({
      id: "otp_2",
      phone: createHash("sha256").update(phone).digest("hex"),
      codeHash,
      expiresAt: new Date(Date.now() + 60_000),
      failedAttempts: 0,
      createdAt: new Date()
    });
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    mocks.prisma.user.create.mockResolvedValue({ id: "client_new", role: "client", phone });

    await controller.verifyOtp({ body: { phone, code }, headers: { "user-agent": "test-agent/1.0" } } as never, {} as never);
    expect(mocks.prisma.user.create).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalled();
  });
});
