import { API_URL } from "../constants/api"; // From previous step
import { storageService } from "./storage.service"; // From previous step

export const api = {
  get: async (endpoint: string) => {
    const token = await storageService.getAccessToken();

    const headers: HeadersInit = {
      "Content-Type": "application/json",
    };

    if (token) {
      headers["Authorization"] = `Bearer ${token}`;
    }

    try {
      const response = await fetch(`${API_URL}${endpoint}`, {
        method: "GET",
        headers,
      });

      if (response.status === 401) {
        // Token expired - in a real app, trigger refresh token flow here
        // For now, we might want to return null or throw
        console.warn("Unauthorized access");
      }

      return await response.json();
    } catch (error) {
      console.error(`GET ${endpoint} failed:`, error);
      throw error;
    }
  },

  // We can add post/put/delete later as needed
};
