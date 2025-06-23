const prisma = require('../config/db');


const createKomentar = async (komentarData) => {
    return await prisma.komentar.create({
        data: komentarData,
        include: {
            penulis: {
                select: {
                    user_id: true,
                    username: true,
                    foto_profil: true
                }
            }
        }
    })
}


module.exports = {
    createKomentar
}