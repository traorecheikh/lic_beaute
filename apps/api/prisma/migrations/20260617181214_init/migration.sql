-- AlterTable
ALTER TABLE "Booking" ADD COLUMN     "disputeOpen" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "isUnderFraudReview" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "refundRequested" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "Salon" ADD COLUMN     "isSuspended" BOOLEAN NOT NULL DEFAULT false;
