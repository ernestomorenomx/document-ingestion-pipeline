# BV-F-020: The password manager's data folder was not covered by any backup

- Status: OPEN
- Priority: P1
- Component: ops
- Evidence (required): The manager keeps its data in one folder on the server, and no existing backup covers it. Its database runs in write-ahead mode: in the folder listing the main file dated months back while the log file was modified the same day, so copying only the main file would produce a stale backup.
- Hypothesis (required): A copy made with SQLite's backup interface, which merges the main file and the log, produces a consistent archive that restores correctly. It would be disproved if a restored copy had a different item count or failed its integrity check.
- Impact: Loss of every stored credential if the server disk fails.
- Decision: scripts/backup-vaultwarden.sh, run daily by a systemd timer 10 minutes after the database backup.
- Change record: none yet.
- Verification (required to close): A restore test of an archive (done in a temporary folder), an offsite copy with matching checksum (done), and one unattended run of the timer producing a verified archive (pending).
