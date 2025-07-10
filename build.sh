#!/bin/bash

# Build script for React Docker images
echo "🏗️ Starting Docker image build process..."

# Set variables
BRANCH=$(git rev-parse --abbrev-ref HEAD)
COMMIT_HASH=$(git rev-parse --short HEAD)
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Determine repository based on branch
if [ "$BRANCH" = "dev" ]; then
    REPO="arundiv/dev"
    TAG="dev-${COMMIT_HASH}"
elif [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
    REPO="arundiv/prod"
    TAG="prod-${COMMIT_HASH}"
else
    echo "❌ Unsupported branch: $BRANCH"
    echo "ℹ️ Only 'dev', 'main', and 'master' branches are supported"
    exit 1
fi

# Build Docker image
echo "🔨 Building Docker image for branch: $BRANCH"
echo "📦 Repository: $REPO"
echo "🏷️ Tag: $TAG"

# Build the image
docker build -t $REPO:$TAG .

# Also tag as latest for the respective repo
docker tag $REPO:$TAG $REPO:latest

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully!"
    echo "📋 Image details:"
    docker images | grep "$REPO"
else
    echo "❌ Docker build failed!"
    exit 1
fi

# Push to Docker Hub
echo "📤 Pushing image to Docker Hub..."
docker push $REPO:$TAG
docker push $REPO:latest

if [ $? -eq 0 ]; then
    echo "✅ Image pushed successfully to Docker Hub!"
    echo "🎉 Build process completed!"
    echo "🔗 Image: $REPO:$TAG"
    echo "🔗 Latest: $REPO:latest"
else
    echo "❌ Failed to push image to Docker Hub!"
    echo "ℹ️ Make sure you're logged into Docker Hub: docker login"
    exit 1
fi

# Clean up old images (keep last 3 versions)
echo "🧹 Cleaning up old images..."
docker images $REPO --format "table {{.Repository}}\t{{.Tag}}\t{{.CreatedAt}}" | tail -n +2 | sort -k3 -r | tail -n +4 | awk '{print $1":"$2}' | xargs -r docker rmi

echo "🎯 Build script completed successfully!"
