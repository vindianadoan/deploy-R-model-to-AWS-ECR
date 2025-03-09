#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <model|base>"
  exit 1
fi

container_type=$1

# Ensure the logs directory exists
mkdir -p ./outside_container_logs/docker_logs/

# Create a unique log filename using a timestamp and the container type
timestamp=$(date +'%Y%m%d_%H%M%S')
log_file="./outside_container_logs/docker_logs/${timestamp}_${container_type}_build.log"

echo "Building starting. Build log will be saved to $log_file"

# Check the argument to determine which Docker build command to use
if [ "$container_type" = "model" ]; then
    docker build --no-cache -t my-r-sagemaker-model . > "$log_file" 2>&1
elif [ "$container_type" = "base" ]; then
    docker build --no-cache -f Dockerfile.base -t r-base-mlops:4.4.1 . > "$log_file" 2>&1
else
    echo "Unknown container type: $container_type. Use 'model' or 'base'."
    exit 1
fi

echo "Build log saved to $log_file"
