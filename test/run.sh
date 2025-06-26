#!/usr/bin/env bash

# Build the Docker image
docker build -t borg-automated-backups-test ./test

# Run the container with the project folder mapped to /app
echo "running tests with cron trigger..."
docker run --detach --rm --privileged --cap-add=ALL \
    --name borg-automated-backups-test \
    -v "$(pwd)":/app \
    -v "$(pwd)"/test/conf-cron.env:/app/conf.env:ro \
    -v borg-automated-backups-test-usr-bin:/usr/bin \
    borg-automated-backups-test

sleep 2
docker exec -it borg-automated-backups-test bash /app/test/test.sh
echo killing container...
docker container rm --force borg-automated-backups-test

echo "running tests with systemd trigger..."
docker run --detach --rm --privileged --cap-add=ALL \
    --name borg-automated-backups-test \
    -v "$(pwd)":/app \
    -v "$(pwd)"/test/conf-systemd.env:/app/conf.env:ro \
    -v borg-automated-backups-test-usr-bin:/usr/bin \
    borg-automated-backups-test \
    bash /app/test/test.sh

sleep 2
docker exec -it borg-automated-backups-test bash /app/test/test.sh
docker container rm --force borg-automated-backups-test
echo killing container...
