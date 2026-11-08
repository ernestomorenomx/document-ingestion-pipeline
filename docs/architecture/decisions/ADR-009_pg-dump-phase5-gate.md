# ADR-009: Verified backup is a hard gate before controlled implementation

- Status: CLOSED
- Date: 2026-10-04

## Decision
All four conditions must hold before the controlled-implementation phase of the design track begins:

1. Automated execution: `pg_dump` runs on a schedule without manual intervention (cron, workflow schedule or systemd timer).
2. Verified output: each backup produces a file with a known SHA-256, confirmed to exist and be non-empty.
3. Secondary copy: the backup lives somewhere other than the server.
4. Tested restore: at least one successful restore into a test database, executed and verified, not assumed.

## Consequences
Schema and pipeline changes are not made on a platform whose only copy of its state is the machine being changed. The checklist lives in `docs/operations/BACKUP_GATE.md`.
