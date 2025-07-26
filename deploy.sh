#!/bin/bash

# A simple script to deploy the Docker container on the application server

CONTAINER_NAME="devops-app"
# Adjust the image name to be dynamic, based on what Jenkins pushes.
# For now, let's use the 'latest' tag for simplicity,
# but ideally, Jenkins would pass a specific build tag.
IMAGE_NAME="arundiv/devops-build-task-dev:latest" # Assuming dev for now, Jenkins will decide prod/dev

# Stop and remove any existing container
echo "Stopping and removing existing container (if any)..."
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Pull the latest image from Docker Hub
echo "Pulling latest image: $IMAGE_NAME"
docker pull $IMAGE_NAME

# Run the new container
echo "Deploying new container from image: $IMAGE_NAME"
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME

echo "Deployment completed successfully on Application Server."
