# Siply Backend - Quick Start Guide

## ⚡ Fastest Way to Start

### Option 1: Automated Setup (Recommended)
```bash
cd backend
./scripts/setup.sh
npm run dev
```

### Option 2: Docker (Easiest - includes database)
```bash
cd backend
docker-compose up
```
API will be at http://localhost:3000

### Option 3: Manual Setup
```bash
# 1. Install dependencies
cd backend
npm install

# 2. Create database
createdb siply
psql siply < scripts/schema.sql

# 3. Configure environment
cp .env.example .env
# Edit .env with your settings

# 4. Add sample data
node scripts/seed.js

# 5. Start server
npm run dev
```

## 🧪 Test the API

### Register a user
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123",
    "displayName": "Test User"
  }'
```

### Login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123"
  }'
```

Save the returned `token` for authenticated requests.

### Create a drink (requires token)
```bash
curl -X POST http://localhost:3000/api/drinks \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "name": "Cappuccino",
    "category": "Coffee",
    "rating": 4.5,
    "price": 5.50,
    "locationName": "Starbucks",
    "locationCity": "San Francisco",
    "locationCountry": "USA"
  }'
```

## 📡 API Endpoints

### Authentication
- `POST /api/auth/register` - Create new account
- `POST /api/auth/login` - Login
- `GET /api/auth/me` - Get current user

### Drinks
- `GET /api/drinks` - List your drinks
- `POST /api/drinks` - Log new drink
- `PUT /api/drinks/:id` - Update drink
- `DELETE /api/drinks/:id` - Delete drink
- `GET /api/drinks/trending/all` - Trending drinks

### Social
- `GET /api/social/feed` - Get feed from followed users
- `POST /api/social/follow/:userId` - Follow user
- `DELETE /api/social/follow/:userId` - Unfollow user
- `POST /api/social/likes/:drinkId` - Like drink
- `POST /api/social/comments/:drinkId` - Add comment

### Venues
- `GET /api/venues` - List venues
- `GET /api/venues/:id` - Venue details
- `GET /api/venues/nearby/search` - Nearby venues
- `GET /api/venues/discounts/student` - Student discounts
- `GET /api/venues/discounts/happy-hour` - Happy hour deals

### Users
- `GET /api/users/:username` - User profile
- `PUT /api/users/profile` - Update profile
- `GET /api/users/:username/drinks` - User's drinks
- `GET /api/users/:username/stats` - User stats

### Achievements
- `GET /api/achievements` - All achievements
- `GET /api/achievements/user` - Your achievements
- `POST /api/achievements/check` - Check for new achievements

## 🔑 Test Credentials (after seeding)

- Username: `johndoe` Password: `password123`
- Username: `sarahchen` Password: `password123`
- Username: `mikej` Password: `password123`

## 🛠️ Development Commands

```bash
npm start          # Production mode
npm run dev        # Development with auto-reload
npm test           # Run tests
```

## 📊 Database Access

```bash
# Connect to database
psql siply

# View tables
\dt

# View users
SELECT * FROM users;

# View drinks
SELECT * FROM drinks;
```

## 🐛 Troubleshooting

**Port already in use:**
```bash
# Find and kill process on port 3000
lsof -ti:3000 | xargs kill -9
```

**Database connection failed:**
```bash
# Start PostgreSQL
brew services start postgresql  # macOS
sudo service postgresql start   # Linux
```

**Reset database:**
```bash
dropdb siply
createdb siply
psql siply < scripts/schema.sql
node scripts/seed.js
```

## 📝 Next Steps

1. Connect iOS app to backend
2. Add image upload (AWS S3 or Cloudinary)
3. Implement real-time features with WebSockets
4. Add push notifications
5. Deploy to production

## 🚀 Deploy

**Heroku:**
```bash
heroku create siply-api
heroku addons:create heroku-postgresql:hobby-dev
git push heroku main
```

**Railway:**
```bash
railway init
railway add postgresql
railway up
```

**Render:**
- Connect GitHub repo
- Add PostgreSQL database
- Deploy automatically

Happy coding! 🎉
