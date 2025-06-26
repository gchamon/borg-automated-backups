#!/usr/bin/env bash
set -euo pipefail

# Build the Docker image
docker build -t borg-automated-backups-test ./test

# Run the container with the project folder mapped to /app
docker run -it --rm \
    -v "$(pwd)":/app \
    -v "$(pwd)"/test/conf.env:/app/conf.env:ro \
    -v borg-automated-backups-test-usr-bin:/usr/bin \
    borg-automated-backups-test \
    bash /app/test/test.sh
