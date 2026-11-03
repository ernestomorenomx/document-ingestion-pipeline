# BV-F-024: Listening services on the server are not in the inventory

- Status: OPEN
- Priority: P2
- Component: ops
- Evidence (required): A socket listing shows a Python script, started about 120 days before the audit, listening on all interfaces on a high port, and a web server on the standard web port. Neither is in the production inventory. A connection test to the script's port from another local machine timed out.
- Hypothesis (required): Both predate the pipeline. Reading their code, configuration and data sources, which has not been done, would confirm or disprove it.
- Impact: Unknown. They may expose data on the local network and are not covered by backups or documentation.
- Decision: none yet
- Change record: none yet
- Verification (required to close): Purpose, listening address and data sources are documented, and each service is added to the inventory or retired.
