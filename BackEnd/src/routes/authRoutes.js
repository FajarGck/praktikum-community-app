const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const userController = require('../controllers/userController');
const { uploadUser } = require('../middleware/upload');
const { verifyUser } = require('../middleware/auth');


router.post('/register', uploadUser, userController.createUser);
router.post('/login', authController.login);
router.get('/me', verifyUser, authController.me);
router.delete('/logout', authController.logout);




module.exports = router;