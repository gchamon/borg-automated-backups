#!/usr/bin/env bash
source constants.sh

logrotate_file=/etc/logrotate.d/borg_backups

echo "" > $logrotate_file

for folder_to_backup in "${FOLDERS_TO_BACKUP[@]}"; do
    cat >> $logrotate_file <<ROTATE
/var/log/borg_backups/$folder_to_backup.log {
    weekly
    rotate 2
    missingok
}
ROTATE
done
