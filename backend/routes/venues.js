const express = require('express');
const router = express.Router();
const { query } = require('../config/database');
const { optionalAuth } = require('../middleware/auth');

// Get all venues (with filters)
router.get('/', optionalAuth, async (req, res, next) => {
  try {
    const { 
      city, 
      category, 
      hasStudentDiscount, 
      hasHappyHour, 
      isPartner,
      limit = 50,
      offset = 0 
    } = req.query;

    let queryText = 'SELECT * FROM venues WHERE 1=1';
    const params = [];
    let paramCount = 0;

    if (city) {
      paramCount++;
      queryText += ` AND city ILIKE $${paramCount}`;
      params.push(`%${city}%`);
    }

    if (category) {
      paramCount++;
      queryText += ` AND category = $${paramCount}`;
      params.push(category);
    }

    if (hasStudentDiscount === 'true') {
      queryText += ' AND has_student_discount = true';
    }

    if (hasHappyHour === 'true') {
      queryText += ' AND has_happy_hour = true';
    }

    if (isPartner === 'true') {
      queryText += ' AND is_partner = true';
    }

    queryText += ' ORDER BY is_partner DESC, name ASC';
    
    paramCount++;
    queryText += ` LIMIT $${paramCount}`;
    params.push(limit);

    paramCount++;
    queryText += ` OFFSET $${paramCount}`;
    params.push(offset);

    const result = await query(queryText, params);

    res.json({
      venues: result.rows,
      pagination: {
        limit: parseInt(limit),
        offset: parseInt(offset)
      }
    });
  } catch (error) {
    next(error);
  }
});

// Get venue by ID
router.get('/:id', optionalAuth, async (req, res, next) => {
  try {
    const venueResult = await query(
      'SELECT * FROM venues WHERE id = $1',
      [req.params.id]
    );

    if (venueResult.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Venue not found' 
      });
    }

    const venue = venueResult.rows[0];

    // Get discounts
    const discountsResult = await query(
      `SELECT * FROM discounts 
       WHERE venue_id = $1 AND is_active = true
       AND (valid_until IS NULL OR valid_until > NOW())
       ORDER BY created_at DESC`,
      [venue.id]
    );

    // Get loyalty program
    const loyaltyResult = await query(
      'SELECT * FROM loyalty_programs WHERE venue_id = $1',
      [venue.id]
    );

    // Get user's progress if authenticated
    let userProgress = null;
    if (req.user) {
      const progressResult = await query(
        'SELECT * FROM user_loyalty_progress WHERE user_id = $1 AND venue_id = $2',
        [req.user.id, venue.id]
      );
      userProgress = progressResult.rows[0] || null;
    }

    res.json({
      ...venue,
      discounts: discountsResult.rows,
      loyaltyProgram: loyaltyResult.rows[0] || null,
      userProgress
    });
  } catch (error) {
    next(error);
  }
});

// Get nearby venues
router.get('/nearby/search', optionalAuth, async (req, res, next) => {
  try {
    const { latitude, longitude, radius = 5, limit = 20 } = req.query;

    if (!latitude || !longitude) {
      return res.status(400).json({ 
        error: 'Bad Request',
        message: 'Latitude and longitude required' 
      });
    }

    // Using Haversine formula for distance calculation
    const result = await query(
      `SELECT *,
        (6371 * acos(cos(radians($1)) * cos(radians(latitude)) * 
         cos(radians(longitude) - radians($2)) + sin(radians($1)) * 
         sin(radians(latitude)))) AS distance
       FROM venues
       WHERE latitude IS NOT NULL AND longitude IS NOT NULL
       HAVING distance < $3
       ORDER BY distance ASC
       LIMIT $4`,
      [latitude, longitude, radius, limit]
    );

    res.json({ venues: result.rows });
  } catch (error) {
    next(error);
  }
});

// Get venues with student discounts
router.get('/discounts/student', optionalAuth, async (req, res, next) => {
  try {
    const result = await query(
      `SELECT v.*, COUNT(d.id) as discount_count
       FROM venues v
       LEFT JOIN discounts d ON v.id = d.venue_id AND d.is_active = true
       WHERE v.has_student_discount = true
       GROUP BY v.id
       ORDER BY v.is_partner DESC, discount_count DESC`,
      []
    );

    res.json({ venues: result.rows });
  } catch (error) {
    next(error);
  }
});

// Get venues with happy hour
router.get('/discounts/happy-hour', optionalAuth, async (req, res, next) => {
  try {
    const result = await query(
      'SELECT * FROM venues WHERE has_happy_hour = true ORDER BY is_partner DESC, name ASC',
      []
    );

    res.json({ venues: result.rows });
  } catch (error) {
    next(error);
  }
});

module.exports = router;


