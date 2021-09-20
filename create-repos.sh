#!/usr/bin/env bash
source constants.sh

for folder_to_backup in "${folders_to_backup[@]}"; do
  repo_folder="$BACKUP_FOLDER"/"$folder_to_backup"
  mkdir --parent "$repo_folder"
  borg init --encryption repokey "$repo_folder"
done
