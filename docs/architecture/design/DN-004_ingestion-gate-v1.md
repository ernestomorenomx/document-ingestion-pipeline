# DN-004: Ingestion Gate v1

- Status: DESIGN NOTE (editable until implementation starts)
- Findings addressed: BV-F-001 (temp files reach the processor), BV-F-018 (empty input folder fails the workflow)
- Related: ADR-007 (gate scope), ADR-008 (status language), ADR-011 (synthetic fixtures)

## Context

Production evidence showed that one Office lock file (`~$*.docx`) made the MarkItDown call fail with HTTP 500 and aborted the whole batch, so no document was registered for about ten weeks. A second run on an empty input folder also failed, because the first read node errors on "No file(s) found". The existing filter only skips names starting with `.` and names ending in `.procesando`.

## Decisions (confirmed by the owner)

1. The gate excludes `tmp`, `part`, `crdownload` and `download` extensions.
2. The gate is a `Code` node inside the n8n workflow.

## Constraints

- Code nodes in this deployment allow only the `crypto` builtin, so the node cannot touch the filesystem. It works on metadata supplied by an upstream `Execute a command` node.
- The gate decides from metadata only: name, size, timestamps. It never inspects content.

## Input and output

Upstream listing (one line per regular file, top level of the input folder only):

    find <input_dir> -maxdepth 1 -type f -printf '%f\t%s\t%T@\t%C@\n'

Fields: name, size in bytes, mtime and ctime in epoch seconds. Known limitation: a file name containing a newline breaks the line format.

Gate output: only accepted items, with the field names the next node already expects. Zero accepted items is a normal outcome and the workflow ends in `success`.

## Rules

Evaluated in this order; the first match rejects the file and sets the reason code.

| # | Reason code | Rule |
| --- | --- | --- |
| 1 | HIDDEN | name starts with `.` |
| 2 | OFFICE_LOCK | name starts with `~$` |
| 3 | MARKER | name ends with `.procesando` |
| 4 | TEMP_EXT | extension (case-insensitive) is `tmp`, `part`, `crdownload` or `download` |
| 5 | EMPTY | size is 0 bytes |
| 6 | UNSUPPORTED_EXT | extension not in the allowed list |
| 7 | UNSTABLE | now minus max(mtime, ctime) is below the stability window (default 60 s) |

Allowed list v1: `pdf`, `docx`, `epub`. These are the only originals observed in the real input and archive folders. The list is a configuration constant at the top of the node. Extending it (for example xlsx or images) requires checking what MarkItDown supports first, and is an open item.

Rejected files stay where they are. The gate never moves, renames or deletes anything (D7).

## Out of scope for v1

- Content validation. A corrupt PDF passes the gate by design; its failure belongs to extraction and error classification (BV-F-002, BV-F-007).
- Claim, lease and orphan `.procesando` handling (BV-F-003, level 6). The gate does not skip a file because a marker exists.
- Per-attempt logging of rejected files (BV-F-007). v1 writes only a count and reason summary to the node console.
- The full-table query repeated per item (BV-F-004).

## Verification plan

1. Offline: run the rules against the synthetic fixtures in `tests/fixtures/synthetic/gate/` and compare with `manifest.json`.
2. In production, after an approved change record: with the folder empty, the run ends in `success`; with a lock file present next to a valid file, the valid file is processed and the lock file stays untouched.

## Open items

- Allowed extension list beyond pdf, docx and epub.
- Stability window value (60 s is a starting point).
- Confirm in n8n that downstream nodes end in `success` with zero input items.
