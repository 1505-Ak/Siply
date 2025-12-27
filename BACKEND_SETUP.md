# 🚀 Siply Backend Setup & Integration Guide

## 📁 What Was Created

A complete Node.js/Express backend with PostgreSQL database has been created in the `/backend` directory:

```
backend/
├── server.js                 # Main server entry point
├── package.json              # Dependencies and scripts
├── .env                      # Environment configuration
├── config/
│   └── database.js          # PostgreSQL connection pool
├── middleware/
│   ├── auth.js              # JWT authentication
│   ├── errorHandler.js      # Error handling
│   └── rateLimiter.js       # Rate limiting
├── routes/
│   ├── auth.js              # Authentication endpoints
│   ├── users.js             # User management
│   ├── drinks.js            # Drink CRUD operations
│   ├── venues.js            # Venues and discounts
│   ├── social.js            # Social features (follow, like, comment)
│   └── achievements.js      # Achievements system
├── scripts/
│   ├── schema.sql           # Database schema
│   ├── seed.js              # Sample data seeder
│   └── setup.sh             # Automated setup script
├── Dockerfile               # Docker container config
├── docker-compose.yml       # Docker Compose setup
├── README.md                # Full API documentation
└── QUICK_START.md           # Quick start guide
```

## 🎯 Features Implemented

### ✅ Core Features
- **User Authentication** - JWT-based with bcrypt password hashing
- **Drink Management** - Full CRUD for logging drinks with ratings, photos, locations
- **Social Features** - Follow/unfollow users, like drinks, comment on posts
- **Feed System** - Personalized feed from followed users
- **Venues & Discounts** - Student discounts, happy hours, loyalty programs
- **Achievements** - Gamification with unlockable achievements
- **Location-Based** - Nearby venues, city/country tracking
- **Stats & Analytics** - User stats, drink trends, category breakdowns

### 🔐 Security
- JWT authentication with expiry
- Password hashing with bcryptjs
- Rate limiting (100 requests per 15 min)
- Helmet.js security headers
- SQL injection protection
- Input validation
- CORS configuration

### 📊 Database Schema
15 tables including:
- `users`, `drinks`, `venues`, `discounts`, `loyalty_programs`
- `follows`, `likes`, `comments`
- `achievements`, `user_achievements`
- `feed_posts`, `notifications`
- Optimized indexes for performance

## 🚀 Quick Start

### Option 1: Automated Setup (Recommended)
```bash
cd backend
./scripts/setup.sh
npm run dev
```

### Option 2: Docker (Includes Database)
```bash
cd backend
docker-compose up
```

### Option 3: Manual Setup
```bash
# 1. Install dependencies
cd backend
npm install

# 2. Start PostgreSQL (if not running)
brew services start postgresql  # macOS
# or
sudo service postgresql start   # Linux

# 3. Create database
createdb siply

# 4. Run schema
psql siply < scripts/schema.sql

# 5. (Optional) Add sample data
node scripts/seed.js

# 6. Start server
npm run dev
```

The API will be available at: **http://localhost:3000**

## 📡 API Endpoints Summary

### Authentication
```
POST   /api/auth/register      # Create account
POST   /api/auth/login         # Login
GET    /api/auth/me            # Get current user
POST   /api/auth/refresh       # Refresh token
```

### Drinks
```
GET    /api/drinks             # List drinks (with filters)
POST   /api/drinks             # Create drink
GET    /api/drinks/:id         # Get drink details
PUT    /api/drinks/:id         # Update drink
DELETE /api/drinks/:id         # Delete drink
GET    /api/drinks/trending/all # Trending drinks
```

### Social
```
GET    /api/social/feed                # Get feed
POST   /api/social/follow/:userId      # Follow user
DELETE /api/social/follow/:userId      # Unfollow user
GET    /api/social/followers/:userId   # Get followers
GET    /api/social/following/:userId   # Get following
POST   /api/social/likes/:drinkId      # Like drink
DELETE /api/social/likes/:drinkId      # Unlike drink
POST   /api/social/comments/:drinkId   # Add comment
GET    /api/social/comments/:drinkId   # Get comments
```

### Venues
```
GET    /api/venues                     # List venues
GET    /api/venues/:id                 # Venue details
GET    /api/venues/nearby/search       # Nearby venues
GET    /api/venues/discounts/student   # Student discounts
GET    /api/venues/discounts/happy-hour # Happy hour
```

### Users
```
GET    /api/users/:username            # User profile
PUT    /api/users/profile              # Update profile
GET    /api/users/:username/drinks     # User's drinks
GET    /api/users/:username/stats      # User stats
GET    /api/users/search/query         # Search users
```

### Achievements
```
GET    /api/achievements               # All achievements
GET    /api/achievements/user          # User achievements
POST   /api/achievements/check         # Check for new ones
```

## 📱 iOS Integration

### Step 1: Add APIClient to Your Project
The `APIClient.swift` file has been created in `Siply/Services/APIClient.swift`.

### Step 2: Update Your View Models
Replace local UserDefaults storage with API calls. Example:

```swift
import Combine

class DrinkManagerV2: ObservableObject {
    @Published var drinks: [Drink] = []
    private var cancellables = Set<AnyCancellable>()
    private let api = APIClient.shared
    
    func loadDrinks() {
        api.getDrinks()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error loading drinks: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    // Convert API drinks to local Drink model
                    self?.drinks = response.drinks.map { apiDrink in
                        // Map APIDrink to your Drink model
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func createDrink(_ drink: Drink) {
        let drinkCreate = DrinkCreate(
            name: drink.name,
            category: drink.category.rawValue,
            rating: drink.rating,
            price: drink.price,
            notes: drink.notes,
            locationName: drink.locationName,
            locationCity: drink.locationCity,
            locationCountry: drink.locationCountry,
            latitude: drink.latitude,
            longitude: drink.longitude
        )
        
        api.createDrink(drink: drinkCreate)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] response in
                    self?.loadDrinks() // Reload after creation
                }
            )
            .store(in: &cancellables)
    }
}
```

### Step 3: Add Login/Register Views
Create authentication views that use:
- `APIClient.shared.register(...)`
- `APIClient.shared.login(...)`

On successful login, the token is automatically saved.

### Step 4: Update Info.plist
Add this to allow localhost connections in development:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsLocalNetworking</key>
    <true/>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## 🧪 Testing the Backend

### 1. Register a Test User
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

### 2. Login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123"
  }'
```

Save the returned `token`.

### 3. Create a Drink
```bash
curl -X POST http://localhost:3000/api/drinks \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "name": "Cappuccino",
    "category": "Coffee",
    "rating": 4.5,
    "locationName": "Starbucks",
    "locationCity": "San Francisco"
  }'
```

### 4. Use Sample Data
```bash
cd backend
node scripts/seed.js
```

Test credentials:
- Username: `johndoe` / Password: `password123`
- Username: `sarahchen` / Password: `password123`

## 🔄 Migration Path

### Phase 1: Parallel Mode (Current)
- Keep UserDefaults working
- Add backend API integration
- Test both systems side-by-side

### Phase 2: Hybrid Mode
- New users → Backend only
- Existing users → Migrate data on first sync

### Phase 3: Backend Only
- Remove UserDefaults persistence
- 100% cloud-based

### Data Migration Script
```swift
func migrateLocalDataToBackend() {
    // Get all local drinks
    let localDrinks = DrinkManager.shared.drinks
    
    // Upload each to backend
    for drink in localDrinks {
        APIClient.shared.createDrink(drink: drink.toAPIModel())
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    print("Migrated: \(drink.name)")
                }
            )
            .store(in: &cancellables)
    }
}
```

## 🚢 Deployment Options

### Heroku (Free tier available)
```bash
heroku create siply-api
heroku addons:create heroku-postgresql:hobby-dev
git subtree push --prefix backend heroku main
```

### Railway (Free tier)
```bash
railway init
railway add postgresql
railway up
```

### Render (Free tier)
1. Connect GitHub repo
2. Select `backend` folder
3. Add PostgreSQL database
4. Auto-deploy on push

### DigitalOcean App Platform
1. Connect GitHub
2. Select Node.js
3. Add PostgreSQL database
4. Deploy

## 🛠️ Development Tips

### View Database
```bash
psql siply
\dt                    # List tables
SELECT * FROM users;   # Query users
SELECT * FROM drinks;  # Query drinks
```

### Reset Database
```bash
dropdb siply && createdb siply
psql siply < scripts/schema.sql
node scripts/seed.js
```

### Monitor Logs
```bash
# Development
npm run dev

# Docker
docker-compose logs -f api
```

### Test Endpoints
Use Postman, Insomnia, or curl to test all endpoints.
Import the API endpoints from `README.md`.

## 📝 Next Steps

### Immediate
1. ✅ Run `cd backend && ./scripts/setup.sh`
2. ✅ Test API with curl or Postman
3. ✅ Verify all endpoints work

### Short-term
1. Add authentication UI to iOS app
2. Integrate APIClient into existing view models
3. Test login → create drink → view feed flow
4. Add error handling and loading states

### Medium-term
1. Implement image upload (AWS S3 or Cloudinary)
2. Add push notifications
3. Implement real-time features (WebSockets)
4. Add search and filtering

### Long-term
1. Deploy to production
2. Set up CI/CD pipeline
3. Add analytics and monitoring
4. Scale database and API

## 🐛 Troubleshooting

**"Port 3000 already in use"**
```bash
lsof -ti:3000 | xargs kill -9
```

**"Database connection failed"**
```bash
brew services start postgresql  # Start PostgreSQL
psql postgres -c "CREATE DATABASE siply;"  # Create DB
```

**"npm not found"**
```bash
# Install Node.js from https://nodejs.org
# Or use nvm: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
```

**"Module not found"**
```bash
cd backend
rm -rf node_modules package-lock.json
npm install
```

## 📞 Support

For issues or questions:
1. Check `backend/README.md` for full API docs
2. Check `backend/QUICK_START.md` for quick reference
3. Review example API calls in documentation
4. Test endpoints with sample data

## 🎉 Summary

You now have:
- ✅ Complete REST API with authentication
- ✅ PostgreSQL database with optimized schema
- ✅ Social features (follow, like, comment)
- ✅ Venues, discounts, and loyalty programs
- ✅ Achievements and gamification
- ✅ iOS APIClient for seamless integration
- ✅ Docker support for easy deployment
- ✅ Comprehensive documentation
- ✅ Sample data and test credentials

**Start the backend now:**
```bash
cd backend
./scripts/setup.sh
npm run dev
```

Then test it:
```bash
curl http://localhost:3000/health
```

Happy coding! 🚀


