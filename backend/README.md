# Siply Backend API

Complete REST API for the Siply drink tracking and social app.

## 🚀 Quick Start

### Prerequisites
- Node.js 16+ and npm
- PostgreSQL 14+

### Installation

1. **Clone and install dependencies:**
```bash
cd backend
npm install
```

2. **Set up database:**
```bash
# Create PostgreSQL database
createdb siply

# Run schema
psql siply < scripts/schema.sql
```

3. **Configure environment:**
```bash
cp .env.example .env
# Edit .env with your database credentials and JWT secret
```

4. **Start server:**
```bash
# Development with auto-reload
npm run dev

# Production
npm start
```

Server runs on `http://localhost:3000`

## 📚 API Documentation

### Authentication

#### Register
```http
POST /api/auth/register
Content-Type: application/json

{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "securepass123",
  "displayName": "John Doe"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "johndoe",
  "password": "securepass123"
}
```

#### Get Current User
```http
GET /api/auth/me
Authorization: Bearer <token>
```

### Drinks

#### Get All Drinks
```http
GET /api/drinks?category=Coffee&minRating=4&limit=20
Authorization: Bearer <token>
```

#### Create Drink
```http
POST /api/drinks
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Cappuccino",
  "category": "Coffee",
  "rating": 4.5,
  "price": 5.50,
  "notes": "Perfect foam!",
  "locationName": "Blue Bottle",
  "locationCity": "San Francisco",
  "locationCountry": "USA",
  "latitude": 37.7749,
  "longitude": -122.4194
}
```

#### Update Drink
```http
PUT /api/drinks/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "rating": 5.0,
  "isFavorite": true
}
```

#### Delete Drink
```http
DELETE /api/drinks/:id
Authorization: Bearer <token>
```

### Users

#### Get User Profile
```http
GET /api/users/:username
Authorization: Bearer <token>
```

#### Update Profile
```http
PUT /api/users/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "displayName": "John Smith",
  "bio": "Coffee enthusiast",
  "favoriteDrink": "Espresso"
}
```

### Social

#### Follow User
```http
POST /api/social/follow/:userId
Authorization: Bearer <token>
```

#### Get Feed
```http
GET /api/social/feed?limit=20&offset=0
Authorization: Bearer <token>
```

#### Like Drink
```http
POST /api/social/likes/:drinkId
Authorization: Bearer <token>
```

### Venues

#### Get All Venues
```http
GET /api/venues?city=San Francisco&category=Coffee
```

#### Get Venue Details
```http
GET /api/venues/:id
```

#### Get Nearby Venues
```http
GET /api/venues/nearby?latitude=37.7749&longitude=-122.4194&radius=5
```

### Achievements

#### Get User Achievements
```http
GET /api/achievements/user
Authorization: Bearer <token>
```

## 🗄️ Database Schema

### Core Tables
- **users** - User accounts and profiles
- **drinks** - Logged drinks
- **venues** - Coffee shops, bars, restaurants
- **discounts** - Venue discounts and deals
- **loyalty_programs** - Loyalty card programs
- **follows** - Social connections
- **likes** - Drink likes
- **comments** - Drink comments
- **achievements** - Achievement definitions
- **user_achievements** - Unlocked achievements

## 🔐 Security Features

- JWT authentication
- Password hashing with bcrypt
- Rate limiting
- Helmet.js security headers
- Input validation
- SQL injection protection
- CORS configuration

## 📊 Response Format

### Success Response
```json
{
  "message": "Operation successful",
  "data": { ... }
}
```

### Error Response
```json
{
  "error": "ErrorType",
  "message": "Descriptive error message"
}
```

## 🧪 Testing

```bash
# Run tests
npm test

# Run with coverage
npm run test:coverage
```

## 📝 Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| PORT | Server port | 3000 |
| NODE_ENV | Environment | development |
| DB_HOST | Database host | localhost |
| DB_PORT | Database port | 5432 |
| DB_NAME | Database name | siply |
| JWT_SECRET | JWT signing key | (required) |
| JWT_EXPIRES_IN | Token expiry | 7d |

## 🚢 Deployment

### Docker
```bash
docker build -t siply-backend .
docker run -p 3000:3000 --env-file .env siply-backend
```

### Heroku
```bash
heroku create siply-api
heroku addons:create heroku-postgresql:hobby-dev
git push heroku main
```

## 📈 Performance

- Connection pooling for database
- Query optimization with indexes
- Rate limiting to prevent abuse
- Efficient pagination
- Caching strategies (Redis recommended)

## 🔄 API Versioning

Currently on v1. Future versions will be available at `/api/v2/...`

## 📞 Support

For issues and questions, please open an issue on GitHub or contact the development team.

## 📄 License

MIT License - see LICENSE file for details


