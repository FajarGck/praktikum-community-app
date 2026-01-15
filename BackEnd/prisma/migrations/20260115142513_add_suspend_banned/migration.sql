-- AlterTable
ALTER TABLE `modul` MODIFY `status` ENUM('pending', 'reject', 'approved', 'suspended', 'banned') NOT NULL DEFAULT 'pending';
