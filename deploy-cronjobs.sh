#!/usr/bin/env bash
source constants.sh

borg_backup_scripts_folder=/opt/borg-backups
mkdir --parents "$borg_backup_scripts_folder"

for folder_to_backup in "${folders_to_backup[@]}"; do
  backup_script="$borg_backup_scripts_folder/$folder_to_backup.sh"
  cat > "$backup_script" <<CRONJOB
#!/usr/bin/env bash
exec > >(tee /var/log/borg_backup_$folder_to_backup.log) 2>&1
echo "[start] \$(date)"
start=\$(date +%s)

borg create \\
  -v --stats \\
  --compression lz4 \\
  $BACKUP_FOLDER/$folder_to_backup::\$(date --iso-8601) \\
  /$folder_to_backup

borg prune -v --list \\
  --keep-within=7d \\
  --keep-last=1 \\
  $BACKUP_FOLDER/$folder_to_backup

end=\$(date +%s)
echo "[end] \$(date)"
echo "[runtime] \$((end-start))"

CRONJOB

  chmod +x "$backup_script"
  echo "$CRON_SCHEDULE root /bin/bash $backup_script" > "/etc/cron.d/borg_backup_$folder_to_backup"
done
