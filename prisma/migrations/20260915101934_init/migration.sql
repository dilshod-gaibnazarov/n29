/*
  Warnings:

  - The primary key for the `Devices` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `id` on the `Devices` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Devices" DROP CONSTRAINT "Devices_pkey",
DROP COLUMN "id",
ADD COLUMN     "deviceId" SERIAL NOT NULL,
ADD CONSTRAINT "Devices_pkey" PRIMARY KEY ("deviceId");
