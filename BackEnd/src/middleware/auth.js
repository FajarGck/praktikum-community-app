const userService = require('../services/userService');


const verifyUser = async (req, res, next) => {
    console.log("Session created:", req.session); 
    if (!req.session.user.user_id) {
        return res.status(401).json({
            status: {
                code: 401,
                message: 'Please Login!'
            }
        });
    }

    try {
        const user = await userService.getUserById(req.session.user.user_id);
        if (!user) {
            return res.status(401).json({
                status: {
                    code: 404,
                    message: 'User Not Found!'
                }
            });
        }

        req.user = user;
        next();

    } catch (error) {
        res.status(500).json({
            status: {
                code: 500,
                message: error.message
            }
        });
    }
}

const isAdmin = (req, res, next) => {
    if (!req.user || req.user.role !== 'admin') {
        return res.status(403).json({
            status: {
                code: 403,
                message: 'Access denied!.'
            }
        });
        
    }
    next();
}


module.exports = {
    verifyUser,
    isAdmin
};