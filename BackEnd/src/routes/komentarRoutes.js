const express = require('express');
const router = express.Router();
const { verifyUser } = require('../middleware/auth');
const komentarController = require('../controllers/komentarController');



router.post('/', verifyUser, komentarController.createKomentar);

module.exports = router;