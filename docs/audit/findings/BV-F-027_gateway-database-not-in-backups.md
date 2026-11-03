# BV-F-027: The messaging gateway database is not covered by any backup

- Status: OPEN
- Priority: P1
- Component: ops
- Evidence (required): The scheduled backup script dumps one named database. A listing of databases showed a second one, used by the messaging gateway, that the script does not name. A one-off dump of that database taken for CR-012 was about 95 KB and restored with matching row counts, so it holds real data. The archive of the gateway data folder was 159 bytes.
- Hypothesis (required): The script was written when only one database existed. A restore test of the latest scheduled dump showing no gateway tables would confirm it; a second scheduled dump I did not see would disprove it.
- Impact: Losing the disk loses the gateway's stored sessions, contacts and messages with no way to recover them, and the device pairing would have to be redone.
- Decision: none yet
- Change record: none yet. CR-012 took a one-off copy only, which is not a scheduled backup.
- Verification (required to close): The scheduled backup includes the gateway database, a restore test into a temporary database matches row counts, and a copy exists off the server. Decide whether the almost empty data folder needs to be included.
- Addendum (2026-11-03): CR-013 added the gateway database to the scheduled dump (observed on a manual start of the real service). The finding stays OPEN until the 02:00 run is observed with the new script, a restore test of a scheduled gateway dump matches row counts, and a copy exists off the server in encrypted storage.
