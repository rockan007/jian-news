const redis = require('redis');

let redisClient;

const initRedis = async () => {
  try {
    redisClient = redis.createClient({
      url: `redis://${process.env.REDIS_HOST}:${process.env.REDIS_PORT}`,
      password: process.env.REDIS_PASSWORD || undefined
    });

    redisClient.on('error', (err) => {
      console.error('Redis Error:', err);
    });

    await redisClient.connect();
    console.log('Redis connected successfully');
  } catch (error) {
    console.error('Redis connection failed:', error);
  }
};

const getCache = async (key) => {
  try {
    const data = await redisClient.get(key);
    return data ? JSON.parse(data) : null;
  } catch (error) {
    console.error('Redis get error:', error);
    return null;
  }
};

const setCache = async (key, data, ttl = process.env.CACHE_TTL || 3600) => {
  try {
    await redisClient.set(key, JSON.stringify(data), { EX: parseInt(ttl) });
  } catch (error) {
    console.error('Redis set error:', error);
  }
};

module.exports = {
  initRedis,
  getCache,
  setCache,
  getRedisClient: () => redisClient
}; 