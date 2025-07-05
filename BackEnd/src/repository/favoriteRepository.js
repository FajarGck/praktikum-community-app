const prisma = require('../config/db');

const addFavorit = async (userId, modulId) => {
    return await prisma.favorit.create({
        data: {
            user_id: userId,
            modul_id: modulId,
        },
    });
};

const removeFavorit = async (userId, modulId) => {
    return await prisma.favorit.delete({
        where: {
            user_id_modul_id: { 
                user_id: userId,
                modul_id: modulId,
            },
        },
    });
};

const findFavorit = async (userId, modulId) => {
    return await prisma.favorit.findUnique({
        where: {
             user_id_modul_id: { 
                user_id: userId,
                modul_id: modulId,
            },
        },
    });
};

const getFavoritByUserId = async (userId) => {
    const favorits = await prisma.favorit.findMany({
        where: { user_id: userId },
        include: {
            modul: {
                select: {
                    modul_id: true,
                    judul: true,
                    deskripsi: true,
                    thumbnail_url: true,
                    penulis: {
                        select: {
                            user_id: true,
                            username: true,
                            foto_profil: true
                        }
                    },
                    kategori: true
                }
            }
        },
        orderBy: {
            created_at: 'desc',
        },
    });
    return favorits.map(fav => fav.modul);
};

module.exports = {
    addFavorit,
    removeFavorit,
    findFavorit,
    getFavoritByUserId,
};