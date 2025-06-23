const modulRepository = require('../repository/modulRepository');

const getAllModulCard = async () => {
    return await modulRepository.getAllModulCard();

}

const getModulCardById = async (userId) => {
    if (!userId) {
        throw new Error('modul id is required')
    }
    return await modulRepository.getModulCardById(userId);
}

const getDetailModulById = async (modulId) => {
    if (!modulId) {
        throw new Error('modul id is required')
    }

    const modul = await modulRepository.getDetailModulById(modulId);
    if (!modul) {
        throw new Error('modul not found!');
    }

    return modul;
}

const searchModul = async (searchTerm) => {
   
    if (!searchTerm) {
  
        return [];
    }
  
    const modules = await searchModulByJudul(searchTerm);
    return modules;
}

const createModul = async (modulData, langkahData) => {
    if (!modulData.judul || !modulData.kategori_id || !langkahData || langkahData.length === 0) {
        throw new Error("Judul, kategori, dan langkah-langkah wajib diisi");
    }

    return await modulRepository.createModul(modulData, langkahData);
};

const updateModul = async (modulId, loggedInUserId, modulData, langkahData) => {

    const existingModul = await modulRepository.getDetailModulById(modulId);
    if (!existingModul) {
        throw new Error("Modul tidak ditemukan!");
    }
    
    if (existingModul.penulis_id !== loggedInUserId) {
        throw new Error("Akses ditolak: Anda bukan pemilik modul ini.");
    }

    return await modulRepository.updateModul(modulId, modulData, langkahData);
};

module.exports = {
    getAllModulCard,
    getModulCardById,
    getDetailModulById,
    searchModul,
    createModul,
    updateModul
}