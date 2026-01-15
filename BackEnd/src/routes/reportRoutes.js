const express = require('express');
const router = express.Router();
const { verifyUser, isAdmin } = require('../middleware/auth');
const reportController = require('../controllers/reportController');

// Route untuk membuat laporan baru
router.post('/', verifyUser, reportController.createReport);

// Route ADMIN: Melihat semua laporan (Wajib Admin)
router.get('/', verifyUser, isAdmin, reportController.getAllReports);

// Route ADMIN: Menyelesaikan laporan (Wajib Admin)
router.patch('/:reportId/resolve', verifyUser, isAdmin, reportController.resolveReport);

// Route USER: Melihat riwayat laporan user sendiri
// (Pastikan menggunakan getReportByUserId)
router.get('/:userId', verifyUser, reportController.getReportByUserId);

module.exports = router;