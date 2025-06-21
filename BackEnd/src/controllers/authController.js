const { filterUsersResponse } = require('../../utils/userUtils');
const userService = require('../services/userService');
const argon2  = require('argon2');
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
dotenv.config();
const TOKEN_SECRET = process.env.TOKEN_SECRET;


const login = async (req, res) => {
    const { username, password } = req.body;
    try {
        const user = await userService.getUserByUsername(username);
        if (!user) {
            return res.status(404).json({
                code: 404,
                message: 'User not found'
            });
        }

        const isPasswordValid = await argon2.verify(user.password, password);
        if (!isPasswordValid) {
            return res.status(401).json({
                code: 401,
                message: 'Invalid password'
            });
        }
        const payload = {
            user_id : user.user_id,
            username: user.username,
            email: user.email,
            role: user.role,
            foto_profil: user.foto_profil,
            created_at: user.created_at,
            updated_at: user.updated_at,
            
        };

        const token = jwt.sign(
            payload,
            TOKEN_SECRET,
            { expiresIn: '10m' }
        )
        res.status(200).json({
            code: 200,
            message: 'Login successful',
            data: {
                token: token,
                user: filterUsersResponse(user)
            }
        });
    } catch (error) {
        res.status(500).json({
            code: 404,
            message: error.message
        });
    }
}

const me = (req, res) => {
    res.status(200).json(req.user);
}

const logout = (req, res) => {
    res.status(200).json({
        code: 200,
        message: 'Logout successfull!'
    })
}


module.exports = {
    login,
    me,
    logout
};