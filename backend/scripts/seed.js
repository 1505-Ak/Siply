const bcrypt = require('bcryptjs');
const { query } = require('../config/database');

async function seed() {
  console.log('🌱 Seeding database...\n');

  try {
    // Create test users
    console.log('Creating users...');
    const passwordHash = await bcrypt.hash('password123', 10);
    
    const users = await query(
      `INSERT INTO users (username, email, password_hash, display_name, bio, favorite_drink) VALUES
       ('johndoe', 'john@example.com', $1, 'John Doe', 'Coffee enthusiast ☕', 'Cappuccino'),
       ('sarahchen', 'sarah@example.com', $1, 'Sarah Chen', 'Exploring cafes worldwide', 'Matcha Latte'),
       ('mikej', 'mike@example.com', $1, 'Mike Johnson', 'Cocktail lover 🍸', 'Espresso Martini')
       RETURNING id, username`,
      [passwordHash]
    );
    console.log(`✅ Created ${users.rows.length} users`);

    const [john, sarah, mike] = users.rows;

    // Create venues
    console.log('\nCreating venues...');
    const venues = await query(
      `INSERT INTO venues (name, category, address, city, country, latitude, longitude, 
                          has_student_discount, has_happy_hour, is_partner) VALUES
       ('Starbucks Reserve', 'Coffee House', '123 Main St', 'San Francisco', 'USA', 37.7749, -122.4194, true, false, true),
       ('Blue Bottle Coffee', 'Coffee House', '456 Market St', 'San Francisco', 'USA', 37.7849, -122.4094, false, false, true),
       ('The Cocktail Bar', 'Bar', '789 Broadway', 'New York', 'USA', 40.7589, -73.9851, false, true, true),
       ('Costa Coffee', 'Coffee House', '321 High St', 'London', 'UK', 51.5074, -0.1278, true, true, true)
       RETURNING id, name`,
      []
    );
    console.log(`✅ Created ${venues.rows.length} venues`);

    // Create drinks
    console.log('\nCreating drinks...');
    await query(
      `INSERT INTO drinks (user_id, name, category, rating, price, notes, location_name, 
                          location_city, location_country, latitude, longitude) VALUES
       ($1, 'Cappuccino', 'Coffee', 4.5, 5.50, 'Perfect foam!', 'Starbucks Reserve', 'San Francisco', 'USA', 37.7749, -122.4194),
       ($1, 'Espresso Martini', 'Cocktail', 5.0, 12.00, 'Amazing cocktail!', 'The Cocktail Bar', 'New York', 'USA', 40.7589, -73.9851),
       ($2, 'Matcha Latte', 'Coffee', 4.0, 6.00, 'Great matcha', 'Blue Bottle Coffee', 'San Francisco', 'USA', 37.7849, -122.4094),
       ($2, 'Iced Latte', 'Coffee', 4.5, 5.00, 'Refreshing', 'Costa Coffee', 'London', 'UK', 51.5074, -0.1278),
       ($3, 'Cold Brew', 'Coffee', 4.5, 4.50, 'Strong and smooth', 'Blue Bottle Coffee', 'San Francisco', 'USA', 37.7849, -122.4094)`,
      [john.id, sarah.id, mike.id]
    );
    console.log('✅ Created sample drinks');

    // Create follows
    console.log('\nCreating social connections...');
    await query(
      `INSERT INTO follows (follower_id, following_id) VALUES
       ($1, $2), ($1, $3), ($2, $1), ($3, $1), ($3, $2)`,
      [john.id, sarah.id, mike.id]
    );
    
    // Update follower/following counts
    await query(
      `UPDATE users SET 
        followers_count = (SELECT COUNT(*) FROM follows WHERE following_id = users.id),
        following_count = (SELECT COUNT(*) FROM follows WHERE follower_id = users.id),
        total_drinks = (SELECT COUNT(*) FROM drinks WHERE user_id = users.id)`,
      []
    );
    console.log('✅ Created social connections');

    // Create achievements
    console.log('\nCreating achievements...');
    await query(
      `INSERT INTO achievements (code, name, description, icon, requirement_type, requirement_value) VALUES
       ('first_sip', 'First Sip', 'Log your first drink', '☕', 'drinks_logged', 1),
       ('coffee_novice', 'Coffee Novice', 'Log 5 drinks', '🎯', 'drinks_logged', 5),
       ('drink_master', 'Drink Master', 'Log 25 drinks', '🏆', 'drinks_logged', 25),
       ('explorer', 'Explorer', 'Visit 5 different cities', '🗺️', 'cities_visited', 5),
       ('globe_trotter', 'Globe Trotter', 'Visit 3 different countries', '🌍', 'countries_visited', 3),
       ('variety_lover', 'Variety Lover', 'Try 5 different drink categories', '🎨', 'categories_tried', 5),
       ('perfectionist', 'Perfectionist', 'Rate 10 drinks with 5 stars', '⭐', 'five_star_drinks', 10)`,
      []
    );
    console.log('✅ Created achievements');

    // Create discounts
    console.log('\nCreating discounts...');
    await query(
      `INSERT INTO discounts (venue_id, title, description, discount_percentage, 
                             requires_student_id, is_active) VALUES
       ((SELECT id FROM venues WHERE name = 'Starbucks Reserve'), 
        'Student Discount', '10% off with valid student ID', 10, true, true),
       ((SELECT id FROM venues WHERE name = 'Costa Coffee'), 
        'Happy Hour Special', '30% off iced drinks 3-5pm', 30, false, true),
       ((SELECT id FROM venues WHERE name = 'The Cocktail Bar'), 
        'Early Bird', '2-for-1 cocktails 5-7pm', 50, false, true)`,
      []
    );
    console.log('✅ Created discounts');

    // Create loyalty programs
    console.log('\nCreating loyalty programs...');
    await query(
      `INSERT INTO loyalty_programs (venue_id, program_type, points_per_visit, 
                                    has_visit_card, visit_card_goal) VALUES
       ((SELECT id FROM venues WHERE name = 'Starbucks Reserve'), 'points', 10, true, 10),
       ((SELECT id FROM venues WHERE name = 'Blue Bottle Coffee'), 'points', 15, true, 8)`,
      []
    );
    console.log('✅ Created loyalty programs');

    console.log('\n✅ Database seeded successfully!');
    console.log('\nTest user credentials:');
    console.log('  Username: johndoe     Password: password123');
    console.log('  Username: sarahchen   Password: password123');
    console.log('  Username: mikej       Password: password123');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding database:', error);
    process.exit(1);
  }
}

seed();


