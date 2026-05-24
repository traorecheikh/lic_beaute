/*
  Warnings:

  - The values [intech] on the enum `PaymentProvider` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "PaymentProvider_new" AS ENUM ('paydunya', 'manual');
ALTER TABLE "public"."Payment" ALTER COLUMN "provider" DROP DEFAULT;
ALTER TABLE "Booking" ALTER COLUMN "paymentProvider" TYPE "PaymentProvider_new" USING ("paymentProvider"::text::"PaymentProvider_new");
ALTER TABLE "Payment" ALTER COLUMN "provider" TYPE "PaymentProvider_new" USING ("provider"::text::"PaymentProvider_new");
ALTER TABLE "Subscription" ALTER COLUMN "billingProvider" TYPE "PaymentProvider_new" USING ("billingProvider"::text::"PaymentProvider_new");
ALTER TABLE "SubscriptionCharge" ALTER COLUMN "provider" TYPE "PaymentProvider_new" USING ("provider"::text::"PaymentProvider_new");
ALTER TABLE "ClientPaymentMethod" ALTER COLUMN "provider" TYPE "PaymentProvider_new" USING ("provider"::text::"PaymentProvider_new");
ALTER TYPE "PaymentProvider" RENAME TO "PaymentProvider_old";
ALTER TYPE "PaymentProvider_new" RENAME TO "PaymentProvider";
DROP TYPE "public"."PaymentProvider_old";
ALTER TABLE "Payment" ALTER COLUMN "provider" SET DEFAULT 'paydunya';
COMMIT;

-- AlterTable
ALTER TABLE "Payment" ALTER COLUMN "provider" SET DEFAULT 'paydunya';
