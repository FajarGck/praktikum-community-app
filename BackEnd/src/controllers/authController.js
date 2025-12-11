const { filterUsersResponse } = require('../../utils/userUtils');
const userService = require('../services/userService');
const argon2  = require('argon2');
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
const path = require('path');
dotenv.config();
const fs = require('fs');
const TOKEN_SECRET = process.env.TOKEN_SECRET;
// Pastikan path key benar sesuai struktur folder kamu
const privateKey = fs.readFileSync(path.join(__dirname, '..', '..', 'private.key'), 'utf8');
const publicKey = fs.readFileSync(path.join(__dirname, '..', '..', 'public.key'), 'utf8');

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

        // [UPDATE DI SINI] Masukkan status sanksi ke dalam payload token
        const payload = {
            user_id : user.user_id,
            username: user.username,
            email: user.email,
            role: user.role,
            can_upload: user.can_upload, // <--- PENTING: Tambahkan ini
            foto_profil: user.foto_profil,
            created_at: user.created_at,
            updated_at: user.updated_at,
        };

        const token = jwt.sign(
            payload,
            privateKey,
            { 
             expiresIn: '1h',
             algorithm: 'RS256',
            }
        )

        // [UPDATE DI SINI] Pastikan data user yang dikirim ke Flutter punya field can_upload
        // Kita gabungkan hasil filter dengan field can_upload manual agar terbawa
        const userResponse = {
            ...filterUsersResponse(user),
            can_upload: user.can_upload // <--- Pastikan ini terkirim
        };

        res.status(200).json({
            code: 200,
            message: 'Login successful',
            data: {
                token: token,
                user: userResponse
            }
        });
    } catch (error) {
        res.status(500).json({
            code: 500, // Perbaiki code status error jadi 500
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