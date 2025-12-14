const express = require('express')
const app = express()
const path = require('path');
const komentarRoutes = require('./routes/komentarRoutes.js');
const dotenv = require("dotenv");
const cors = require('cors');
const loggRequestMiddleware = require("../src/middleware/logs")
dotenv.config();
const PORT = process.env.PORT || 7000;
const serviceName = process.env.SERVICE_NAME || 'comment-service';

app.use(express.json());
app.use(cors({
    origin: '*',
    methods: "GET,POST,PUT,PATCH,DELETE,OPTIONS",
    allowedHeaders: "Content-Type, Authorization",
}));
app.use('/public', express.static(path.join(__dirname, '..', 'public')))
app.use(loggRequestMiddleware)
app.get('/', (req, res) => {
    res.send('Server Berjalan')
})
app.get('/health', (req, res) => res.json({ ok: true, service: 'comment-service' }));
app.use('/komentar', komentarRoutes);


app.use((req, res) => {
    res.status(404).json({
        status: 404,
        message: 'Not Found!'
    })
})
app.listen(PORT, () => {
    console.log(`${serviceName} running in http://localhost:${PORT}`)
})

