#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

cd "$SCRIPT_DIR"

source constants.sh
source conf.env

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

if test -n "${CRON_TRIGGER-}"; then
    if [[ "$CRON_TRIGGER" =~ cron|systemd ]]; then
        echo "Using cron trigger: $CRON_TRIGGER"
    else
        echo "ERROR: CRON_TRIGGER should be cron or systemd, got $CRON_TRIGGER"
    fi
else
    echo -e "${COLOR_RED}Please set CRON_TRIGGER env var${COLOR_NONE}"
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
        mv borg-linux-glibc228 /usr/bin/borg
        chmod +x /usr/bin/borg
        which borg
        rm borg-linux*
    fi
fi

echo testing borg installation...
borg --version
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
