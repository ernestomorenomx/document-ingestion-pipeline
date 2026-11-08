# BV-F-004: Full-table query loads all extracted text on every run

- Status: OPEN
- Priority: P1
- Component: persistence
- Aliases: n8n audit H04
- Evidence (required): the lookup is `SELECT hash_sha256, status, content_md FROM document;` and the match is done in memory, so each run reads the full text of every document. The target form is a lookup by hash for the file at hand.
- Hypothesis (required): cost grows with the corpus and will become the slowest step. Disproved if the lookup time is flat as rows grow.
- Impact: wasted I/O every two minutes, and a hard ceiling on corpus size.
- Decision: none yet beyond "query by hash with an indexed column".
- Change record: none yet.
- Verification (required to close): compare query plan and rows read before and after on a synthetic corpus.
