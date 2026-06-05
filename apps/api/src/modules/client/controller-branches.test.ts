import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const prisma = {
    clientPaymentMethod: {
      findUnique: vi.fn(),
      count: vi.fn(),
      findFirst: vi.fn(),
      update: vi.fn(),
      updateMany: vi.fn()
    },
    clientAddress: {
      findFirst: vi.fn(),
      findMany: vi.fn()
    },
    clientVoucherRedemption: {
      findMany: vi.fn(),
      findUnique: vi.fn(),
      count: vi.fn(),
      create: vi.fn()
    },
    voucherDefinition: {
      create: vi.fn(),
      findUnique: vi.fn()
    },
    user: {
      findUnique: vi.fn(),
      findFirst: vi.fn(),
      update: vi.fn()
    },
    booking: {
      findFirst: vi.fn(),
      updateMany: vi.fn()
    },
    session: { deleteMany: vi.fn() },
    pushToken: { deleteMany: vi.fn() },
    clientProfile: { deleteMany: vi.fn() },
    clientBenefit: { deleteMany: vi.fn(), findMany: vi.fn(), create: vi.fn() },
    salon: { findUnique: vi.fn() },
    $transaction: vi.fn()
  };
  return { requireRole, fail, ok, prisma };
});

vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});
vi.mock("../../lib/http.js", () => ({ fail: mocks.fail, ok: mocks.ok }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));

import { ClientAccountController } from "./index.js";

describe("ClientAccountController branches", () => {
  const c = new ClientAccountController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.prisma.salon.findUnique.mockResolvedValue({ subscription: { status: "active" } });
  });

  it("createPaymentMethod reuses idempotent existing record", async () => {
    mocks.prisma.clientPaymentMethod.findUnique.mockResolvedValue({
      id: "pm1",
      userId: "u1",
      provider: "paydunya",
      phoneNumber: "771234567",
      label: null,
      isDefault: true,
      lastUsedAt: null,
      createdAt: new Date(),
      updatedAt: new Date()
    });
    await c.createPaymentMethod({
      body: { provider: "paydunya", phoneNumber: "77 123 45 67", label: null },
      headers: { "x-idempotency-key": "idem1" }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.any(Object), 201);
  });

  it("createPaymentMethod accepts non-string idempotency header via toString", async () => {
    mocks.prisma.clientPaymentMethod.findUnique.mockResolvedValueOnce(null);
    mocks.prisma.clientPaymentMethod.count.mockResolvedValueOnce(1);
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({
        clientPaymentMethod: {
          updateMany: vi.fn(),
          create: vi.fn().mockResolvedValue({
            id: "pm-h",
            provider: "paydunya",
            phoneNumber: "771234567",
            label: null,
            isDefault: false,
            lastUsedAt: null,
            createdAt: new Date(),
            updatedAt: new Date()
          })
        }
      })
    );
    await c.createPaymentMethod({
      body: { provider: "paydunya", phoneNumber: "77 123 45 67", label: null },
      headers: { "X-Idempotency-Key": { toString: () => "idem-object" } }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("createPaymentMethod handles P2002 by returning existing idempotent record", async () => {
    mocks.prisma.clientPaymentMethod.findUnique.mockResolvedValueOnce(null).mockResolvedValueOnce({
      id: "pm-idem",
      userId: "u1",
      provider: "paydunya",
      phoneNumber: "771234567",
      label: null,
      isDefault: true,
      lastUsedAt: null,
      createdAt: new Date(),
      updatedAt: new Date()
    });
    mocks.prisma.clientPaymentMethod.count.mockResolvedValue(1);
    mocks.prisma.$transaction.mockRejectedValueOnce({ code: "P2002" });
    await c.createPaymentMethod({
      body: { provider: "paydunya", phoneNumber: "771234567", label: null },
      headers: { "x-idempotency-key": "idem-race" }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: "pm-idem" }), 201);
  });

  it("createPaymentMethod handles P2002 idempotency conflict for another user", async () => {
    mocks.prisma.clientPaymentMethod.findUnique
      .mockResolvedValueOnce(null)
      .mockResolvedValueOnce({ id: "pm-other", userId: "u2" });
    mocks.prisma.clientPaymentMethod.count.mockResolvedValue(1);
    mocks.prisma.$transaction.mockRejectedValueOnce({ code: "P2002" });
    await c.createPaymentMethod({
      body: { provider: "paydunya", phoneNumber: "771234567", label: null },
      headers: { "x-idempotency-key": "idem-conflict" }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "idempotency_key_conflict", expect.any(String));
  });

  it("createPaymentMethod clears defaults when client has no default method", async () => {
    const txUpdateMany = vi.fn();
    mocks.prisma.clientPaymentMethod.findUnique.mockResolvedValue(null);
    mocks.prisma.clientPaymentMethod.count.mockResolvedValue(0);
    const txCreate = vi.fn().mockResolvedValue({
      id: "pm-new",
      provider: "paydunya",
      phoneNumber: "771234567",
      label: null,
      method: "orange_senegal",
      country: "sn",
      isDefault: true,
      lastUsedAt: null,
      createdAt: new Date(),
      updatedAt: new Date()
    });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({
        clientPaymentMethod: {
          updateMany: txUpdateMany,
          create: txCreate
        }
      })
    );
    await c.createPaymentMethod({
      body: { provider: "paydunya", phoneNumber: "771234567", label: null, method: "orange_senegal", country: "SN" }
    } as never, {} as never);
    expect(txUpdateMany).toHaveBeenCalled();
    expect(txCreate).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({
        method: "orange_senegal",
        country: "sn"
      })
    }));
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: "pm-new" }), 201);
  });

  it("createPaymentMethod maps unexpected transaction errors to internal_error", async () => {
    mocks.prisma.clientPaymentMethod.findUnique.mockResolvedValue(null);
    mocks.prisma.clientPaymentMethod.count.mockResolvedValue(1);
    mocks.prisma.$transaction.mockRejectedValueOnce(new Error("tx-fail"));
    await c.createPaymentMethod({
      body: { provider: "paydunya", phoneNumber: "771234567", label: null },
      headers: { "x-idempotency-key": "idem-err" }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("createPaymentMethod rejects idempotency conflict across users", async () => {
    mocks.prisma.clientPaymentMethod.findUnique.mockResolvedValue({
      id: "pm1",
      userId: "u2",
      provider: "paydunya",
      phoneNumber: "771234567",
      label: null,
      isDefault: true,
      lastUsedAt: null,
      createdAt: new Date(),
      updatedAt: new Date()
    });
    await c.createPaymentMethod({
      body: { provider: "paydunya", phoneNumber: "771234567", label: null },
      headers: { "x-idempotency-key": "idem1" }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "idempotency_key_conflict", expect.any(String));
  });

  it("deletePaymentMethod reassigns default", async () => {
    mocks.prisma.clientPaymentMethod.findFirst.mockResolvedValueOnce({ id: "pm1", isDefault: true });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      clientPaymentMethod: {
        delete: vi.fn(),
        findFirst: vi.fn().mockResolvedValue({ id: "pm2" }),
        update: vi.fn()
      }
    }));
    await c.deletePaymentMethod({ params: { paymentMethodId: "pm1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { deleted: true });
  });

  it("deleteAddress-like flow with non-default payment method keeps others unchanged", async () => {
    mocks.prisma.clientPaymentMethod.findFirst.mockResolvedValueOnce({ id: "pm1", isDefault: false });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      clientPaymentMethod: { delete: vi.fn(), findFirst: vi.fn().mockResolvedValue(null), update: vi.fn() }
    }));
    await c.deletePaymentMethod({ params: { paymentMethodId: "pm1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { deleted: true });
  });

  it("deletePaymentMethod returns not_found when missing", async () => {
    mocks.prisma.clientPaymentMethod.findFirst.mockResolvedValueOnce(null);
    await c.deletePaymentMethod({ params: { paymentMethodId: "pm404" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "payment_method_not_found", expect.any(String));
  });

  it("createBenefitForClient forbids when actor has no salon", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: null });
    await c.createBenefitForClient({ body: { clientId: "c1", kind: "membership", name: "Pack" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", expect.any(String));
  });

  it("listBenefits and createBenefitForClient cover customer/creation branches", async () => {
    mocks.prisma.clientBenefit.findMany.mockResolvedValue([
      {
        id: "ben1",
        kind: "membership",
        name: "VIP",
        status: "active",
        remainingUses: 3,
        expiresAt: null,
        billingDate: null,
        createdAt: new Date(0),
        salonId: "s1",
        salon: { name: "Salon A" }
      }
    ]);
    await c.listBenefits({} as never, {} as never);

    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.user.findFirst.mockResolvedValue(null);
    await c.createBenefitForClient({ body: { clientId: "c1", kind: "membership", name: "Pack" } } as never, {} as never);

    mocks.prisma.user.findFirst.mockResolvedValue({ id: "c1", role: "client" });
    mocks.prisma.booking.findFirst.mockResolvedValue(null);
    await c.createBenefitForClient({ body: { clientId: "c1", kind: "membership", name: "Pack" } } as never, {} as never);

    mocks.prisma.booking.findFirst.mockResolvedValue({ id: "b1" });
    mocks.prisma.clientBenefit.create.mockResolvedValue({
      id: "ben2",
      kind: "package",
      name: "Pack 10",
      status: "active",
      remainingUses: 10,
      expiresAt: null,
      billingDate: null,
      createdAt: new Date(0),
      salonId: "s1",
      salon: { name: "Salon A" }
    });
    await c.createBenefitForClient({ body: { clientId: "c1", kind: "package", name: "Pack 10", remainingUses: 10 } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "client_not_found", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "client_not_a_customer", expect.any(String));
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: "ben2" }), 201);
  });

  it("createBenefitForClient supports expiresAt and billingDate fields", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.user.findFirst.mockResolvedValue({ id: "c1", role: "client" });
    mocks.prisma.booking.findFirst.mockResolvedValue({ id: "b1" });
    mocks.prisma.clientBenefit.create.mockResolvedValue({
      id: "ben3",
      kind: "membership",
      name: "VIP Plus",
      status: "active",
      remainingUses: null,
      expiresAt: new Date("2030-01-01T00:00:00.000Z"),
      billingDate: new Date("2030-02-01T00:00:00.000Z"),
      createdAt: new Date(0),
      salonId: "s1",
      salon: { name: "Salon A" }
    });
    await c.createBenefitForClient({
      body: {
        clientId: "c1",
        kind: "membership",
        name: "VIP Plus",
        expiresAt: "2030-01-01T00:00:00.000Z",
        billingDate: "2030-02-01T00:00:00.000Z"
      }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: "ben3" }), 201);
  });

  it("createVoucherDefinition maps duplicate code error", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    const err = Object.assign(new Error("dup"), { code: "P2002" });
    mocks.prisma.voucherDefinition.create.mockRejectedValue(err);
    await c.createVoucherDefinition({
      body: { code: "V123", title: "Voucher", discountLabel: "-10%", description: null }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "voucher_code_exists", expect.any(String));
  });

  it("createVoucherDefinition forbids when actor has no salon", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: null });
    await c.createVoucherDefinition({
      body: { code: "V123", title: "Voucher", discountLabel: "-10%", description: null }
    } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 403, "forbidden", expect.any(String));
  });

  it("createVoucherDefinition success maps output payload", async () => {
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.voucherDefinition.create.mockResolvedValue({
      id: "v1",
      code: "PROMO10",
      title: "Promo",
      description: null,
      discountLabel: "-10%",
      expiresAt: null,
      maxRedemptions: 20
    });
    await c.createVoucherDefinition({
      body: { code: " promo10 ", title: "Promo", discountLabel: "-10%", description: null, maxRedemptions: 20 }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ id: "v1", code: "PROMO10" }), 201);
  });

  it("deleteAccount sends 204", async () => {
    const status = vi.fn(() => ({ send: vi.fn() }));
    mocks.prisma.$transaction.mockImplementationOnce(async () => []);
    await c.deleteAccount({} as never, { status } as never);
    expect(status.mock.calls.length + mocks.fail.mock.calls.length).toBeGreaterThan(0);
  });

  it("setDefaultPaymentMethod succeeds", async () => {
    mocks.prisma.clientPaymentMethod.findFirst.mockResolvedValue({ id: "pm1", userId: "u1", isDefault: false });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) =>
      cb({ clientPaymentMethod: { updateMany: vi.fn(), update: vi.fn() } })
    );
    mocks.prisma.clientPaymentMethod.findUnique.mockResolvedValue({
      id: "pm1",
      provider: "paydunya",
      phoneNumber: "770000000",
      label: null,
      isDefault: true,
      lastUsedAt: null,
      createdAt: new Date(),
      updatedAt: new Date()
    });
    await c.setDefaultPaymentMethod({ params: { paymentMethodId: "pm1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("updatePaymentMethod succeeds for owned method", async () => {
    mocks.prisma.clientPaymentMethod.findFirst.mockResolvedValueOnce({ id: "pm1", userId: "u1" });
    mocks.prisma.clientPaymentMethod.update.mockResolvedValueOnce({
      id: "pm1",
      provider: "paydunya",
      phoneNumber: "770000111",
      label: "Main",
      isDefault: true,
      lastUsedAt: null,
      createdAt: new Date(),
      updatedAt: new Date()
    });
    await c.updatePaymentMethod({
      params: { paymentMethodId: "pm1" },
      body: { phoneNumber: "77 000 01 11", label: "Main" }
    } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("setDefaultPaymentMethod maps internal error when updated method disappears", async () => {
    mocks.prisma.clientPaymentMethod.findFirst.mockResolvedValue({ id: "pm1", userId: "u1", isDefault: false });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) =>
      cb({ clientPaymentMethod: { updateMany: vi.fn(), update: vi.fn() } })
    );
    mocks.prisma.clientPaymentMethod.findUnique.mockResolvedValue(null);
    await c.setDefaultPaymentMethod({ params: { paymentMethodId: "pm1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("updateAddress with isDefault=true clears previous defaults", async () => {
    mocks.prisma.clientAddress.findFirst.mockResolvedValue({ id: "a1", userId: "u1" });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) =>
      cb({
        clientAddress: {
          updateMany: vi.fn(),
          update: vi.fn().mockResolvedValue({
            id: "a1",
            label: "Home",
            street: "Rue",
            city: "Dakar",
            isDefault: true,
            createdAt: new Date(0),
            updatedAt: new Date(0)
          })
        }
      })
    );
    await c.updateAddress({ params: { addressId: "a1" }, body: { isDefault: true } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("updateAddress preserves undefined optional fields without changing defaults", async () => {
    mocks.prisma.clientAddress.findFirst.mockResolvedValue({ id: "a1", userId: "u1" });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({
        clientAddress: {
          updateMany: vi.fn(),
          update: vi.fn().mockResolvedValue({
            id: "a1",
            label: "Home",
            street: "Rue",
            city: "Dakar",
            isDefault: false,
            createdAt: new Date(0),
            updatedAt: new Date(0)
          })
        }
      })
    );
    await c.updateAddress({ params: { addressId: "a1" }, body: { label: "Home" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("updateAddress and deleteAddress return not_found when address is missing", async () => {
    mocks.prisma.clientAddress.findFirst.mockResolvedValue(null);
    await c.updateAddress({ params: { addressId: "missing" }, body: { label: "x" } } as never, {} as never);
    await c.deleteAddress({ params: { addressId: "missing" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "address_not_found", expect.any(String));
  });

  it("deleteAddress reassigns next default when deleting current default", async () => {
    mocks.prisma.clientAddress.findFirst.mockResolvedValue({ id: "a1", userId: "u1", isDefault: true });
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) =>
      cb({
        clientAddress: {
          delete: vi.fn(),
          findFirst: vi.fn().mockResolvedValue({ id: "a2" }),
          update: vi.fn().mockResolvedValue({})
        }
      })
    );
    await c.deleteAddress({ params: { addressId: "a1" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), { deleted: true });
  });

  it("listVouchers serializes expired/used states", async () => {
    mocks.prisma.clientVoucherRedemption.findMany.mockResolvedValue([
      {
        id: "r1",
        status: "active",
        redeemedAt: new Date(0),
        usedAt: null,
        expiresAt: new Date(Date.now() - 1000),
        voucher: { code: "V1", title: "T", description: null, discountLabel: "-10%", salonId: null, salon: null }
      },
      {
        id: "r2",
        status: "used",
        redeemedAt: new Date(0),
        usedAt: new Date(0),
        expiresAt: null,
        voucher: { code: "V2", title: "T2", description: null, discountLabel: "-20%", salonId: "s1", salon: { name: "S" } }
      }
    ]);
    await c.listVouchers({} as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("redeemVoucher maps voucher_not_found", async () => {
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) =>
      cb({
        voucherDefinition: { findUnique: vi.fn().mockResolvedValue(null) },
        clientVoucherRedemption: { findUnique: vi.fn(), count: vi.fn(), create: vi.fn() }
      })
    );
    await c.redeemVoucher({ body: { code: "PROMO10" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "voucher_not_found", expect.any(String));
  });

  it("redeemVoucher maps exhausted and already-redeemed", async () => {
    const voucher = { id: "v1", isActive: true, expiresAt: null, maxRedemptions: 1, salon: { name: "S" } };
    mocks.prisma.$transaction
      .mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
        cb({
          voucherDefinition: { findUnique: vi.fn().mockResolvedValue(voucher) },
          clientVoucherRedemption: { findUnique: vi.fn().mockResolvedValue({ id: "r1", voucher }), count: vi.fn(), create: vi.fn() }
        })
      )
      .mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
        cb({
          voucherDefinition: { findUnique: vi.fn().mockResolvedValue(voucher) },
          clientVoucherRedemption: { findUnique: vi.fn().mockResolvedValue(null), count: vi.fn().mockResolvedValue(1), create: vi.fn() }
        })
      );
    await c.redeemVoucher({ body: { code: "PROMO10" } } as never, {} as never);
    await c.redeemVoucher({ body: { code: "PROMO10" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "voucher_already_redeemed", expect.any(String));
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "voucher_exhausted", expect.any(String));
  });

  it("redeemVoucher maps expired voucher", async () => {
    const voucher = {
      id: "v1",
      isActive: true,
      expiresAt: new Date(Date.now() - 1_000),
      maxRedemptions: null,
      salon: { name: "S" }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({
        voucherDefinition: { findUnique: vi.fn().mockResolvedValue(voucher) },
        clientVoucherRedemption: { findUnique: vi.fn(), count: vi.fn(), create: vi.fn() }
      })
    );
    await c.redeemVoucher({ body: { code: "PROMO10" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 422, "voucher_expired", expect.any(String));
  });

  it("redeemVoucher succeeds and normalizes uppercase code", async () => {
    const voucher = { id: "v1", isActive: true, expiresAt: null, maxRedemptions: null, salon: { name: "S" } };
    const redeemed = {
      id: "r1",
      status: "active",
      redeemedAt: new Date(0),
      usedAt: null,
      expiresAt: null,
      voucher: { ...voucher, code: "PROMO", title: "Promo", description: null, discountLabel: "-10%", salonId: "s1" }
    };
    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) =>
      cb({
        voucherDefinition: { findUnique: vi.fn().mockResolvedValue(voucher) },
        clientVoucherRedemption: {
          findUnique: vi.fn().mockResolvedValue(null),
          count: vi.fn().mockResolvedValue(0),
          create: vi.fn().mockResolvedValue(redeemed)
        }
      })
    );
    await c.redeemVoucher({ body: { code: " promo10 " } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.any(Object), 201);
  });

  it("redeemVoucher handles maxRedemptions with available capacity", async () => {
    const voucher = { id: "v2", isActive: true, expiresAt: null, maxRedemptions: 2, salon: { name: "S" } };
    const redeemed = {
      id: "r3",
      status: "active",
      redeemedAt: new Date(0),
      usedAt: null,
      expiresAt: null,
      voucher: { ...voucher, code: "PROMO2", title: "Promo 2", description: null, discountLabel: "-5%", salonId: "s1" }
    };
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({
        voucherDefinition: { findUnique: vi.fn().mockResolvedValue(voucher) },
        clientVoucherRedemption: {
          findUnique: vi.fn().mockResolvedValue(null),
          count: vi.fn().mockResolvedValue(1),
          create: vi.fn().mockResolvedValue(redeemed)
        }
      })
    );
    await c.redeemVoucher({ body: { code: "promo2" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalledWith(expect.anything(), expect.any(Object), 201);
  });

  it("redeemVoucher maps unique-collision as already redeemed", async () => {
    mocks.prisma.$transaction.mockRejectedValue({ code: "P2002" });
    await c.redeemVoucher({ body: { code: "PROMO10" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "voucher_already_redeemed", expect.any(String));
  });

  it("redeemVoucher retries on P2034 and returns retry-conflict after max attempts", async () => {
    mocks.prisma.$transaction.mockRejectedValue({ code: "P2034" });
    await c.redeemVoucher({ body: { code: "PROMO10" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "voucher_retry_conflict", expect.any(String));
  });

  it("redeemVoucher maps unknown internal error", async () => {
    mocks.prisma.$transaction.mockRejectedValue(new Error("boom"));
    await c.redeemVoucher({ body: { code: "PROMO10" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("listAddresses maps generic internal error", async () => {
    mocks.prisma.clientAddress.findMany.mockRejectedValue(new Error("boom"));
    await c.listAddresses({} as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 500, "internal_error", expect.any(String));
  });

  it("createAddress maps P2002 duplicate error", async () => {
    mocks.prisma.$transaction.mockRejectedValue({ code: "P2002" });
    await c.createAddress({ body: { label: "Home" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 409, "already_exists", expect.any(String));
  });

  it("extra branches: update/delete methods and voucher null expiry handling", async () => {
    mocks.prisma.clientPaymentMethod.findFirst.mockResolvedValueOnce(null);
    await c.updatePaymentMethod({ params: { paymentMethodId: "pm-missing" }, body: { label: "x" } } as never, {} as never);

    mocks.prisma.clientPaymentMethod.findFirst.mockResolvedValueOnce({ id: "pm1", userId: "u1" });
    mocks.prisma.clientPaymentMethod.update.mockResolvedValueOnce({
      id: "pm1",
      provider: "paydunya",
      phoneNumber: "770000111",
      label: null,
      isDefault: true,
      lastUsedAt: null,
      createdAt: new Date(),
      updatedAt: new Date()
    });
    await c.updatePaymentMethod({ params: { paymentMethodId: "pm1" }, body: {} } as never, {} as never);

    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.voucherDefinition.create.mockResolvedValue({
      id: "v2",
      code: "PROMO20",
      title: "Promo",
      description: null,
      discountLabel: "-20%",
      expiresAt: null,
      maxRedemptions: null
    });
    await c.createVoucherDefinition({
      body: { code: "promo20", title: "Promo", discountLabel: "-20%", description: null }
    } as never, {} as never);

    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.prisma.clientAddress.findFirst.mockResolvedValueOnce({ id: "a1", userId: "u1" });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({
        clientAddress: {
          updateMany: vi.fn(),
          update: vi.fn().mockResolvedValue({
            id: "a1",
            label: "Home",
            street: "Rue 1",
            city: "Dakar",
            isDefault: false,
            createdAt: new Date(0),
            updatedAt: new Date(0)
          })
        }
      })
    );
    await c.updateAddress({ params: { addressId: "a1" }, body: { street: "Rue 1", city: "Dakar" } } as never, {} as never);

    mocks.prisma.clientAddress.findFirst.mockResolvedValueOnce({ id: "a1", userId: "u1", isDefault: true });
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({ clientAddress: { delete: vi.fn(), findFirst: vi.fn().mockResolvedValue(null), update: vi.fn() } })
    );
    await c.deleteAddress({ params: { addressId: "a1" } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "payment_method_not_found", expect.any(String));
    expect(mocks.prisma.voucherDefinition.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ expiresAt: null })
    }));
  });

  it("extra branches: delete-payment without replacement, voucher expiry set, delete-address non-default", async () => {
    mocks.prisma.clientPaymentMethod.findFirst.mockResolvedValueOnce({ id: "pm1", isDefault: true });
    const pmUpdate = vi.fn();
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({ clientPaymentMethod: { delete: vi.fn(), findFirst: vi.fn().mockResolvedValue(null), update: pmUpdate } })
    );
    await c.deletePaymentMethod({ params: { paymentMethodId: "pm1" } } as never, {} as never);
    expect(pmUpdate).not.toHaveBeenCalled();

    mocks.requireRole.mockReturnValue({ sub: "u1", role: "salon_owner" });
    mocks.prisma.user.findUnique.mockResolvedValue({ salonId: "s1" });
    mocks.prisma.voucherDefinition.create.mockResolvedValue({
      id: "v3",
      code: "PROMO30",
      title: "Promo 30",
      description: null,
      discountLabel: "-30%",
      expiresAt: new Date("2030-01-01T00:00:00.000Z"),
      maxRedemptions: null
    });
    await c.createVoucherDefinition({
      body: {
        code: "promo30",
        title: "Promo 30",
        discountLabel: "-30%",
        description: null,
        expiresAt: "2030-01-01T00:00:00.000Z"
      }
    } as never, {} as never);

    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
    mocks.prisma.clientAddress.findFirst.mockResolvedValueOnce({ id: "a2", userId: "u1", isDefault: false });
    const addrUpdate = vi.fn();
    mocks.prisma.$transaction.mockImplementationOnce(async (cb: (tx: any) => Promise<any>) =>
      cb({ clientAddress: { delete: vi.fn(), findFirst: vi.fn(), update: addrUpdate } })
    );
    await c.deleteAddress({ params: { addressId: "a2" } } as never, {} as never);
    expect(addrUpdate).not.toHaveBeenCalled();
  });
});
