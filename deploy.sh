#!/bin/bash

# Deploy script for React production app
echo "🚀 Starting React app deployment..."

# Set variables
CONTAINER_NAME="react-devops-app"
IMAGE_NAME="arundiv/prod:latest"
PORT=3000

# Stop existing container
echo "🛑 Stopping existing container..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Pull latest image
echo "📥 Pulling latest image..."
docker pull $IMAGE_NAME

# Run new container
echo "🏃 Running new React container..."
docker run -d \
  --name $CONTAINER_NAME \
  -p $PORT:80 \
  --restart unless-stopped \
  -e NODE_ENV=production \
  $IMAGE_NAME

# Check if container is running
if docker ps | grep -q $CONTAINER_NAME; then
  echo "✅ Deployment successful!"
  echo "🌐 React app is running on port $PORT"
  
  # Wait for app to be ready
  echo "⏳ Waiting for React app to be ready..."
  sleep 10
  
  # Health check
  if curl -f http://localhost:$PORT/health > /dev/null 2>&1; then
    echo "✅ Health check passed!"
  else
    echo "❌ Health check failed!"
    exit 1
  fi
  
  # Test main page
  if curl -f http://localhost:$PORT/ > /dev/null 2>&1; then
    echo "✅ React app is accessible!"
  else
    echo "❌ React app is not accessible!"
    exit 1
  fi
else
  echo "❌ Deployment failed!"
  exit 1
fi

# Show logs
echo "📋 Container logs:"
docker logs $CONTAINER_NAME --tail 20

echo "🎉 React app deployment completed successfully!"
echo "🔗 Access your React app at: http://localhost:$PORT"
echo "🏥 Health check at: http://localhost:$PORT/health"
