const prisma = require('../config/db');

const getAllKategori = async () => {
    return await prisma.kategori.findMany();
}

const getKategoriById = async (kategoriId) => {
    return await prisma.kategori.findFirst({
        where: {
            kategori_id: kategoriId
        }
    })
}

const createKategori = async (kategoriData) => {
    return await prisma.kategori.create({
        data: {
            kategori_id: kategoriData.kategori_id,
            nama_kategori: kategoriData.nama_kategori
        }
    })
}

const updateKategoriById = async (kategoriId, kategoriData) => {
    return await prisma.kategori.update({
        where: {
            kategori_id: kategoriId
        },
        data: {
            kategori_id: kategoriData.kategori_id,
            nama_kategori: kategoriData.nama_kategori
        }
    })
}

const deleteKategoriById = async (kategoriId) => {
    return await prisma.kategori.delete({
        where: {
            kategori_id: kategoriId
        }
    })
}

module.exports = {
    getAllKategori,
    getKategoriById,
    createKategori,
    updateKategoriById,
    deleteKategoriById
}