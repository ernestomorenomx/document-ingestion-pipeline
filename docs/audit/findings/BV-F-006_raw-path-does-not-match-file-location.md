# BV-F-006: `raw_path` does not match the physical file location

- Status: ARCHITECTURE RESOLVED / IMPLEMENTATION PENDING
- Priority: P1
- Component: persistence
- Aliases: n8n audit H06
- Evidence (required): the database stores `/raw/<year>/<filename>`, but processed originals are moved to an archive folder inside the ingestion tree. The stored path does not resolve to any known location.
- Hypothesis (required): the path was a planned layout that was never implemented. Disproved if a stored path resolves to an existing file.
- Impact: a database row cannot be traced to its bytes.
- Decision: ADR-002 (`physical_copy` records the real repository, device and path).
- Change record: none yet.
- Verification (required to close): for every row, the recorded path resolves to a file whose SHA-256 matches.
