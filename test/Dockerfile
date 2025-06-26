FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
  cron \
  logrotate \
  sudo \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

ENV BORG_PASSPHRASE=2025_such_secure_wow

