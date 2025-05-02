# Jian News App

A news application built with Flutter (mobile app) and Node.js (backend server) that uses the NewsAPI.org API to fetch and display news articles.

## Features

- Browse top headlines by category
- Search for news articles
- View article details
- Share articles
- Open full articles in browser
- Light and dark theme support
- Content caching with Redis

## Project Structure

```
jian-news/
├── mobile/             # Flutter mobile app
│   ├── lib/
│   │   ├── models/     # Data models
│   │   ├── providers/  # State management
│   │   ├── screens/    # App screens
│   │   ├── widgets/    # Reusable UI components
│   │   └── main.dart   # Entry point
│   └── pubspec.yaml    # Flutter dependencies
│
└── server/             # Node.js backend server
    ├── src/
    │   ├── config/     # Configuration files
    │   ├── routes/     # API route handlers
    │   ├── services/   # Business logic
    │   └── index.js    # Entry point
    └── package.json    # Node.js dependencies
```

## Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Node.js](https://nodejs.org/) (v14 or later)
- [Redis](https://redis.io/download)
- [NewsAPI.org](https://newsapi.org/) API key

## Setup

### Backend Server

1. Create a `.env` file in the `server` directory:

```
PORT=3000
NEWS_API_KEY=your_newsapi_key_here
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
CACHE_TTL=3600
```

2. Install dependencies and start the server:

```bash
cd server
npm install
npm run dev
```

### Mobile App

1. Create a `.env` file in the `mobile` directory:

```
API_BASE_URL=http://YOUR_LOCAL_IP:3000/api
```

2. Install dependencies and run the app:

```bash
cd mobile
flutter pub get
flutter run
```

## API Endpoints

- `GET /api/news/headlines` - Get top headlines
  - Query params: `country`, `category`, `page`, `pageSize`
- `GET /api/news/search` - Search for news articles
  - Query params: `q`, `from`, `to`, `language`, `page`, `pageSize`
- `GET /api/news/categories` - Get list of available categories

## Dependencies

### Mobile App (Flutter)

- http: For API requests
- provider: State management
- cached_network_image: Loading and caching images
- intl: Date formatting
- share_plus: Sharing articles
- url_launcher: Opening URLs in browser
- flutter_dotenv: Loading environment variables

### Backend Server (Node.js)

- express: Web framework
- axios: HTTP client
- redis: Redis client
- dotenv: Environment variables
- cors: Cross-origin resource sharing

## License

MIT 