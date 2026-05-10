import { API_URL } from "../constants/api";
import { api } from "./api.service";

export const profileService = {
  getUserProfile: async () => {
    try {
      // 1. Get current user's identity
      const me = await api.get("/auth/me");
      if (!me || !me.username) return null;

      // 2. Get full public profile with stats
      const profile = await api.get(`/users/${me.username}`);
      const BASE_HOST = API_URL.replace("/api", "");

      // 3. Map to Frontend Model exactly as ProfileScreen expects
      return {
        id: profile.id,
        name: profile.displayName || profile.username,
        handle: `@${profile.username}`,
        followers: profile.followersCount || 0,
        following: profile.followingCount || 0,

        avatarUrl: profile.avatarUrl
          ? profile.avatarUrl.startsWith("http")
            ? profile.avatarUrl
            : `${BASE_HOST}${profile.avatarUrl}`
          : null,

        // ACTUAL STATS FROM DATABASE
        stats: {
          drinks: profile.totalDrinks || 0,
          avgRating: profile.avgRating
            ? Number(profile.avgRating).toFixed(1)
            : "0.0",
          cities: profile.totalCities || 0,
          countries: profile.totalCountries || 0,
        },

        signatureDrink: profile.favoriteDrink || "Not set",
        journalCount: profile.totalDrinks || 0,
      };
    } catch (error) {
      console.error("Profile fetch error", error);
      return null;
    }
  },

  getAchievementsOverview: async () => {
    return [];
  },
};
