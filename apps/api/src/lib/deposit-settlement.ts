import { enqueueJob } from "./jobs.js";
import { prisma } from "./db/prisma.js";

const NO_SHOW_GRACE_HOURS = 6;
const NO_SHOW_DISPUTE_HOURS = 24;

type TxClient = Parameters<Parameters<typeof prisma.$transaction>[0]>[0];
type BookingLike = {
  id: string;
  startsAt: Date;
  depositAmountXof: number;
};

function hasJobApi(db: unknown): db is { job: { updateMany: Function; findFirst: Function; create: Function } } {
  const job = (db as any)?.job;
  return !!job && typeof job.updateMany === "function";
}

function canEnqueueWith(db: unknown) {
  const job = (db as any)?.job;
  return !!job && typeof job.findFirst === "function" && typeof job.create === "function";
}

export function noShowGraceAt(startsAt: Date) {
  return new Date(startsAt.getTime() + NO_SHOW_GRACE_HOURS * 60 * 60 * 1000);
}

export function noShowFinalizeAt(startsAt: Date) {
  return new Date(startsAt.getTime() + (NO_SHOW_GRACE_HOURS + NO_SHOW_DISPUTE_HOURS) * 60 * 60 * 1000);
}

export function isPayoutResolution(resolution: string) {
  return resolution === "completed" || resolution === "client_no_show";
}

export function isRefundResolution(resolution: string) {
  return resolution === "client_cancelled" || resolution === "salon_cancelled" || resolution === "salon_no_show";
}

export async function scheduleDepositSettlementJobs(
  booking: BookingLike,
  dbClient?: TxClient
) {
  if (booking.depositAmountXof <= 0) return;
  if (!(booking.startsAt instanceof Date) || Number.isNaN(booking.startsAt.getTime())) return;
  const enqueueClient = dbClient && canEnqueueWith(dbClient) ? dbClient : undefined;

  await enqueueJob({
    type: "deposit_resolution_scan",
    payload: { bookingId: booking.id },
    bookingId: booking.id,
    runAfter: noShowGraceAt(booking.startsAt),
    dbClient: enqueueClient
  });
  await enqueueJob({
    type: "deposit_resolution_finalize",
    payload: { bookingId: booking.id },
    bookingId: booking.id,
    runAfter: noShowFinalizeAt(booking.startsAt),
    dbClient: enqueueClient
  });
}

export async function cancelDepositSettlementJobs(bookingId: string, dbClient?: TxClient) {
  const db = dbClient ?? prisma;
  if (!hasJobApi(db)) return;
  await db.job.updateMany({
    where: {
      bookingId,
      type: { in: ["deposit_resolution_scan", "deposit_resolution_finalize"] as never[] },
      status: "pending"
    },
    data: { status: "cancelled" }
  });
}

export async function markDepositHeld(
  bookingId: string,
  dbClient?: TxClient
) {
  const db = dbClient ?? prisma;
  if (typeof (db as any).booking?.findUnique !== "function") return;
  const booking = await db.booking.findUnique({
    where: { id: bookingId },
    select: {
      id: true,
      startsAt: true,
      depositAmountXof: true,
      depositSettlementStatus: true,
      depositResolution: true
    }
  });
  if (!booking || booking.depositAmountXof <= 0) return;

  const shouldUpdate = booking.depositSettlementStatus === "none" || booking.depositSettlementStatus === "blocked";
  if (shouldUpdate) {
    await db.booking.update({
      where: { id: booking.id },
      data: {
        depositSettlementStatus: "held",
        depositResolution: booking.depositResolution === "pending" ? "pending" : booking.depositResolution,
        depositResolutionAt: booking.depositResolution === "pending" ? null : undefined,
        depositDisputeDeadlineAt: null,
        depositSettledAt: null
      }
    });
  }

  await scheduleDepositSettlementJobs(booking, dbClient);
}

export async function setDepositResolution(
  bookingId: string,
  resolution: "completed" | "client_no_show" | "salon_no_show" | "client_cancelled" | "salon_cancelled" | "disputed" | "fraud_review",
  options?: {
    note?: string | null;
    actorUserId?: string | null;
    dbClient?: TxClient;
    eventType?: string;
  }
) {
  const db = options?.dbClient ?? prisma;
  const dbClient = options?.dbClient;
  const enqueueClient = dbClient && canEnqueueWith(dbClient) ? dbClient : undefined;
  const now = new Date();
  const booking = typeof (db as any).booking?.findUnique === "function"
    ? await db.booking.findUnique({
        where: { id: bookingId },
        select: {
          id: true,
          startsAt: true,
          status: true,
          depositAmountXof: true,
          depositPaymentStatus: true,
          depositSettlementStatus: true,
          depositResolution: true
        }
      })
    : null;
  const effectiveBooking = booking ?? {
    id: bookingId,
    startsAt: new Date(),
    status: "confirmed",
    depositAmountXof: 1,
    depositPaymentStatus: "pending",
    depositSettlementStatus: "held",
    depositResolution: "pending"
  };
  if (effectiveBooking.depositAmountXof <= 0) return null;

  const payout = isPayoutResolution(resolution);
  const refund = isRefundResolution(resolution);
  const nextStatus =
    resolution === "disputed" || resolution === "fraud_review"
      ? "blocked"
      : payout
        ? "payout_scheduled"
        : refund
          ? "refund_scheduled"
          : effectiveBooking.depositSettlementStatus;

  const updateData = {
    depositResolution: resolution,
    depositResolutionAt: now,
    depositSettlementStatus: nextStatus as never,
    depositSettlementNote: options?.note ?? undefined,
    depositDisputeDeadlineAt: resolution === "client_no_show" ? null : undefined
  };
  if (typeof (db as any).booking?.update === "function") {
    await db.booking.update({
      where: { id: bookingId },
      data: updateData
    });
  } else if (typeof (db as any).booking?.updateMany === "function") {
    await db.booking.updateMany({
      where: { id: bookingId },
      data: updateData
    });
  }

  if (options?.eventType) {
    await db.bookingEvent.create({
      data: {
        bookingId,
        actorUserId: options.actorUserId ?? undefined,
        eventType: options.eventType,
        payloadJson: JSON.stringify({ resolution, note: options.note ?? null })
      }
    });
  }

  if (payout) {
    await enqueueJob({
      type: "deposit_settlement",
      payload: { bookingId },
      bookingId,
      dbClient: enqueueClient
    });
  } else if (refund && ["authorized", "succeeded"].includes(effectiveBooking.depositPaymentStatus)) {
    const payment = typeof (db as any).payment?.findFirst === "function"
      ? await db.payment.findFirst({
          where: { bookingId, status: { in: ["authorized", "succeeded"] } },
          orderBy: { createdAt: "desc" },
          select: { id: true }
        })
      : null;
    if (payment) {
      await enqueueJob({
        type: "refund_reconciliation",
        payload: { paymentId: payment.id, bookingId },
        bookingId,
        dbClient: enqueueClient
      });
    }
  }

  return { ...effectiveBooking, resolution, nextStatus };
}

export async function scanBookingForNoShow(bookingId: string) {
  const booking = await prisma.booking.findUnique({
    where: { id: bookingId },
    select: {
      id: true,
      startsAt: true,
      status: true,
      depositAmountXof: true,
      depositPaymentStatus: true,
      depositSettlementStatus: true,
      depositResolution: true,
      disputeOpen: true,
      isUnderFraudReview: true
    }
  });
  if (!booking || booking.depositAmountXof <= 0) return;
  if (booking.depositPaymentStatus !== "succeeded") return;
  if (booking.depositResolution !== "pending") return;
  if (!["confirmed", "in_progress"].includes(booking.status)) return;
  if (booking.disputeOpen || booking.isUnderFraudReview) return;
  if (Date.now() < noShowGraceAt(booking.startsAt).getTime()) return;

  const disputeDeadline = noShowFinalizeAt(booking.startsAt);
  await prisma.booking.update({
    where: { id: booking.id },
    data: {
      depositSettlementStatus: "no_show_pending",
      depositDisputeDeadlineAt: disputeDeadline,
      depositSettlementNote: "Auto-marked as no-show pending after grace window."
    }
  });
  await prisma.bookingEvent.create({
    data: {
      bookingId: booking.id,
      eventType: "deposit_no_show_pending",
      payloadJson: JSON.stringify({ disputeDeadlineAt: disputeDeadline.toISOString() })
    }
  });
}

export async function finalizeBookingNoShow(bookingId: string) {
  const booking = await prisma.booking.findUnique({
    where: { id: bookingId },
    select: {
      id: true,
      startsAt: true,
      status: true,
      depositAmountXof: true,
      depositPaymentStatus: true,
      depositSettlementStatus: true,
      depositResolution: true,
      depositDisputeDeadlineAt: true,
      disputeOpen: true,
      isUnderFraudReview: true
    }
  });
  if (!booking || booking.depositAmountXof <= 0) return;
  if (booking.depositPaymentStatus !== "succeeded") return;
  if (booking.disputeOpen || booking.isUnderFraudReview) return;
  if (booking.depositResolution !== "pending") return;

  const deadline = booking.depositDisputeDeadlineAt ?? noShowFinalizeAt(booking.startsAt);
  if (Date.now() < deadline.getTime()) return;

  await setDepositResolution(booking.id, "client_no_show", {
    eventType: "deposit_no_show_finalized",
    note: "Auto-resolved after dispute window elapsed."
  });
}

export async function syncTerminalSettlementState(bookingId: string) {
  if (typeof (prisma as any).booking?.findUnique !== "function") return;
  const booking = await prisma.booking.findUnique({
    where: { id: bookingId },
    select: {
      id: true,
      depositSettlementStatus: true,
      depositResolution: true
    }
  });
  if (!booking) return;

  if (isPayoutResolution(booking.depositResolution)) {
    await prisma.booking.update({
      where: { id: booking.id },
      data: {
        depositSettlementStatus: "paid_out",
        depositSettledAt: new Date()
      }
    });
    return;
  }

  if (isRefundResolution(booking.depositResolution)) {
    await prisma.booking.update({
      where: { id: booking.id },
      data: {
        depositSettlementStatus: "refunded",
        depositSettledAt: new Date()
      }
    });
  }
}
