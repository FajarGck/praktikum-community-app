const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { isAdmin, verifyUser } = require('../middleware/auth');

router.get('/', userController.getAllUser);
router.post('/', userController.createUser);
router.post('/admin', verifyUser, isAdmin, userController.createAdminUser);


module.exports = router;