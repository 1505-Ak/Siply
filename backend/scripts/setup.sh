#!/bin/bash

echo "🚀 Setting up Siply Backend..."
echo ""

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL is not installed"
    echo "Install it with: brew install postgresql (macOS) or apt-get install postgresql (Linux)"
    exit 1
fi

echo "✅ PostgreSQL found"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed"
    echo "Install it from: https://nodejs.org"
    exit 1
fi

echo "✅ Node.js $(node --version) found"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

# Create database
echo ""
echo "🗄️  Creating database..."
createdb siply 2>/dev/null || echo "Database 'siply' already exists"

# Run schema
echo ""
echo "📋 Running database schema..."
psql siply < scripts/schema.sql

if [ $? -eq 0 ]; then
    echo "✅ Database schema created successfully"
else
    echo "❌ Error creating database schema"
    exit 1
fi

# Seed data (optional)
read -p "Would you like to add sample data? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🌱 Seeding database..."
    node scripts/seed.js
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "To start the server:"
echo "  npm start       (production)"
echo "  npm run dev     (development with auto-reload)"
echo ""
echo "The API will be available at: http://localhost:3000"
echo "Health check: http://localhost:3000/health"
echo ""


