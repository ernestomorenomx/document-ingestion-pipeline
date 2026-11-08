# BV-F-014: No automated, verified, secondary-copy database backup

- Status: RESOLVED
- Priority: P1
- Component: ops
- Aliases: ADR-009
- Evidence (required): at audit time there was no scheduled backup. Now a systemd timer runs the backup script at 02:00 for both databases. The run of 2026-11-08 produced a verified dump of each (5 and 37 tables) unattended, with SHA-256 lines in the checksum file. A restore into a temporary database matched row counts and a content hash for every table, and an encrypted copy was taken off the server.
- Hypothesis (required): the only copy of the state lived on the machine being changed. Disproved by the restore test and the off-server copy.
- Impact: before the fix, loss of the host meant loss of all identity, state and lineage.
- Decision: ADR-009.
- Change record: CR-013 (scheduled backup covers both databases).
- Verification (required to close): scheduled run output, checksum line, restore comparison and off-server checksum match, as recorded in the Task log and the closing commit for the related messaging-gateway finding. Link a dedicated verification record if one is added later.
