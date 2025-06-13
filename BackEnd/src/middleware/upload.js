const multer = require('multer');
const path = require('path');
const crypto = require('crypto');
const PUBLIC_PATH = path.join(__dirname, '..', '..', 'public');
const makeStorage = (folder) =>  multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, path.join(PUBLIC_PATH, 'images', folder));
    }, 
    filename: (req, file, cb) => {
        const ext = path.extname(file.originalname);
        const fileName = `${Date.now()}-${crypto.randomUUID()}${ext}`;
        cb(null, fileName);
    }
})


const fileFilter = (req, file, cb) => {
    const allowedFiles = ['image/jpeg', 'image/jpg', 'image/png'].includes(file.mimetype);
    cb(allowedFiles ? null : new Error('File Type Not Allowed!'), allowedFiles);
}

const uploadUser = multer({ storage: makeStorage('users'), fileFilter: fileFilter, limits: { fileSize: 1000000}}).single('foto_profile');
const uploadModul = multer({ storage: makeStorage('moduls'), fileFilter: fileFilter, limits: { fileSize: 1000000}}).single('thumbnail_url');
const uploadLangkah = multer({ storage: makeStorage('langkah'), fileFilter: fileFilter, limits: { fileSize: 1000000}}).single('foto_langkah');

module.exports = {
    uploadUser,
    uploadModul,
    uploadLangkah
}