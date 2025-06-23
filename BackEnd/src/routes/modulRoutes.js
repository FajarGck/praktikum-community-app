const express = require('express');
const router = express.Router();
const { verifyUser } = require('../middleware/auth');
const modulController = require('../controllers/modulController');
const { uploadModul } = require('../middleware/upload');

router.get('/', verifyUser, modulController.getAllModulCard);
router.get('/card/:userId', verifyUser, modulController.getModulCardById)
router.get('/:modulId', verifyUser, modulController.getDetailModulById);
router.get('/search', verifyUser, modulController.searchModul);

router.post('/', verifyUser, uploadModul, modulController.createModul);
router.patch('/:modulId', verifyUser, uploadModul, modulController.updateModul);

module.exports = router;