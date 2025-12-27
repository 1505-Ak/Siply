#!/bin/bash

echo "🚀 Siply Backend Starter Script"
echo "================================"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed"
    echo ""
    echo "Please install Node.js first:"
    echo "  1. Visit https://nodejs.org/"
    echo "  2. Download and install the LTS version"
    echo "  3. Run this script again"
    echo ""
    echo "Or install via Homebrew:"
    echo "  brew install node"
    exit 1
fi

echo "✅ Node.js $(node --version) found"
echo "✅ npm $(npm --version) found"
echo ""

# Navigate to backend directory
cd "$(dirname "$0")/backend" || exit 1

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies (first time only)..."
    npm install
    echo ""
fi

# Check if database exists
if ! psql -lqt 2>/dev/null | cut -d \| -f 1 | grep -qw siply; then
    echo "🗄️  Database 'siply' not found"
    echo "Creating database and running schema..."
    createdb siply 2>/dev/null || echo "Note: Using existing database"
    psql siply < scripts/schema.sql 2>/dev/null
    
    # Seed with sample data
    read -p "Add sample data? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        node scripts/seed.js
    fi
fi

# Start the server
echo ""
echo "🚀 Starting Siply Backend Server..."
echo "================================"
echo ""
npm start


