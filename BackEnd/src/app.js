const express = require('express')
const app = express()
const path = require('path');
const userRoutes = require('./routes/userRoutes');
const authRoutes = require('./routes/authRoutes');
const kategoriRoutes = require('./routes/kategoriRoutes');
const dotenv = require("dotenv");
const cors = require('cors');
const loggRequestMiddleware = require("../src/middleware/logs")
dotenv.config();
const PORT = process.env.PORT || 7000;

app.use(express.json());
app.use(cors({
    credentials: true,
    origin: 'http://localhost:5005'
}));
app.use('/public', express.static(path.join(__dirname, '..', 'public')))
app.use(loggRequestMiddleware)
app.get('/', (req, res) => {
    res.send('Server Berjalan')
})
app.use('/users', userRoutes)
app.use('/auth', authRoutes)
app.use('/kategori', kategoriRoutes)

app.use((req, res) => {
    res.status(404).json({
        status: 404,
        message: 'Not Found!'
    })
})
app.listen(PORT, () => {
    console.log(`Server running in http://localhost:${PORT}`)
})

