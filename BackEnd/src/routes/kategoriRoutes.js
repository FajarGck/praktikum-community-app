const express = require('express');
const router = express.Router();
const { isAdmin, verifyUser } = require('../middleware/auth');
const kategoriController = require('../controllers/kategoriController');


router.get('/', verifyUser, kategoriController.getAllKategori);
router.get('/:kategoriId', verifyUser, kategoriController.getKategoriById);
router.post('/', verifyUser, isAdmin, kategoriController.createKategori);
router.patch('/:kategoriId', verifyUser, isAdmin, kategoriController.updateupdateKategoriById);
router.delete('/:kategoriId', verifyUser, isAdmin, kategoriController.deleteKategoriById);

module.exports = router;