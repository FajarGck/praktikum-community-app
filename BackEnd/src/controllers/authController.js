const { filterUsersResponse } = require('../../utils/userUtils');
const userService = require('../services/userService');
const argon2  = require('argon2');


const login = async (req, res) => {
    const { username, password } = req.body;
    try {
        const user = await userService.getUserByUsername(username);
        if (!user) {
            return res.status(404).json({
                status: {
                    code: 404,
                    message: 'User not found'
                }
            });
        }

        const isPasswordValid = await argon2.verify(user.password, password);
        if (!isPasswordValid) {
            return res.status(401).json({
                status: {
                    code: 401,
                    message: 'Invalid password'
                }
            });
        }

        req.session.user = {
            user_id: user.user_id,
            username: user.username,
            role: user.role
        };

        res.status(200).json({
            status: {
                code: 200,
                message: 'Login successful'
            },
            data: {
                user: filterUsersResponse(user),
                session: {
                    session_id: req.session.id,
                    user_id: req.session.user.user_id,
                    username: req.session.user.username,
                    role: req.session.user.role
                }
            }
        });
    } catch (error) {
        res.status(500).json({
            status: {
                code: 500,
                message: error.message + ' error🥴'
            }
        });
    }
}

const me = (req, res) => {

}

const logout = (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            res.status(500).json({
                status: {
                    code: 500,
                    message: err.message
                }
            })
        }

        res.status(200).json({
            status: {
                code: 200,
                message: 'Logout successfull!'
            },
            data: {
                user: filterUsersResponse(user),
                session: {
                    session_id: req.session.id,
                    user_id: req.session.user.user_id,
                    username: req.session.user.username,
                    role: req.session.user.role
                }
            }
        })
    })
}


module.exports = {
    login,
    logout
};