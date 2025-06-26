#!/usr/bin/env bash
set -euo pipefail

cd /app

source conf.env

bash deploy.sh

if [[ "$CRON_TRIGGER" == "cron" ]]; then
    # with cron, tests bypass the cron schedule
    /opt/borg-backups/run_all.sh
fi

if [[ "$CRON_TRIGGER" == "systemd" ]]; then
    systemctl start borg-backup
    journalctl -u borg-backup
fi
