# ADR-003: Filesystem recoverability (D4) versus PostgreSQL authority (D5)

- Status: CLOSED
- Date: 2026-10-04

## Context
ADR-001 makes PostgreSQL the authority. That raises the question of what survives if PostgreSQL is lost and no backup exists.

## Decision
- D5 is unchanged: PostgreSQL governs semantics.
- D4 is redefined: the filesystem keeps bytes sufficient for controlled re-ingestion.

Recoverable by re-ingestion: SHA-256, file type, physical location, processable content.
Accepted loss: explicit lineage, document relationships, state history, conflict resolutions, knowledge-space assignments.

| Level | Situation | Outcome |
|---|---|---|
| 1 | Normal operation | PostgreSQL is absolute authority |
| 2 | Disaster with backup | `pg_dump` plus filesystem snapshot gives full restoration |
| 3 | Disaster without backup | Re-ingestion; partial recovery, semantic loss accepted |

## Consequences
Level 3 is a last resort and is stated openly as lossy. Backups (ADR-009) are what keep the system at level 2.
