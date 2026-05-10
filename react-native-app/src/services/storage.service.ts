import * as SecureStore from "expo-secure-store";

const ACCESS_TOKEN_KEY = "siply_access_token";
const REFRESH_TOKEN_KEY = "siply_refresh_token";

export const storageService = {
  saveAuth: async (accessToken: string, refreshToken: string) => {
    await SecureStore.setItemAsync(ACCESS_TOKEN_KEY, accessToken);
    await SecureStore.setItemAsync(REFRESH_TOKEN_KEY, refreshToken);
  },

  getAccessToken: async () => {
    return await SecureStore.getItemAsync(ACCESS_TOKEN_KEY);
  },

  getRefreshToken: async () => {
    return await SecureStore.getItemAsync(REFRESH_TOKEN_KEY);
  },

  clearAuth: async () => {
    await SecureStore.deleteItemAsync(ACCESS_TOKEN_KEY);
    await SecureStore.deleteItemAsync(REFRESH_TOKEN_KEY);
  },
};
