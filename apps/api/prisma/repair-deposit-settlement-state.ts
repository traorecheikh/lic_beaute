import path from "node:path";
import { fileURLToPath } from "node:url";

import dotenv from "dotenv";

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.resolve(scriptDir, "../../../.env") });

const dryRun = !process.argv.includes("--confirm");

const { prisma } = await import("../src/lib/db/prisma.js");
const { config } = await import("../src/config.js");
const { getPaymentAdapter } = await import("../src/adapters/index.js");
const { createPayoutForBooking } = await import("../src/lib/payout-service.js");
const { markDepositHeld, setDepositResolution } = await import("../src/lib/deposit-settlement.js");

const paymentAdapter = getPaymentAdapter(config.paymentDriver, {
  baseOrigin: config.webOrigin,
  paydunyaMasterKey: config.paydunyaMasterKey,
  paydunyaPublicKey: config.paydunyaPublicKey,
  paydunyaPrivateKey: config.paydunyaPrivateKey,
  paydunyaToken: config.paydunyaToken,
  paydunyaEnv: config.paydunyaEnv,
  paydunyaBaseUrl: config.paydunyaBaseUrl
});

function normalizeRemoteStatus(remoteStatus: string) {
  const normalized = remoteStatus.toUpperCase();
  if (normalized === "COMPLETED" || normalized === "SUCCESS" || normalized === "SUCCESSFUL") return "succeeded";
  if (normalized === "AUTHORIZED") return "authorized";
  if (normalized === "FAILED" || normalized === "ERROR" || normalized === "CANCELLED" || normalized === "CANCELED" || normalized === "EXPIRED") return "failed";
  if (normalized === "REFUNDED") return "refunded";
  return "pending";
}

async function reconcilePendingDepositPayments() {
  const payments = await prisma.payment.findMany({
    where: {
      provider: "paydunya",
      status: { in: ["pending", "authorized"] },
      webhookSignature: { not: null },
      booking: { depositAmountXof: { gt: 0 } }
    },
    include: { booking: true }
  });

  let changed = 0;
  for (const payment of payments) {
    let remoteStatus: string;
    try {
      remoteStatus = normalizeRemoteStatus(await paymentAdapter.fetchPaymentStatus!({
        providerToken: payment.webhookSignature!
      }));
    } catch (error) {
      console.log(`[WARN] payment=${payment.id} reconcile failed: ${String(error)}`);
      continue;
    }

    const effectiveStatus = payment.status === "authorized" && remoteStatus === "pending"
      ? "authorized"
      : remoteStatus;

    if (effectiveStatus === payment.status) continue;

    changed++;
    console.log(`[PAYMENT] ${payment.id} ${payment.status} -> ${effectiveStatus}`);
    if (dryRun) continue;

    await prisma.$transaction(async (tx) => {
      await tx.payment.update({
        where: { id: payment.id },
        data: { status: effectiveStatus as any }
      });
      await tx.booking.update({
        where: { id: payment.bookingId },
        data: {
          depositPaymentStatus: effectiveStatus as any,
          ...(effectiveStatus === "failed"
            ? {
                depositSettlementStatus: "none",
                depositResolution: "pending",
                depositResolutionAt: null,
                depositDisputeDeadlineAt: null,
                depositSettledAt: null
              }
            : {})
        }
      });
      if (effectiveStatus === "succeeded") {
        const existingHeld = await tx.settlementEvent.findFirst({
          where: { paymentId: payment.id, eventType: "held" }
        });
        if (!existingHeld) {
          await tx.settlementEvent.create({
            data: {
              bookingId: payment.bookingId,
              paymentId: payment.id,
              eventType: "held",
              amountXof: payment.amountXof,
              providerReference: payment.providerTxId ?? payment.webhookSignature ?? undefined
            }
          });
        }
      }
    });

    if (!dryRun && effectiveStatus === "succeeded") {
      await markDepositHeld(payment.bookingId);
    }
  }

  return changed;
}

async function resolveHistoricalBookings() {
  const bookings = await prisma.booking.findMany({
    where: {
      depositAmountXof: { gt: 0 },
      depositPaymentStatus: "succeeded",
      depositResolution: "pending"
    },
    include: {
      bookingEvents: { orderBy: { createdAt: "desc" }, take: 3 }
    }
  });

  let resolved = 0;
  let rehydrated = 0;
  for (const booking of bookings) {
    if (booking.depositSettlementStatus === "none") {
      rehydrated++;
      console.log(`[BOOKING] ${booking.id} settlement -> held`);
      if (!dryRun) {
        await markDepositHeld(booking.id);
      }
    }

    let resolution:
      | "completed"
      | "client_no_show"
      | "client_cancelled"
      | "salon_cancelled"
      | null = null;

    if (booking.status === "completed") {
      resolution = "completed";
    } else if (booking.status === "cancelled") {
      const latestEvent = booking.bookingEvents[0]?.eventType ?? "";
      resolution = latestEvent === "rejected" ? "salon_cancelled" : "client_cancelled";
    } else if (
      ["confirmed", "in_progress"].includes(booking.status) &&
      booking.startsAt.getTime() + 30 * 60 * 60 * 1000 <= Date.now() &&
      !booking.disputeOpen &&
      !booking.isUnderFraudReview
    ) {
      resolution = "client_no_show";
    }

    if (!resolution) continue;
    resolved++;
    console.log(`[BOOKING] ${booking.id} resolution -> ${resolution}`);
    if (!dryRun) {
      await setDepositResolution(booking.id, resolution, {
        note: "Backfilled by repair-deposit-settlement-state.ts"
      });
    }
  }

  return { resolved, rehydrated };
}

async function createMissingPayouts() {
  const bookings = await prisma.booking.findMany({
    where: {
      depositAmountXof: { gt: 0 },
      depositPaymentStatus: "succeeded",
      depositResolution: { in: ["completed", "client_no_show"] as any },
      payout: null
    },
    select: { id: true }
  });

  for (const booking of bookings) {
    console.log(`[PAYOUT] create missing payout for booking=${booking.id}`);
    if (!dryRun) {
      await createPayoutForBooking(booking.id);
    }
  }

  return bookings.length;
}

async function main() {
  console.log("=== deposit settlement repair ===");
  console.log(`mode: ${dryRun ? "dry-run" : "confirm"}`);

  const paymentsChanged = await reconcilePendingDepositPayments();
  const { resolved: bookingsResolved, rehydrated: bookingsRehydrated } = await resolveHistoricalBookings();
  const payoutsCreated = await createMissingPayouts();

  console.log("--- summary ---");
  console.log(`payments reconciled: ${paymentsChanged}`);
  console.log(`bookings resolved: ${bookingsResolved}`);
  console.log(`bookings rehydrated: ${bookingsRehydrated}`);
  console.log(`payouts created: ${payoutsCreated}`);
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
