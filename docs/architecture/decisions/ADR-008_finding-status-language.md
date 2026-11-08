# ADR-008: Finding status language

- Status: CLOSED
- Date: 2026-10-04

## Decision
Three finding states only:

| State | Meaning |
|---|---|
| OPEN | Problem identified, no design solution |
| ARCHITECTURE RESOLVED / IMPLEMENTATION PENDING | Design closed, no verified production change |
| RESOLVED | Design closed and the fix verified in production |

`RESOLVED` without qualification is allowed only when verification output is linked from a change record. Process words such as "done" or "fixed" are not statuses.

## Consequences
A reader can tell at a glance whether a problem is understood, designed, or proven fixed.
