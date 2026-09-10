/*
  Warnings:

  - Added the required column `role` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "Roles" AS ENUM ('SUPERADMIN', 'ADMIN', 'SELLER', 'CUSTOMER');

-- CreateEnum
CREATE TYPE "Status" AS ENUM ('ACTIVE', 'INACTIVE');

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "role" "Roles" NOT NULL,
ADD COLUMN     "status" "Status" NOT NULL DEFAULT 'ACTIVE',
ALTER COLUMN "fullName" DROP NOT NULL;
