-- CreateEnum
CREATE TYPE "PayoutMethod" AS ENUM ('wave_senegal', 'orange_money_senegal');

-- CreateEnum
CREATE TYPE "MerchantPayoutStatus" AS ENUM ('blocked', 'scheduled', 'creating', 'created', 'submitting', 'pending', 'succeeded', 'failed_retryable', 'failed_terminal', 'cancelled', 'manual_review');

-- AlterTable
ALTER TABLE "Salon" ADD COLUMN     "payoutMethod" "PayoutMethod",
ADD COLUMN     "payoutName" TEXT,
ADD COLUMN     "payoutPhone" TEXT,
ADD COLUMN     "payoutVerificationStatus" TEXT NOT NULL DEFAULT 'unverified',
ADD COLUMN     "payoutVerifiedAt" TIMESTAMP(3),
ADD COLUMN     "payoutVerifiedBy" TEXT;

-- CreateTable
CREATE TABLE "MerchantPayout" (
    "id" TEXT NOT NULL,
    "salonId" TEXT NOT NULL,
    "bookingId" TEXT,
    "paymentId" TEXT,
    "payoutMethod" "PayoutMethod" NOT NULL,
    "beneficiaryPhoneSnapshot" TEXT NOT NULL,
    "beneficiaryNameSnapshot" TEXT NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'XOF',
    "grossAmount" INTEGER NOT NULL,
    "platformCommissionAmount" INTEGER NOT NULL,
    "merchantPayoutAmount" INTEGER NOT NULL,
    "collectionFeeAmount" INTEGER NOT NULL DEFAULT 0,
    "payoutFeeAmount" INTEGER NOT NULL DEFAULT 0,
    "disburseToken" TEXT,
    "disburseId" TEXT NOT NULL,
    "transactionId" TEXT,
    "providerRef" TEXT,
    "providerDisburseTxId" TEXT,
    "status" "MerchantPayoutStatus" NOT NULL DEFAULT 'blocked',
    "failureCategory" TEXT,
    "failureCode" TEXT,
    "safeFailureMessage" TEXT,
    "attemptCount" INTEGER NOT NULL DEFAULT 0,
    "nextRetryTime" TIMESTAMP(3),
    "eligibleAt" TIMESTAMP(3),
    "initiatedAt" TIMESTAMP(3),
    "submittedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "failedAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "lastReconciledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 1,
    "commissionType" TEXT NOT NULL DEFAULT 'percentage',
    "commissionConfiguredValue" DOUBLE PRECISION NOT NULL DEFAULT 5.0,
    "commissionBaseAmount" INTEGER NOT NULL,
    "commissionCalculatedAmount" INTEGER NOT NULL,
    "commissionRoundingMethod" TEXT NOT NULL DEFAULT 'round',
    "policyVersion" TEXT NOT NULL DEFAULT 'v1',
    "feeResponsibilityPolicy" TEXT NOT NULL DEFAULT 'platform_absorbs_fees',

    CONSTRAINT "MerchantPayout_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LedgerEntry" (
    "id" TEXT NOT NULL,
    "salonId" TEXT NOT NULL,
    "bookingId" TEXT,
    "paymentId" TEXT,
    "payoutId" TEXT,
    "eventType" TEXT NOT NULL,
    "amountXof" INTEGER NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'XOF',
    "actorUserId" TEXT,
    "reason" TEXT,
    "metadataJson" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LedgerEntry_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "MerchantPayout_bookingId_key" ON "MerchantPayout"("bookingId");

-- CreateIndex
CREATE UNIQUE INDEX "MerchantPayout_disburseToken_key" ON "MerchantPayout"("disburseToken");

-- CreateIndex
CREATE UNIQUE INDEX "MerchantPayout_disburseId_key" ON "MerchantPayout"("disburseId");

-- CreateIndex
CREATE INDEX "MerchantPayout_status_idx" ON "MerchantPayout"("status");

-- CreateIndex
CREATE INDEX "MerchantPayout_nextRetryTime_idx" ON "MerchantPayout"("nextRetryTime");

-- CreateIndex
CREATE INDEX "MerchantPayout_salonId_idx" ON "MerchantPayout"("salonId");

-- CreateIndex
CREATE INDEX "MerchantPayout_bookingId_idx" ON "MerchantPayout"("bookingId");

-- CreateIndex
CREATE INDEX "LedgerEntry_salonId_idx" ON "LedgerEntry"("salonId");

-- CreateIndex
CREATE INDEX "LedgerEntry_bookingId_idx" ON "LedgerEntry"("bookingId");

-- CreateIndex
CREATE INDEX "LedgerEntry_createdAt_idx" ON "LedgerEntry"("createdAt");

-- AddForeignKey
ALTER TABLE "MerchantPayout" ADD CONSTRAINT "MerchantPayout_salonId_fkey" FOREIGN KEY ("salonId") REFERENCES "Salon"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MerchantPayout" ADD CONSTRAINT "MerchantPayout_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Booking"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MerchantPayout" ADD CONSTRAINT "MerchantPayout_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "Payment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LedgerEntry" ADD CONSTRAINT "LedgerEntry_salonId_fkey" FOREIGN KEY ("salonId") REFERENCES "Salon"("id") ON DELETE CASCADE ON UPDATE CASCADE;
