import { API_URL } from "../constants/api";
import { storageService } from "./storage.service";

export const authService = {
  login: async (username: string, password: string) => {
    try {
      console.log(`Attempting login at ${API_URL}/auth/login`);

      const response = await fetch(`${API_URL}/auth/login`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username, password }),
      });

      const data = await response.json();

      if (!response.ok) {
        alert(data.message || "Login failed");
        return { success: false, message: data.message };
      }

      // Save tokens to SecureStore
      await storageService.saveAuth(data.accessToken, data.refreshToken);

      return {
        success: true,
        user: data.user,
      };
    } catch (error) {
      console.error("Login Error:", error);
      alert("Network error. Is the backend running?");
      return { success: false, error };
    }
  },

  register: async (userData: any) => {
    try {
      const { username, email, displayName, password } = userData;

      const response = await fetch(`${API_URL}/auth/register`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          username,
          email,
          displayName,
          password,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        alert(data.message || "Registration failed");
        return { success: false };
      }

      // Auto-login after register by saving tokens
      await storageService.saveAuth(data.accessToken, data.refreshToken);

      return { success: true, user: data.user };
    } catch (error) {
      console.error("Register Error:", error);
      alert("Network error during registration.");
      return { success: false };
    }
  },

  logout: async () => {
    await storageService.clearAuth();
  },

  // Check if we have a valid token on app launch
  checkAuthState: async (): Promise<boolean> => {
    try {
      const token = await storageService.getAccessToken();
      if (!token) return false;

      // Optional: Verify token with backend /me endpoint
      const response = await fetch(`${API_URL}/auth/me`, {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (response.ok) {
        return true;
      } else {
        // Token might be expired, try to refresh (Optional complexity for later)
        // For now, if /me fails, we log out
        await storageService.clearAuth();
        return false;
      }
    } catch (e) {
      return false;
    }
  },
};
