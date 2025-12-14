const komentarService = require('../services/komentarService');



const createKomentar = async (req, res) => {
    const userId = req.user.user_id;
    const { modul_id, isi_komentar, parent_id } = req.body;

    try {
        const komentarData = await komentarService.createKomentar({
            modul_id: parseInt(modul_id),
            user_id: userId,
            isi_komentar,
            parent_id: parent_id || null
        });

        res.status(201).json({
            code: 201,
            message: 'Komentar created successfully',
            data: komentarData
        })
    } catch (error) {
        res.status(400).json({
            code: 400,
            message: error.message
        })
    }
}


module.exports = {
    createKomentar
}