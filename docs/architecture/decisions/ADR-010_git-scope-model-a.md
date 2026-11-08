# ADR-010: Git scope (Model A)

- Status: CLOSED
- Date: 2026-10-04

## Decision
| Git controls | PostgreSQL controls |
|---|---|
| pipeline code, SQL schema definitions | logical documents, versions, content |
| workflow exports, OCR scripts | physical copies, spaces, state machine |
| ADRs, design notes, architecture docs | processing attempts, error log, lineage |
| tests and fixtures, deployment config | all runtime data |

The `sql/` directory is the intersection: schema definitions live in Git, data lives in PostgreSQL. Git is invisible to the retrieval runtime.

## Consequences
The repository can be public and reproducible without containing any real document or runtime data.
