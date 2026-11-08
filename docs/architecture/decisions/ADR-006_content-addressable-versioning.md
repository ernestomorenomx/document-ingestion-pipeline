# ADR-006: Content-addressable versioning

- Status: CLOSED
- Date: 2026-10-04

## Decision
The same `content_id` can be referenced by several `document_version` rows. `content.sha256` is UNIQUE. A revert is a version event, not a new content object.

```
v1 -> content A (original)
v2 -> content B (modification)
v3 -> content A (revert: points to the existing content_id)
```

Gate logic: compute SHA-256, look it up in `content`. If it exists, reuse `content_id` and create a new `document_version`. If not, insert `content`, then create the version.

## Consequences
A revert is detected as a version event in PostgreSQL. Vectors for the earlier content already exist, so a revert costs no re-embedding. SHA-256 is necessary for content identity but not sufficient for logical identity (see ADR-002).
