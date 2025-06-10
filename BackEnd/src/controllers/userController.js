const { filterUsersResponse } = require('../../utils/userUtils');
const userService = require('../services/userService');


const getAllUser = async (req, res) => {
    const users = await userService.getAllUser();
    try {
        res.status(200).json({
            status: {
                code: '200',
                message: 'ok!'
            },
            data: users
        })
    } catch (error) {
        res.status(400).json({
            status: {
                code: 400,
                message: error
            }
        })
    }
}

const createUser = async (req, res) => {
    try {
        const user = await userService.createUser(req.body);
        res.status(201).json({
            status: {
                code: 201,
                message: 'User created successfully'
            },
            data: filterUsersResponse(user)
        })
    } catch (error) {
        res.status(400).json({
            status: {
                code: 400,
                message: error.message
            }
        })
    }
}

const createAdminUser = async (req, res) => {
    try {
        const user = await userService.createUser(req.body, true);
        res.status(201).json({
            status: {
                code: 201,
                message: 'Admin created successfully'
            },
            data: filterUsersResponse(user)
        })
    } catch (error) {
        res.status(400).json({
            status: {
                code: 400,
                message: error.message
            }
        })
    } 
}


module.exports = {
    getAllUser,
    createUser,
    createAdminUser
}