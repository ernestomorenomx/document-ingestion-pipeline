# BV-F-012: Duplicate content across locations and generations

- Status: ARCHITECTURE RESOLVED / IMPLEMENTATION PENDING
- Priority: P2
- Component: persistence
- Aliases: architecture audit H4 and H5, synchronization audit
- Evidence (required): duplicate groups were found by SHA-256. The two audits report different figures because their scopes differ (16 groups among 139 Markdown files versus 28 groups across the whole tree); fresh evidence with a single scope is needed before publishing a number. One note existed as two generations with six physical copies.
- Hypothesis (required): duplicates come from reorganizations and copies, not from corruption. Disproved if a duplicate group differs in anything but location.
- Impact: noise in retrieval and uncertainty about which copy is canonical. Equal hashes do not by themselves justify deleting anything.
- Decision: ADR-002 and ADR-006 model copies and generations; cleanup is a manual task after the model exists.
- Change record: none yet.
- Verification (required to close): a re-count with one stated scope, and a cleanup log in which nothing is removed without approval.
