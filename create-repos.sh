#!/usr/bin/env bash
source constants.sh

for folder_to_backup in "${FOLDERS_TO_BACKUP[@]}"; do
    filename="$(filename-from-path $folder_to_backup)"
    repo_folder="$BACKUP_FOLDER"/"$filename"
    if [[ -d $repo_folder ]]; then
        echo "$repo_folder exists. Skipping..."
    else
        echo Initializing borg repo in "$repo_folder"...
        mkdir --parent "$repo_folder"
        borg init --make-parent-dirs --encryption repokey "$repo_folder" >/dev/null 2>&1
    fi
done
