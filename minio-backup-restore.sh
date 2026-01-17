#!/bin/bash
# minio-backup-restore.sh
# Usage:
#   ./minio-backup-restore.sh backup <backup_dir>
#   ./minio-backup-restore.sh restore <backup_dir>

MINIO_DATA_DIR="./minio_data"

backup() {
    local backup_dir="$1"
    if [ -z "$backup_dir" ]; then
        echo "Usage: $0 backup <backup_dir>"
        exit 1
    fi
    mkdir -p "$backup_dir"
    rsync -av --delete "$MINIO_DATA_DIR/" "$backup_dir/"
    # Compress the backup directory into a zip file
    zipfile="${backup_dir%/}-$(date +%Y%m%d%H%M%S).zip"
    zip -r "$zipfile" "$backup_dir"
    echo "Backup completed and compressed to $zipfile"
}

restore() {
    local backup_dir="$1"
    if [ -z "$backup_dir" ]; then
        echo "Usage: $0 restore <backup_dir|zipfile>"
        exit 1
    fi
    if [[ "$backup_dir" == *.zip ]]; then
        unzip "$backup_dir" -d /tmp/minio_restore
        rsync -av --delete /tmp/minio_restore/"$(basename "${backup_dir%.*}")"/ "$MINIO_DATA_DIR/"
        rm -rf /tmp/minio_restore
        echo "Restore completed from $backup_dir (zip)"
    else
        rsync -av --delete "$backup_dir/" "$MINIO_DATA_DIR/"
        echo "Restore completed from $backup_dir"
    fi
}

case "$1" in
    backup)
        backup "$2"
        ;;
    restore)
        restore "$2"
        ;;
    *)
        echo "Usage: $0 [backup|restore] <backup_dir>"
        exit 1
        ;;
esac
