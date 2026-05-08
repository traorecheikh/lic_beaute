-- Normalize legacy provider values before removing enum member.
UPDATE "Booking" SET "paymentProvider" = 'intech' WHERE "paymentProvider" = 'paytech';
UPDATE "Payment" SET "provider" = 'intech' WHERE "provider" = 'paytech';
UPDATE "Subscription" SET "billingProvider" = 'intech' WHERE "billingProvider" = 'paytech';
UPDATE "SubscriptionCharge" SET "provider" = 'intech' WHERE "provider" = 'paytech';
UPDATE "ClientPaymentMethod" SET "provider" = 'intech' WHERE "provider" = 'paytech';

-- Recreate enum without deprecated value.
ALTER TYPE "PaymentProvider" RENAME TO "PaymentProvider_old";
CREATE TYPE "PaymentProvider" AS ENUM ('intech', 'manual');

ALTER TABLE "Booking"
  ALTER COLUMN "paymentProvider" TYPE "PaymentProvider"
  USING "paymentProvider"::text::"PaymentProvider";

ALTER TABLE "Payment"
  ALTER COLUMN "provider" TYPE "PaymentProvider"
  USING "provider"::text::"PaymentProvider";

ALTER TABLE "Subscription"
  ALTER COLUMN "billingProvider" TYPE "PaymentProvider"
  USING "billingProvider"::text::"PaymentProvider";

ALTER TABLE "SubscriptionCharge"
  ALTER COLUMN "provider" TYPE "PaymentProvider"
  USING "provider"::text::"PaymentProvider";

ALTER TABLE "ClientPaymentMethod"
  ALTER COLUMN "provider" TYPE "PaymentProvider"
  USING "provider"::text::"PaymentProvider";

DROP TYPE "PaymentProvider_old";
