-- AlterEnum
ALTER TYPE "PaymentProvider" ADD VALUE 'paydunya';

-- AlterEnum
ALTER TYPE "Role" ADD VALUE 'salon_manager';

-- CreateTable
CREATE TABLE "PaydunyaMethod" (
    "code" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PaydunyaMethod_pkey" PRIMARY KEY ("code")
);

-- CreateIndex
CREATE INDEX "PaydunyaMethod_country_enabled_idx" ON "PaydunyaMethod"("country", "enabled");

-- CreateIndex
CREATE INDEX "PaydunyaMethod_enabled_idx" ON "PaydunyaMethod"("enabled");

-- CreateIndex
CREATE INDEX "Booking_salonId_createdAt_idx" ON "Booking"("salonId", "createdAt");

-- CreateIndex
CREATE INDEX "Booking_salonId_status_createdAt_idx" ON "Booking"("salonId", "status", "createdAt");

-- CreateIndex
CREATE INDEX "Booking_clientId_startsAt_idx" ON "Booking"("clientId", "startsAt");

-- CreateIndex
CREATE INDEX "Salon_approvalStatus_isVisibleInMarketplace_subscriptionTie_idx" ON "Salon"("approvalStatus", "isVisibleInMarketplace", "subscriptionTier", "averageRating");

-- CreateIndex
CREATE INDEX "Salon_city_approvalStatus_isVisibleInMarketplace_idx" ON "Salon"("city", "approvalStatus", "isVisibleInMarketplace");

-- CreateIndex
CREATE INDEX "Salon_isPrestige_prestigeScore_idx" ON "Salon"("isPrestige", "prestigeScore");

-- CreateIndex
CREATE INDEX "Service_salonId_isActive_idx" ON "Service"("salonId", "isActive");
