const multer = require('multer');
const path = require('path');
const crypto = require('crypto');
const PUBLIC_PATH = path.join(__dirname, '..', '..', 'public');

const makeStorage = (folder) => multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, path.join(PUBLIC_PATH, 'images', folder));
    },
    filename: (req, file, cb) => {
        const ext = path.extname(file.originalname);
        const fileName = `${Date.now()}-${crypto.randomUUID()}${ext}`;
        cb(null, fileName);
    }
});

const fileFilter = (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
        cb(null, true);
    } else {
        cb(new Error('File yang diupload harus berupa gambar!'), false);
    }
};

// .single() dipanggil di sini, dan hasilnya yang diekspor
const uploadUser = multer({ storage: makeStorage('users'), fileFilter }).single('foto_profile');
const uploadModul = multer({ storage: makeStorage('moduls'), fileFilter }).single('thumbnail_url');
const uploadLangkah = multer({ storage: makeStorage('langkah'), fileFilter }).single('foto_langkah');

module.exports = {
    uploadUser,
    uploadModul,
    uploadLangkah
};