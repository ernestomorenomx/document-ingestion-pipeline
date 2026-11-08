# ADR-001: PostgreSQL is the source of truth

- Status: CLOSED
- Date: 2026-10-04
- Supersedes: the implicit assumption that a document is a file path

## Context
Identity, state and lineage were inferred from the filesystem. The filesystem knows bytes and locations, not which document a file belongs to, which version is current, or where it came from.

## Decision
PostgreSQL is the only authority for logical identity, state, versions, relationships and lineage. The filesystem stores bytes only. No document exists for the platform until PostgreSQL recognizes it, and the ingestion gate is the only entry point that assigns identity.

## Consequences
- An automated, verified `pg_dump` is a structural precondition, not a later improvement (see ADR-009).
- Any process that touches files without registering them in PostgreSQL is outside the system.
- Recovery without a backup is partial by design (see ADR-003).

```
        PostgreSQL (source of truth)
     identity | lineage | state
                  |
              filesystem (bytes only)
```
