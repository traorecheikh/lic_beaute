-- AlterTable
ALTER TABLE "Employee" ADD COLUMN     "avatarUrl" TEXT,
ADD COLUMN     "description" TEXT;

-- AlterTable
ALTER TABLE "Salon" ADD COLUMN     "logoUrl" TEXT;

-- AlterTable
ALTER TABLE "Service" ADD COLUMN     "category" TEXT NOT NULL DEFAULT 'general';
