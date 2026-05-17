import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const tx = {
    booking: { updateMany: vi.fn() },
    bookingEvent: { create: vi.fn() },
    job: { updateMany: vi.fn() },
    auditLog: { create: vi.fn() }
  };
  const prisma = {
    booking: { findFirst: vi.fn() },
    platformSetting: { findUnique: vi.fn() },
    $transaction: vi.fn(async (fn: any) => fn(tx))
  };
  const requireRole = vi.fn();
  const ok = vi.fn();
  const fail = vi.fn();
  return { tx, prisma, requireRole, ok, fail };
});

vi.mock("../../adapters/index.js", () => ({ getPaymentAdapter: () => ({}) }));
vi.mock("../../lib/db/prisma.js", () => ({ prisma: mocks.prisma }));
vi.mock("../../lib/http.js", () => ({ ok: mocks.ok, fail: mocks.fail }));
vi.mock("../../lib/cache.js", () => ({ invalidateCacheTags: vi.fn() }));
vi.mock("../../lib/jobs.js", () => ({ enqueueJob: vi.fn() }));
vi.mock("../../lib/auth/index.js", async (importOriginal) => {
  const actual = await importOriginal<typeof import("../../lib/auth/index.js")>();
  return { ...actual, requireRole: mocks.requireRole };
});

import { BookingController } from "./index.js";

describe("Booking cancellation race handling", () => {
  const controller = new BookingController();

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.requireRole.mockReturnValue({ sub: "client_1", role: "client" });
    mocks.prisma.platformSetting.findUnique.mockResolvedValue({ value: "24" });
    mocks.prisma.booking.findFirst.mockResolvedValue({
      id: "book_1",
      clientId: "client_1",
      status: "confirmed",
      startsAt: new Date(Date.now() + 48 * 3600_000),
      payments: []
    });
  });

  it("returns status_conflict when another request already changed booking status", async () => {
    mocks.tx.booking.updateMany.mockResolvedValue({ count: 0 });

    await controller.cancel({ params: { bookingId: "book_1" } } as never, {} as never);

    expect(mocks.fail).toHaveBeenCalledWith(
      expect.anything(),
      409,
      "status_conflict",
      "Statut modifié en parallèle. Réessayez."
    );
  });
});

