export const JWT_CONFIG = {
  secret: process.env.JWT_SECRET || 'change-me-super-secret-key',
  accessTtl: '1h', // Matches 3600000ms
  refreshTtlDays: 30, // Matches 2592000000ms
};