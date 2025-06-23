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
                mode: 'insensitive' 
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


module.exports = {
    getAllModulCard,
    getDetailModulById,
    getModulCardById,
    searchModulByJudul
}