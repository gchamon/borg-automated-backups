# borg-backups
Automated backup solution using Borg Backup for critical system directories.

## Description
This project provides scripts to automatically backup important system directories using
Borg Backup. It includes automatic log rotation and scheduled backups via cron jobs. While
similar functionality can be achieved using
[borgmatic](https://github.com/borgmatic-collective/borgmatic), this project offers a
lightweight, customizable solution focused on basic backup needs.

## Dependencies

Required packages:
- `borgbackup`: For creating and managing backups
- `logrotate`: For managing log file rotation
- `cron`: For scheduling backup jobs

You can install them on Arch Linux with:
```bash
sudo pacman -S borg cronie logrotate
```

Note: On Arch Linux, the package is named 'borg' instead of 'borgbackup', and 'cronie'
provides the cron functionality.

## Installation
1. Clone this repository
2. Ensure you have all required dependencies installed
3. Make sure you have sufficient permissions to access the backup locations

## Configuration
### Environment Variables
- `BORG_PASSPHRASE`: (Required) The passphrase used to encrypt your backups
- `BACKUP_FOLDER`: (Optional) The destination folder where backups will be stored
- `CRON_SCHEDULE`: (Optional) The schedule for automatic backups (in cron format)

### Default Backup Directories
The following directories are backed up by default:
- /home
- /etc
- /srv
- /boot
- /opt
- /usr

You can change the directories for backup by copying `env.dist` into `env` and modifying it.

## Usage
1. Set up the encryption passphrase:
```bash
sudo echo "BORG_PASSPHRASE={your_long_passphrase}" >> /etc/environment
```

2. Deploy the backup system:
```bash
sudo sh -c 'CRON_SCHEDULE="0 13 * * *" BACKUP_FOLDER=/media/remote-server/backups bash deploy.sh'
```

The default schedule (0 13 * * *) runs backups daily at 13:00.

## Backup Strategy
- Daily backups are kept for 7 days
- Logs are rotated weekly and kept for 2 rotations
- Backups are compressed using LZ4 compression
- Each directory is backed up to its own Borg repository

## Troubleshooting
Common issues:
- If backups fail, check the logs in `/var/log/borg_backups/`
- Ensure BORG_PASSPHRASE is correctly set in /etc/environment
- Verify that the backup destination has sufficient space
- Check that the backup user has appropriate permissions
