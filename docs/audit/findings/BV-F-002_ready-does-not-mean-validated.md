# BV-F-002: READY does not mean validated; no explicit failed or quarantined state

- Status: ARCHITECTURE RESOLVED / IMPLEMENTATION PENDING
- Priority: P1
- Component: state
- Aliases: n8n audit H02 and H07, architecture audit H8
- Evidence (required): an image row was found with status `ready` and zero bytes of OCR content. The document table has a free-text status; at audit time all 23 rows were `ready`, with none `processing`, `pending` or `failed`.
- Hypothesis (required): `ready` is written when the workflow finishes, not when the output passes a quality check. Disproved if a failed extraction ever lands in a state other than `ready`.
- Impact: partial or empty content is served as if it were complete.
- Decision: ADR-008 and the state machine (`docs/architecture/STATE_MACHINE.md`): PARTIAL, LOW_CONFIDENCE, QUARANTINE.
- Change record: none yet.
- Verification (required to close): a synthetic empty-extraction fixture ends in a non-ready state; link the run output.

## Addendum (2026-11-08)
CR-018 deployed the classification function and a review view in the database. One row that was marked ready with empty content was reclassified to low_confidence. The workflow does not use classification yet, so the status stays ARCHITECTURE RESOLVED / IMPLEMENTATION PENDING.
