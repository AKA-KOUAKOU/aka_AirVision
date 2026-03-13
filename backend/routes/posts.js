const express = require('express');
const router = express.Router();

// Mock posts database (replace with PostgreSQL)
const posts = [
  { id: 1, content: 'Welcome to AirVision!', user: 'Admin', timestamp: new Date() }
];

router.get('/', (req, res) => {
  res.json(posts);
});

router.post('/', (req, res) => {
  const { content, user } = req.body;
  const newPost = { id: posts.length + 1, content, user, timestamp: new Date() };
  posts.push(newPost);
  res.status(201).json(newPost);
});

module.exports = router;
