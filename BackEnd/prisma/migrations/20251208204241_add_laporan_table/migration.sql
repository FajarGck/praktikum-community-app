/*
  Warnings:

  - You are about to drop the column `foto_langkah` on the `langkah` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `langkah` DROP COLUMN `foto_langkah`;

-- CreateTable
CREATE TABLE `laporan` (
    `laporan_id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `modul_id` INTEGER NOT NULL,
    `kategori` ENUM('modul_bermasalah', 'tidak_etis', 'tidak_sesuai', 'lainnya') NOT NULL,
    `deskripsi` TEXT NOT NULL,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_laporan_user`(`user_id`),
    INDEX `idx_laporan_modul`(`modul_id`),
    PRIMARY KEY (`laporan_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `laporan` ADD CONSTRAINT `fk_laporan_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `laporan` ADD CONSTRAINT `fk_laporan_modul` FOREIGN KEY (`modul_id`) REFERENCES `modul`(`modul_id`) ON DELETE CASCADE ON UPDATE CASCADE;
