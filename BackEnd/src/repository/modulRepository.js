const prisma = require('../config/db');

const getAllModulCard = async () => {
    return await prisma.modul.findMany({
        where: {
            status: 'approved'
        },
        orderBy: {
            created_at: 'desc'
        },
        select: {
            modul_id: true,
            judul: true,
            deskripsi: true,
            thumbnail_url: true,
            created_at: true,
            penulis: {
                select: {
                    user_id: true,
                    username: true,
                    foto_profil: true
                }
            },
            kategori: {
                select: {
                    kategori_id: true,
                    nama_kategori: true
                }
            }
        }
    })
}

const getModulCardById = async (userId) => {
    return await prisma.modul.findMany({
        where: {
            penulis_id: userId
        },
         orderBy: {
            created_at: 'desc'
        }, 
        select: {
            modul_id: true,
            judul: true,
            deskripsi: true,
            thumbnail_url: true,
            created_at: true,
            penulis: {
                select: {
                    user_id: true,
                    username: true,
                    foto_profil: true
                }
            },
            kategori: {
                select: {
                    kategori_id: true,
                    nama_kategori: true
                }
            }
        }
    })
}

const getModulCardByKategori = async (kategoriId) => {
    return await prisma.modul.findMany({
        where: {
            kategori_id: kategoriId
        },
         orderBy: {
            created_at: 'desc'
        }, 
        select: {
            modul_id: true,
            judul: true,
            deskripsi: true,
            thumbnail_url: true,
            created_at: true,
            penulis: {
                select: {
                    user_id: true,
                    username: true,
                    foto_profil: true
                }
            },
            kategori: {
                select: {
                    kategori_id: true,
                    nama_kategori: true
                }
            }
        }
    })
} 

const getDetailModulById = async (modulId) =>{
    return await prisma.modul.findUnique({
        where: {
            modul_id: modulId
        },
        include: {
            penulis: {
                select: {
                    user_id: true,
                    username: true,
                    foto_profil: true,
                    email: true,
                    role: true,
                }
            },
            kategori: true,
            langkah: true,
            komentar: {
                orderBy: {
                    created_at: 'desc'
                },
                include: {
                    penulis: {
                        select: {
                            user_id: true,
                            username: true,
                            foto_profil: true
                        }
                    }
                }
            },
        }
    })
}

const searchModulByJudul = async (searchTerm) => {
    return await prisma.modul.findMany({
        where: {
            judul: {
                contains: searchTerm,
            },
            status: 'approved' 
        },
        orderBy: {
            created_at: 'desc'
        },
        select: {
            modul_id: true,
            judul: true,
            deskripsi: true,
            thumbnail_url: true,
            created_at: true,
            penulis: {
                select: {
                    user_id: true,
                    username: true,
                    foto_profil: true
                }
            },
            kategori: {
                select: {
                    kategori_id: true,
                    nama_kategori: true
                }
            }
        }
    });

}

const createModul = async (modulData, langkahData) => {
    return await prisma.$transaction(async (tx) => {
        const newModul = await tx.modul.create({
            data: {
                ...modulData,
                status: 'approved' 
            }
        });

        const langkahWithModulId = langkahData.map(langkah => ({
            ...langkah,
            modul_id: newModul.modul_id
        }));

        await tx.langkah.createMany({
            data: langkahWithModulId
        });

        return newModul;
    });
};


const updateModul = async (modulId, modulData, langkahData) => {
    return await prisma.$transaction(async (tx) => {
        const updatedModul = await tx.modul.update({
            where: { modul_id: modulId },
            data: modulData
        });

        await tx.langkah.deleteMany({
            where: { modul_id: modulId }
        });

        if (langkahData && langkahData.length > 0) {
            const langkahWithModulId = langkahData.map(langkah => ({
                ...langkah,
                modul_id: modulId
            }));
            await tx.langkah.createMany({
                data: langkahWithModulId
            });
        }

        return updatedModul;
    });
};


module.exports = {
    getAllModulCard,
    getDetailModulById,
    getModulCardByKategori,
    getModulCardById,
    searchModulByJudul,
    createModul,
    updateModul
}