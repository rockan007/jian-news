require('dotenv').config();
const express = require('express');
const cors = require('cors');
const newsRoutes = require('./routes/news');
const { initRedis } = require('./config/redis');

const app = express();
const PORT = process.env.PORT || 3000;

// Initialize Redis
initRedis();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/news', newsRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
}); 