# ADR-005: Knowledge spaces are many-to-many

- Status: CLOSED
- Date: 2026-10-04

## Context
One document is often relevant to several knowledge bases at once.

## Decision
A logical document can belong to several knowledge spaces. `knowledge_space_id` is removed from `logical_document`; membership lives in the junction table `document_space(document_id, space_id, relevance, added_at, added_by)` with relevance PRIMARY, SECONDARY or REFERENCE.

Example: one standards document is REFERENCE in a personal space, PRIMARY in a safety space and SECONDARY in a project space, with a single logical_document row.

The vector-store payload carries `document_id`, `knowledge_spaces[]`, `primary_space`, `semantic_layer`, `base_class`, `subclass`, `rag_strategy` and `extraction_confidence`. The full payload is DN-003.

## Consequences
No duplication of documents across spaces. Re-assigning a space is a metadata change and never a re-embedding.
