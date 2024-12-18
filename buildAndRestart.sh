#!/bin/bash

# Function to check if backend is running
check_backend() {
    if pgrep -f "node.*dist/main" > /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to stop backend
stop_backend() {
    echo "🔍 Checking if backend is running..."
    if check_backend; then
        echo "📋 Backend process found, stopping it..."
        pkill -f "node.*dist/main"
        sleep 2
        if check_backend; then
            echo "❌ Failed to stop backend process"
            exit 1
        else
            echo "✅ Backend process stopped successfully"
        fi
    else
        echo "ℹ️  No backend process found running"
    fi
}

# Change to backend directory
cd backend || { echo "❌ Failed to change to backend directory"; exit 1; }
echo "📂 Changed to backend directory"

# Stop any running backend process
stop_backend

# Install dependencies
echo "📦 Installing dependencies..."
pnpm install --force || { echo "❌ Failed to install dependencies"; exit 1; }
echo "✅ Dependencies installed successfully"

# Build the project
echo "🔨 Building project..."
pnpm run build || { echo "❌ Build failed"; exit 1; }
echo "✅ Build completed successfully"

# Start the backend
echo "🚀 Starting backend..."
pnpm run start:dev &
sleep 5

# Check if backend started successfully
if check_backend; then
    echo "✅ Backend started successfully"
else
    echo "❌ Failed to start backend"
    exit 1
fi

echo "✨ Build and restart process completed successfully"