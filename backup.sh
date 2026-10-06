#!/usr/bin/env bash
# Nightly backup. Cron: 0 1 * * * /opt/grc/backup.sh
set -euo pipefail
cd "$(dirname "$0")"
set -a; source .env; set +a
STAMP=$(date +%F)
mkdir -p backups
docker compose exec -T db pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "backups/db-$STAMP.sql.gz"
docker run --rm -v "$(basename "$PWD")_media":/media -v "$PWD/backups":/out alpine \
  tar czf "/out/media-$STAMP.tar.gz" -C /media .
find backups -type f -mtime +14 -delete
echo "Backup done: $STAMP"
