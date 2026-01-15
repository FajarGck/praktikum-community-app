const modulService = require('../services/modulService');



const getAllModulCard = async (req, res) => {
    const modulCard = await modulService.getAllModulCard();
    try {
        res.status(200).json({
            code: 200,
            message: 'ok!',
            data: modulCard
        })
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message
        })
    }
}

const getModulCardById = async (req, res) => {
    const userId = parseInt(req.params.userId);
    try {
        const modul = await modulService.getModulCardById(userId);
        res.status(200).json({
            code: 200,
            message: 'ok!',
            data: modul
        })
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message
        })
    }
}

const getModulCardByKategori = async (req, res) => {
    const kategoriId = parseInt(req.params.kategoriId);
    try {
        const modul = await modulService.getModulCardByKategori(kategoriId);
        res.status(200).json({
            code: 200,
            message: 'ok!',
            data: modul
        })
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message
        })
    }
}

const getDetailModulById = async (req, res) => {
    const modulId = parseInt(req.params.modulId);
    const modul = await modulService.getDetailModulById(modulId);
    try {
        res.status(200).json({
            status: 200,
            message: 'ok!',
            data: modul
        })
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message
        })
    }
}

const searchModul = async (req, res) => {
    const { judul } = req.query;

    try {
        const modules = await modulService.searchModul(judul);
        res.status(200).json({
            code: 200,
            message: 'ok!',
            data: modules
        });
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message
        });
    }
}

const createModul = async (req, res) => {
    try {
        const penulis_id = req.user.user_id;
        const { judul, deskripsi, kategori_id, langkah } = req.body;

        if (!req.file) {
            return res.status(400).json({ message: "Thumbnail modul wajib di-upload" });
        }
        const thumbnailUrl = `/public/images/moduls/${req.file.filename}`;

        if (!langkah) {
            throw new Error("Data 'langkah' tidak boleh kosong.");
        }
        const langkahParsed = JSON.parse(langkah);

        const modulData = {
            judul,
            deskripsi,
            kategori_id: parseInt(kategori_id),
            penulis_id: penulis_id,
            thumbnail_url: thumbnailUrl
        };

        const newModul = await modulService.createModul(modulData, langkahParsed);

        res.status(201).json({
            code: 201,
            message: 'Modul berhasil dibuat!',
            data: newModul
        });
    } catch (error) {
        console.error("!!! ERROR DI createModul Controller:", error);
        res.status(400).json({
            code: 400,
            message: error.message
        });
    }
};

const updateModul = async (req, res) => {
    try {
        const modulId = parseInt(req.params.modulId);
        const loggedInUserId = req.user.user_id;
        const { judul, deskripsi, kategori_id, langkah } = req.body;

        const modulData = {
            judul,
            deskripsi,
            kategori_id: parseInt(kategori_id),
            updated_at: new Date()
        };

        if (req.file) {
            modulData.thumbnail_url = `/public/images/moduls/${req.file.filename}`;
        }
        
        if (!langkah) {
            throw new Error("Data 'langkah' tidak boleh kosong.");
        }
        const langkahParsed = JSON.parse(langkah);

        const updatedModul = await modulService.updateModul(modulId, loggedInUserId, modulData, langkahParsed);

        res.status(200).json({
            code: 200,
            message: 'Modul berhasil diperbarui!',
            data: updatedModul
        });
    } catch (error) {
        console.error("!!! ERROR DI updateModul Controller:", error);
        res.status(400).json({
            code: 400,
            message: error.message
        });
    }
};

const updateModulStatus = async (req, res) => {
  try {
    const modulId = parseInt(req.params.modulId, 10);
    
    // --- TAMBAHAN DEBUGGING (Lihat di Terminal Backend) ---
    console.log("=== DEBUG UPDATE STATUS ===");
    console.log("Modul ID:", modulId);
    console.log("Body yang diterima:", req.body);
    console.log("Status yang dikirim:", req.body.status);
    // -----------------------------------------------------

    if (isNaN(modulId)) {
      return res.status(400).json({ code: 400, message: "modulId tidak valid" });
    }

    const { status } = req.body;
    if (!status) {
      return res.status(400).json({ code: 400, message: "status is required" });
    }

    // PASTIKAN LIST INI BENAR-BENAR SUDAH DIUPDATE DI FILE YANG AKTIF
    const allowed = ['pending', 'approved', 'reject', 'suspended', 'banned']; 
    
    console.log("Apakah status valid?", allowed.includes(status)); // Cek log ini

    if (!allowed.includes(status)) {
      return res.status(400).json({ code: 400, message: "status tidak valid (rejected by controller)" });
    }

    const data = await modulService.updateModulStatus(modulId, status);

    res.status(200).json({
      code: 200,
      message: "Status modul berhasil diupdate",
      data
    });
  } catch (error) {
    console.log("ERROR:", error.message);
    res.status(400).json({ code: 400, message: error.message });
  }
};


const deleteModul = async (req, res) => {
    try {
        const modulid = parseInt(req.params.modulId);
        const loggedInUserId = req.user.user_id;
        const deleted = await modulService.deleteModul(modulid, loggedInUserId);
        res.status(200).json({
            code: 200,
            message: 'Modul berhasil dihapus!',
            data: deleted
        });
    } catch (error) {
        console.error("!!! ERROR DI delete Controller:", error);
        res.status(400).json({
            code: 400,
            message: error.message
        });
    }
}

const adminDeleteModul = async (req, res) => {
  try {
    const modulId = parseInt(req.params.modulId, 10);
    if (isNaN(modulId)) {
      return res.status(400).json({ code: 400, message: "modulId tidak valid" });
    }

    const deleted = await modulService.adminDeleteModul(modulId);

    return res.status(200).json({
      code: 200,
      message: "Modul berhasil dihapus oleh admin",
      data: deleted
    });
  } catch (error) {
    return res.status(400).json({ code: 400, message: error.message });
  }
};


module.exports = {
    getAllModulCard,
    getModulCardById,
    getModulCardByKategori,
    getDetailModulById,
    searchModul,
    createModul,
    updateModul,
    updateModulStatus,
    deleteModul,
    adminDeleteModul
}