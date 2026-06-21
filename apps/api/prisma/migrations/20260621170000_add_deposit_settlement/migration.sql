CREATE TYPE "DepositSettlementStatus" AS ENUM (
  'none',
  'held',
  'no_show_pending',
  'payout_scheduled',
  'paid_out',
  'refund_scheduled',
  'refunded',
  'blocked'
);

CREATE TYPE "DepositResolution" AS ENUM (
  'pending',
  'completed',
  'client_no_show',
  'salon_no_show',
  'client_cancelled',
  'salon_cancelled',
  'disputed',
  'fraud_review'
);

ALTER TABLE "Booking"
  ADD COLUMN "depositSettlementStatus" "DepositSettlementStatus" NOT NULL DEFAULT 'none',
  ADD COLUMN "depositResolution" "DepositResolution" NOT NULL DEFAULT 'pending',
  ADD COLUMN "depositResolutionAt" TIMESTAMP(3),
  ADD COLUMN "depositDisputeDeadlineAt" TIMESTAMP(3),
  ADD COLUMN "depositSettledAt" TIMESTAMP(3),
  ADD COLUMN "depositSettlementNote" TEXT;

CREATE INDEX "Booking_depositSettlementStatus_startsAt_idx"
  ON "Booking"("depositSettlementStatus", "startsAt");

CREATE INDEX "Booking_depositResolution_startsAt_idx"
  ON "Booking"("depositResolution", "startsAt");
