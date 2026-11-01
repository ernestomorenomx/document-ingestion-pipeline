# BV-F-020: The password manager's data folder was not covered by any backup

- Status: RESOLVED
- Priority: P1
- Component: ops
- Evidence (required): The manager keeps its data in one folder on the server, and no existing backup covers it. Its database runs in write-ahead mode: in the folder listing the main file dated months back while the log file was modified the same day, so copying only the main file would produce a stale backup.
- Hypothesis (required): A copy made with SQLite's backup interface, which merges the main file and the log, produces a consistent archive that restores correctly. It would be disproved if a restored copy had a different item count or failed its integrity check.
- Impact: Loss of every stored credential if the server disk fails.
- Decision: scripts/backup-vaultwarden.sh, run daily by a systemd timer 10 minutes after the database backup.
- Change record: CR-005.
- Verification (required to close): A restore test of an archive in a temporary folder (owner-reported), an offsite copy with matching checksum, and an unattended run of the timer on 2026-11-01 that produced a private archive with result success.
- Residual risk: The offsite copy is manual and archives are unencrypted on both machines until the encrypted image and disk encryption are in place.
