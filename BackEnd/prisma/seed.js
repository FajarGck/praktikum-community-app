const { PrismaClient } = require('@prisma/client');
const argon2 = require('argon2'); // Menggunakan argon2 sesuai package.json

const prisma = new PrismaClient();

async function main() {
  console.log('Start seeding...');

  // ==========================================================
  // 1. CLEAN UP: Hapus data lama (Urutan penting karena Foreign Key)
  // ==========================================================
  console.log('Cleaning up existing data...');
  
  // Hapus dari tabel yang memiliki foreign key terlebih dahulu
  await prisma.favorit.deleteMany({});
  await prisma.komentar.deleteMany({});
  await prisma.langkah.deleteMany({});
  await prisma.report.deleteMany({});
  await prisma.modul.deleteMany({});
  await prisma.kategori.deleteMany({});
  await prisma.users.deleteMany({});

  console.log('All data deleted.');

  // ==========================================================
  // 2. SEEDING: Isi data baru
  // ==========================================================

  // --- A. Create Users (Admin & Regular User) ---
  // Hash password menggunakan argon2
  const passwordHash = await argon2.hash('password123');

  const admin = await prisma.users.create({
    data: {
      username: 'admin_utama',
      email: 'admin@praktikum.com',
      password: passwordHash,
      role: 'admin',
      foto_profil: 'https://ui-avatars.com/api/?name=Admin+Utama',
    },
  });

  const user1 = await prisma.users.create({
    data: {
      username: 'budi_santoso',
      email: 'budi@gmail.com',
      password: passwordHash,
      role: 'user',
      foto_profil: 'https://ui-avatars.com/api/?name=Budi+Santoso',
    },
  });

  const user2 = await prisma.users.create({
    data: {
      username: 'siti_aminah',
      email: 'siti@gmail.com',
      password: passwordHash,
      role: 'user',
      foto_profil: 'https://ui-avatars.com/api/?name=Siti+Aminah',
    },
  });

  console.log('Users created.');

  // --- B. Create Kategori ---
  const kat1 = await prisma.kategori.create({ data: { nama_kategori: 'Pemrograman Web' } });
  const kat2 = await prisma.kategori.create({ data: { nama_kategori: 'Data Science' } });
  const kat3 = await prisma.kategori.create({ data: { nama_kategori: 'Mobile Development' } });
  const kat4 = await prisma.kategori.create({ data: { nama_kategori: 'Jaringan Komputer' } });

  console.log('Kategori created.');

  // --- C. Create Modul ---
  // Modul 1: Web Dasar (Approved) oleh User 1
  const modul1 = await prisma.modul.create({
    data: {
      judul: 'Belajar HTML & CSS Dasar',
      deskripsi: 'Panduan lengkap untuk pemula yang ingin belajar membuat website dari nol.',
      thumbnail_url: 'https://placehold.co/600x400/png',
      status: 'approved',
      kategori_id: kat1.kategori_id,
      penulis_id: user1.user_id,
      langkah: {
        create: [
          { urutan: 1, deskripsi_langkah: 'Instalasi VS Code dan persiapan folder proyek.' },
          { urutan: 2, deskripsi_langkah: 'Membuat file index.html pertama.' },
          { urutan: 3, deskripsi_langkah: 'Mengenal tag dasar: div, p, h1, dan span.' },
        ],
      },
    },
  });

  // Modul 2: Python Data Science (Approved) oleh User 2
  const modul2 = await prisma.modul.create({
    data: {
      judul: 'Analisis Data dengan Pandas',
      deskripsi: 'Cara menggunakan library Pandas di Python untuk mengolah data CSV.',
      thumbnail_url: 'https://placehold.co/600x400/png',
      status: 'approved',
      kategori_id: kat2.kategori_id,
      penulis_id: user2.user_id,
      langkah: {
        create: [
          { urutan: 1, deskripsi_langkah: 'Instalasi Python dan Jupyter Notebook.' },
          { urutan: 2, deskripsi_langkah: 'Import library pandas dan numpy.' },
          { urutan: 3, deskripsi_langkah: 'Membaca file CSV menggunakan read_csv.' },
        ],
      },
    },
  });

  // Modul 3: Flutter (Pending) oleh User 1
  const modul3 = await prisma.modul.create({
    data: {
      judul: 'Membuat Aplikasi To-Do List Flutter',
      deskripsi: 'Tutorial membuat aplikasi manajemen tugas sederhana menggunakan Flutter.',
      thumbnail_url: 'https://placehold.co/600x400/png',
      status: 'pending',
      kategori_id: kat3.kategori_id,
      penulis_id: user1.user_id,
      langkah: {
        create: [
          { urutan: 1, deskripsi_langkah: 'Setup Flutter SDK.' },
          { urutan: 2, deskripsi_langkah: 'Membuat UI dasar dengan Scaffold.' },
        ],
      },
    },
  });

  console.log('Modul & Langkah created.');

  // --- D. Create Komentar ---
  const komen1 = await prisma.komentar.create({
    data: {
      isi_komentar: 'Tutorialnya sangat jelas, terima kasih gan!',
      modul_id: modul1.modul_id,
      user_id: user2.user_id,
    },
  });

  await prisma.komentar.create({
    data: {
      isi_komentar: 'Sama-sama, semoga bermanfaat!',
      modul_id: modul1.modul_id,
      user_id: user1.user_id,
      parent_id: komen1.komentar_id,
    },
  });

  await prisma.komentar.create({
    data: {
      isi_komentar: 'Mohon tambahkan contoh datasetnya ya.',
      modul_id: modul2.modul_id,
      user_id: admin.user_id,
    },
  });

  console.log('Komentar created.');

  // --- E. Create Favorit ---
  await prisma.favorit.create({
    data: {
      user_id: user2.user_id,
      modul_id: modul1.modul_id,
    },
  });

  await prisma.favorit.create({
    data: {
      user_id: admin.user_id,
      modul_id: modul2.modul_id,
    },
  });

  console.log('Favorit created.');
  console.log('Seeding finished successfully.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });