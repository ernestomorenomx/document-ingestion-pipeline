# BV-F-018: An empty input folder makes the file-read node fail

- Status: RESOLVED
- Priority: P1
- Component: gate
- Evidence (required): In the execution detail of the original workflow, the first read node ends with the error "No file(s) found" and 0 items whenever the input folder holds no matching file, so every idle run ended in error (about 720 failed runs per day). After the gated workflow replaced it, four consecutive idle runs ended in success; the per-node detail shows the listing node returning output, the gate returning 0 items and no later node executing.
- Hypothesis (required): The read node treats zero files as an error. It would be disproved if the error persisted after the node was replaced by a listing command.
- Impact: Failed runs could not be told apart from real failures, which hid a ten-week ingestion stop (BV-F-001), and they filled n8n's execution history (BV-F-009).
- Decision: DN-004 (listing command plus gate in a Code node).
- Change record: CR-003.
- Verification (required to close): Consecutive scheduled runs of the gated workflow in success with the input folder idle, and the per-node item counts above. See CR-003.
