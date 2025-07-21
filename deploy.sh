#!/bin/bash

# A simple script to deploy the Docker container

CONTAINER_NAME="devops-app"
IMAGE_NAME="arundiv/devops-build-task:latest"

# Stop and remove any existing container
echo "Stopping and removing existing container (if any)..."
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Run the new container
echo "Deploying new container from image: $IMAGE_NAME"
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME

echo "Deployment completed successfully."
