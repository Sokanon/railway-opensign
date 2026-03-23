#!/bin/bash
set -e

# --- Wait for MongoDB to be reachable before starting Parse Server ---
# Parse Server calls process.exit() if it cannot connect to MongoDB,
# which causes container restart loops on Railway. This script extracts
# the host:port from MONGODB_URI and waits until it is reachable.

if [ -n "$MONGODB_URI" ]; then
  # Strip protocol prefix and credentials
  hostport=$(echo "$MONGODB_URI" | sed -E 's|^mongodb(\+srv)?://([^@]+@)?||' | sed -E 's|/.*||' | sed -E 's|\?.*||')
  host=$(echo "$hostport" | cut -d: -f1)
  port=$(echo "$hostport" | grep -o ':[0-9]*' | tr -d ':')
  port=${port:-27017}

  echo "Waiting for MongoDB at $host:$port ..."
  retries=0
  max_retries=60
  while ! nc -z "$host" "$port" 2>/dev/null; do
    retries=$((retries + 1))
    if [ "$retries" -ge "$max_retries" ]; then
      echo "MongoDB not reachable after ${max_retries}s — starting anyway (Parse Server will retry)."
      break
    fi
    sleep 1
  done
  echo "MongoDB is reachable. Starting OpenSign Server..."
else
  echo "WARNING: MONGODB_URI is not set."
fi

exec npm start
