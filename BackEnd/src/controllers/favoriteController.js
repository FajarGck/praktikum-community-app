const favoritService = require('../services/favoriteService');

const toggleFavorit = async (req, res) => {
    const userId = req.user.user_id;
    const { modulId } = req.params;
    const parsedModulId = parseInt(modulId, 10);
    if (isNaN(parsedModulId)) {
        return res.status(400).json({ code: 400, message: "Modul ID tidak valid." });
    }

    try {
        const result = await favoritService.toggleFavorit(userId, parsedModulId);
        res.status(200).json({
            code: 200,
            message: result.message,
            isFavorited: result.isFavorited
        });
    } catch (error) {
        console.error("!!! ERROR di toggleFavorit Controller:", error);
        res.status(400).json({
            code: 400,
            message: error.message,
        });
    }
};

const getFavoritByUserId = async (req, res) => {
    const userId = req.user.user_id;

    try {
        const moduls = await favoritService.getFavoritByUserId(userId);
        res.status(200).json({
            code: 200,
            message: 'OK',
            data: moduls,
        });
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message,
        });
    }
};

const checkIsFavorited = async (req, res) => {
    const userId = req.user.user_id;
    const { modulId } = req.params;

    const parsedModulId = parseInt(modulId, 10);
    if (isNaN(parsedModulId)) {
        return res.status(400).json({ code: 400, message: "Modul ID tidak valid." });
    }

    try {
        const isFavorited = await favoritService.checkIsFavorited(userId, parsedModulId);
        res.status(200).json({
            code: 200,
            isFavorited: isFavorited
        });
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message
        });
    }
};

module.exports = {
    toggleFavorit,
    getFavoritByUserId,
    checkIsFavorited
};