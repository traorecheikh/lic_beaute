import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const requireRole = vi.fn();
  const fail = vi.fn();
  const ok = vi.fn();
  const prisma = {
    clientPaymentMethod: {},
    clientBenefit: {},
    voucherRedemption: {},
    clientAddress: {},
    voucher: {},
    booking: {},
    user: {},
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

import { HttpAuthError } from "../../lib/auth/index.js";
import { ClientAccountController } from "./index.js";

describe("ClientAccountController auth failures", () => {
  const c = new ClientAccountController();
  const rep = {} as never;

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockImplementation(() => {
      throw new HttpAuthError(401, "missing_auth", "No auth");
    });
  });

  it("blocks auth-protected endpoints", async () => {
    await c.listPaymentMethods({} as never, rep);
    await c.createPaymentMethod({ body: {} } as never, rep);
    await c.updatePaymentMethod({ params: { paymentMethodId: "p1" }, body: {} } as never, rep);
    await c.deletePaymentMethod({ params: { paymentMethodId: "p1" } } as never, rep);
    await c.setDefaultPaymentMethod({ params: { paymentMethodId: "p1" } } as never, rep);
    await c.listBenefits({} as never, rep);
    await c.createBenefitForClient({ body: {} } as never, rep);
    await c.listVouchers({} as never, rep);
    await c.redeemVoucher({ body: {} } as never, rep);
    await c.createVoucherDefinition({ body: {} } as never, rep);
    await c.listAddresses({} as never, rep);
    await c.createAddress({ body: {} } as never, rep);
    await c.updateAddress({ params: { addressId: "a1" }, body: {} } as never, rep);
    await c.deleteAddress({ params: { addressId: "a1" } } as never, rep);
    await c.deleteAccount({} as never, rep);
    expect(mocks.fail).toHaveBeenCalled();
  });
});

