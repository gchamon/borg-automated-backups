#!/usr/bin/env bash
source constants.sh

logrotate_file=/etc/logrotate.d/borg_backups

echo "" > $logrotate_file

for folder_to_backup in "${folders_to_backup[@]}"; do
    cat >> $logrotate_file <<ROTATE
/var/log/borg_backups/$folder_to_backup* {
    weekly
    rotate 2
    missingok
}
ROTATE
done