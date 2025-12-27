const errorHandler = (err, req, res, next) => {
  console.error('Error:', err);

  // Default error
  let statusCode = err.statusCode || 500;
  let message = err.message || 'Internal Server Error';

  // Mongoose/Database errors
  if (err.code === '23505') {
    // Unique constraint violation
    statusCode = 409;
    message = 'Resource already exists';
  } else if (err.code === '23503') {
    // Foreign key violation
    statusCode = 400;
    message = 'Invalid reference';
  } else if (err.code === '22P02') {
    // Invalid UUID
    statusCode = 400;
    message = 'Invalid ID format';
  }

  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    statusCode = 401;
    message = 'Invalid token';
  } else if (err.name === 'TokenExpiredError') {
    statusCode = 401;
    message = 'Token expired';
  }

  // Validation errors
  if (err.name === 'ValidationError') {
    statusCode = 400;
    message = Object.values(err.errors).map(e => e.message).join(', ');
  }

  // Don't leak error details in production
  const response = {
    error: err.name || 'Error',
    message: message
  };

  if (process.env.NODE_ENV === 'development') {
    response.stack = err.stack;
    response.details = err.details;
  }

  res.status(statusCode).json(response);
};

module.exports = errorHandler;


