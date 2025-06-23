const express = require('express');
const router = express.Router();
const { isAdmin, verifyUser } = require('../middleware/auth');
const { uploadUser } = require('../middleware/upload')
const userController = require('../controllers/userController');

router.get('/', verifyUser, userController.getAllUser);
router.get('/email/:email', verifyUser, userController.getUserByEmail)
router.get('/username/:username', verifyUser, userController.getUserByUsername);
router.post('/admin', verifyUser, isAdmin, uploadUser, userController.createAdminUser);
router.patch('/:userId', verifyUser, uploadUser, userController.updateUserById);


module.exports = router;