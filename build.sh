#!/bin/bash

# Change to backend directory
cd backend || { echo "❌ Failed to change to backend directory"; exit 1; }
echo "📂 Changed to backend directory"

# Build the project
echo "🔨 Building project..."
pnpm run build || { echo "❌ Build failed"; exit 1; }
echo "✅ Build completed successfully"

# Change back to root directory
cd .. || { echo "❌ Failed to change to root directory"; exit 1; }

echo "✨ Build process completed successfully"