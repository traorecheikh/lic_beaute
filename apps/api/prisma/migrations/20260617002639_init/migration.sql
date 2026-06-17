/*
  Warnings:

  - The `role` column on the `PushToken` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `depositMode` column on the `Service` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- CreateEnum
CREATE TYPE "DepositMode" AS ENUM ('none', 'fixed', 'percent');

-- AlterTable
ALTER TABLE "PushToken" DROP COLUMN "role",
ADD COLUMN     "role" "Role";

-- AlterTable
ALTER TABLE "Service" DROP COLUMN "depositMode",
ADD COLUMN     "depositMode" "DepositMode" NOT NULL DEFAULT 'none';
