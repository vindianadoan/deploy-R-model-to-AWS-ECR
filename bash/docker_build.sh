#!/bin/bash

# Change working directory to the repository root.
# This works if your script is in ./bash/ and your repo root is one level up.
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT" || exit 1

# Check if an argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <model|base|aws-model>"
  exit 1
fi

container_type=$1

# Ensure the logs directory exists
mkdir -p logs/outside_container_logs/docker_logs/

# Create a unique log filename using a timestamp and the container type
timestamp=$(date +'%Y%m%d_%H%M%S')
log_file="logs/outside_container_logs/docker_logs/${timestamp}_${container_type}_build.log"

echo "Build starting. Build log will be saved to $log_file"

if [ "$container_type" = "model" ]; then
    docker build --no-cache -f docker/Dockerfile.model -t my-r-sagemaker-model . > "$log_file" 2>&1
elif [ "$container_type" = "base" ]; then
    docker build --no-cache -f docker/Dockerfile.base -t r-base-mlops:4.4.1 . > "$log_file" 2>&1
elif [ "$container_type" = "aws-model" ]; then
    # Use Docker Buildx to build and push the image with the correct manifest for SageMaker.
    export DOCKER_CLI_EXPERIMENTAL=enabled
    docker buildx build --platform linux/amd64 -f docker/Dockerfile.awsmodel -t my-r-sagemaker-model . > "$log_file" 2>&1
else
    echo "Unknown container type: $container_type. Use 'model', 'base', or 'aws-model'."
    exit 1
fi

echo "Build log saved to $log_file"
