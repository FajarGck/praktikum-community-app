const prisma = require('../config/db');

const getAllUser = async () => {
    return await prisma.users.findMany();
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


module.exports = {
    getAllUser,
    getUserByUsername,
    getUserById,
    createUser,
}