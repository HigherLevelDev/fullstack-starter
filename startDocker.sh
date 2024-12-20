#!/bin/bash

# Start the containers in detached mode
docker compose -f docker/docker-compose.yml up -d --build

# Wait for containers to be healthy
echo "Waiting for containers to be healthy..."
TIMEOUT=20  # 20 seconds timeout
ELAPSED=0
INTERVAL=2  # Check every 2 seconds

while [ $ELAPSED -lt $TIMEOUT ]; do
    if docker compose -f docker/docker-compose.yml ps | grep -q "healthy"; then
        echo "Containers are healthy!"
        exit 0
    fi
    
    if docker compose -f docker/docker-compose.yml ps | grep -q "unhealthy\|exit"; then
        echo "Container health check failed! Container logs:"
        docker compose -f docker/docker-compose.yml logs
        echo "Error: Containers failed to start properly."
        exit 1
    fi
    
    sleep $INTERVAL
    ELAPSED=$((ELAPSED + INTERVAL))
    echo "Still waiting for containers to be healthy... ($ELAPSED seconds elapsed)"
done

echo "Timeout waiting for containers to be healthy! Container logs:"
docker compose -f docker/docker-compose.yml logs
echo "Error: Containers failed to start within timeout period."
exit 1