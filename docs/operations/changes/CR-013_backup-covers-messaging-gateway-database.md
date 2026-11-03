# CR-013: Scheduled database backup also covers the messaging gateway database

- Date: 2026-11-03
- Findings addressed: BV-F-027 (partially: the scheduled dump now includes the gateway database; the finding stays open until the checks listed below pass).
- Approved by: owner, in the working session
- Backup taken (required): The installed backup script was copied next to itself with a date suffix, with the same mode and owner, before it was replaced. The script in the repository was byte-identical to the installed one before the change (compared with a diff).
- Change: The script now loops over a list of databases, by default the main one and the gateway one, and can be overridden with an environment variable. For each database it dumps, checks that the dump is not empty and lists at least one table, writes a checksum and rotates to the last 14 dumps of that database. The timer and service units were not touched; the unit runs as the owner's user and sets no database variables.
- Rollback: Copy the saved script back over the installed one. No schedule or unit has to be undone. Not used.
- Verification (required): Observed in command output: a manual start of the real service finished successfully and its journal showed one "ok" line for each database, with 5 tables in the main dump and 37 in the gateway dump; both new dump files existed with sizes of about 980 KB and 95 KB; the two checksum lines verified; the gateway dump listed 37 public tables when read back through the database container.
- Residual risk: The next scheduled run at 02:00 has not been observed with the new script. No restore test has been done on a scheduled gateway dump (the earlier test was on the one-off dump of CR-012). The off-server copy is still a manual copy and has not yet been done for the gateway dump, which contains message data and must go to encrypted storage. Rotation keeps 14 dumps per database, so the gateway dump adds about 1.3 MB per two weeks of retention.
