import { API_URL } from "../constants/api";
import { timeAgo } from "../utils/date";
import { api } from "./api.service";
// If you don't want to install jwt-decode, we can store userId in storageService during login

// Helper to map backend category string to icon names
const getIconForCategory = (category: string) => {
  const map: any = {
    Coffee: "coffee",
    Cocktail: "glass-cocktail",
    Beer: "beer",
    "Bubble Tea": "cup",
    Wine: "glass-wine",
    Mocktail: "glass-cocktail-off",
  };
  return map[category] || "glass-drink";
};

export const drinkService = {
  // 1. Get Global Feed
  getFeed: async () => {
    try {
      const data = await api.get("/social/feed");

      // We need the Base URL (without /api) for images usually
      // If API_URL is http://localhost:3000/api, we want http://localhost:3000
      const BASE_HOST = API_URL.replace("/api", "");

      return data.map((post: any) => ({
        // IDs
        id: post.id, // Feed Post ID
        drinkId: post.drinkId, // Actual Drink ID

        // User Info
        user: {
          displayName: post.user.displayName || post.user.username,
          avatarUrl: post.user.avatarUrl
            ? `${BASE_HOST}${post.user.avatarUrl}`
            : null,
          // You can add logic for 'isMe' here if you decode the token
        },

        // Display Data
        time: timeAgo(post.createdAt),
        category: post.drink.category,
        drinkName: post.drink.name,
        rating: parseFloat(post.drink.rating),
        price: post.drink.price ? `$${post.drink.price}` : "",

        // Detailed Data (For the Detail Screen)
        notes: post.content || post.drink.notes,
        tags: post.drink.tags || [],
        location: post.drink.locationName || "Unknown Location",
        locationCity: post.drink.locationCity,

        // Coordinate Logic
        coordinates:
          post.drink.latitude && post.drink.longitude
            ? {
                latitude: parseFloat(post.drink.latitude),
                longitude: parseFloat(post.drink.longitude),
              }
            : null,

        // Stats
        likes: post.drink.likesCount || 0,
        comments: post.drink.commentsCount || 0,

        // Image Handling
        // If the URL starts with /uploads, prepend the host
        imageUrl: post.imageUrl
          ? post.imageUrl.startsWith("http")
            ? post.imageUrl
            : `${BASE_HOST}${post.imageUrl}`
          : null,
      }));
    } catch (error) {
      console.error("Feed error", error);
      return [];
    }
  },

  // 2. Get Trending Drinks
  getTrending: async () => {
    try {
      const data = await api.get("/drinks/trending/all");
      return data.map((drink: any) => ({
        id: drink.id,
        name: drink.name,
        rating: Math.round(parseFloat(drink.rating)),
        icon: getIconForCategory(drink.category),
      }));
    } catch (error) {
      return [];
    }
  },

  // 3. Get Discovery Venues
  // We fetch all venues but slice the array to return only 3 for the home screen
  getDiscovery: async () => {
    try {
      const data = await api.get("/venues");
      // Limit to 3 for the home screen "Discover" widget
      return data.slice(0, 3).map((venue: any) => ({
        id: venue.id,
        name: venue.name,
        icon: getIconForCategory(venue.category),
      }));
    } catch (error) {
      return [];
    }
  },

  // 4. Get Categories (Static for now, or fetch from backend if you add an endpoint)
  getCategories: async () => {
    return [
      { id: "c1", name: "Cocktail", icon: "glass-cocktail" },
      { id: "c2", name: "Mocktail", icon: "glass-cocktail-off" }, // Changed icon slightly
      { id: "c3", name: "Coffee", icon: "coffee" },
      { id: "c4", name: "Bubble Tea", icon: "cup" },
      { id: "c5", name: "Craft", i: "beer" }, // Kept 'i' to match your Home logic or normalize to 'icon'
    ];
  },
};
