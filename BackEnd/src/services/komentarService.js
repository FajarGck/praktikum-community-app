const komentarRepository = require('../repository/komentarRepository');


const createKomentar = async (komentarData) => {
        if (!komentarData) {
            throw new Error('Komentar data is required');
        }

        const dataToSave = {
            modul_id: komentarData.modul_id,
            user_id: komentarData.user_id,
            isi_komentar: komentarData.isi_komentar,
            created_at: new Date(),
            parent_id: komentarData.parent_id || null,
        }

        const komentar = await komentarRepository.createKomentar(komentarData);
        return komentar;
}


module.exports = {
    createKomentar
}