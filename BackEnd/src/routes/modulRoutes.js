const express = require('express');
const router = express.Router();
const { verifyUser } = require('../middleware/auth');
const modulController = require('../controllers/modulController');


router.get('/', verifyUser, modulController.getAllModulCard);
router.get('/card/:userId', verifyUser, modulController.getModulCardById)
router.get('/:modulId', verifyUser, modulController.getDetailModulById);
router.get('/search', verifyUser, modulController.searchModul);

module.exports = router;