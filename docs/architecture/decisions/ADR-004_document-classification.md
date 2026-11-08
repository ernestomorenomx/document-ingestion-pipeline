# ADR-004: Three independent classification dimensions

- Status: CLOSED
- Date: 2026-10-04

## Context
One label cannot carry who produced a document, how it was processed and what kind of knowledge it holds. Retrieval needs all three.

## Decision
| Dimension | Meaning | Values |
|---|---|---|
| semantic_layer | who produced it, epistemic weight | SOURCE, DERIVATIVE, KNOWLEDGE |
| media_type | how it was processed, extraction confidence | PDF, DOCX, MD, IMAGE, AUDIO, XLSX |
| document_class | what knowledge it holds, retrieval strategy | two-level controlled vocabulary |

Base classes are fixed and immutable: CONTRACT, STANDARD, REPORT, MANUAL, LOG, TEMPLATE, REFERENCE, CORRESPONDENCE, OTHER.
Subclasses are extensible by domain (HSE, CIVIL, PKM, KNOWLEDGE); the initial sets are in DN-002.

Extension rule: new types are added only as subclasses, never as base classes. A new subclass requires `base_class`, `domain`, an `UPPER_SNAKE_CASE` name and a `rag_strategy`.

`rag_strategy` values: CITE_LITERAL, SYNTHESIZE, CHRONOLOGICAL, PROCEDURAL.

## Consequences
Retrieval can weight and chunk by class without re-reading content. Vocabulary growth is controlled and cannot fragment the base classes.
