-- Flyway migration generated from existing Node schema
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  bio TEXT,
  avatar_url TEXT,
  favorite_drink VARCHAR(255),
  followers_count INTEGER DEFAULT 0,
  following_count INTEGER DEFAULT 0,
  total_drinks INTEGER DEFAULT 0,
  total_cities INTEGER DEFAULT 0,
  total_countries INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP,
  is_verified BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE drinks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  category VARCHAR(50) NOT NULL,
  rating DECIMAL(2,1) CHECK (rating >= 0 AND rating <= 5),
  price DECIMAL(10,2),
  notes TEXT,
  location_name VARCHAR(255),
  location_city VARCHAR(100),
  location_country VARCHAR(100),
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  image_url TEXT,
  tags TEXT[],
  is_favorite BOOLEAN DEFAULT FALSE,
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE venues (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  category VARCHAR(50) NOT NULL,
  address TEXT,
  city VARCHAR(100),
  country VARCHAR(100),
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  has_student_discount BOOLEAN DEFAULT FALSE,
  has_happy_hour BOOLEAN DEFAULT FALSE,
  is_partner BOOLEAN DEFAULT FALSE,
  image_url TEXT,
  phone VARCHAR(50),
  website TEXT,
  opening_hours JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE discounts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  venue_id UUID REFERENCES venues(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  discount_percentage INTEGER,
  discount_amount DECIMAL(10,2),
  requires_student_id BOOLEAN DEFAULT FALSE,
  valid_from TIMESTAMP,
  valid_until TIMESTAMP,
  terms TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE loyalty_programs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  venue_id UUID REFERENCES venues(id) ON DELETE CASCADE,
  program_type VARCHAR(50) NOT NULL,
  points_per_visit INTEGER DEFAULT 0,
  points_per_dollar INTEGER DEFAULT 0,
  has_multiplier BOOLEAN DEFAULT FALSE,
  multiplier_rate DECIMAL(3,1) DEFAULT 1.0,
  has_subscription BOOLEAN DEFAULT FALSE,
  subscription_details TEXT,
  has_visit_card BOOLEAN DEFAULT FALSE,
  visit_card_goal INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_loyalty_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  venue_id UUID REFERENCES venues(id) ON DELETE CASCADE,
  points_earned INTEGER DEFAULT 0,
  visit_count INTEGER DEFAULT 0,
  is_favorite BOOLEAN DEFAULT FALSE,
  last_visit TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, venue_id)
);

CREATE TABLE follows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  follower_id UUID REFERENCES users(id) ON DELETE CASCADE,
  following_id UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(follower_id, following_id),
  CHECK (follower_id != following_id)
);

CREATE TABLE likes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  drink_id UUID REFERENCES drinks(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, drink_id)
);

CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  drink_id UUID REFERENCES drinks(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE achievements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  icon VARCHAR(50),
  requirement_type VARCHAR(50),
  requirement_value INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_achievements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  achievement_id UUID REFERENCES achievements(id) ON DELETE CASCADE,
  unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  progress INTEGER DEFAULT 0,
  UNIQUE(user_id, achievement_id)
);

CREATE TABLE feed_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  drink_id UUID REFERENCES drinks(id) ON DELETE CASCADE,
  content TEXT,
  image_url TEXT,
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  is_tagged BOOLEAN DEFAULT FALSE,
  tagged_users UUID[],
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255),
  message TEXT,
  related_id UUID,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_drinks_user_id ON drinks(user_id);
CREATE INDEX idx_drinks_category ON drinks(category);
CREATE INDEX idx_drinks_created_at ON drinks(created_at DESC);
CREATE INDEX idx_drinks_location ON drinks(location_city, location_country);
CREATE INDEX idx_drinks_rating ON drinks(rating DESC);

CREATE INDEX idx_venues_city ON venues(city);
CREATE INDEX idx_venues_category ON venues(category);
CREATE INDEX idx_venues_partner ON venues(is_partner);

CREATE INDEX idx_follows_follower ON follows(follower_id);
CREATE INDEX idx_follows_following ON follows(following_id);

CREATE INDEX idx_likes_drink ON likes(drink_id);
CREATE INDEX idx_likes_user ON likes(user_id);

CREATE INDEX idx_comments_drink ON comments(drink_id);
CREATE INDEX idx_comments_user ON comments(user_id);

CREATE INDEX idx_feed_user ON feed_posts(user_id);
CREATE INDEX idx_feed_created ON feed_posts(created_at DESC);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_drinks_updated_at BEFORE UPDATE ON drinks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_venues_updated_at BEFORE UPDATE ON venues
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


