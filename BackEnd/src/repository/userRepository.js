const prisma = require('../config/db');

const getAllUser = async () => {
    return await prisma.users.findMany({
        orderBy: {
            created_at: 'desc'
        }
    });
}

const getUserByUsername = async (username) => {
    return await prisma.users.findFirst({
        where: {
            username: username
        }
    })
}

const getUserById = async (userId) => {
    return await prisma.users.findUnique({
        where: {
            user_id: userId
        }
    })
}

const getUserByEmail = async (userEmail) => {
    return await prisma.users.findUnique({
        where: {
            email: userEmail
        }
    })
}

const createUser = async (userData) => {
    return await prisma.users.create({
        data: {
            user_id: userData.user_id,
            username: userData.username,
            password: userData.password,
            email: userData.email,
            foto_profil: userData.foto_profil,
            created_at: new Date(),
            updated_at: new Date(),
            role: userData.role,
        }
    })
}

const updateUserById = async (userId, userData) => {
    return await prisma.users.update({
        where: {
            user_id: userId
        }, data: {
            user_id: userData.user_id,
            username: userData.username,
            password: userData.password,
            email: userData.email,
            foto_profil: userData.foto_profil,
            updated_at: new Date(),
        }
    })
}


module.exports = {
    getAllUser,
    getUserByUsername,
    getUserByEmail,
    getUserById,
    createUser,
    updateUserById
}