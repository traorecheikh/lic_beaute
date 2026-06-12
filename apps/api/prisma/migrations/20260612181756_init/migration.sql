-- AlterTable
ALTER TABLE "SettlementEvent" ADD COLUMN     "payoutAmountXof" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "platformFeeXof" INTEGER NOT NULL DEFAULT 0;
