-- CreateTable
CREATE TABLE `favorit` (
    `user_id` INTEGER NOT NULL,
    `modul_id` INTEGER NOT NULL,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_favorit_modul`(`modul_id`),
    PRIMARY KEY (`user_id`, `modul_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `kategori` (
    `kategori_id` INTEGER NOT NULL AUTO_INCREMENT,
    `nama_kategori` VARCHAR(100) NOT NULL,

    PRIMARY KEY (`kategori_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `komentar` (
    `komentar_id` INTEGER NOT NULL AUTO_INCREMENT,
    `modul_id` INTEGER NOT NULL,
    `user_id` INTEGER NOT NULL,
    `isi_komentar` TEXT NOT NULL,
    `parent_id` INTEGER NULL,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_komentar_modul`(`modul_id`),
    INDEX `idx_komentar_parent`(`parent_id`),
    INDEX `idx_komentar_user`(`user_id`),
    PRIMARY KEY (`komentar_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `langkah` (
    `langkah_id` INTEGER NOT NULL AUTO_INCREMENT,
    `modul_id` INTEGER NOT NULL,
    `urutan` INTEGER NOT NULL,
    `deskripsi_langkah` TEXT NOT NULL,
    `foto_langkah` VARCHAR(255) NULL,

    INDEX `idx_langkah_modul_urutan`(`modul_id`, `urutan`),
    PRIMARY KEY (`langkah_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `modul` (
    `modul_id` INTEGER NOT NULL AUTO_INCREMENT,
    `judul` VARCHAR(255) NOT NULL,
    `thumbnail_url` VARCHAR(255) NULL,
    `deskripsi` TEXT NULL,
    `kategori_id` INTEGER NOT NULL,
    `penulis_id` INTEGER NOT NULL,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `status` ENUM('pending', 'reject', 'approved') NOT NULL DEFAULT 'pending',

    INDEX `idx_modul_kategori`(`kategori_id`),
    INDEX `idx_modul_penulis`(`penulis_id`),
    PRIMARY KEY (`modul_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `users` (
    `user_id` INTEGER NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `foto_profil` VARCHAR(255) NULL,
    `created_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `role` ENUM('admin', 'user') NOT NULL DEFAULT 'user',

    UNIQUE INDEX `ux_users_username`(`username`),
    UNIQUE INDEX `ux_users_email`(`email`),
    PRIMARY KEY (`user_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `favorit` ADD CONSTRAINT `fk_favorit_modul` FOREIGN KEY (`modul_id`) REFERENCES `modul`(`modul_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `favorit` ADD CONSTRAINT `fk_favorit_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `komentar` ADD CONSTRAINT `fk_komentar_modul` FOREIGN KEY (`modul_id`) REFERENCES `modul`(`modul_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `komentar` ADD CONSTRAINT `fk_komentar_parent` FOREIGN KEY (`parent_id`) REFERENCES `komentar`(`komentar_id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `komentar` ADD CONSTRAINT `fk_komentar_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `langkah` ADD CONSTRAINT `fk_langkah_modul` FOREIGN KEY (`modul_id`) REFERENCES `modul`(`modul_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `modul` ADD CONSTRAINT `fk_modul_kategori` FOREIGN KEY (`kategori_id`) REFERENCES `kategori`(`kategori_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `modul` ADD CONSTRAINT `fk_modul_penulis` FOREIGN KEY (`penulis_id`) REFERENCES `users`(`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
