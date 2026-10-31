#!/usr/bin/env bash
# Consistent backup of the password manager data (BV-F-020). Prints no secrets.
set -euo pipefail
umask 077
SRC=${VW_DATA_DIR:?set VW_DATA_DIR to the password manager data folder}
DEST=${VW_BACKUP_DIR:-/var/backups/brainvault/vaultwarden}
KEEP=${KEEP:-14}
mkdir -p "$DEST"
TMP=$(mktemp -d "$DEST/.tmp.XXXXXX")
trap 'rm -rf "$TMP"' EXIT
python3 - "$SRC/db.sqlite3" "$TMP/db.sqlite3" <<'PY'
import sqlite3, sys
src = sqlite3.connect(f"file:{sys.argv[1]}?mode=ro", uri=True)
dst = sqlite3.connect(sys.argv[2])
src.backup(dst)
src.close()
ok = dst.execute("pragma integrity_check").fetchone()[0]
n = dst.execute("select count(*) from ciphers").fetchone()[0]
dst.close()
if ok != "ok":
    sys.exit("integrity check failed")
print(f"ok ciphers={n}")
PY
cp "$SRC/rsa_key.pem" "$SRC/config.json" "$TMP/"
NAME="vaultwarden_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$DEST/$NAME" -C "$TMP" .
(cd "$DEST" && sha256sum "$NAME" >> checksums.txt)
ls -1t "$DEST"/vaultwarden_*.tar.gz | tail -n +$((KEEP + 1)) | xargs -r rm --
echo "ok $NAME"
