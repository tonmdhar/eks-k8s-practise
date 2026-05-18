#!/bin/bash
set -e

export DOCKER_HOST="unix:///Users/tonmdhar/.colima/default/docker.sock"

ECR_URL=$1
REGION="us-east-1"
ACCOUNT="394820919946"

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin \
  $ACCOUNT.dkr.ecr.$REGION.amazonaws.com

docker buildx create --name amd64builder --use 2>/dev/null || docker buildx use amd64builder
docker buildx build --platform linux/amd64 -f ../docker/Dockerfile -t $ECR_URL:latest --push ../
