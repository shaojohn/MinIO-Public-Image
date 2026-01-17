# MinIO Backup and Restore Guide

This guide explains how to backup and restore your MinIO data using the provided bash script.

## Prerequisites
- Docker Compose MinIO deployment (see README.md)
- Bash shell
- `zip`, `unzip`, and `rsync` installed

## Script Location
The script is named `minio-backup-restore.sh` and should be in your MinIO project directory.

## Backup MinIO Data
To backup your MinIO data and compress it:

```bash
./minio-backup-restore.sh backup /path/to/backup_dir
```
- This will copy all data from `./minio_data` to `/path/to/backup_dir` and create a zip file named `/path/to/backup_dir-YYYYMMDDHHMMSS.zip`.

## Restore MinIO Data
You can restore from either a directory or a zip file:

### Restore from Directory
```bash
./minio-backup-restore.sh restore /path/to/backup_dir
```

### Restore from Zip File
```bash
./minio-backup-restore.sh restore /path/to/backup_dir-YYYYMMDDHHMMSS.zip
```
- The script will unzip the backup and restore the data to `./minio_data`.

## Notes
- Make sure MinIO is stopped before restoring data to avoid data corruption:
  ```bash
  docker compose down
  # Run restore command
  docker compose up -d
  ```
- You can schedule backups using cron for regular protection.
- Always verify your backup and restore process before relying on it for production.

## Troubleshooting
- Ensure you have enough disk space for backups.
- Check permissions if you encounter errors.
- For large datasets, backup and restore may take time.

## References
- [MinIO Documentation](https://min.io/docs/minio/linux/index.html)
- [rsync Manual](https://linux.die.net/man/1/rsync)
- [zip Manual](https://linux.die.net/man/1/zip)
- [unzip Manual](https://linux.die.net/man/1/unzip)
