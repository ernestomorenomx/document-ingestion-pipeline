#!/usr/bin/env bash
# BrainVault PostgreSQL backup: dump, verify, checksum, rotate.
set -euo pipefail
umask 077

BACKUP_DIR="${BACKUP_DIR:-/var/backups/brainvault}"
CONTAINER="${PG_CONTAINER:-postgres-brainvault}"
PG_USER="${POSTGRES_USER:-brainvault}"
PG_DB="${POSTGRES_DB:-brainvault}"
KEEP="${BACKUP_KEEP:-14}"

mkdir -p "$BACKUP_DIR"
exec 9>"$BACKUP_DIR/.lock"
flock -n 9 || { echo "another backup is running" >&2; exit 1; }

OUT="$BACKUP_DIR/${PG_DB}_$(date +%Y%m%d_%H%M%S).dump"
TMP="$OUT.partial"

docker exec "$CONTAINER" pg_dump -U "$PG_USER" -Fc "$PG_DB" > "$TMP"

[ -s "$TMP" ] || { echo "empty dump" >&2; rm -f "$TMP"; exit 1; }
TABLES=$(docker exec -i "$CONTAINER" pg_restore -l < "$TMP" | grep -c 'TABLE public' || true)
[ "$TABLES" -ge 1 ] || { echo "dump unreadable" >&2; rm -f "$TMP"; exit 1; }

mv "$TMP" "$OUT"
( cd "$BACKUP_DIR" && sha256sum "$(basename "$OUT")" >> checksums.txt )
echo "ok $(basename "$OUT") tables=$TABLES"

ls -1t "$BACKUP_DIR/${PG_DB}"_*.dump | tail -n +$((KEEP + 1)) | xargs -r rm -f
