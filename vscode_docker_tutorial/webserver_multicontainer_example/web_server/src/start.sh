#!/bin/bash
# Start Redis server in background
redis-server /etc/redis/redis.conf --daemonize yes

# Wait for Redis to be ready
while ! redis-cli ping; do
  sleep 1
done

# Start Flask application
python3 web_server.py