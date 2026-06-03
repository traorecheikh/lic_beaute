-- AlterEnum
ALTER TYPE "SubscriptionChargeType" ADD VALUE 'downgrade';

-- AlterTable
ALTER TABLE "Subscription" ADD COLUMN     "pendingTier" "SubscriptionTier";
