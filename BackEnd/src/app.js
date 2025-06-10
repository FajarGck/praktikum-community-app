const express = require('express')
const app = express()
const userRoutes = require('./routes/userRoutes');
const authRoutes = require('./routes/authRoutes');
const dotenv = require("dotenv");
const session = require('express-session');
const MySQLStore = require('express-mysql-session')(session);
const cors = require('cors');
const loggRequestMiddleware = require("../src/middleware/logs")
dotenv.config();
const PORT = process.env.PORT || 7000;

const sessionStore = new MySQLStore({
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '',
    database: 'praktikum_comunity'
})

app.use(express.json());
app.use(session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    store: sessionStore,
    cookie: {
      secure: false,           
      httpOnly: true,
      sameSite: 'lax',         
      maxAge: 1000 * 60 * 60    // optional: 1 jam
    }
  }));
  

app.use(cors({
    credentials: true,
    origin: 'http://localhost:5005'
}));
app.use(loggRequestMiddleware)
app.get('/', (req, res) => {
    res.send('Server Berjalan')
})
app.use('/users', userRoutes)
app.use('/auth', authRoutes)

app.use((req, res) => {
    res.status(404).json({
        status: 404,
        message: 'Not Found!'
    })
})
app.listen(PORT, () => {
    console.log(`Server running in http://localhost:${PORT}`)
})

