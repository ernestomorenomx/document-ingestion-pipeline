# BV-F-017: Orchestrator workflows and credentials live outside the database backup

- Status: OPEN
- Priority: P1
- Component: ops
- Aliases: production inventory
- Evidence (required): the orchestrator runs on SQLite plus a data folder, so its workflows, credentials and encryption key are not covered by the PostgreSQL dump. Workflow exports and the config folder are copied by a separate step, and an encrypted copy of the keys is kept off the server.
- Hypothesis (required): the PostgreSQL backup was treated as the whole backup. Disproved by restoring the orchestrator from the separate copies on a clean host.
- Impact: losing the data folder loses every workflow and makes stored credentials unreadable.
- Decision: none yet; options are moving the orchestrator to PostgreSQL or formalizing and testing the separate copy.
- Change record: none yet.
- Verification (required to close): a tested restore of the orchestrator from backup copies only.
