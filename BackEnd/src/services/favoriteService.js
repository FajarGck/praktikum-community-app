const favoritRepository = require('../repository/favoriteRepository');
const modulRepository = require('../repository/modulRepository'); 

const toggleFavorit = async (userId, modulId) => {
    const modul = await modulRepository.getDetailModulById(modulId);
    if (!modul) {
        throw new Error('Modul tidak ditemukan');
    }

    const existingFavorit = await favoritRepository.findFavorit(userId, modulId);

    if (existingFavorit) {
        await favoritRepository.removeFavorit(userId, modulId);
        return { message: 'Modul berhasil dihapus dari favorit', isFavorited: false };
    } else {
        await favoritRepository.addFavorit(userId, modulId);
        return { message: 'Modul berhasil ditambahkan ke favorit', isFavorited: true };
    }
};

const getFavoritByUserId = async (userId) => {
    return await favoritRepository.getFavoritByUserId(userId);
};

const checkIsFavorited = async (userId, modulId) => {
    const favorit = await favoritRepository.findFavorit(userId, modulId);
    return !!favorit; 
}

module.exports = {
    toggleFavorit,
    getFavoritByUserId,
    checkIsFavorited,
};