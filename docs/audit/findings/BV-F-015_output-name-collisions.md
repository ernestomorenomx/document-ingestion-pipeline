# BV-F-015: Output name collisions on `<filename>.md`

- Status: OPEN
- Priority: P2
- Component: persistence
- Aliases: synchronization audit
- Evidence (required): processed output is named after the input filename. Two inputs with the same name from different origins would compete for the same output file.
- Hypothesis (required): filename is used as an implicit key. Disproved if two same-named synthetic inputs both produce distinct outputs.
- Impact: one document silently overwrites another.
- Decision: none yet; name outputs from content identity, not filename.
- Change record: none yet.
- Verification (required to close): two same-named synthetic inputs yield two distinct outputs.
