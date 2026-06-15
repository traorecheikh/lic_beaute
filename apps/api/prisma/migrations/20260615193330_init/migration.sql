-- CreateEnum
CREATE TYPE "SearchEventType" AS ENUM ('search_submitted', 'suggestion_tapped', 'filter_applied', 'result_opened', 'module_item_opened');

-- CreateTable
CREATE TABLE "SearchEvent" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "sessionKey" TEXT NOT NULL,
    "eventType" "SearchEventType" NOT NULL,
    "query" TEXT,
    "salonId" TEXT,
    "category" TEXT,
    "city" TEXT,
    "position" INTEGER,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SearchEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SearchProfile" (
    "id" TEXT NOT NULL,
    "sessionKey" TEXT NOT NULL,
    "userId" TEXT,
    "preferredCategories" JSONB NOT NULL DEFAULT '[]',
    "preferredCities" JSONB NOT NULL DEFAULT '[]',
    "preferredNeighborhoods" JSONB NOT NULL DEFAULT '[]',
    "priceMin" INTEGER,
    "priceMax" INTEGER,
    "prestigeAffinity" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "distanceToleranceKm" DOUBLE PRECISION NOT NULL DEFAULT 5,
    "lastQueries" JSONB NOT NULL DEFAULT '[]',
    "interactionCount" INTEGER NOT NULL DEFAULT 0,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SearchProfile_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "SearchEvent_sessionKey_createdAt_idx" ON "SearchEvent"("sessionKey", "createdAt");

-- CreateIndex
CREATE INDEX "SearchEvent_userId_createdAt_idx" ON "SearchEvent"("userId", "createdAt");

-- CreateIndex
CREATE INDEX "SearchEvent_eventType_createdAt_idx" ON "SearchEvent"("eventType", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "SearchProfile_sessionKey_key" ON "SearchProfile"("sessionKey");

-- CreateIndex
CREATE INDEX "SearchProfile_userId_idx" ON "SearchProfile"("userId");
