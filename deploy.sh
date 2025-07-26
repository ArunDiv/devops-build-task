#!/bin/bash

# A simple script to deploy the Docker container on the application server
# This script is executed remotely by Jenkins

# Ensure IMAGE_NAME and CONTAINER_NAME are passed as environment variables from Jenkins.
# If not set, provide defaults or exit with error.
: "${IMAGE_NAME:?Error: IMAGE_NAME environment variable not set}"
: "${CONTAINER_NAME:?Error: CONTAINER_NAME environment variable not set}"

echo "Stopping and removing existing container (if any): $CONTAINER_NAME"
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Pull the latest image from Docker Hub (this will now use the IMAGE_NAME passed by Jenkins)
echo "Pulling image: $IMAGE_NAME"
docker pull $IMAGE_NAME

# Run the new container
echo "Deploying new container from image: $IMAGE_NAME"
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME

echo "Deployment completed successfully on Application Server."
