# ADR-011: Synthetic fixtures only

- Status: CLOSED
- Date: 2026-10-04

## Decision
The repository contains only synthetic, programmatically generated fixtures. Real documents are structurally excluded by `.gitignore`. Fixtures are generated, never anonymized from real documents, and are deterministic: the same script yields the same SHA-256 every time.

```
tests/fixtures/synthetic/
  duplicate/    same SHA, two locations
  versioning/   v1 = A, v2 = B, v3 = A
  generations/  two generations, one logical document
  conflicts/    CANDIDATE state, no automatic destruction
  gate/         exclusion filter: temp files, hidden files, markers, corrupt files
  ocr/          READY requires validation, LOW_CONFIDENCE explicit
```

Each fixture directory has a README stating what it tests and the expected behaviour.

## Consequences
Anyone can reproduce the behaviour without access to private data, and a published hash can never confirm a private file.
