#!/usr/bin/env bash
source constants.sh

borg_backup_scripts_folder=/opt/borg-backups
borg_backup_logs_folder=/var/log/borg_backups
mkdir --parents "$borg_backup_scripts_folder"
mkdir --parents $borg_backup_logs_folder

echo '#!/bin/bash' >"$borg_backup_scripts_folder"/run_all.sh

for folder_to_backup in "${FOLDERS_TO_BACKUP[@]}"; do
    filename="$(filename-from-path $folder_to_backup)"
    backup_script="$borg_backup_scripts_folder/$filename.sh"
    cat >"$backup_script" <<CRONJOB
#!/usr/bin/env bash
exec > >(tee -a $borg_backup_logs_folder/$filename.log) 2>&1
echo "[start] \$(date)"
start=\$(date +%s)

source /etc/environment
export BORG_PASSPHRASE

echo 'creating archive entry...'
borg create \\
  -v --stats \\
  --compression lz4 \\
  $BACKUP_FOLDER/$filename::\$(date '+%Y-%m-%dT%H:%M:%S') \\
  /$folder_to_backup

echo 'pruning archive...'
borg prune -v --list \\
  --keep-within=${BACKUP_RETENTION_DAYS:-7}d \\
  --keep-last=1 \\
  $BACKUP_FOLDER/$filename

echo 'compacting archive...'
borg compact $BACKUP_FOLDER/$filename

end=\$(date +%s)
echo "[end] \$(date)"
echo "[runtime] \$((end-start))"

CRONJOB
    chmod +x "$backup_script"
    echo "bash $backup_script" >>"$borg_backup_scripts_folder"/run_all.sh
done

chmod +x "$borg_backup_scripts_folder"/run_all.sh

if [[ "$CRON_TRIGGER" == "cron" ]]; then
    echo "$CRON_SCHEDULE root /bin/bash $borg_backup_scripts_folder/run_all.sh" >"/etc/cron.d/borg_backup"
elif [[ "$CRON_TRIGGER" == "systemd" ]]; then
    cat >/etc/systemd/system/borg-backup.service <<EOF
[Unit]
Description=Automated Borg Backup
Requires=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/opt/borg-backups/run_all.sh
EnvironmentFile=/etc/environment
User=root
Group=root
EOF
    cat >/etc/systemd/system/borg-backup.timer <<EOF
[Unit]
Description=Runs Borg Backup daily

[Timer]
OnCalendar=$CRON_SCHEDULE
Persistent=true
RandomizedDelaySec=5m
Unit=borg-backup.service

[Install]
WantedBy=timers.target
EOF
    systemctl daemon-reload
    systemctl enable --now borg-backup.timer
fi
