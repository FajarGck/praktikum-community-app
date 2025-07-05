-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 05, 2025 at 03:32 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `praktikum_comunity`
--

-- --------------------------------------------------------

--
-- Table structure for table `favorit`
--

CREATE TABLE `favorit` (
  `user_id` int(11) NOT NULL,
  `modul_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `favorit`
--

INSERT INTO `favorit` (`user_id`, `modul_id`, `created_at`) VALUES
(23, 31, '2025-07-05 13:24:34'),
(23, 32, '2025-07-05 13:17:55'),
(23, 36, '2025-07-05 13:24:13');

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `kategori_id` int(11) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`kategori_id`, `nama_kategori`) VALUES
(1, 'PBE'),
(3, 'Pemrograman'),
(4, 'Pemrograman Mobile'),
(5, 'Pemrograman Web'),
(7, 'Logika Pemrograman'),
(30, 'PemPer Lanjut'),
(38, 'Pemrograman IoT'),
(40, 'MPTI'),
(41, 'PIK'),
(45, 'METOPEN'),
(46, 'Penulisan Ilmiah'),
(47, 'OAK'),
(50, 'Kriptografi');

-- --------------------------------------------------------

--
-- Table structure for table `komentar`
--

CREATE TABLE `komentar` (
  `komentar_id` int(11) NOT NULL,
  `modul_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `isi_komentar` text NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `komentar`
--

INSERT INTO `komentar` (`komentar_id`, `modul_id`, `user_id`, `isi_komentar`, `parent_id`, `created_at`) VALUES
(1, 32, 23, 'Terima kasih menarik sekali dan mudah diimplementasikan!', NULL, '2025-06-22 09:42:58'),
(2, 33, 23, 'Turotial nya mudah dipahami', NULL, '2025-06-22 09:44:26'),
(4, 32, 45, 'mantap', NULL, '2025-06-22 12:41:48'),
(5, 32, 45, 'Mudah dipahami banget✌', NULL, '2025-06-22 12:44:30'),
(6, 32, 45, 'mencoba komentar baru', NULL, '2025-06-22 12:50:06'),
(7, 32, 44, 'matap ✌', NULL, '2025-06-22 12:53:51'),
(8, 32, 44, 'new comment', NULL, '2025-06-22 12:55:00'),
(9, 31, 44, 'oke', NULL, '2025-06-22 12:55:16'),
(10, 31, 44, 'bagus', NULL, '2025-06-22 12:55:22'),
(15, 31, 23, 'mantap', NULL, '2025-06-29 07:23:07'),
(16, 36, 23, 'oke bgt', NULL, '2025-06-29 07:23:29'),
(17, 39, 23, 'oke pemula', NULL, '2025-06-29 07:27:10'),
(18, 35, 23, 'terimakasih', NULL, '2025-06-29 07:56:27'),
(21, 39, 23, 'baik', NULL, '2025-07-01 01:25:31'),
(23, 43, 23, 'bagus', NULL, '2025-07-01 10:08:07'),
(24, 41, 23, 'mantap', NULL, '2025-07-03 03:55:49'),
(25, 43, 23, 'mantap', NULL, '2025-07-03 09:25:58'),
(26, 43, 23, 'eror bang', NULL, '2025-07-03 09:49:23');

-- --------------------------------------------------------

--
-- Table structure for table `langkah`
--

CREATE TABLE `langkah` (
  `langkah_id` int(11) NOT NULL,
  `modul_id` int(11) NOT NULL,
  `urutan` int(11) NOT NULL,
  `deskripsi_langkah` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `langkah`
--

INSERT INTO `langkah` (`langkah_id`, `modul_id`, `urutan`, `deskripsi_langkah`) VALUES
(35, 34, 1, 'Buat file router baru, misalnya `productRoutes.js` untuk menampung endpoint CRUD produk.'),
(36, 34, 2, 'Implementasikan endpoint POST `/products` untuk membuat produk baru. Ambil data dari `req.body` dan gunakan `prisma.product.create()`.'),
(37, 34, 3, 'Implementasikan endpoint GET `/products` untuk membaca semua produk dan GET `/products/:id` untuk produk spesifik.'),
(38, 34, 4, 'Implementasikan endpoint PATCH `/products/:id` untuk memperbarui data produk menggunakan `prisma.product.update()`.'),
(39, 34, 5, 'Implementasikan endpoint DELETE `/products/:id` untuk menghapus produk menggunakan `prisma.product.delete()`.'),
(86, 41, 1, 'buka vscode'),
(87, 41, 2, 'buat file. py'),
(88, 41, 3, 'lalu tuliskan kode untuk kalkulator'),
(89, 31, 1, 'Bubble Sort: Lakukan perulangan pada array, bandingkan setiap elemen dengan elemen di sebelahnya dan tukar jika urutannya salah. Ulangi hingga tidak ada lagi pertukaran.'),
(90, 31, 2, 'Selection Sort: Cari elemen terkecil dalam array, tukar dengan elemen pertama. Ulangi proses untuk sisa array.'),
(91, 31, 3, 'Insertion Sort: Bangun array yang sudah terurut satu per satu. Ambil satu elemen dari data yang belum diurutkan dan masukkan ke posisi yang benar di dalam array yang sudah terurut.'),
(92, 32, 1, 'Navigasi Dasar (Anonymous Route): Gunakan `Navigator.push()` untuk pindah ke halaman baru dan `Navigator.pop()` untuk kembali.'),
(93, 32, 2, 'Named Routes: Definisikan rute Anda sebagai string di dalam properti `routes` pada `MaterialApp`.'),
(94, 32, 3, 'Gunakan `Navigator.pushNamed()` untuk bernavigasi menggunakan nama rute yang sudah didefinisikan.'),
(95, 32, 4, 'Passing Arguments: Kirim data ke halaman baru menggunakan argumen pada `pushNamed` dan terima data tersebut menggunakan `ModalRoute.of(context)!.settings.arguments`.'),
(96, 35, 1, 'Buat file `index.html`. Pahami struktur dasar tag HTML seperti `<html>`, `<head>`, dan `<body>`.'),
(97, 35, 2, 'Gunakan tag heading (`<h1>` - `<h6>`), paragraf (`<p>`), link (`<a>`), dan gambar (`<img>`) untuk membuat konten halaman.'),
(98, 35, 3, 'Buat file `style.css` dan hubungkan ke file HTML menggunakan tag `<link>` di dalam `<head>`.'),
(99, 35, 4, 'Gunakan selector CSS (seperti nama tag, class, atau ID) untuk menargetkan elemen HTML dan berikan style seperti `color`, `font-size`, dan `background-color`.'),
(100, 33, 1, 'Tambahkan package `provider` ke dalam file `pubspec.yaml` Anda dan jalankan `flutter pub get`.'),
(101, 33, 2, 'Buat sebuah class baru yang menggunakan `ChangeNotifier` untuk menampung data state Anda, misalnya `CounterProvider`.'),
(102, 33, 3, 'Bungkus widget utama Anda (biasanya MaterialApp) dengan `MultiProvider` atau `ChangeNotifierProvider`.'),
(103, 33, 4, 'Gunakan `Provider.of<NamaProvider>(context)` atau `context.watch<NamaProvider>()` untuk mengakses state di dalam UI Anda.'),
(104, 33, 5, 'Panggil method di dalam provider Anda menggunakan `context.read<NamaProvider>().namaMethod()` untuk mengubah state.'),
(105, 36, 1, 'Bentuk Normal Pertama: Pastikan semua nilai dalam kolom bersifat atomik (tidak dapat dibagi lagi) dan setiap baris unik.'),
(106, 36, 2, 'Bentuk Normal Kedua : Penuhi syarat 1NF dan pastikan semua atribut non-kunci memiliki ketergantungan fungsional penuh pada *primary key*. Pisahkan tabel jika diperlukan.'),
(107, 36, 3, 'Bentuk Normal Ketiga : Penuhi syarat 2NF dan pastikan tidak ada ketergantungan transitif, yaitu atribut non-kunci tidak bergantung pada atribut non-kunci lainnya.'),
(108, 39, 1, 'siapkan vs code'),
(109, 39, 2, 'buat file baru .py'),
(110, 39, 3, 'tuliskan print(\"Hello Dunia😀\") '),
(111, 39, 4, 'open terminal jalankan py namafile. py'),
(127, 43, 1, 'buka vscode'),
(128, 43, 2, 'buat file Python '),
(129, 43, 3, 'copas kode'),
(130, 43, 4, 'jalankan');

-- --------------------------------------------------------

--
-- Table structure for table `modul`
--

CREATE TABLE `modul` (
  `modul_id` int(11) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `thumbnail_url` varchar(255) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `kategori_id` int(11) NOT NULL,
  `penulis_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp(),
  `status` enum('pending','reject','approved') NOT NULL DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `modul`
--

INSERT INTO `modul` (`modul_id`, `judul`, `thumbnail_url`, `deskripsi`, `kategori_id`, `penulis_id`, `created_at`, `updated_at`, `status`) VALUES
(31, 'Manajemen State Flutter dengan Provider', '/public/images/moduls/thumbnail.png', 'Pelajari cara mengelola state aplikasi Flutter secara efisien menggunakan package Provider, salah satu pendekatan state management yang paling populer.', 4, 44, '2025-06-18 21:17:03', '2025-06-29 13:34:08', 'approved'),
(32, 'Membuat CRUD API dengan Express dan Prisma', '/public/images/moduls/thumbnail.png', 'Panduan langkah demi langkah untuk membangun endpoint API Create, Read, Update, dan Delete (CRUD) menggunakan Express.js dan Prisma ORM.', 5, 44, '2025-06-18 21:17:03', '2025-06-29 13:34:20', 'approved'),
(33, 'Dasar-dasar HTML & CSS untuk Pemula', '/public/images/moduls/thumbnail.png', 'Modul pengenalan konsep dasar HTML untuk struktur halaman web dan CSS untuk styling, cocok untuk yang baru memulai di dunia web.', 5, 45, '2025-06-18 21:17:03', '2025-06-29 13:35:40', 'approved'),
(34, 'Normalisasi Database: Dari 1NF hingga 3NF', '/public/images/moduls/thumbnail.png', 'Pahami pentingnya normalisasi untuk merancang skema database yang efisien dan bebas dari anomali data. Pembahasan mencakup Bentuk Normal Pertama, Kedua, dan Ketiga.', 3, 46, '2025-06-18 21:17:03', '2025-06-18 21:17:03', 'approved'),
(35, 'Pengenalan Algoritma Sorting', '/public/images/moduls/thumbnail.png', 'Mempelajari logika dasar di balik beberapa algoritma pengurutan data yang fundamental seperti Bubble Sort, Selection Sort, dan Insertion Sort.', 7, 48, '2025-06-18 21:17:03', '2025-06-29 13:35:05', 'approved'),
(36, 'Navigasi dan Routing pada Aplikasi Flutter', '/public/images/moduls/thumbnail.png', 'Menguasai berbagai teknik navigasi di Flutter, mulai dari Navigator 1.0 (push/pop) hingga Navigator 2.0 dengan named routes untuk aplikasi skala besar.', 4, 46, '2025-06-18 21:17:03', '2025-06-29 13:36:27', 'approved'),
(39, 'Pengantar Pemrograman', '/public/images/moduls/1751182013360-56032d8d-3e7d-4dbf-b4ae-724064e58ca1.png', 'pengantar pemrograman membuat kode program untuk pertama kalinya', 7, 23, '2025-06-29 07:26:53', '2025-07-01 01:25:44', 'approved'),
(41, 'Membuat Aplikasi Simple', '/public/images/moduls/1751203909583-acca963e-18ba-4558-9b4a-0992da65ba46.png', 'membuat aplikasi simple dengan bahasa pemrograman python', 7, 23, '2025-06-29 13:31:49', '2025-06-29 13:31:49', 'approved'),
(43, 'Kriptografi Modern', '/public/images/moduls/1751364480424-18db47b3-4397-4361-9955-5c4074a91308.png', 'akan mempelajari pengguna an kriptografi modern sepertI RSA, DLL. ', 50, 23, '2025-07-01 10:08:00', '2025-07-05 11:22:43', 'approved');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `foto_profil` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp(),
  `role` enum('admin','user') NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `foto_profil`, `created_at`, `updated_at`, `role`) VALUES
(23, 'Master', '$argon2id$v=19$m=65536,t=3,p=4$OXPR5flelRtP7rz//mC2DQ$3mgziT/HaMjC6Ojf9c5pjDnkihojz45MrYd45RPBf+c', 'master@gmail.com', '/public/images/users/profile.png', '2025-06-13 09:48:34', '2025-06-30 12:42:04', 'admin'),
(44, 'Alfred', '$argon2id$v=19$m=65536,t=3,p=4$jNPU+BwxYdry+pgom1BjcQ$gOaMYiy8ZqEvxaVQVwr/gZt3SZmRYKsMhQUFYd8clP8', 'alf@gmail.com', '/public/images/users/profile.png', '2025-06-17 05:13:38', '2025-06-17 05:13:38', 'user'),
(45, 'Baru banget', '$argon2id$v=19$m=65536,t=3,p=4$nRQuCKV7EVh3OzMQah/NzQ$Mu8NNTvCDJPUeTJ0Q0qA+BK7aNHtoMl/MnoCVJ6RdLw', 'baru@gmail.com', '/public/images/users/profile.png', '2025-06-17 13:10:38', '2025-06-27 13:30:32', 'user'),
(46, 'Gwendi', '$argon2id$v=19$m=65536,t=3,p=4$0B+IAeP7l8qTLeqjDY76Uw$iAawr8Q9Ytl3Z/kLT8jOFlPOywv/fLxqRVNgt+SFe/c', 'gwendi@gmail.com', '/public/images/users/profile.png', '2025-06-17 15:39:23', '2025-06-27 09:01:29', 'user'),
(47, 'Alvin14', '$argon2id$v=19$m=65536,t=3,p=4$f+ltiFdNCH8PC8lEPv9iKA$gvsTq1f7Nlx0ANh5hVw1pJwW/ZPMnSHGOP2SV15Udec', 'alvin@gmail.com', '/public/images/users/profile.png', '2025-06-18 13:54:32', '2025-06-18 13:54:32', 'user'),
(48, 'Dendy11', '$argon2id$v=19$m=65536,t=3,p=4$4+mEb9aTGOwnuBD2rFM3Jg$B/CjF3mX2n6yrwMFaB0qriu4GO2YMPMV+4s+MDzck04', 'dendy@gmail.com', '/public/images/users/profile.png', '2025-06-18 13:55:15', '2025-06-18 13:55:15', 'user');

-- --------------------------------------------------------

--
-- Table structure for table `_prisma_migrations`
--

CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) NOT NULL,
  `checksum` varchar(64) NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) NOT NULL,
  `logs` text DEFAULT NULL,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `applied_steps_count` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `_prisma_migrations`
--

INSERT INTO `_prisma_migrations` (`id`, `checksum`, `finished_at`, `migration_name`, `logs`, `rolled_back_at`, `started_at`, `applied_steps_count`) VALUES
('40fe9463-f6e4-4cfc-93dc-08ef5cd3ab2c', 'c3f3868daf7d8d7cc008aadb58f39add7b257d3b569553220415c6579c109a5b', '2025-06-12 04:01:08.618', '20250612040106_init', NULL, NULL, '2025-06-12 04:01:06.811', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `favorit`
--
ALTER TABLE `favorit`
  ADD PRIMARY KEY (`user_id`,`modul_id`),
  ADD KEY `idx_favorit_modul` (`modul_id`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`kategori_id`);

--
-- Indexes for table `komentar`
--
ALTER TABLE `komentar`
  ADD PRIMARY KEY (`komentar_id`),
  ADD KEY `idx_komentar_modul` (`modul_id`),
  ADD KEY `idx_komentar_parent` (`parent_id`),
  ADD KEY `idx_komentar_user` (`user_id`);

--
-- Indexes for table `langkah`
--
ALTER TABLE `langkah`
  ADD PRIMARY KEY (`langkah_id`),
  ADD KEY `idx_langkah_modul_urutan` (`modul_id`,`urutan`);

--
-- Indexes for table `modul`
--
ALTER TABLE `modul`
  ADD PRIMARY KEY (`modul_id`),
  ADD KEY `idx_modul_kategori` (`kategori_id`),
  ADD KEY `idx_modul_penulis` (`penulis_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `ux_users_username` (`username`),
  ADD UNIQUE KEY `ux_users_email` (`email`);

--
-- Indexes for table `_prisma_migrations`
--
ALTER TABLE `_prisma_migrations`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `kategori_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `komentar`
--
ALTER TABLE `komentar`
  MODIFY `komentar_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `langkah`
--
ALTER TABLE `langkah`
  MODIFY `langkah_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=133;

--
-- AUTO_INCREMENT for table `modul`
--
ALTER TABLE `modul`
  MODIFY `modul_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=170;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `favorit`
--
ALTER TABLE `favorit`
  ADD CONSTRAINT `fk_favorit_modul` FOREIGN KEY (`modul_id`) REFERENCES `modul` (`modul_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_favorit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `komentar`
--
ALTER TABLE `komentar`
  ADD CONSTRAINT `fk_komentar_modul` FOREIGN KEY (`modul_id`) REFERENCES `modul` (`modul_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_komentar_parent` FOREIGN KEY (`parent_id`) REFERENCES `komentar` (`komentar_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_komentar_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `langkah`
--
ALTER TABLE `langkah`
  ADD CONSTRAINT `fk_langkah_modul` FOREIGN KEY (`modul_id`) REFERENCES `modul` (`modul_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `modul`
--
ALTER TABLE `modul`
  ADD CONSTRAINT `fk_modul_kategori` FOREIGN KEY (`kategori_id`) REFERENCES `kategori` (`kategori_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_modul_penulis` FOREIGN KEY (`penulis_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
