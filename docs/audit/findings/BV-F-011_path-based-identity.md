# BV-F-011: Path-based identity; SHA-256 is not sufficient as logical identity

- Status: ARCHITECTURE RESOLVED / IMPLEMENTATION PENDING
- Priority: P2
- Component: persistence
- Aliases: architecture audit H1, H2, H3 and H12
- Evidence (required): the same content was found in several locations; documents move; names diverge. Equal SHA-256 does not prove the same logical document, and different SHA-256 does not prove different ones. PostgreSQL acts as a passive catalog with a one-row-per-file assumption.
- Hypothesis (required): identity was inferred from file placement. Disproved if renaming a file creates no new logical document.
- Impact: moves look like deletes plus creates; generations cannot be related.
- Decision: ADR-001, ADR-002, ADR-006.
- Change record: none yet.
- Verification (required to close): synthetic move, rename and revert fixtures keep a single logical document with the right versions.
