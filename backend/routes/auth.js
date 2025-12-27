const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const { body, validationResult } = require('express-validator');
const { query } = require('../config/database');
const { generateToken, authenticateToken } = require('../middleware/auth');

// Register new user
router.post('/register', [
  body('username').trim().isLength({ min: 3, max: 50 }).isAlphanumeric(),
  body('email').isEmail().normalizeEmail(),
  body('password').isLength({ min: 6 }),
  body('displayName').trim().notEmpty()
], async (req, res, next) => {
  try {
    // Validate request
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { username, email, password, displayName } = req.body;

    // Check if user exists
    const existingUser = await query(
      'SELECT id FROM users WHERE username = $1 OR email = $2',
      [username, email]
    );

    if (existingUser.rows.length > 0) {
      return res.status(409).json({ 
        error: 'Conflict',
        message: 'Username or email already exists' 
      });
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, 10);

    // Create user
    const result = await query(
      `INSERT INTO users (username, email, password_hash, display_name) 
       VALUES ($1, $2, $3, $4) 
       RETURNING id, username, email, display_name, created_at`,
      [username, email, passwordHash, displayName]
    );

    const user = result.rows[0];
    const token = generateToken(user);

    res.status(201).json({
      message: 'User created successfully',
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        displayName: user.display_name,
        createdAt: user.created_at
      },
      token
    });
  } catch (error) {
    next(error);
  }
});

// Login
router.post('/login', [
  body('username').trim().notEmpty(),
  body('password').notEmpty()
], async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { username, password } = req.body;

    // Find user (allow login with username or email)
    const result = await query(
      'SELECT * FROM users WHERE username = $1 OR email = $1',
      [username]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ 
        error: 'Unauthorized',
        message: 'Invalid credentials' 
      });
    }

    const user = result.rows[0];

    // Check if user is active
    if (!user.is_active) {
      return res.status(403).json({ 
        error: 'Forbidden',
        message: 'Account is disabled' 
      });
    }

    // Verify password
    const isValidPassword = await bcrypt.compare(password, user.password_hash);
    if (!isValidPassword) {
      return res.status(401).json({ 
        error: 'Unauthorized',
        message: 'Invalid credentials' 
      });
    }

    // Update last login
    await query('UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = $1', [user.id]);

    const token = generateToken(user);

    res.json({
      message: 'Login successful',
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        displayName: user.display_name,
        avatarUrl: user.avatar_url,
        followersCount: user.followers_count,
        followingCount: user.following_count
      },
      token
    });
  } catch (error) {
    next(error);
  }
});

// Get current user (verify token)
router.get('/me', authenticateToken, async (req, res, next) => {
  try {
    const result = await query(
      `SELECT id, username, email, display_name, bio, avatar_url, favorite_drink,
              followers_count, following_count, total_drinks, total_cities, total_countries,
              created_at, is_verified
       FROM users WHERE id = $1`,
      [req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'User not found' 
      });
    }

    const user = result.rows[0];
    res.json({
      id: user.id,
      username: user.username,
      email: user.email,
      displayName: user.display_name,
      bio: user.bio,
      avatarUrl: user.avatar_url,
      favoriteDrink: user.favorite_drink,
      stats: {
        followersCount: user.followers_count,
        followingCount: user.following_count,
        totalDrinks: user.total_drinks,
        totalCities: user.total_cities,
        totalCountries: user.total_countries
      },
      createdAt: user.created_at,
      isVerified: user.is_verified
    });
  } catch (error) {
    next(error);
  }
});

// Refresh token
router.post('/refresh', authenticateToken, async (req, res, next) => {
  try {
    const token = generateToken(req.user);
    res.json({ token });
  } catch (error) {
    next(error);
  }
});

module.exports = router;


