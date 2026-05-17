-- CreateEnum
CREATE TYPE "MediaPurpose" AS ENUM ('salon_cover', 'salon_logo', 'salon_gallery', 'kyc_document', 'avatar');

-- CreateEnum
CREATE TYPE "MediaVisibility" AS ENUM ('incoming', 'public', 'private_kyc', 'rejected');

-- CreateEnum
CREATE TYPE "UploadStatus" AS ENUM ('pending_upload', 'upload_confirmed', 'review_pending', 'approved', 'rejected');

-- CreateEnum
CREATE TYPE "ReviewStatus" AS ENUM ('pending', 'approved', 'rejected');

-- AlterEnum
ALTER TYPE "SettlementEventType" ADD VALUE 'balance_collected';

-- AlterTable
ALTER TABLE "Job" ADD COLUMN     "bookingId" TEXT;

-- AlterTable
ALTER TABLE "MediaAsset" ADD COLUMN     "bucket" TEXT NOT NULL DEFAULT 'beauteavenu',
ADD COLUMN     "fileExt" TEXT,
ADD COLUMN     "finalObjectKey" TEXT,
ADD COLUMN     "originalFilename" TEXT,
ADD COLUMN     "purpose" "MediaPurpose",
ADD COLUMN     "rejectionReason" TEXT,
ADD COLUMN     "reviewStatus" "ReviewStatus" NOT NULL DEFAULT 'pending',
ADD COLUMN     "reviewedAt" TIMESTAMP(3),
ADD COLUMN     "reviewedBy" TEXT,
ADD COLUMN     "salonId" TEXT,
ADD COLUMN     "uploadStatus" "UploadStatus" NOT NULL DEFAULT 'pending_upload',
ADD COLUMN     "uploadedBy" TEXT,
ADD COLUMN     "visibility" "MediaVisibility" NOT NULL DEFAULT 'incoming',
ALTER COLUMN "publicUrl" DROP NOT NULL,
ALTER COLUMN "sizeBytes" SET DEFAULT 0;

-- AlterTable
ALTER TABLE "PushToken" ADD COLUMN     "appVersion" TEXT,
ADD COLUMN     "lastSeenAt" TIMESTAMP(3),
ADD COLUMN     "role" TEXT;

-- AlterTable
ALTER TABLE "Session" ADD COLUMN     "userAgentHash" TEXT;

-- CreateTable
CREATE TABLE "OtpChallenge" (
    "id" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "codeHash" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "failedAttempts" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OtpChallenge_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "OtpChallenge_phone_key" ON "OtpChallenge"("phone");

-- AddForeignKey
ALTER TABLE "MediaAsset" ADD CONSTRAINT "MediaAsset_salonId_fkey" FOREIGN KEY ("salonId") REFERENCES "Salon"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MediaAsset" ADD CONSTRAINT "MediaAsset_uploadedBy_fkey" FOREIGN KEY ("uploadedBy") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
