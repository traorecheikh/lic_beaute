-- Add batch-level payout execution while keeping MerchantPayout as the per-booking trace record.

CREATE TABLE "MerchantPayoutBatch" (
    "id" TEXT NOT NULL,
    "salonId" TEXT NOT NULL,
    "payoutMethod" "PayoutMethod" NOT NULL,
    "beneficiaryPhoneSnapshot" TEXT NOT NULL,
    "beneficiaryNameSnapshot" TEXT NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'XOF',
    "grossAmount" INTEGER NOT NULL,
    "platformCommissionAmount" INTEGER NOT NULL,
    "merchantPayoutAmount" INTEGER NOT NULL,
    "itemCount" INTEGER NOT NULL,
    "cadence" TEXT NOT NULL,
    "scheduledFor" TIMESTAMP(3) NOT NULL,
    "windowStartAt" TIMESTAMP(3),
    "windowEndAt" TIMESTAMP(3),
    "disburseToken" TEXT,
    "disburseId" TEXT NOT NULL,
    "transactionId" TEXT,
    "providerRef" TEXT,
    "providerDisburseTxId" TEXT,
    "status" "MerchantPayoutStatus" NOT NULL DEFAULT 'scheduled',
    "failureCategory" TEXT,
    "failureCode" TEXT,
    "safeFailureMessage" TEXT,
    "attemptCount" INTEGER NOT NULL DEFAULT 0,
    "nextRetryTime" TIMESTAMP(3),
    "initiatedAt" TIMESTAMP(3),
    "submittedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "failedAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "lastReconciledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "MerchantPayoutBatch_pkey" PRIMARY KEY ("id")
);

ALTER TABLE "MerchantPayout"
    ADD COLUMN "batchId" TEXT,
    ADD COLUMN "releaseBatchAt" TIMESTAMP(3);

DROP INDEX IF EXISTS "MerchantPayout_disburseToken_key";
DROP INDEX IF EXISTS "MerchantPayout_disburseId_key";

CREATE UNIQUE INDEX "MerchantPayoutBatch_disburseToken_key" ON "MerchantPayoutBatch"("disburseToken");
CREATE UNIQUE INDEX "MerchantPayoutBatch_disburseId_key" ON "MerchantPayoutBatch"("disburseId");
CREATE UNIQUE INDEX "MerchantPayoutBatch_salonId_scheduledFor_payoutMethod_beneficiaryPhoneSnapshot_key"
ON "MerchantPayoutBatch"("salonId", "scheduledFor", "payoutMethod", "beneficiaryPhoneSnapshot");

CREATE INDEX "MerchantPayoutBatch_status_idx" ON "MerchantPayoutBatch"("status");
CREATE INDEX "MerchantPayoutBatch_nextRetryTime_idx" ON "MerchantPayoutBatch"("nextRetryTime");
CREATE INDEX "MerchantPayoutBatch_scheduledFor_idx" ON "MerchantPayoutBatch"("scheduledFor");
CREATE INDEX "MerchantPayoutBatch_salonId_idx" ON "MerchantPayoutBatch"("salonId");
CREATE INDEX "MerchantPayout_batchId_idx" ON "MerchantPayout"("batchId");
CREATE INDEX "MerchantPayout_releaseBatchAt_idx" ON "MerchantPayout"("releaseBatchAt");

ALTER TABLE "MerchantPayoutBatch"
    ADD CONSTRAINT "MerchantPayoutBatch_salonId_fkey"
    FOREIGN KEY ("salonId") REFERENCES "Salon"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "MerchantPayout"
    ADD CONSTRAINT "MerchantPayout_batchId_fkey"
    FOREIGN KEY ("batchId") REFERENCES "MerchantPayoutBatch"("id") ON DELETE SET NULL ON UPDATE CASCADE;
