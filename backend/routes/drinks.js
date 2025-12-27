const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const { query, transaction } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

// Get all drinks (with filters)
router.get('/', authenticateToken, async (req, res, next) => {
  try {
    const { 
      category, 
      minRating, 
      city, 
      country, 
      limit = 50, 
      offset = 0,
      sortBy = 'created_at',
      sortOrder = 'DESC'
    } = req.query;

    let queryText = `
      SELECT d.*, u.username, u.display_name, u.avatar_url,
             (SELECT COUNT(*) FROM likes WHERE drink_id = d.id) as likes_count,
             EXISTS(SELECT 1 FROM likes WHERE drink_id = d.id AND user_id = $1) as is_liked
      FROM drinks d
      JOIN users u ON d.user_id = u.id
      WHERE d.user_id = $1
    `;
    
    const params = [req.user.id];
    let paramCount = 1;

    if (category) {
      paramCount++;
      queryText += ` AND d.category = $${paramCount}`;
      params.push(category);
    }

    if (minRating) {
      paramCount++;
      queryText += ` AND d.rating >= $${paramCount}`;
      params.push(minRating);
    }

    if (city) {
      paramCount++;
      queryText += ` AND d.location_city ILIKE $${paramCount}`;
      params.push(`%${city}%`);
    }

    if (country) {
      paramCount++;
      queryText += ` AND d.location_country ILIKE $${paramCount}`;
      params.push(`%${country}%`);
    }

    // Add sorting
    const validSortColumns = ['created_at', 'rating', 'price'];
    const validSortOrders = ['ASC', 'DESC'];
    const safeSortBy = validSortColumns.includes(sortBy) ? sortBy : 'created_at';
    const safeSortOrder = validSortOrders.includes(sortOrder.toUpperCase()) ? sortOrder.toUpperCase() : 'DESC';
    
    queryText += ` ORDER BY d.${safeSortBy} ${safeSortOrder}`;
    
    // Add pagination
    paramCount++;
    queryText += ` LIMIT $${paramCount}`;
    params.push(limit);
    
    paramCount++;
    queryText += ` OFFSET $${paramCount}`;
    params.push(offset);

    const result = await query(queryText, params);

    res.json({
      drinks: result.rows,
      pagination: {
        limit: parseInt(limit),
        offset: parseInt(offset),
        total: result.rowCount
      }
    });
  } catch (error) {
    next(error);
  }
});

// Get single drink
router.get('/:id', authenticateToken, async (req, res, next) => {
  try {
    const result = await query(
      `SELECT d.*, u.username, u.display_name, u.avatar_url,
              (SELECT COUNT(*) FROM likes WHERE drink_id = d.id) as likes_count,
              EXISTS(SELECT 1 FROM likes WHERE drink_id = d.id AND user_id = $2) as is_liked
       FROM drinks d
       JOIN users u ON d.user_id = u.id
       WHERE d.id = $1`,
      [req.params.id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Drink not found' 
      });
    }

    res.json(result.rows[0]);
  } catch (error) {
    next(error);
  }
});

// Create new drink
router.post('/', authenticateToken, [
  body('name').trim().notEmpty(),
  body('category').isIn(['Cocktail', 'Mocktail', 'Coffee', 'Bubble Tea', 'Craft Beer', 'Wine', 'Smoothie', 'Juice', 'Tea', 'Soda', 'Other']),
  body('rating').isFloat({ min: 0, max: 5 }),
  body('locationName').optional().trim()
], async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const {
      name,
      category,
      rating,
      price,
      notes,
      locationName,
      locationCity,
      locationCountry,
      latitude,
      longitude,
      imageUrl,
      tags
    } = req.body;

    const result = await query(
      `INSERT INTO drinks 
       (user_id, name, category, rating, price, notes, location_name, location_city, 
        location_country, latitude, longitude, image_url, tags)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
       RETURNING *`,
      [req.user.id, name, category, rating, price, notes, locationName, locationCity, 
       locationCountry, latitude, longitude, imageUrl, tags]
    );

    // Update user stats
    await query(
      `UPDATE users 
       SET total_drinks = total_drinks + 1
       WHERE id = $1`,
      [req.user.id]
    );

    // Check and update city/country counts
    if (locationCity) {
      await query(
        `UPDATE users 
         SET total_cities = (
           SELECT COUNT(DISTINCT location_city) 
           FROM drinks 
           WHERE user_id = $1 AND location_city IS NOT NULL
         )
         WHERE id = $1`,
        [req.user.id]
      );
    }

    if (locationCountry) {
      await query(
        `UPDATE users 
         SET total_countries = (
           SELECT COUNT(DISTINCT location_country) 
           FROM drinks 
           WHERE user_id = $1 AND location_country IS NOT NULL
         )
         WHERE id = $1`,
        [req.user.id]
      );
    }

    res.status(201).json({
      message: 'Drink created successfully',
      drink: result.rows[0]
    });
  } catch (error) {
    next(error);
  }
});

// Update drink
router.put('/:id', authenticateToken, async (req, res, next) => {
  try {
    const drinkId = req.params.id;

    // Check ownership
    const checkResult = await query(
      'SELECT user_id FROM drinks WHERE id = $1',
      [drinkId]
    );

    if (checkResult.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Drink not found' 
      });
    }

    if (checkResult.rows[0].user_id !== req.user.id) {
      return res.status(403).json({ 
        error: 'Forbidden',
        message: 'You can only update your own drinks' 
      });
    }

    const {
      name,
      category,
      rating,
      price,
      notes,
      locationName,
      locationCity,
      locationCountry,
      isFavorite
    } = req.body;

    const result = await query(
      `UPDATE drinks 
       SET name = COALESCE($1, name),
           category = COALESCE($2, category),
           rating = COALESCE($3, rating),
           price = COALESCE($4, price),
           notes = COALESCE($5, notes),
           location_name = COALESCE($6, location_name),
           location_city = COALESCE($7, location_city),
           location_country = COALESCE($8, location_country),
           is_favorite = COALESCE($9, is_favorite),
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $10
       RETURNING *`,
      [name, category, rating, price, notes, locationName, locationCity, 
       locationCountry, isFavorite, drinkId]
    );

    res.json({
      message: 'Drink updated successfully',
      drink: result.rows[0]
    });
  } catch (error) {
    next(error);
  }
});

// Delete drink
router.delete('/:id', authenticateToken, async (req, res, next) => {
  try {
    const drinkId = req.params.id;

    // Check ownership
    const checkResult = await query(
      'SELECT user_id FROM drinks WHERE id = $1',
      [drinkId]
    );

    if (checkResult.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Drink not found' 
      });
    }

    if (checkResult.rows[0].user_id !== req.user.id) {
      return res.status(403).json({ 
        error: 'Forbidden',
        message: 'You can only delete your own drinks' 
      });
    }

    await query('DELETE FROM drinks WHERE id = $1', [drinkId]);

    // Update user stats
    await query(
      'UPDATE users SET total_drinks = total_drinks - 1 WHERE id = $1',
      [req.user.id]
    );

    res.json({ message: 'Drink deleted successfully' });
  } catch (error) {
    next(error);
  }
});

// Get trending drinks
router.get('/trending/all', authenticateToken, async (req, res, next) => {
  try {
    const { limit = 10 } = req.query;

    const result = await query(
      `SELECT d.*, u.username, u.display_name, u.avatar_url,
              COUNT(l.id) as likes_count
       FROM drinks d
       JOIN users u ON d.user_id = u.id
       LEFT JOIN likes l ON d.id = l.drink_id
       WHERE d.created_at > NOW() - INTERVAL '7 days'
       GROUP BY d.id, u.username, u.display_name, u.avatar_url
       ORDER BY likes_count DESC, d.rating DESC
       LIMIT $1`,
      [limit]
    );

    res.json({ drinks: result.rows });
  } catch (error) {
    next(error);
  }
});

module.exports = router;


