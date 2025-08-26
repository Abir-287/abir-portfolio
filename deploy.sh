#!/bin/bash
set -e

echo "🚀 Starting Docker deployment..."

cd /var/www/portfolio
echo "Current directory: $(pwd)"

# Pull latest code
echo "📥 Pulling latest code..."
git pull origin main || { echo "Git pull failed"; exit 1; }

# Build Docker image
echo "🐳 Building Docker image..."
docker build -t portfolio:latest . || { echo "Docker build failed"; exit 1; }

# Stop and remove existing container (if any)
echo "🛑 Stopping and removing existing container..."
docker stop portfolio 2>/dev/null || true
docker rm portfolio 2>/dev/null || true

# Run new container
echo "🚀 Running new Docker container..."
docker run -d -p 3000:3000 --name portfolio portfolio:latest || { echo "Docker run failed"; exit 1; }

# Verify container status
echo "🛠 Checking container status..."
docker ps

echo "✅ Docker deployment completed!"
