-- CreateTable
CREATE TABLE "PlatformServiceSuggestion" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PlatformServiceSuggestion_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "PlatformServiceSuggestion_name_key" ON "PlatformServiceSuggestion"("name");

-- CreateIndex
CREATE INDEX "PlatformServiceSuggestion_enabled_idx" ON "PlatformServiceSuggestion"("enabled");
