/*
  Warnings:

  - You are about to drop the column `foto_langkah` on the `langkah` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `langkah` DROP COLUMN `foto_langkah`;

-- CreateTable
CREATE TABLE `report` (
    `report_id` INTEGER NOT NULL AUTO_INCREMENT,
    `modul_id` INTEGER NOT NULL,
    `user_id` INTEGER NOT NULL,
    `reason` ENUM('spam', 'not_academic', 'harassment', 'plagiarism', 'other') NOT NULL,
    `note` TEXT NULL,
    `status` ENUM('pending', 'resolved') NOT NULL DEFAULT 'pending',
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_report_modul`(`modul_id`),
    INDEX `idx_report_status`(`status`),
    UNIQUE INDEX `ux_report_user_modul`(`user_id`, `modul_id`),
    PRIMARY KEY (`report_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `report` ADD CONSTRAINT `fk_report_modul` FOREIGN KEY (`modul_id`) REFERENCES `modul`(`modul_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `report` ADD CONSTRAINT `fk_report_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
