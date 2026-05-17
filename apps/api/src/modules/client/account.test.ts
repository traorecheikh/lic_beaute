import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  class HttpAuthError extends Error {
    statusCode: number;
    code: string;
    constructor(statusCode: number, code: string, message: string) {
      super(message);
      this.statusCode = statusCode;
      this.code = code;
    }
  }

  const prisma = {
    clientPaymentMethod: {
      findUnique: vi.fn(),
      count: vi.fn(),
      updateMany: vi.fn(),
      create: vi.fn(),
      findFirst: vi.fn(),
      update: vi.fn(),
      delete: vi.fn()
    },
    voucherDefinition: {
      create: vi.fn()
    },
    clientAddress: {
      findMany: vi.fn(),
      findFirst: vi.fn(),
      create: vi.fn(),
      update: vi.fn(),
      updateMany: vi.fn(),
      delete: vi.fn(),
      deleteMany: vi.fn()
    },
    user: {
      findUnique: vi.fn(),
      findFirst: vi.fn(),
      update: vi.fn()
    },
    session: {
      deleteMany: vi.fn()
    },
    pushToken: {
      deleteMany: vi.fn()
    },
    clientVoucherRedemption: {
      findUnique: vi.fn(),
      count: vi.fn(),
      create: vi.fn(),
      findMany: vi.fn()
    },
    $transaction: vi.fn()
  };

  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();

  return { prisma, requireRole, ok, fail, HttpAuthError };
});

vi.mock("../../lib/db/prisma.js", () => ({
  prisma: mocks.prisma
}));

vi.mock("../../lib/auth/index.js", () => ({
  HttpAuthError: mocks.HttpAuthError,
  requireRole: mocks.requireRole
}));

vi.mock("../../lib/http.js", () => ({
  ok: mocks.ok,
  fail: mocks.fail
}));

import { ClientAccountController } from "./index.js";

describe("ClientAccountController concurrency/error mapping", () => {
  const controller = new ClientAccountController();

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("returns 409 when idempotency key belongs to another user", async () => {
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.prisma.clientPaymentMethod.findUnique.mockResolvedValue({
      id: "pm_1",
      userId: "client_other"
    });

    await controller.createPaymentMethod({
      headers: { "x-idempotency-key": "idem-key" },
      body: { provider: "intech", phoneNumber: "770000000", label: null }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      409,
      "idempotency_key_conflict",
      "Cette clé d'idempotence est déjà utilisée."
    );
  });

  it("returns 409 voucher_code_exists on voucher code unique collision", async () => {
    mocks.requireRole.mockReturnValue({ sub: "owner_1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "salon_1" });
    mocks.prisma.voucherDefinition.create.mockRejectedValue({ code: "P2002" });

    await controller.createVoucherDefinition({
      body: {
        code: "PROMO10",
        title: "Promo",
        discountLabel: "10%",
        description: null,
        maxRedemptions: 1,
        expiresAt: null
      }
    } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      409,
      "voucher_code_exists",
      "Ce code voucher existe déjà."
    );
  });

  it("retries voucher redemption on serialization conflicts then returns retry error", async () => {
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.prisma.$transaction.mockRejectedValue({ code: "P2034" });

    await controller.redeemVoucher({
      body: { code: "PROMO10" }
    } as never, {} as never);

    expect(mocks.prisma.$transaction).toHaveBeenCalledTimes(3);
    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      409,
      "voucher_retry_conflict",
      "Conflit de concurrence, réessayez."
    );
  });

  it("lists addresses for authenticated client", async () => {
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.prisma.clientAddress.findMany.mockResolvedValue([
      { id: "addr_1", label: "Domicile", street: "123 Rue Principale", city: "Dakar", isDefault: true, createdAt: new Date(0), updatedAt: new Date(0) }
    ]);

    await controller.listAddresses({} as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), {
      items: [{ id: "addr_1", label: "Domicile", street: "123 Rue Principale", city: "Dakar", isDefault: true, createdAt: "1970-01-01T00:00:00.000Z", updatedAt: "1970-01-01T00:00:00.000Z" }]
    });
  });

  it("creates address and sets it as default", async () => {
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.prisma.$transaction.mockImplementation(async (fn: Function) => fn(mocks.prisma));
    mocks.prisma.clientAddress.create.mockResolvedValue({
      id: "addr_new", label: "Bureau", street: null, city: null, isDefault: true, createdAt: new Date(0), updatedAt: new Date(0)
    });

    await controller.createAddress({
      body: { label: "Bureau" }
    } as never, {} as never);

    expect(mocks.prisma.clientAddress.updateMany).toHaveBeenCalled();
    expect(mocks.ok).toHaveBeenCalledWith(
      expect.anything(),
      { id: "addr_new", label: "Bureau", street: null, city: null, isDefault: true, createdAt: "1970-01-01T00:00:00.000Z", updatedAt: "1970-01-01T00:00:00.000Z" },
      201
    );
  });

  it("returns 404 when updating non-existent address", async () => {
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.prisma.clientAddress.findFirst.mockResolvedValue(null);

    await controller.updateAddress({ params: { addressId: "nonexistent" }, body: {} } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "address_not_found", "Adresse introuvable.");
  });

  it("deletes address and promotes next to default", async () => {
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.prisma.clientAddress.findFirst.mockResolvedValue({ id: "addr_1", label: "Domicile", isDefault: true });
    mocks.prisma.clientAddress.delete.mockResolvedValue({});
    const findFirstResult = { id: "addr_2", label: "Bureau", isDefault: false, createdAt: new Date(), updatedAt: new Date() };
    mocks.prisma.$transaction.mockImplementation(async (fn: Function) => {
      await fn(mocks.prisma);
    });
    mocks.prisma.clientAddress.findFirst.mockResolvedValueOnce({ id: "addr_1", label: "Domicile", isDefault: true });
    mocks.prisma.clientAddress.findFirst.mockResolvedValueOnce(findFirstResult);

    await controller.deleteAddress({ params: { addressId: "addr_1" } } as never, {} as never);

    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { deleted: true });
  });

  // ─── GDPR Delete Account ─────────────────────────────────────────────────

  it("deletes account and anonymizes PII", async () => {
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.prisma.user.update.mockResolvedValue({});
    mocks.prisma.session.deleteMany.mockResolvedValue({ count: 0 });
    mocks.prisma.pushToken.deleteMany.mockResolvedValue({ count: 0 });
    mocks.prisma.clientAddress.deleteMany.mockResolvedValue({ count: 0 });
    mocks.prisma.$transaction.mockResolvedValue(undefined);

    const mockReply = { status: vi.fn().mockReturnValue({ send: vi.fn() }) };
    await controller.deleteAccount({} as never, mockReply as never);

    expect(mocks.prisma.$transaction).toHaveBeenCalledTimes(1);
    expect(mocks.prisma.user.update).toHaveBeenCalledWith({
      where: { id: "client_1" },
      data: { fullName: "Deleted User", email: "deleted+client_1@beauteavenue.local", phone: null }
    });
    expect(mocks.prisma.session.deleteMany).toHaveBeenCalledWith({ where: { userId: "client_1" } });
    expect(mocks.prisma.pushToken.deleteMany).toHaveBeenCalledWith({ where: { userId: "client_1" } });
    expect(mocks.prisma.clientAddress.deleteMany).toHaveBeenCalledWith({ where: { userId: "client_1" } });
    expect(mockReply.status).toHaveBeenCalledWith(204);
  });

  it("rejects unauthenticated account deletion", async () => {
    mocks.requireRole.mockImplementation(() => {
      throw new mocks.HttpAuthError(401, "unauthorized", "Authentification requise.");
    });

    await controller.deleteAccount({} as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      401,
      "unauthorized",
      "Authentification requise."
    );
  });
});
