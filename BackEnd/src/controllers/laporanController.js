const prisma = require("../config/db");

// 1. CREATE LAPORAN (Untuk User)
const createLaporan = async (req, res) => {
  try {
    // 1. Ambil data yang dikirim dari Flutter (Body)
    const { modul_id, kategori, deskripsi } = req.body;

    // 2. Ambil ID User dari Token Login (req.user diset oleh middleware auth)
    const user_id = req.user.user_id; 

    // 3. Validasi sederhana
    if (!modul_id || !kategori || !deskripsi) {
      return res.status(400).json({
        status: 400,
        message: "Data tidak lengkap. Modul ID, Kategori, dan Deskripsi wajib diisi."
      });
    }

    // 4. Simpan ke Database
    const newLaporan = await prisma.laporan.create({
      data: {
        user_id: parseInt(user_id),
        modul_id: parseInt(modul_id),
        kategori: kategori, // Pastikan sesuai enum prisma
        deskripsi: deskripsi,
      },
    });

    // 5. Beri respon sukses
    res.status(201).json({
      status: 201,
      message: "Laporan berhasil dikirim. Terima kasih atas masukan Anda.",
      data: newLaporan,
    });

  } catch (error) {
    console.error("Error creating laporan:", error);
    res.status(500).json({
      status: 500,
      message: "Terjadi kesalahan server saat mengirim laporan.",
      error: error.message
    });
  }
};

// 2. GET ALL LAPORAN (Untuk Admin)
const getAllLaporan = async (req, res) => {
  try {
    const laporan = await prisma.laporan.findMany({
      include: {
        // Ambil info pelapor (siapa yang lapor)
        pelapor: {
          select: { username: true, email: true, foto_profil: true }
        },
        // Ambil info modul yang dilaporkan
        modul: {
          select: { 
            judul: true, 
            modul_id: true, 
            thumbnail_url: true,
            // [PENTING] Ambil info Penulis Modul (Target Sanksi)
            penulis: {
                select: { user_id: true, username: true, can_upload: true }
            }
          }
        }
      },
      orderBy: { created_at: 'desc' } // Urutkan dari yang terbaru
    });

    res.status(200).json({
      status: 200,
      message: "Berhasil memuat data laporan",
      data: laporan,
    });
  } catch (error) {
    console.error("Error get laporan:", error);
    res.status(500).json({ message: "Server Error" });
  }
};

// 3. DELETE LAPORAN (Untuk Admin - Menandai Selesai)
const deleteLaporan = async (req, res) => {
  const { id } = req.params;
  try {
    await prisma.laporan.delete({
      where: { laporan_id: parseInt(id) },
    });

    res.status(200).json({
      status: 200,
      message: "Laporan berhasil dihapus",
    });
  } catch (error) {
    console.error("Error delete laporan:", error);
    res.status(500).json({ message: "Gagal menghapus laporan" });
  }
};

module.exports = { createLaporan, getAllLaporan, deleteLaporan };