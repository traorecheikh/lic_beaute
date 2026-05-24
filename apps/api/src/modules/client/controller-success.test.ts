import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const prisma = {
    clientPaymentMethod: {
      findMany: vi.fn(),
      findFirst: vi.fn(),
      update: vi.fn(),
      findUnique: vi.fn(),
      updateMany: vi.fn(),
      delete: vi.fn()
    },
    clientAddress: {
      findMany: vi.fn(),
      create: vi.fn(),
      findFirst: vi.fn(),
      update: vi.fn(),
      updateMany: vi.fn(),
      delete: vi.fn()
    },
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

describe("ClientAccountController success paths", () => {
  const c = new ClientAccountController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "u1", role: "client" });
  });

  it("lists payment methods", async () => {
    mocks.prisma.clientPaymentMethod.findMany.mockResolvedValue([
      {
        id: "pm1", provider: "paydunya", phoneNumber: "771234567", label: null, isDefault: true,
        lastUsedAt: null, createdAt: new Date(), updatedAt: new Date()
      }
    ]);
    await c.listPaymentMethods({} as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });

  it("setDefaultPaymentMethod returns 404 when missing", async () => {
    mocks.prisma.clientPaymentMethod.findFirst.mockResolvedValue(null);
    await c.setDefaultPaymentMethod({ params: { paymentMethodId: "pm1" } } as never, {} as never);
    expect(mocks.fail).toHaveBeenCalledWith(expect.anything(), 404, "payment_method_not_found", expect.any(String));
  });

  it("lists and creates addresses", async () => {
    mocks.prisma.clientAddress.findMany.mockResolvedValue([
      { id: "a1", label: "Home", street: "Rue", city: "Dakar", isDefault: true, createdAt: new Date(), updatedAt: new Date() }
    ]);
    await c.listAddresses({} as never, {} as never);

    mocks.prisma.$transaction.mockImplementation(async (cb: (tx: any) => Promise<any>) => cb({
      clientAddress: { updateMany: vi.fn(), create: vi.fn().mockResolvedValue({ id: "a2", label: "Office", street: null, city: null, isDefault: true, createdAt: new Date(), updatedAt: new Date() }) }
    }));
    await c.createAddress({ body: { label: "Office" } } as never, {} as never);
    expect(mocks.ok).toHaveBeenCalled();
  });
});

