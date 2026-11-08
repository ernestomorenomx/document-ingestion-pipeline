# BV-F-008: Repository does not match production; unpinned images

- Status: ARCHITECTURE RESOLVED / IMPLEMENTATION PENDING
- Priority: P1
- Component: ops
- Aliases: architecture audit H7
- Evidence (required): the OCR script ran only from a system folder and was not in Git. The converter and orchestrator ran on floating `latest` tags. The schema file in Git was an early prototype (one table, serial key) while production had five tables with UUID keys. The compose file described a different stack from the deployed one.
- Hypothesis (required): the system evolved by hand outside Git. Disproved if a fresh checkout reproduces the deployed stack.
- Impact: the repository is not evidence of what runs, and a rebuild is not reproducible.
- Decision: archive the prototype schema, commit a schema-only baseline taken from production, and document the deployed stack in a descriptive production compose with pinned versions.
- Change record: partial repository-side work recorded in the Task log; the sanitized workflow export and README note are still pending.
- Verification (required to close): a checkout reproduces the documented stack and the schema baseline applies cleanly to an empty database.
