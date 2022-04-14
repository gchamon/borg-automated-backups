#!/usr/bin/env bash
set -eo pipefail

exit_fail=false

if test -n "${BORG_PASSPHRASE-}"; then
  echo "BORG_PASSPHRASE set"
else
  echo "Please set BORG_PASSPHRASE env var"
  exit_fail=true
fi

if test -n "${BACKUP_FOLDER-}"; then
  echo "Using backup folder: $BACKUP_FOLDER"
else
  echo "Please set BACKUP_FOLDER env var"
  exit_fail=true
fi

if test -n "${CRON_SCHEDULE-}"; then
  echo "Using cron schedule: $CRON_SCHEDULE"
else
  echo "Please set BACKUP_FOLDER env var"
  exit_fail=true
fi

if [[ "$exit_fail" == true ]]; then
  exit 1
fi

export BORG_PASSPHRASE
export BACKUP_FOLDER
export CRON_SCHEDULE

bash create-repos.sh || true
bash deploy-cronjobs.sh
bash configure-logrotate.sh
