# BV-F-003: No transactional claim; orphan processing markers

- Status: ARCHITECTURE RESOLVED / IMPLEMENTATION PENDING
- Priority: P1
- Component: state
- Aliases: n8n audit H03, architecture audit H9
- Evidence (required): the workflow runs every two minutes and creates a `.procesando` marker only after hashing and the database lookup, so two overlapping runs can both pass the check. Three markers were found permanently on disk, zero bytes, with their originals still present.
- Hypothesis (required): a file marker is not an atomic claim. Disproved if two concurrent runs on the same file never double-process.
- Impact: duplicate processing, and markers that cannot be told apart from live work.
- Decision: claim with lease in PostgreSQL (state machine, `processing_queue`).
- Change record: none yet.
- Verification (required to close): run two concurrent executions against one synthetic file and show one claim and one result.
