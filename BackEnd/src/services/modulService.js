const prisma = require('../config/db');
const modulRepository = require('../repository/modulRepository');

const getAllModulCard = async () => {
  return await modulRepository.getAllModulCard();
};

const getModulCardById = async (userId) => {
  if (!userId) {
    throw new Error('modul id is required');
  }
  return await modulRepository.getModulCardById(userId);
};

const getModulCardByKategori = async (kategoriId) => {
  if (!kategoriId) {
    throw new Error('Kategeori Id is required');
  }
  return await modulRepository.getModulCardByKategori(kategoriId);
};

const getDetailModulById = async (modulId) => {
  if (!modulId) {
    throw new Error('modul id is required');
  }

  const modul = await modulRepository.getDetailModulById(modulId);
  if (!modul) {
    throw new Error('modul not found!');
  }

  return modul;
};

const searchModul = async (searchTerm) => {
  if (!searchTerm) {
    return [];
  }

  const modules = await modulRepository.searchModulByJudul(searchTerm);
  return modules;
};

const createModul = async (modulData, langkahData) => {
  if (
    !modulData.judul ||
    !modulData.kategori_id ||
    !langkahData ||
    langkahData.length === 0
  ) {
    throw new Error('Judul, kategori, dan langkah-langkah wajib diisi');
  }

  return await modulRepository.createModul(modulData, langkahData);
};

const updateModul = async (modulId, loggedInUserId, modulData, langkahData) => {
  const existingModul = await modulRepository.getDetailModulById(modulId);
  if (!existingModul) {
    throw new Error('Modul tidak ditemukan!');
  }

  if (existingModul.penulis_id !== loggedInUserId) {
    throw new Error('Akses ditolak: Anda bukan pemilik modul ini.');
  }

  return await modulRepository.updateModul(modulId, modulData, langkahData);
};

const updateModulStatus = async (modulId, status) => {
  if (!modulId) throw new Error('modul id is required');

  const existing = await modulRepository.getDetailModulById(modulId);
  if (!existing) throw new Error('Modul tidak ditemukan!');

  return await prisma.$transaction(async (tx) => {
    const updatedModul = await tx.modul.update({
      where: { modul_id: modulId },
      data: { status },
    });
    if (status === 'reject') {
      await tx.report.updateMany({
        where: {
          modul_id: modulId,
          status: 'pending',
        },
        data: { status: 'resolved' },
      });
    }

    return updatedModul;
  });
};

const deleteModul = async (modulId, loggedInUserId) => {
  if (!modulId) {
    throw new Error('Modul ID is required');
  }

  const existingModul = await modulRepository.getDetailModulById(modulId);
  if (!existingModul) {
    throw new Error('Modul tidak ditemukan!');
  }

  if (existingModul.penulis_id !== loggedInUserId) {
    throw new Error('Akses ditolak: Anda bukan pemilik modul ini.');
  }

  return await modulRepository.deleteModul(modulId);
};

const adminDeleteModul = async (modulId) => {
  const existing = await modulRepository.getDetailModulById(modulId);
  if (!existing) throw new Error('Modul tidak ditemukan!');
  return await modulRepository.deleteModul(modulId);
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
  adminDeleteModul,
};
