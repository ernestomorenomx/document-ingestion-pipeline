# BV-F-009: Orchestrator SQLite database is oversized with no retention policy

- Status: OPEN
- Priority: P1
- Component: ops
- Aliases: n8n audit H09
- Evidence (required): the orchestrator's SQLite file is about 15 GB with roughly 10,000 stored executions, while the document corpus is a few tens of megabytes.
- Hypothesis (required): execution data, including binaries, accumulates without pruning. Disproved if a retention setting is already enforced.
- Impact: slow backups, risk of disk pressure, and a large blast radius for any corruption.
- Decision: none yet; retention window (for example 14 days) to be set after a verified backup.
- Change record: none yet.
- Verification (required to close): size and execution count after pruning, plus a successful scheduled run afterwards.
