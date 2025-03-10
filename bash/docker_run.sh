#!/bin/bash

docker run -p 8080:8080 -v "/c/Users/Vince/repos/AWS-projects/deploy-R-model-to-AWS-ECR/logs/inside_container_logs:/app/logs" my-r-sagemaker-model:latest