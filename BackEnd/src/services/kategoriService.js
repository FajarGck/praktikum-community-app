const kategoriRepository = require('../repository/kategoriRepository')

const getAllKategori = async () => {
    return await kategoriRepository.getAllKategori();
}

const getKategoriById = async (kategoriId) => {
    if (!kategoriId) {
        throw new Error('Kategori Id is Not Found!');
    }
    
    const kategori = await kategoriRepository.getKategoriById(kategoriId);
    if (!kategori) {
        throw new Error('Kategori Not Found!');
    }

    return kategori;
}


const createKategori = async (kategoriData) => {
    if (!kategoriData) {
        throw new Error('Kategori Data is Required!');
    } else if (!kategoriData.nama_kategori) {
        throw new Error('Nama Kategori is Required!');
    }

    return await kategoriRepository.createKategori(kategoriData);
   
}

const updateKategoriById = async (kategoriId, kategoriData) => {
    if (!kategoriId) {
        throw new Error('Kategori Id is Required!');
    } else if (!kategoriData) {
        throw new Error('Kategori Data is Required!');
    } else if (!kategoriData.nama_kategori) {
        throw new Error('Nama Kategori is Required!');
    }

    return await kategoriRepository.updateKategoriById(kategoriId, kategoriData);
}

const deleteKategoriById = async (kategoriId) => {
    await getKategoriById(kategoriId);
    await kategoriRepository.deleteKategoriById(parseInt(kategoriId));
}




module.exports = {
    getAllKategori,
    getKategoriById,
    createKategori,
    updateKategoriById,
    deleteKategoriById
}