const express = require('express');
const newsService = require('../services/newsService');

const router = express.Router();

// GET /api/news/headlines
router.get('/headlines', async (req, res) => {
  try {
    const { country = 'us', category, page = 1, pageSize = 20 } = req.query;
    
    const params = {
      country,
      page: parseInt(page),
      pageSize: parseInt(pageSize)
    };
    
    if (category) {
      params.category = category;
    }
    
    const data = await newsService.getTopHeadlines(params);
    res.json(data);
  } catch (error) {
    console.error('Headlines route error:', error);
    res.status(error.response?.status || 500).json({
      message: error.message,
      status: 'error'
    });
  }
});

// GET /api/news/search
router.get('/search', async (req, res) => {
  try {
    const { q, from, to, language = 'en', page = 1, pageSize = 20 } = req.query;
    
    if (!q) {
      return res.status(400).json({
        message: 'Search query is required',
        status: 'error'
      });
    }
    
    const params = {
      q,
      language,
      page: parseInt(page),
      pageSize: parseInt(pageSize)
    };
    
    if (from) params.from = from;
    if (to) params.to = to;
    
    const data = await newsService.searchNews(params);
    res.json(data);
  } catch (error) {
    console.error('Search route error:', error);
    res.status(error.response?.status || 500).json({
      message: error.message,
      status: 'error'
    });
  }
});

// GET /api/news/categories
router.get('/categories', (req, res) => {
  // NewsAPI.org supported categories
  const categories = [
    'business', 
    'entertainment', 
    'general', 
    'health', 
    'science', 
    'sports', 
    'technology'
  ];
  
  res.json({
    categories,
    status: 'ok'
  });
});

module.exports = router; 