-- CreateEnum
CREATE TYPE "CancellationReason" AS ENUM ('too_expensive', 'missing_features', 'low_traffic', 'technical_issues', 'poor_support', 'seasonal_closure', 'switching_competitor', 'business_closure', 'payment_issues', 'other');

-- AlterTable
ALTER TABLE "Subscription" ADD COLUMN     "cancelAdditionalInfo" TEXT,
ADD COLUMN     "cancelReason" "CancellationReason",
ADD COLUMN     "cancelRequestedAt" TIMESTAMP(3);
