# ADR-007: Ingestion gate entry-point scope

- Status: CLOSED
- Date: 2026-10-04

## Decision
The gate is mandatory for content that needs identity assignment. Three paths:

| Path | Origin | Handling |
|---|---|---|
| 1 | External SOURCE content arriving by sync | Gate mandatory, then PostgreSQL |
| 2 | User-created KNOWLEDGE (notes) | Lightweight registration, no gate |
| 3 | Human edit to an existing DERIVATIVE | Version event only: SHA check, new `document_version`, no gate |

The gate governs SOURCE content, new `logical_document_id` assignment and unknown semantic layer. It does not govern user-created knowledge or human edits to documents whose identity already exists.

## Consequences
The gate stays small and strict. Editing a note never triggers extraction, and sync never creates identity.
