const express = require('express');
const router = express.Router();
const { query } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

// Get user by username
router.get('/:username', authenticateToken, async (req, res, next) => {
  try {
    const result = await query(
      `SELECT id, username, display_name, bio, avatar_url, favorite_drink,
              followers_count, following_count, total_drinks, total_cities, total_countries,
              created_at, is_verified
       FROM users 
       WHERE username = $1 AND is_active = true`,
      [req.params.username]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'User not found' 
      });
    }

    const user = result.rows[0];

    // Check if current user follows this user
    const followResult = await query(
      'SELECT id FROM follows WHERE follower_id = $1 AND following_id = $2',
      [req.user.id, user.id]
    );

    res.json({
      ...user,
      isFollowing: followResult.rows.length > 0,
      isOwnProfile: user.id === req.user.id
    });
  } catch (error) {
    next(error);
  }
});

// Update current user profile
router.put('/profile', authenticateToken, async (req, res, next) => {
  try {
    const { displayName, bio, favoriteDrink, avatarUrl } = req.body;

    const result = await query(
      `UPDATE users 
       SET display_name = COALESCE($1, display_name),
           bio = COALESCE($2, bio),
           favorite_drink = COALESCE($3, favorite_drink),
           avatar_url = COALESCE($4, avatar_url),
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $5
       RETURNING id, username, display_name, bio, avatar_url, favorite_drink`,
      [displayName, bio, favoriteDrink, avatarUrl, req.user.id]
    );

    res.json({
      message: 'Profile updated successfully',
      user: result.rows[0]
    });
  } catch (error) {
    next(error);
  }
});

// Get user's drinks
router.get('/:username/drinks', authenticateToken, async (req, res, next) => {
  try {
    const { limit = 20, offset = 0 } = req.query;

    // Get user ID
    const userResult = await query(
      'SELECT id FROM users WHERE username = $1',
      [req.params.username]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'User not found' 
      });
    }

    const userId = userResult.rows[0].id;

    const result = await query(
      `SELECT d.*, 
              (SELECT COUNT(*) FROM likes WHERE drink_id = d.id) as likes_count,
              EXISTS(SELECT 1 FROM likes WHERE drink_id = d.id AND user_id = $1) as is_liked
       FROM drinks d
       WHERE d.user_id = $2
       ORDER BY d.created_at DESC
       LIMIT $3 OFFSET $4`,
      [req.user.id, userId, limit, offset]
    );

    res.json({
      drinks: result.rows,
      pagination: {
        limit: parseInt(limit),
        offset: parseInt(offset)
      }
    });
  } catch (error) {
    next(error);
  }
});

// Get user stats
router.get('/:username/stats', authenticateToken, async (req, res, next) => {
  try {
    const userResult = await query(
      'SELECT id FROM users WHERE username = $1',
      [req.params.username]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'User not found' 
      });
    }

    const userId = userResult.rows[0].id;

    // Get comprehensive stats
    const stats = await query(
      `SELECT 
        COUNT(DISTINCT d.id) as total_drinks,
        COUNT(DISTINCT d.location_city) as total_cities,
        COUNT(DISTINCT d.location_country) as total_countries,
        AVG(d.rating) as average_rating,
        COUNT(DISTINCT d.category) as categories_tried,
        MAX(d.created_at) as last_drink_date
       FROM drinks d
       WHERE d.user_id = $1`,
      [userId]
    );

    // Get category breakdown
    const categories = await query(
      `SELECT category, COUNT(*) as count
       FROM drinks
       WHERE user_id = $1
       GROUP BY category
       ORDER BY count DESC`,
      [userId]
    );

    // Get recent locations
    const recentLocations = await query(
      `SELECT DISTINCT location_city, location_country, COUNT(*) as visit_count
       FROM drinks
       WHERE user_id = $1 AND location_city IS NOT NULL
       GROUP BY location_city, location_country
       ORDER BY visit_count DESC
       LIMIT 5`,
      [userId]
    );

    res.json({
      stats: stats.rows[0],
      categories: categories.rows,
      recentLocations: recentLocations.rows
    });
  } catch (error) {
    next(error);
  }
});

// Search users
router.get('/search/query', authenticateToken, async (req, res, next) => {
  try {
    const { q, limit = 20 } = req.query;

    if (!q || q.length < 2) {
      return res.status(400).json({ 
        error: 'Bad Request',
        message: 'Search query must be at least 2 characters' 
      });
    }

    const result = await query(
      `SELECT id, username, display_name, avatar_url, followers_count, total_drinks
       FROM users
       WHERE (username ILIKE $1 OR display_name ILIKE $1)
         AND is_active = true
       ORDER BY followers_count DESC
       LIMIT $2`,
      [`%${q}%`, limit]
    );

    res.json({ users: result.rows });
  } catch (error) {
    next(error);
  }
});

module.exports = router;


