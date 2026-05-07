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
      delete: vi.fn()
    },
    platformSetting: {
      upsert: vi.fn(),
      findUnique: vi.fn(),
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

vi.mock("../adapters/otp.js", () => ({
  NoopOtpAdapter: class {
    async send(phone: string, code: string) {
      return mocks.otpSend(phone, code);
    }

    async verify() {
      return true;
    }
  }
}));

vi.mock("../lib/db/prisma.js", () => ({
  prisma: mocks.prisma
}));

vi.mock("../lib/http.js", () => ({
  ok: mocks.ok,
  fail: mocks.fail
}));

import { AuthController } from "./index.js";

describe("AuthController OTP persistence", () => {
  const controller = new AuthController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.prisma.user.findUnique.mockResolvedValue(null);
    mocks.prisma.platformSetting.deleteMany.mockResolvedValue({ count: 1 });
    mocks.prisma.session.create.mockResolvedValue({ id: "sess_1" });
  });

  it("persists OTP challenge in database-backed setting store", async () => {
    await controller.requestOtp({ body: { phone: "+221770000001" } } as never, {
      code: vi.fn().mockReturnThis(),
      send: vi.fn()
    } as never);

    expect(mocks.prisma.platformSetting.upsert).toHaveBeenCalled();
    const upsertArg = mocks.prisma.platformSetting.upsert.mock.calls.at(-1)![0];
    expect(upsertArg.where.key).toContain("otp:challenge:");
    const parsed = JSON.parse(upsertArg.create.value as string);
    expect(parsed).toEqual(
      expect.objectContaining({
        codeHash: expect.any(String),
        expiresAt: expect.any(Number)
      })
    );
    expect(parsed.codeHash).toHaveLength(64);
    expect(mocks.otpSend).toHaveBeenCalledTimes(1);
  });

  it("verifies OTP challenge from persistent store and clears it", async () => {
    const phone = "+221770000002";
    const code = "123456";
    const codeHash = createHash("sha256")
      .update(`${phone}:${code}:dev-access-secret`)
      .digest("hex");

    mocks.prisma.platformSetting.findUnique.mockResolvedValue({
      value: JSON.stringify({ codeHash, expiresAt: Date.now() + 60_000 })
    });
    mocks.prisma.user.findUnique.mockResolvedValue({ id: "client_1", role: "client", phone });

    await controller.verifyOtp({ body: { phone, code } } as never, {} as never);

    expect(mocks.prisma.platformSetting.deleteMany).toHaveBeenCalledTimes(1);
    expect(mocks.prisma.session.create).toHaveBeenCalledTimes(1);
    expect(mocks.ok).toHaveBeenCalledTimes(1);
    expect(mocks.fail).not.toHaveBeenCalled();
  });

  it("rejects invalid OTP when no persistent challenge exists", async () => {
    mocks.prisma.platformSetting.findUnique.mockResolvedValue(null);

    await controller.verifyOtp({ body: { phone: "+221770000003", code: "000000" } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      401,
      "invalid_otp",
      "Code OTP invalide ou expiré."
    );
  });
});
