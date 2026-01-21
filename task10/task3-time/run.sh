#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="task3-time:latest"
CONTAINER_NAME="task3-time"

if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  docker rm -f "$CONTAINER_NAME"
fi

docker build -t "$IMAGE_NAME" .

docker run -d --name "$CONTAINER_NAME" "$IMAGE_NAME"

echo "Container started: $CONTAINER_NAME"
