const userRepository = require('../repository/userRepository');
const argon2 = require('argon2');

const getAllUser = async () => {
    const users = await userRepository.getAllUser();
    return users;
}

const getUserByUsername = async (username) => {
    if (!username) {
        throw new Error('Username is requires');
    }
    const user = await userRepository.getUserByUsername(username);
    if (!user) {
        throw new Error('User Not Found!');
    }
    return user;
}

const getUserById = async (userId) => {
    if (!userId) {
        throw new Error('User Id is requires');
    }
    const user = await userRepository.getUserById(userId);
    if (!user) {
        throw new Error('User Not Found!');
    }
    return user;
}

const createUser = async (userData, isAdmin = false) => {
    
    if (!userData) {
        throw new Error('User data is required');
       }
    const hashPassword = await argon2.hash(userData.password);

    const dataToSave = {
        user_id: userData.user_id,
        username: userData.username,
        password: hashPassword,
        email: userData.email,
        foto_profil: userData.foto_profil,
        role: isAdmin ? userData.role : 'user',
        created_at: new Date(),
        updated_at: new Date(), 
    }
    const user = await userRepository.createUser(dataToSave);

    return user;
}



module.exports = {
    getAllUser,
    getUserByUsername,
    getUserById,
    createUser,
}