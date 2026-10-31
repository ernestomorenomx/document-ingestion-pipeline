# CR-002: Office lock file removed from the input folder

- Date: 2026-10-29
- Findings addressed: BV-F-001
- Approved by: owner, in the working session (no pull request or issue link yet)
- Backup taken (required): The lock file and its processing marker were copied to a private folder outside the synced tree, with the SHA-256 of the copy compared against the value recorded in the earlier audit.
- Change: Copy first, verify, then remove the lock file and its marker from the input folder. Nothing else was touched. At the time of the second command the owner's terminal showed both files already absent from the input folder, so the removal had happened in an earlier run; the quarantine copy was confirmed.
- Rollback: Copy the quarantined file back into the input folder.
- Verification (required): The next scheduled run after the removal succeeded and registered the pending PDF. The document table went from 23 to 24 ready rows, the first new row since 2026-08-16, and the new row has 119,674 extracted characters from the primary converter with no OCR. The input folder was empty and the processed and archive folders each grew by one file.
- Residual risk: This is a manual workaround. Word recreates lock files whenever someone opens a synced document, so the problem can return until the gate filter (CR-003) is in place. BV-F-001 closes only with that verification.
