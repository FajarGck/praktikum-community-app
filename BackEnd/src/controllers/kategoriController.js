const kategoriService = require('../services/kategoriService');


const getAllKategori = async (req, res) => {
    try {
        const kategoris = await kategoriService.getAllKategori();
        res.status(200).json({
            code: 200,
            message: 'ok!',
            data: kategoris
        })
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message,
        });
        
    }
}

const getKategoriById = async (req, res) => {
    try {
        const kategoris = await kategoriService.getKategoriById(parseInt(req.params.kategoriId));
        res.status(200).json({
            code: 200,
            message: 'ok!',
            data: kategoris
        })
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message,
        });
    }
}

const createKategori = async (req, res) => {
    try {
        const kategori = await kategoriService.createKategori(req.body);
        res.status(201).json({
            code: 201,
            message: 'Kategori Created Successfully!',
            data: kategori
        })
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message,
        });
    }
}

const updateupdateKategoriById = async (req, res) => {
    const kategoriId = parseInt(req.params.kategoriId);
    const kategoriData = req.body;
    try {
        const prevData = await kategoriService.getKategoriById(kategoriId);
        const kategori = await kategoriService.updateKategoriById(kategoriId, kategoriData);
        res.status(200).json({
            status: 200,
            message: 'Kategori Updated Successfully!',
            data: {
                prevData: prevData,
                newData: kategori
            }
        })
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message,
        });
        
    }
}

const deleteKategoriById = async (req, res) => {
    const kategoriId = parseInt(req.params.kategoriId);
    try {
        const kategori = await kategoriService.deleteKategoriById(kategoriId);
        res.status(200).json({
            code: 200,
            message: 'Kategori Deleted Successfully!',
            data: kategori
        })
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message,
        });
    }
}



module.exports = {
    getAllKategori,
    getKategoriById,
    createKategori,
    updateupdateKategoriById,
    deleteKategoriById
}