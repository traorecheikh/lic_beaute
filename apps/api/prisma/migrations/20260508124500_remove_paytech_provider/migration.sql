-- Recreate PaymentProvider enum as ('intech', 'manual').
-- Previous enum values were ('wave', 'orange_money'); 'paytech' and 'intech' were
-- never added via migrations, so UPDATE-based normalization cannot reference them.
-- The USING clause maps any unrecognised value (wave, orange_money, paytech) to 'intech'.
-- Payment.provider has a DEFAULT that references the old enum type — must be dropped
-- before the ALTER COLUMN TYPE and restored afterwards.

ALTER TYPE "PaymentProvider" RENAME TO "PaymentProvider_old";
CREATE TYPE "PaymentProvider" AS ENUM ('intech', 'manual');

ALTER TABLE "Booking"
  ALTER COLUMN "paymentProvider" TYPE "PaymentProvider"
  USING CASE
    WHEN "paymentProvider"::text = 'intech' THEN 'intech'::"PaymentProvider"
    WHEN "paymentProvider"::text = 'manual' THEN 'manual'::"PaymentProvider"
    ELSE 'intech'::"PaymentProvider"
  END;

ALTER TABLE "Payment"
  ALTER COLUMN "provider" DROP DEFAULT;

ALTER TABLE "Payment"
  ALTER COLUMN "provider" TYPE "PaymentProvider"
  USING CASE
    WHEN "provider"::text = 'intech' THEN 'intech'::"PaymentProvider"
    WHEN "provider"::text = 'manual' THEN 'manual'::"PaymentProvider"
    ELSE 'intech'::"PaymentProvider"
  END;

ALTER TABLE "Payment"
  ALTER COLUMN "provider" SET DEFAULT 'intech'::"PaymentProvider";

ALTER TABLE "Subscription"
  ALTER COLUMN "billingProvider" TYPE "PaymentProvider"
  USING CASE
    WHEN "billingProvider"::text = 'intech' THEN 'intech'::"PaymentProvider"
    WHEN "billingProvider"::text = 'manual' THEN 'manual'::"PaymentProvider"
    ELSE 'intech'::"PaymentProvider"
  END;

ALTER TABLE "SubscriptionCharge"
  ALTER COLUMN "provider" TYPE "PaymentProvider"
  USING CASE
    WHEN "provider"::text = 'intech' THEN 'intech'::"PaymentProvider"
    WHEN "provider"::text = 'manual' THEN 'manual'::"PaymentProvider"
    ELSE 'intech'::"PaymentProvider"
  END;

ALTER TABLE "ClientPaymentMethod"
  ALTER COLUMN "provider" TYPE "PaymentProvider"
  USING CASE
    WHEN "provider"::text = 'intech' THEN 'intech'::"PaymentProvider"
    WHEN "provider"::text = 'manual' THEN 'manual'::"PaymentProvider"
    ELSE 'intech'::"PaymentProvider"
  END;

DROP TYPE "PaymentProvider_old";
