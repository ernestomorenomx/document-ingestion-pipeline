# ADR-002: A document is a logical document (four-level identity model)

- Status: CLOSED
- Date: 2026-10-04

## Context
Treating a file as a document breaks as soon as the same content appears in several places, a document is renamed or moved, or a document has several generations.

## Decision
`document` in PostgreSQL means a logical document: the persistent semantic entity. A physical file is never a document; it is a physical copy of a content object.

| Level | Answers | Lifetime |
|---|---|---|
| logical_document | what it is | permanent |
| document_version | which iteration, which is canonical | per generation |
| content | what it contains (SHA-256, extracted text) | per distinct bytes |
| physical_copy | where it lives (repository, device, path) | per location |

Target tables: `logical_document`, `document_version`, `content`, `physical_copy`. Column-level detail lives in DN-001 and is finalized in `sql/002_identity_model.sql`.

Version canonicality values: HEAD, HISTORICAL, CANDIDATE, CONFLICT, REJECTED.

## Validation case
One logical document with two generations and six physical copies maps to: 1 logical_document row, 2 document_version rows, 2 content rows, 6 physical_copy rows.

## Consequences
The current single `document` table must be decomposed in the migration design phase. Path, filename and device are never primary identity (directive D1).
