#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="task2-flask-redis:latest"
REDIS_NAME="task2-redis"
PY_NAME="task2-python"

# Cleanup any existing containers
if docker ps -a --format '{{.Names}}' | grep -q "^${PY_NAME}$"; then
  docker rm -f "$PY_NAME"
fi
if docker ps -a --format '{{.Names}}' | grep -q "^${REDIS_NAME}$"; then
  docker rm -f "$REDIS_NAME"
fi

# Build app image
docker build -t "$IMAGE_NAME" .

# Start Redis (no published ports)
docker run -d --name "$REDIS_NAME" redis:7.2-alpine

# Start Python app in the same network namespace as Redis
# Redis is reachable as 127.0.0.1:6379 from this container.
docker run -d --name "$PY_NAME" \
  --network container:"$REDIS_NAME" \
  -e REDIS_HOST=127.0.0.1 \
  -e REDIS_PORT=6379 \
  -e FLASK_PORT=5000 \
  "$IMAGE_NAME"

echo "Containers started: $REDIS_NAME, $PY_NAME"
