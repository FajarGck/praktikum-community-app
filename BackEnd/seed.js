const { PrismaClient } = require('@prisma/client');
const argon2 = require('argon2');

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Memulai seeding database...');

  // 1. Bersihkan data lama (Urutan penting karena Foreign Key!)
  // Kita hapus child dulu baru parent
  await prisma.laporan.deleteMany();
  await prisma.komentar.deleteMany();
  await prisma.favorit.deleteMany();
  await prisma.langkah.deleteMany();
  await prisma.modul.deleteMany();
  await prisma.kategori.deleteMany();
  await prisma.users.deleteMany();
  
  console.log('🧹 Data lama dibersihkan.');

  // 2. Siapkan Password Hash
  const password = await argon2.hash("123456");

  // 3. Buat Users (Sesuai skenario simulasi)
  
  // A. ADMIN (Super User)
  const admin = await prisma.users.create({
    data: {
      username: 'admin',
      email: 'admin@test.com',
      password: password,
      role: 'admin',
      foto_profil: 'https://ui-avatars.com/api/?name=Admin+Ganteng&background=0D8ABC&color=fff',
      can_upload: true, // Admin bebas
    },
  });

  // B. PENULIS BAIK (User Normal)
  const userBaik = await prisma.users.create({
    data: {
      username: 'fajar_developer',
      email: 'fajar@test.com',
      password: password,
      role: 'user',
      foto_profil: 'https://ui-avatars.com/api/?name=Fajar+Dev&background=random',
      can_upload: true, // Boleh upload
    },
  });

  // C. PENULIS NAKAL (User Disanksi)
  const userNakal = await prisma.users.create({
    data: {
      username: 'si_spammer',
      email: 'spam@test.com',
      password: password,
      role: 'user',
      foto_profil: 'https://ui-avatars.com/api/?name=Bad+Guy&background=000000&color=fff',
      can_upload: false, // [SANKSI] Tidak boleh upload!
    },
  });

  // D. PELAPOR (User yang melapor)
  const pelapor = await prisma.users.create({
    data: {
      username: 'kang_lapor',
      email: 'lapor@test.com',
      password: password,
      role: 'user',
      foto_profil: 'https://ui-avatars.com/api/?name=Reporter&background=random',
      can_upload: true,
    },
  });

  console.log('✅ Users berhasil dibuat.');

  // 4. Buat Kategori
  const katWeb = await prisma.kategori.create({ data: { nama_kategori: 'Web Development' } });
  const katMobile = await prisma.kategori.create({ data: { nama_kategori: 'Mobile Development' } });
  const katUI = await prisma.kategori.create({ data: { nama_kategori: 'UI/UX Design' } });

  console.log('✅ Kategori berhasil dibuat.');

  // 5. Buat Modul Dummy

  // A. Modul Bagus (Milik Fajar)
  const modulBagus = await prisma.modul.create({
    data: {
      judul: 'Tutorial Flutter untuk Pemula',
      deskripsi: 'Panduan lengkap belajar Flutter dari nol sampai mahir.',
      thumbnail_url: '/public/images/moduls/thumbnail.png', // Pastikan ada dummy image atau null
      kategori_id: katMobile.kategori_id,
      penulis_id: userBaik.user_id,
      status: 'approved',
      langkah: {
        create: [
          { urutan: 1, deskripsi_langkah: 'Install Flutter SDK dan Android Studio.' },
          { urutan: 2, deskripsi_langkah: 'Buat project baru dengan flutter create.' },
          { urutan: 3, deskripsi_langkah: 'Jalankan aplikasi di emulator.' },
        ]
      }
    },
  });

  // B. Modul Bermasalah (Milik Spammer - yang akan dilaporkan)
  const modulJelek = await prisma.modul.create({
    data: {
      judul: 'CARA KAYA INSTAN TANPA KERJA!!!',
      deskripsi: 'Klik link ini untuk dapat uang kaget 1 Miliar rupiah sekarang juga!',
      thumbnail_url: null,
      kategori_id: katWeb.kategori_id,
      penulis_id: userNakal.user_id, // Penulisnya si nakal
      status: 'approved', // Lolos kurasi tapi bermasalah
      langkah: {
        create: [
          { urutan: 1, deskripsi_langkah: 'Transfer uang dulu ke saya.' },
        ]
      }
    },
  });

  console.log('✅ Modul berhasil dibuat.');

  // 6. Buat Laporan (Simulasi User Melapor)
  // Kang Lapor melaporkan modul si Spammer
  await prisma.laporan.create({
    data: {
      user_id: pelapor.user_id,
      modul_id: modulJelek.modul_id,
      kategori: 'modul_bermasalah', // Sesuai enum prisma
      deskripsi: 'Ini adalah penipuan dan spam. Mohon segera dihapus.',
    },
  });
  
  // Tambah satu laporan lagi biar rame
  await prisma.laporan.create({
    data: {
      user_id: userBaik.user_id, // Fajar juga ikut lapor
      modul_id: modulJelek.modul_id,
      kategori: 'tidak_etis',
      deskripsi: 'Judulnya clickbait dan isinya menyesatkan.',
    },
  });

  console.log('✅ Laporan dummy berhasil dibuat.');

  console.log('🎉 SEEDING SELESAI! Database siap digunakan.');
  console.log('-------------------------------------------');
  console.log('🔑 Akun Login:');
  console.log('   Admin: admin@test.com / 123456');
  console.log('   User Nakal (Disanksi): spam@test.com / 123456');
  console.log('   User Biasa: fajar@test.com / 123456');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });