import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../src/generated/prisma/client.ts";
import dotenv from "dotenv";
import path from "node:path";
import { fileURLToPath } from "node:url";

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.resolve(scriptDir, "../../../.env") });

const adapter = new PrismaPg(
  process.env.DATABASE_URL ??
    "postgresql://postgres:postgres@localhost:5434/beaute_avenue?schema=public",
  { schema: "public" }
);
const prisma = new PrismaClient({ adapter });

const confirm = process.argv.includes("--confirm");

async function main() {
  console.log("=== BEAUTÉ AVENUE MERCHANT PAYOUT BACKFILL ===");
  console.log(`Mode: ${confirm ? "EXECUTE (Inserting to DB)" : "DRY-RUN (Default)"}`);
  console.log("==============================================\n");

  // Find all completed bookings with succeeded deposit payments that don't have a payout record yet
  const bookings = await prisma.booking.findMany({
    where: {
      status: "completed",
      depositPaymentStatus: "succeeded",
      payout: null // no payout record yet
    },
    include: {
      salon: true,
      payments: {
        where: { status: "succeeded" },
        take: 1
      }
    }
  });

  console.log(`Found ${bookings.length} completed booking(s) with succeeded deposits requiring a payout record.\n`);

  if (bookings.length === 0) {
    console.log("No backfill required. All completed bookings already have payout records.");
    return;
  }

  // Get current platform setting for commission
  const setting = await prisma.platformSetting.findUnique({
    where: { key: "commission_rate_percent" },
    select: { value: true }
  });
  const commissionRate = parseFloat(setting?.value ?? "5");

  let processedCount = 0;
  let skippedCount = 0;

  for (const b of bookings) {
    const payment = b.payments[0];
    if (!payment) {
      console.log(`[SKIP] Booking ${b.id}: No succeeded payment record found in Payments table.`);
      skippedCount++;
      continue;
    }

    const grossAmount = b.depositAmountXof;
    if (grossAmount <= 0) {
      console.log(`[SKIP] Booking ${b.id}: Deposit amount is zero or negative.`);
      skippedCount++;
      continue;
    }

    // Determine eligibility for automated payouts
    let eligible = true;
    let blockReason = "";

    if (!b.salon.payoutMethod || !b.salon.payoutPhone) {
      eligible = false;
      blockReason = "salon_payout_details_missing";
    } else if (b.salon.payoutVerificationStatus !== "verified") {
      eligible = false;
      blockReason = "salon_payout_details_unverified";
    } else if (b.salon.isSuspended) {
      eligible = false;
      blockReason = "salon_suspended";
    } else if (b.isUnderFraudReview) {
      eligible = false;
      blockReason = "booking_under_fraud_review";
    } else if (b.refundRequested) {
      eligible = false;
      blockReason = "refund_request_open";
    } else if (b.disputeOpen) {
      eligible = false;
      blockReason = "dispute_open";
    }

    // Calculations using integer arithmetic
    const platformCommissionAmount = Math.round((grossAmount * commissionRate) / 100);
    const merchantPayoutAmount = grossAmount - platformCommissionAmount;

    console.log(`Booking: ${b.id}`);
    console.log(`  Salon: ${b.salon.name} (${b.salon.id})`);
    console.log(`  Financials: Gross=${grossAmount} XOF | Com=${platformCommissionAmount} XOF (Rate=${commissionRate}%) | Net=${merchantPayoutAmount} XOF`);
    console.log(`  Status: ${eligible ? "Eligible (will be scheduled)" : `Blocked (Reason: ${blockReason})`}`);

    if (!confirm) {
      console.log("  [DRY-RUN] Record would be created.");
      processedCount++;
    } else {
      try {
        await prisma.$transaction(async (tx) => {
          const status = eligible ? "scheduled" : "blocked";
          const eligibleAt = b.updatedAt; // Backfill: eligible when the booking was completed/updated
          
          // Atomically create payout record
          const createdPlaceholder = `placeholder-${Date.now()}-${Math.random().toString(36).substring(7)}`;
          
          const payout = await tx.merchantPayout.create({
            data: {
              salonId: b.salonId,
              bookingId: b.id,
              paymentId: payment.id,
              payoutMethod: (b.salon.payoutMethod as any) || "wave_senegal",
              beneficiaryPhoneSnapshot: b.salon.payoutPhone || "unconfigured",
              beneficiaryNameSnapshot: b.salon.payoutName || b.salon.name,
              currency: "XOF",
              grossAmount,
              platformCommissionAmount,
              merchantPayoutAmount,
              status,
              disburseId: `merchant_payout_${createdPlaceholder}`,
              eligibleAt,
              safeFailureMessage: eligible ? null : blockReason,
              commissionType: "percentage",
              commissionConfiguredValue: commissionRate,
              commissionBaseAmount: grossAmount,
              commissionCalculatedAmount: platformCommissionAmount,
              commissionRoundingMethod: "round",
              policyVersion: "v1",
              feeResponsibilityPolicy: "platform_absorbs_fees"
            }
          });

          // Update disburseId with real payout ID
          const realDisburseId = `merchant_payout_${payout.id}`;
          await tx.merchantPayout.update({
            where: { id: payout.id },
            data: { disburseId: realDisburseId }
          });

          // Log ledger entries
          await tx.ledgerEntry.create({
            data: {
              salonId: b.salonId,
              bookingId: b.id,
              paymentId: payment.id,
              payoutId: payout.id,
              type: "client_payment_confirmed",
              amountXof: grossAmount,
              description: `Encaissement acompte RDV ${b.id}`
            }
          });

          await tx.ledgerEntry.create({
            data: {
              salonId: b.salonId,
              bookingId: b.id,
              paymentId: payment.id,
              payoutId: payout.id,
              type: "platform_commission_recognized",
              amountXof: -platformCommissionAmount,
              description: `Commission plateforme de ${commissionRate}% sur RDV ${b.id}`
            }
          });

          await tx.ledgerEntry.create({
            data: {
              salonId: b.salonId,
              bookingId: b.id,
              paymentId: payment.id,
              payoutId: payout.id,
              type: "merchant_payable_created",
              amountXof: -merchantPayoutAmount,
              description: `Obligation de règlement créée pour le RDV ${b.id}`
            }
          });
        });

        console.log("  [SUCCESS] Payout record and ledger entries created.");
        processedCount++;
      } catch (err) {
        console.error(`  [ERROR] Failed to backfill booking ${b.id}:`, err);
        skippedCount++;
      }
    }
    console.log("");
  }

  console.log("=== Backfill Run Complete ===");
  console.log(`Processed: ${processedCount}`);
  console.log(`Skipped: ${skippedCount}`);
  if (!confirm) {
    console.log("\nTo apply these changes to the database, run the script with the '--confirm' flag:");
    console.log("pnpm --filter @beauteavenue/api tsx prisma/backfill-merchant-payouts.ts --confirm");
  }
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
