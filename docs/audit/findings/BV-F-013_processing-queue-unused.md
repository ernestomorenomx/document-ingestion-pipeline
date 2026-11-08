# BV-F-013: `processing_queue` exists but is unused

- Status: OPEN
- Priority: P2
- Component: state
- Aliases: n8n audit H08
- Evidence (required): the schema has a `processing_queue` table with task type, priority, attempts and status; it held zero rows at audit time and the workflow does not write to it.
- Hypothesis (required): the table was designed for claim and retry but never wired in. Disproved if any workflow node writes to it.
- Impact: lost opportunity; the claim mechanism (BV-F-003) can build on it instead of inventing a queue.
- Decision: none yet; evolve the existing table.
- Change record: none yet.
- Verification (required to close): rows are created and consumed during a synthetic run.
