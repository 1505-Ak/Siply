const express = require('express');
const router = express.Router();
const { query } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

// Get all achievements
router.get('/', async (req, res, next) => {
  try {
    const result = await query(
      'SELECT * FROM achievements ORDER BY requirement_value ASC',
      []
    );

    res.json({ achievements: result.rows });
  } catch (error) {
    next(error);
  }
});

// Get user's achievements
router.get('/user', authenticateToken, async (req, res, next) => {
  try {
    const result = await query(
      `SELECT a.*, ua.unlocked_at, ua.progress,
              CASE WHEN ua.id IS NOT NULL THEN true ELSE false END as is_unlocked
       FROM achievements a
       LEFT JOIN user_achievements ua ON a.id = ua.achievement_id AND ua.user_id = $1
       ORDER BY ua.unlocked_at DESC NULLS LAST, a.requirement_value ASC`,
      [req.user.id]
    );

    const unlocked = result.rows.filter(a => a.is_unlocked);
    const locked = result.rows.filter(a => !a.is_unlocked);

    res.json({
      unlocked,
      locked,
      stats: {
        total: result.rows.length,
        unlocked: unlocked.length,
        locked: locked.length
      }
    });
  } catch (error) {
    next(error);
  }
});

// Check and unlock achievements for user
router.post('/check', authenticateToken, async (req, res, next) => {
  try {
    // Get user stats
    const statsResult = await query(
      `SELECT 
        COUNT(DISTINCT d.id) as total_drinks,
        COUNT(DISTINCT d.location_city) as total_cities,
        COUNT(DISTINCT d.location_country) as total_countries,
        COUNT(DISTINCT d.category) as categories_tried,
        COUNT(DISTINCT CASE WHEN d.rating >= 5 THEN d.id END) as five_star_drinks
       FROM drinks d
       WHERE d.user_id = $1`,
      [req.user.id]
    );

    const stats = statsResult.rows[0];

    // Get all achievements not yet unlocked
    const achievementsResult = await query(
      `SELECT a.*
       FROM achievements a
       WHERE NOT EXISTS (
         SELECT 1 FROM user_achievements ua 
         WHERE ua.achievement_id = a.id AND ua.user_id = $1
       )`,
      [req.user.id]
    );

    const newlyUnlocked = [];

    // Check each achievement
    for (const achievement of achievementsResult.rows) {
      let shouldUnlock = false;

      switch (achievement.requirement_type) {
        case 'drinks_logged':
          shouldUnlock = stats.total_drinks >= achievement.requirement_value;
          break;
        case 'cities_visited':
          shouldUnlock = stats.total_cities >= achievement.requirement_value;
          break;
        case 'countries_visited':
          shouldUnlock = stats.total_countries >= achievement.requirement_value;
          break;
        case 'categories_tried':
          shouldUnlock = stats.categories_tried >= achievement.requirement_value;
          break;
        case 'five_star_drinks':
          shouldUnlock = stats.five_star_drinks >= achievement.requirement_value;
          break;
      }

      if (shouldUnlock) {
        await query(
          'INSERT INTO user_achievements (user_id, achievement_id) VALUES ($1, $2)',
          [req.user.id, achievement.id]
        );
        newlyUnlocked.push(achievement);
      }
    }

    res.json({
      message: newlyUnlocked.length > 0 ? 'New achievements unlocked!' : 'No new achievements',
      newlyUnlocked,
      stats
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;


