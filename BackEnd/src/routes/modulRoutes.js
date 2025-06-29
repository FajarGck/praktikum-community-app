const express = require('express');
const router = express.Router();
const { verifyUser } = require('../middleware/auth');
const modulController = require('../controllers/modulController');
const { uploadModul } = require('../middleware/upload');

router.get('/search', verifyUser, modulController.searchModul);
router.get('/user/:userId', verifyUser, modulController.getModulCardById);
router.get('/kategori/:kategoriId', verifyUser, modulController.getModulCardByKategori);
router.get('/', verifyUser, modulController.getAllModulCard);
router.get('/:modulId', verifyUser, modulController.getDetailModulById);

router.post('/', verifyUser, uploadModul, modulController.createModul);
router.patch('/:modulId', verifyUser, uploadModul, modulController.updateModul);

module.exports = router;