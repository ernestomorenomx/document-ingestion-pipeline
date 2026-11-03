# CR-007: Reset of the workflow engine owner account, evaluated and not executed

- Date: 2026-11-01
- Findings addressed: none closed. Related to BV-F-017 and BV-F-022.
- Approved by: owner, in the working session. The production reset was never approved to run.
- Backup taken (required): A consistent copy of the engine database, made with the SQLite backup interface while the engine kept running, plus its key file, in a private folder on the root disk with SHA-256 values recorded. The copy passed the integrity check and showed 3 active flows and 2 credentials, matching production.
- Change: None in production. The reset command ran only against a second copy, in a throwaway container without network, using the exact image of the running engine.
- Rollback: Not applicable. Production was not touched.
- Verification (required): On the copy, one owner with email and password became one owner with both empty; the API key row, 3 active flows, 2 credentials and their ownership were unchanged. The owner then regained access to the interface, so the production reset was cancelled.
- Residual risk: A reset leaves the owner unclaimed until someone registers, and the engine is published on all interfaces (BV-F-022). The restored access was reported by the owner, not observed. The working copy was deleted afterwards; the verified backup copy remains.
