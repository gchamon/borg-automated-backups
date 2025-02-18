#!/usr/bin/env bash
set -euo pipefail

source constants.sh

exit_fail=false

if test -n "${BORG_PASSPHRASE-}"; then
  echo "BORG_PASSPHRASE set"
else
  echo -e "${COLOR_RED}Please set BORG_PASSPHRASE env var${COLOR_NONE}"
  exit_fail=true
fi

if test -n "${BACKUP_FOLDER-}"; then
  echo "Using backup folder: $BACKUP_FOLDER"
else
  echo -e "${COLOR_RED}Please set BACKUP_FOLDER env var${COLOR_NONE}"
  exit_fail=true
fi

if test -n "${CRON_SCHEDULE-}"; then
  echo "Using cron schedule: $CRON_SCHEDULE"
else
  echo -e "${COLOR_RED}Please set BACKUP_FOLDER env var${COLOR_NONE}"
  exit_fail=true
fi

if [[ "$exit_fail" == true ]]; then
  echo Fix the errors above and retry. Exiting...
  exit 1
fi

if [[ "${DEPLOY_BORG_BINARY:-false}" == "true" ]]; then
    if command -v borg 2>&1 >/dev/null; then
        echo borg already deployed
    else
        echo deploying borg binary...
        wget https://github.com/borgbackup/borg/releases/download/1.4.0/borg-linux-glibc228
        sudo mv borg-linux-glibc228 /usr/bin/borg
        sudo chmod +x /usr/bin/borg
        which borg
    fi
fi

echo testing borg installation...
borg_version=$(borg --version | cut -d ' ' -f2)
if ! [[ "$borg_version" =~ ^1\.4 ]]; then
    echo borg version is $borg_version, but the required version is 1.4.x
    exit 1
else
    echo borg test passed! borg is at version $borg_version
fi

export BORG_PASSPHRASE
export BACKUP_FOLDER
export CRON_SCHEDULE

source create-repos.sh
source deploy-cronjobs.sh
source configure-logrotate.sh
