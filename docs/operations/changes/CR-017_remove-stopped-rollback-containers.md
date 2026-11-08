# CR-017: stopped rollback containers removed

- Date: 2026-11-08
- Findings addressed: BV-F-025 (credentials left in old container definitions), hygiene
- Approved by: owner, explicit approval in chat on 2026-11-08 for the listed containers
- Backup taken: nightly dumps of both databases; the script checked that the newest dump of each is under 26 hours old, non-empty and has its checksum recorded. Containers were removed without deleting volumes, so no data folder was touched
- Change: five stopped containers (previous versions of the password manager, the database, the messaging gateway, the converter and the container manager) removed with docker rm; a temporary environment file in the home folder shredded. The previous orchestrator container was kept on purpose as rollback. A pre-cutover data copy was left untouched pending a decision
- Rollback: none for the removed containers. They can be recreated from their retained images, and any credential that lived in their definitions must come from the password manager
- Verification: all six live services were running before and after; only the previous orchestrator container remains among the stopped rollback containers; the temporary environment file no longer exists
- Residual risk: images of the removed containers remain on disk; the pre-cutover data copy needs a decision; credentials that lived in the removed definitions should be treated as exposed to anyone who had access to the server and rotated when convenient
