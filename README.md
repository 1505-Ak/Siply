# Siply - Your Drink Discovery & Logging App

An iOS app where people review, rate, and discover drinks (cocktails, mocktails, coffees, bubble tea, craft beers, smoothies, etc.). Think of it as a social drink journal with discovery features.

## 🎯 Phase 1 MVP Features (Implemented)

### Core Features
✅ **Drink Logging & Tracking** - Personal drink journal with rich details
✅ **Automatic Location Logging** - GPS-based location capture for each drink
✅ **Discovery & Recommendations** - Trending drinks and personalized recommendations
✅ **Social Sharing & Community** - Public/private posts, likes, and shares
✅ **Interactive Map** - Visual exploration of drinks by location
✅ **Personal Journal** - View and filter all your logged drinks

### Design
- **Colorful, Minimalist UI** using brand colors:
  - Jade (#D0FF14) - Primary accent
  - Magenta (#6C244C) - Secondary accent
  - Charcoal (#3C4044) - Dark backgrounds
  - Light Brown (#BF875D) - Tertiary accent
- **Dark theme** optimized for modern iOS
- **Intuitive tab navigation** with 5 main sections

## 📱 App Structure

### Main Views
1. **Discover (Home)** - Trending drinks, recommendations, browse by category
2. **Map** - See all drinks plotted on an interactive map
3. **Log Drink** - Add new drinks with ratings, notes, photos, location
4. **Journal** - Personal collection with search, filter, and sort
5. **Profile** - User stats, favorite drinks, settings

### Architecture
- **MVVM Pattern** for clean separation of concerns
- **SwiftUI** for modern, declarative UI
- **Combine** for reactive data flow
- **UserDefaults** for data persistence (can be upgraded to Core Data later)
- **CoreLocation** for automatic location tracking
- **MapKit** for interactive maps

### Data Models
- `Drink` - Main drink model with ratings, location, notes, tags, etc.
- `User` - User profile with stats and preferences
- `DrinkCategory` - 11 drink categories with icons

### View Models
- `DrinkManager` - Handles all drink operations, filtering, recommendations
- `LocationManager` - GPS tracking and geocoding
- `UserManager` - User profile management

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- macOS 14.0+ for development

### Setup Instructions

1. **Open the Project**
   ```bash
   cd /Users/anulomekishore/Downloads/Siply
   open Siply.xcodeproj
   ```

2. **Configure Signing**
   - Select your development team in Xcode
   - Go to: Siply target → Signing & Capabilities
   - Choose your Apple Developer account

3. **Build and Run**
   - Select an iOS Simulator or device
   - Press ⌘R to build and run

### Required Permissions
The app requests:
- **Location When In Use** - For automatic drink location logging
- Permissions are configured in `Info.plist`

## 🎨 Features Breakdown

### 1. Drink Logging
- Choose from 11 drink categories (Cocktail, Coffee, Beer, Wine, etc.)
- Rate drinks from 1-5 stars
- Add detailed notes and tags
- Set price information
- Automatic GPS location capture
- Public/private visibility toggle

### 2. Discovery
- **Trending Now** - Most liked drinks
- **Recommendations** - Highest-rated drinks
- **Categories** - Browse by drink type
- Visual cards with ratings and locations

### 3. Map View
- Interactive map showing all logged drinks
- Custom markers with category icons
- Tap markers to see drink details
- Quick actions (favorite, view details)

### 4. Journal
- Complete drink history
- Search by name or location
- Filter by category
- Sort by date, rating, or name
- Stats dashboard (total drinks, locations, avg rating)

### 5. Profile
- User information and bio
- Favorite drink showcase
- Stats overview (drinks logged, locations visited, etc.)
- Recent activity feed
- Social stats (friends, followers, following)

## 📊 Key Features

### Smart Recommendations
- Algorithm sorts by rating and engagement
- Can be enhanced with ML in Phase 4

### Automatic Location
- Uses CoreLocation for precise GPS tracking
- Reverse geocoding for readable addresses
- Location suggestions similar to Uber

### Social Features
- Like/favorite drinks
- Share to social media (prepared for integration)
- Public/private posts
- Engagement metrics (likes, shares)

### Data Persistence
- UserDefaults for MVP (fast, simple)
- Easy to migrate to Core Data or SwiftData later
- Sample data included for testing

## 🔮 Future Enhancements (Phases 2-4)

### Phase 2 (Months 9-12)
- [ ] Events & Promotions
- [ ] Dashboard/Analytics (VIP)
- [ ] Enhanced map features

### Phase 3 (Year 2)
- [ ] Leaderboards & Challenges
- [ ] Taste Profile Builder (Spotify Wrapped style)
- [ ] Gamification elements

### Phase 4 (Year 2-3)
- [ ] AI-powered recommendations
- [ ] Integration with delivery apps
- [ ] AR label scanning
- [ ] Real social networking

## 🏗️ Technical Improvements for Production

### Before Launch
1. Replace UserDefaults with Core Data or SwiftData
2. Add backend API (Firebase, AWS, or custom)
3. Implement real authentication
4. Add image upload capability
5. Implement real social features
6. Add analytics (Mixpanel, Amplitude)
7. Set up crash reporting (Crashlytics)

### Backend Needed
- User authentication & profiles
- Cloud storage for drink data
- Image hosting (Cloudinary, S3)
- Social graph (friends, followers)
- Real-time feed updates
- Push notifications

## 🎯 Monetization Strategy

1. **Freemium Model**
   - Basic features free
   - VIP dashboard ($4.99/month)
   - Advanced analytics

2. **Partnerships**
   - Sponsored drinks/bars
   - Delivery app integrations
   - Event promotions

3. **Advertising**
   - Native ads in discovery feed
   - Sponsored challenges

## 📄 File Structure

```
Siply/
├── SiplyApp.swift              # App entry point
├── ContentView.swift           # Main tab navigation
├── Models/
│   ├── Drink.swift            # Drink data model
│   └── User.swift             # User data model
├── ViewModels/
│   ├── DrinkManager.swift     # Drink operations
│   ├── LocationManager.swift  # GPS & geocoding
│   └── UserManager.swift      # User management
├── Views/
│   ├── Home/
│   │   └── HomeView.swift     # Discovery & trending
│   ├── Map/
│   │   └── MapView.swift      # Interactive map
│   ├── AddDrink/
│   │   └── AddDrinkView.swift # Logging interface
│   ├── Journal/
│   │   └── JournalView.swift  # Personal collection
│   ├── Detail/
│   │   └── DrinkDetailView.swift # Drink details
│   └── Profile/
│       └── ProfileView.swift   # User profile
├── Theme/
│   └── ColorTheme.swift       # Brand colors
└── Info.plist                 # App configuration
```

## 👥 Team

- **Anulome** - Head of Tech
- **Arvin** - Head of Design and Marketing
- **Ashoka** - Head of Commercial and Sales

## 📝 Next Steps

1. **Test the App** - Run it in the simulator and test all features
2. **Add Your Team's Branding** - Update colors/logo if needed
3. **Prepare for TestFlight** - Set up Apple Developer account
4. **Backend Setup** - Choose and implement backend (Firebase recommended for MVP)
5. **YC Application** - Use this as proof of concept!

## 🐛 Known Limitations (MVP)

- No real backend (data stored locally)
- No user authentication
- No image upload (using emojis as placeholders)
- No real social networking
- Sample data for testing only

## 📞 Support

For questions or issues, contact the dev team or refer to the business plan in `Siply.pdf`.

---

**Built using swift, java, redis, and graphql**


