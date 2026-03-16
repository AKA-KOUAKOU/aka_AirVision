const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const authRoutes = require('./routes/auth');
const postsRoutes = require('./routes/posts');
const bookingsRoutes = require('./routes/bookings');
const productsRoutes = require('./routes/products');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/posts', postsRoutes);
app.use('/api/bookings', bookingsRoutes);
app.use('/api/products', productsRoutes);

app.get('/', (req, res) => {
  res.json({
    name: 'AirVision Backend API',
    version: '1.0.0',
    endpoints: [
      'POST /api/auth/register',
      'POST /api/auth/login',
      'GET  /api/posts',
      'POST /api/posts',
      'GET  /api/bookings',
      'POST /api/bookings',
      'GET  /api/products',
      'POST /api/products/order',
    ],
  });
});

// Socket.io – real-time social feed & notifications
io.on('connection', (socket) => {
  console.log('User connected:', socket.id);

  // New post broadcast
  socket.on('post:new', (post) => {
    io.emit('post:created', post);
  });

  // Like toggle broadcast
  socket.on('post:like', (data) => {
    io.emit('post:liked', data);
  });

  // Booking confirmation broadcast (to a specific user room)
  socket.on('booking:join', (userId) => {
    socket.join(`user:${userId}`);
  });

  socket.on('booking:confirm', (booking) => {
    io.to(`user:${booking.user}`).emit('booking:confirmed', booking);
  });

  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`AirVision server running on port ${PORT}`);
});

