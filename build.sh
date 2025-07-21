#!/bin/bash

# A simple script to build the Docker image
IMAGE_NAME="arundiv/devops-build-task:latest"

echo "Building Docker image: $IMAGE_NAME"
docker build -t $IMAGE_NAME .

echo "Build completed successfully."
