import { beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => ({
  enqueueJob: vi.fn(),
  prisma: {
    job: { updateMany: vi.fn() },
    booking: {
      findUnique: vi.fn(),
      update: vi.fn()
    },
    bookingEvent: { create: vi.fn() },
    payment: { findFirst: vi.fn() }
  }
}));

vi.mock("./jobs.js", () => ({ enqueueJob: mocks.enqueueJob }));
vi.mock("./db/prisma.js", () => ({ prisma: mocks.prisma }));

import {
  finalizeBookingNoShow,
  markDepositHeld,
  noShowFinalizeAt,
  noShowGraceAt,
  scanBookingForNoShow
} from "./deposit-settlement.js";

beforeEach(() => {
  vi.clearAllMocks();
});

describe("deposit settlement helpers", () => {
  it("computes no-show timestamps from booking start", () => {
    const startsAt = new Date("2026-06-21T10:00:00.000Z");
    expect(noShowGraceAt(startsAt).toISOString()).toBe("2026-06-21T16:00:00.000Z");
    expect(noShowFinalizeAt(startsAt).toISOString()).toBe("2026-06-22T16:00:00.000Z");
  });

  it("marks a succeeded deposit as held and schedules follow-up jobs", async () => {
    mocks.prisma.booking.findUnique.mockResolvedValue({
      id: "b1",
      startsAt: new Date("2026-06-21T10:00:00.000Z"),
      depositAmountXof: 200,
      depositSettlementStatus: "none",
      depositResolution: "pending"
    });

    await markDepositHeld("b1");

    expect(mocks.prisma.booking.update).toHaveBeenCalledWith({
      where: { id: "b1" },
      data: expect.objectContaining({ depositSettlementStatus: "held" })
    });
    expect(mocks.enqueueJob).toHaveBeenCalledTimes(2);
    expect(mocks.enqueueJob).toHaveBeenNthCalledWith(1, expect.objectContaining({
      type: "deposit_resolution_scan",
      bookingId: "b1"
    }));
    expect(mocks.enqueueJob).toHaveBeenNthCalledWith(2, expect.objectContaining({
      type: "deposit_resolution_finalize",
      bookingId: "b1"
    }));
  });

  it("moves elapsed unresolved bookings to no_show_pending", async () => {
    vi.setSystemTime(new Date("2026-06-21T18:00:00.000Z"));
    mocks.prisma.booking.findUnique.mockResolvedValue({
      id: "b2",
      startsAt: new Date("2026-06-21T10:00:00.000Z"),
      status: "confirmed",
      depositAmountXof: 200,
      depositPaymentStatus: "succeeded",
      depositSettlementStatus: "held",
      depositResolution: "pending",
      disputeOpen: false,
      isUnderFraudReview: false
    });

    await scanBookingForNoShow("b2");

    expect(mocks.prisma.booking.update).toHaveBeenCalledWith({
      where: { id: "b2" },
      data: expect.objectContaining({ depositSettlementStatus: "no_show_pending" })
    });
    expect(mocks.prisma.bookingEvent.create).toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ eventType: "deposit_no_show_pending" })
    }));
    vi.useRealTimers();
  });

  it("finalizes no-show bookings and enqueues settlement", async () => {
    vi.setSystemTime(new Date("2026-06-22T16:30:00.000Z"));
    mocks.prisma.booking.findUnique
      .mockResolvedValueOnce({
        id: "b3",
        startsAt: new Date("2026-06-21T10:00:00.000Z"),
        status: "confirmed",
        depositAmountXof: 200,
        depositPaymentStatus: "succeeded",
        depositSettlementStatus: "no_show_pending",
        depositResolution: "pending",
        depositDisputeDeadlineAt: new Date("2026-06-22T16:00:00.000Z"),
        disputeOpen: false,
        isUnderFraudReview: false
      })
      .mockResolvedValueOnce({
        id: "b3",
        startsAt: new Date("2026-06-21T10:00:00.000Z"),
        status: "confirmed",
        depositAmountXof: 200,
        depositPaymentStatus: "succeeded",
        depositSettlementStatus: "no_show_pending",
        depositResolution: "pending"
      });

    await finalizeBookingNoShow("b3");

    expect(mocks.prisma.booking.update).toHaveBeenCalledWith({
      where: { id: "b3" },
      data: expect.objectContaining({
        depositResolution: "client_no_show",
        depositSettlementStatus: "payout_scheduled"
      })
    });
    expect(mocks.enqueueJob).toHaveBeenCalledWith(expect.objectContaining({
      type: "deposit_settlement",
      bookingId: "b3"
    }));
    vi.useRealTimers();
  });
});
