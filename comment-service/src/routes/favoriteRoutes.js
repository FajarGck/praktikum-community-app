const express = require('express');
const router = express.Router();
const { verifyUser } = require('../middleware/auth');
const favoritController = require('../controllers/favoriteController');

router.get('/', verifyUser, favoritController.getFavoritByUserId);
router.post('/toggle/:modulId', verifyUser, favoritController.toggleFavorit);
router.get('/status/:modulId', verifyUser, favoritController.checkIsFavorited);


module.exports = router;