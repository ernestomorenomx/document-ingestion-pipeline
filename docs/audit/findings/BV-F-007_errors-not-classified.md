# BV-F-007: Errors not classified; no retry or per-attempt trace

- Status: ARCHITECTURE RESOLVED / IMPLEMENTATION PENDING
- Priority: P1
- Component: state
- Aliases: architecture audit H10 and H11
- Evidence (required): 7,207 errors were recorded with `retryOf=0` and `retrySuccessId=0`. There is no TRANSIENT, DETERMINISTIC or UNKNOWN classification and no per-attempt record of processor, version, duration or error class.
- Hypothesis (required): every failure is retried by the next schedule tick or ignored, with no distinction. Disproved if a deterministic failure stops being retried.
- Impact: a permanent failure repeats forever; a transient one is not retried with backoff; neither can be diagnosed.
- Decision: directives D9 and D10; TRANSIENT retries with backoff, DETERMINISTIC goes to QUARANTINE, UNKNOWN gets limited retries.
- Change record: none yet.
- Verification (required to close): one synthetic fixture per class ends in the expected state with an attempt row.
