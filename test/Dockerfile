FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV BORG_PASSPHRASE=2025_such_secure_wow

# Install dependencies
RUN apt-get update && apt-get install -y \
  cron \
  logrotate \
  wget \
  systemd \
  systemd-sysv \
  dbus \
  dbus-user-session \
  && printf "systemctl start systemd-logind" >> /etc/profile \
  && rm -rf /var/lib/apt/lists/*

RUN echo "BORG_PASSPHRASE=${BORG_PASSPHRASE}" > /etc/environment

# Set working directory
WORKDIR /app

ENTRYPOINT [ "/sbin/init" ]
