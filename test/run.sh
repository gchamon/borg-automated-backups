#!/usr/bin/env bash
set -euo pipefail

# Build the Docker image
docker build -t borg-automated-backups-test ./test

# Run the container with the project folder mapped to /app
docker run -it --rm \
    -v "$(pwd)":/app \
    borg-automated-backups-test \
    bash
