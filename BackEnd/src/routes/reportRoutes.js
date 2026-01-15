const express = require('express');
const router = express.Router();
const { verifyUser, isAdmin } = require('../middleware/auth');
const reportController = require('../controllers/reportController');
const reportController = require('../controllers/reportController');

router.post('/', verifyUser, reportController.createReport);
router.get('/', verifyUser, isAdmin, reportController.getAllReports);
router.patch('/:reportId/resolve', verifyUser, isAdmin, reportController.resolveReport);
router.get('/:userId', verifyUser, reportController.getReportById);
router.get('/:userId', verifyUser, reportController.getReportByUserId);

module.exports = router;
