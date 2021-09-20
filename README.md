# borg-backups
Holds borg backup scripts

# Usage

- Add `BORG_PASSPHRASE={long_passphrase}` to `/etc/environment`
- Execute `sudo sh -c 'CRON_SCHEDULE="0 13 * * *" BACKUP_FOLDER=/media/remote-server/backups bash deploy.sh'`.
