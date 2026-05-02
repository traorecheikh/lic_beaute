-- CreateEnum
CREATE TYPE "ClientContactChannel" AS ENUM ('phone', 'sms', 'whatsapp');

-- CreateEnum
CREATE TYPE "ClientBenefitKind" AS ENUM ('membership', 'package');

-- CreateEnum
CREATE TYPE "ClientBenefitStatus" AS ENUM ('active', 'paused', 'expired', 'exhausted', 'cancelled');

-- CreateEnum
CREATE TYPE "VoucherRedemptionStatus" AS ENUM ('active', 'used', 'expired');

-- CreateTable
CREATE TABLE "ClientProfile" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "city" TEXT,
    "avatarMediaId" TEXT,
    "avatarUrl" TEXT,
    "preferredContactChannel" "ClientContactChannel" NOT NULL DEFAULT 'phone',
    "pushOptIn" BOOLEAN NOT NULL DEFAULT true,
    "marketingOptIn" BOOLEAN NOT NULL DEFAULT false,
    "preferredLanguage" TEXT NOT NULL DEFAULT 'fr',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ClientProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ClientPaymentMethod" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "provider" "PaymentProvider" NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "label" TEXT,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "lastUsedAt" TIMESTAMP(3),
    "idempotencyKey" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ClientPaymentMethod_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ClientBenefit" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "salonId" TEXT NOT NULL,
    "kind" "ClientBenefitKind" NOT NULL,
    "name" TEXT NOT NULL,
    "status" "ClientBenefitStatus" NOT NULL DEFAULT 'active',
    "remainingUses" INTEGER,
    "expiresAt" TIMESTAMP(3),
    "billingDate" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ClientBenefit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoucherDefinition" (
    "id" TEXT NOT NULL,
    "salonId" TEXT,
    "code" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "discountLabel" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "maxRedemptions" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "VoucherDefinition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ClientVoucherRedemption" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "voucherId" TEXT NOT NULL,
    "status" "VoucherRedemptionStatus" NOT NULL DEFAULT 'active',
    "redeemedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usedAt" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ClientVoucherRedemption_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "ClientProfile_userId_key" ON "ClientProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "ClientProfile_avatarMediaId_key" ON "ClientProfile"("avatarMediaId");

-- CreateIndex
CREATE UNIQUE INDEX "ClientPaymentMethod_idempotencyKey_key" ON "ClientPaymentMethod"("idempotencyKey");

-- CreateIndex
CREATE INDEX "ClientPaymentMethod_userId_provider_idx" ON "ClientPaymentMethod"("userId", "provider");

-- CreateIndex
CREATE INDEX "ClientBenefit_userId_status_idx" ON "ClientBenefit"("userId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "VoucherDefinition_code_key" ON "VoucherDefinition"("code");

-- CreateIndex
CREATE INDEX "ClientVoucherRedemption_userId_status_idx" ON "ClientVoucherRedemption"("userId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "ClientVoucherRedemption_userId_voucherId_key" ON "ClientVoucherRedemption"("userId", "voucherId");

-- AddForeignKey
ALTER TABLE "ClientProfile" ADD CONSTRAINT "ClientProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClientPaymentMethod" ADD CONSTRAINT "ClientPaymentMethod_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClientBenefit" ADD CONSTRAINT "ClientBenefit_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClientBenefit" ADD CONSTRAINT "ClientBenefit_salonId_fkey" FOREIGN KEY ("salonId") REFERENCES "Salon"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoucherDefinition" ADD CONSTRAINT "VoucherDefinition_salonId_fkey" FOREIGN KEY ("salonId") REFERENCES "Salon"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClientVoucherRedemption" ADD CONSTRAINT "ClientVoucherRedemption_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClientVoucherRedemption" ADD CONSTRAINT "ClientVoucherRedemption_voucherId_fkey" FOREIGN KEY ("voucherId") REFERENCES "VoucherDefinition"("id") ON DELETE CASCADE ON UPDATE CASCADE;
