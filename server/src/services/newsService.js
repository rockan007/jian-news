const axios = require('axios');
const { getCache, setCache } = require('../config/redis');

const NEWS_API_KEY = process.env.NEWS_API_KEY;
const BASE_URL = 'https://newsapi.org/v2';

/**
 * Get top headlines
 * 
 * @param {Object} params - Query parameters
 * @param {string} params.country - 2-letter ISO 3166-1 country code
 * @param {string} params.category - News category
 * @param {number} params.page - Page number
 * @param {number} params.pageSize - Number of results per page
 */
const getTopHeadlines = async (params = {}) => {
  const cacheKey = `headlines:${JSON.stringify(params)}`;
  
  // Try to get from cache first
  const cachedData = await getCache(cacheKey);
  if (cachedData) {
    return cachedData;
  }
  
  try {
    const response = await axios.get(`${BASE_URL}/top-headlines`, {
      params: {
        ...params,
        apiKey: NEWS_API_KEY
      }
    });
    
    // Cache the results
    await setCache(cacheKey, response.data);
    
    return response.data;
  } catch (error) {
    console.error('Error fetching top headlines:', error.message);
    throw error;
  }
};

/**
 * Search for news articles
 * 
 * @param {Object} params - Query parameters
 * @param {string} params.q - Search query
 * @param {string} params.from - Start date (YYYY-MM-DD)
 * @param {string} params.to - End date (YYYY-MM-DD)
 * @param {string} params.language - 2-letter ISO-639-1 language code
 * @param {number} params.page - Page number
 * @param {number} params.pageSize - Number of results per page
 */
const searchNews = async (params = {}) => {
  if (!params.q) {
    throw new Error('Search query is required');
  }
  
  const cacheKey = `search:${JSON.stringify(params)}`;
  
  // Try to get from cache first
  const cachedData = await getCache(cacheKey);
  if (cachedData) {
    return cachedData;
  }
  
  try {
    const response = await axios.get(`${BASE_URL}/everything`, {
      params: {
        ...params,
        apiKey: NEWS_API_KEY
      }
    });
    
    // Cache the results
    await setCache(cacheKey, response.data);
    
    return response.data;
  } catch (error) {
    console.error('Error searching news:', error.message);
    throw error;
  }
};

module.exports = {
  getTopHeadlines,
  searchNews
}; 