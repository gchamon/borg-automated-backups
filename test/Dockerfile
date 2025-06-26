FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    borgbackup \
    logrotate \
    cron \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Keep container running
CMD ["tail", "-f", "/dev/null"]
