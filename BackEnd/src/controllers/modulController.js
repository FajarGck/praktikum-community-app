const modulServcie = require('../services/modulService');



const getAllModulCard = async (req, res) => {
    const modulCard = await modulServcie.getAllModulCard();
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
        const modul = await modulServcie.getModulCardById(userId);
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
    const modul = await modulServcie.getDetailModulById(modulId);
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
        const modules = await modulServcie.searchModul(judul);
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

module.exports = {
    getAllModulCard,
    getModulCardById,
    getDetailModulById,
    searchModul
}