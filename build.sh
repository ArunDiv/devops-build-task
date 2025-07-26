#!/bin/bash

# A script to build the Docker image
# This script will be executed by Jenkins on the Jenkins Server (Instance 1)

# Ensure IMAGE_NAME is passed or defined.
# In Jenkinsfile, we'll set the environment variable, so it will be available here.
if [ -z "$IMAGE_NAME" ]; then
  echo "Error: IMAGE_NAME environment variable not set."
  echo "Usage: IMAGE_NAME=your-repo/your-image:tag ./build.sh"
  exit 1
fi

echo "Building Docker image: $IMAGE_NAME"
# The context '.' means the Dockerfile and build context are in the current directory.
docker build -t $IMAGE_NAME .

echo "Build completed successfully for image: $IMAGE_NAME"
