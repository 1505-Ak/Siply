const express = require('express');
const router = express.Router();
const { query, transaction } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

// Get user feed (drinks from followed users)
router.get('/feed', authenticateToken, async (req, res, next) => {
  try {
    const { limit = 20, offset = 0 } = req.query;

    const result = await query(
      `SELECT d.*, u.username, u.display_name, u.avatar_url,
              (SELECT COUNT(*) FROM likes WHERE drink_id = d.id) as likes_count,
              (SELECT COUNT(*) FROM comments WHERE drink_id = d.id) as comments_count,
              EXISTS(SELECT 1 FROM likes WHERE drink_id = d.id AND user_id = $1) as is_liked
       FROM drinks d
       JOIN users u ON d.user_id = u.id
       WHERE d.user_id IN (
         SELECT following_id FROM follows WHERE follower_id = $1
       )
       OR d.user_id = $1
       ORDER BY d.created_at DESC
       LIMIT $2 OFFSET $3`,
      [req.user.id, limit, offset]
    );

    res.json({
      feed: result.rows,
      pagination: {
        limit: parseInt(limit),
        offset: parseInt(offset)
      }
    });
  } catch (error) {
    next(error);
  }
});

// Follow user
router.post('/follow/:userId', authenticateToken, async (req, res, next) => {
  try {
    const followingId = req.params.userId;

    if (followingId === req.user.id) {
      return res.status(400).json({ 
        error: 'Bad Request',
        message: 'Cannot follow yourself' 
      });
    }

    // Check if user exists
    const userCheck = await query(
      'SELECT id FROM users WHERE id = $1',
      [followingId]
    );

    if (userCheck.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'User not found' 
      });
    }

    // Check if already following
    const existingFollow = await query(
      'SELECT id FROM follows WHERE follower_id = $1 AND following_id = $2',
      [req.user.id, followingId]
    );

    if (existingFollow.rows.length > 0) {
      return res.status(409).json({ 
        error: 'Conflict',
        message: 'Already following this user' 
      });
    }

    // Create follow relationship and update counts in transaction
    await transaction(async (client) => {
      await client.query(
        'INSERT INTO follows (follower_id, following_id) VALUES ($1, $2)',
        [req.user.id, followingId]
      );

      await client.query(
        'UPDATE users SET following_count = following_count + 1 WHERE id = $1',
        [req.user.id]
      );

      await client.query(
        'UPDATE users SET followers_count = followers_count + 1 WHERE id = $1',
        [followingId]
      );
    });

    res.json({ message: 'Successfully followed user' });
  } catch (error) {
    next(error);
  }
});

// Unfollow user
router.delete('/follow/:userId', authenticateToken, async (req, res, next) => {
  try {
    const followingId = req.params.userId;

    const result = await query(
      'DELETE FROM follows WHERE follower_id = $1 AND following_id = $2 RETURNING id',
      [req.user.id, followingId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Follow relationship not found' 
      });
    }

    // Update counts
    await Promise.all([
      query('UPDATE users SET following_count = following_count - 1 WHERE id = $1', [req.user.id]),
      query('UPDATE users SET followers_count = followers_count - 1 WHERE id = $1', [followingId])
    ]);

    res.json({ message: 'Successfully unfollowed user' });
  } catch (error) {
    next(error);
  }
});

// Get followers
router.get('/followers/:userId', authenticateToken, async (req, res, next) => {
  try {
    const { limit = 50, offset = 0 } = req.query;

    const result = await query(
      `SELECT u.id, u.username, u.display_name, u.avatar_url, u.followers_count,
              EXISTS(SELECT 1 FROM follows WHERE follower_id = $1 AND following_id = u.id) as is_following
       FROM users u
       JOIN follows f ON u.id = f.follower_id
       WHERE f.following_id = $2
       ORDER BY f.created_at DESC
       LIMIT $3 OFFSET $4`,
      [req.user.id, req.params.userId, limit, offset]
    );

    res.json({ users: result.rows });
  } catch (error) {
    next(error);
  }
});

// Get following
router.get('/following/:userId', authenticateToken, async (req, res, next) => {
  try {
    const { limit = 50, offset = 0 } = req.query;

    const result = await query(
      `SELECT u.id, u.username, u.display_name, u.avatar_url, u.followers_count,
              EXISTS(SELECT 1 FROM follows WHERE follower_id = $1 AND following_id = u.id) as is_following
       FROM users u
       JOIN follows f ON u.id = f.following_id
       WHERE f.follower_id = $2
       ORDER BY f.created_at DESC
       LIMIT $3 OFFSET $4`,
      [req.user.id, req.params.userId, limit, offset]
    );

    res.json({ users: result.rows });
  } catch (error) {
    next(error);
  }
});

// Like drink
router.post('/likes/:drinkId', authenticateToken, async (req, res, next) => {
  try {
    const drinkId = req.params.drinkId;

    // Check if drink exists
    const drinkCheck = await query(
      'SELECT id, user_id FROM drinks WHERE id = $1',
      [drinkId]
    );

    if (drinkCheck.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Drink not found' 
      });
    }

    // Check if already liked
    const existingLike = await query(
      'SELECT id FROM likes WHERE user_id = $1 AND drink_id = $2',
      [req.user.id, drinkId]
    );

    if (existingLike.rows.length > 0) {
      return res.status(409).json({ 
        error: 'Conflict',
        message: 'Already liked this drink' 
      });
    }

    await query(
      'INSERT INTO likes (user_id, drink_id) VALUES ($1, $2)',
      [req.user.id, drinkId]
    );

    res.json({ message: 'Drink liked successfully' });
  } catch (error) {
    next(error);
  }
});

// Unlike drink
router.delete('/likes/:drinkId', authenticateToken, async (req, res, next) => {
  try {
    const result = await query(
      'DELETE FROM likes WHERE user_id = $1 AND drink_id = $2 RETURNING id',
      [req.user.id, req.params.drinkId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Like not found' 
      });
    }

    res.json({ message: 'Drink unliked successfully' });
  } catch (error) {
    next(error);
  }
});

// Add comment
router.post('/comments/:drinkId', authenticateToken, async (req, res, next) => {
  try {
    const { content } = req.body;

    if (!content || content.trim().length === 0) {
      return res.status(400).json({ 
        error: 'Bad Request',
        message: 'Comment content required' 
      });
    }

    const drinkId = req.params.drinkId;

    // Check if drink exists
    const drinkCheck = await query(
      'SELECT id FROM drinks WHERE id = $1',
      [drinkId]
    );

    if (drinkCheck.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Drink not found' 
      });
    }

    const result = await query(
      `INSERT INTO comments (user_id, drink_id, content) 
       VALUES ($1, $2, $3) 
       RETURNING *`,
      [req.user.id, drinkId, content]
    );

    res.status(201).json({
      message: 'Comment added successfully',
      comment: result.rows[0]
    });
  } catch (error) {
    next(error);
  }
});

// Get comments for drink
router.get('/comments/:drinkId', authenticateToken, async (req, res, next) => {
  try {
    const { limit = 50, offset = 0 } = req.query;

    const result = await query(
      `SELECT c.*, u.username, u.display_name, u.avatar_url
       FROM comments c
       JOIN users u ON c.user_id = u.id
       WHERE c.drink_id = $1
       ORDER BY c.created_at DESC
       LIMIT $2 OFFSET $3`,
      [req.params.drinkId, limit, offset]
    );

    res.json({ comments: result.rows });
  } catch (error) {
    next(error);
  }
});

module.exports = router;


