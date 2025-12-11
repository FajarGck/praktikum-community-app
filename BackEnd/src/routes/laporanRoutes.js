const express = require('express');
const router = express.Router();
const { createLaporan } = require('../controllers/laporanController');
// PERBAIKAN DI SINI: Gunakan kurung kurawal {} untuk mengambil fungsi 'verifyUser'
const { verifyUser } = require('../middleware/auth'); 

// POST localhost:7000/laporan
// Gunakan 'verifyUser' sebagai middleware
router.post('/', verifyUser, createLaporan);

module.exports = router;