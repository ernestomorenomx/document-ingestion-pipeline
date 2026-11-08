# BV-F-001: Office temporary files reach the document processor

- Status: ARCHITECTURE RESOLVED / IMPLEMENTATION PENDING
- Priority: P0
- Component: gate
- Aliases: n8n audit H01, architecture audit H6
- Evidence (required): execution 84455 ended with HTTP 500 from the converter ("Could not convert stream to Markdown ... filetype is simply not supported"). The failing item was an Office lock file (`~$example.docx`) sitting next to the real document, which had already been processed correctly. The original hash step skipped markers and hidden files but not names starting with `~$`.
- Hypothesis (required): the gate lacked an exclusion rule for Office lock files. Disproved if the same lock file, once excluded, still reaches the converter.
- Impact: one junk file fails the whole scheduled execution and hides real failures in the noise.
- Decision: ADR-007 (gate scope); exclusion list in `tests/fixtures/synthetic/gate/`.
- Change record: none linked yet. A gate workflow is active in production per the owner; its verification has not been linked here.
- Verification (required to close): drop a synthetic `~$example.docx` into the input folder and show that the gate skips it and the execution succeeds; link the output from a change record.
