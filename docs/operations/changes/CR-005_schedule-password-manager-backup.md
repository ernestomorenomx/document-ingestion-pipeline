# CR-005: Daily backup of the password manager data

- Date: 2026-10-31, verified 2026-11-01
- Findings addressed: BV-F-020
- Approved by: owner, in the working session (no pull request or issue link yet)
- Backup taken (required): The change only adds a backup and reads the manager's data folder. Before any later update of the manager, a manual run of the same script and a full copy of the data folder were made.
- Change: Installed scripts/backup-vaultwarden.sh as a system script, a one-shot service that runs it under the owner's user with the data folder passed as an environment variable, and a daily timer at 02:10 that catches up if the server was off. The script copies the database with SQLite's backup interface, checks integrity, adds the signing key and settings file, writes a private archive with a recorded checksum and keeps the newest 14.
- Rollback: Disable and remove the timer, the service and the installed script. Existing archives stay.
- Verification (required): A manual service start ended with result success and exit status 0 and produced a private archive. A restore test of an archive in a temporary folder passed according to the owner (checksum, integrity, item counts; the output was not shared). An offsite copy to the laptop matched the server checksum. The first unattended run, on 2026-11-01 at 02:10, created a new private archive of about 15.6 KB with result success and exit status 0.
- Residual risk: The item-count line of a service run is not visible to the owner's user. The offsite copy is manual. Archives hold the signing key and settings file unencrypted, so they are kept outside the synced vault tree. The master password is not backed up and cannot be recovered.
