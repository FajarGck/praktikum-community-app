const userService = require('../services/userService');
const jwt = require('jsonwebtoken')
const fs = require('fs');
const path = require('path');
const TOKEN_SECRET = process.env.TOKEN_SECRET;
const publicKey = fs.readFileSync(path.join(__dirname, '..', '..', 'public.key'), 'utf8');

const verifyUser = async (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; 
    if (!authHeader || !token) {
        return res.status(401).json({
            code: 401,
            message: 'Please Login!'
        });
    }

    try {
        const decodedPayload = jwt.verify(token, publicKey, { algorithms: ['RS256'] })
        if (!decodedPayload) {
            return res.status(403).json({
                code: 403,
                message: 'Invalid Token!'
            })
        }

        req.user = decodedPayload;
        const user = await userService.getUserById(decodedPayload.user_id);
        if (!user) {
            return res.status(401).json({
                code: 404,
                message: 'User Not Found!'
            });
        }

      
        next();
    } catch (error) {
        if (error.name === 'TokenExpiredError' || error.name === 'JsonWebTokenError') {
            return res.status(403).json({ code: 403, message: 'Invalid or expired token!' });
          }
          console.error(err);
          return res.status(500).json({ code: 500, message: 'Internal Server Error' });
    }
}

const isAdmin = (req, res, next) => {
    // console.log(req.user);
    if (!req.user || req.user.role !== 'admin') {
        return res.status(403).json({
            code: 403,
            message: 'Access denied!.'
        });
        
    }
    next();
}


module.exports = {
    verifyUser,
    isAdmin
};