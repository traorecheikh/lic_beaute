-- AlterTable
ALTER TABLE "Salon" ADD COLUMN     "isPrestige" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "prestigeScore" DOUBLE PRECISION;
