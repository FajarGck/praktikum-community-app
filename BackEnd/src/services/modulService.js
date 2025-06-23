const { modul } = require('../config/db');
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

module.exports = {
    getAllModulCard,
    getModulCardById,
    getDetailModulById
}