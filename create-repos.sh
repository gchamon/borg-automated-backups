#!/usr/bin/env bash
source constants.sh

for folder_to_backup in "${folders_to_backup[@]}"; do
  borg init --encryption repokey "$BACKUP_FOLDER"/"$folder_to_backup"
done
