# Gate fixtures (synthetic)

Tests the Ingestion Gate v1 rules from DN-004 (BV-F-001, BV-F-018).

- `generate.py` creates deterministic fixtures in `generated/` (git-ignored) and writes `manifest.json`.
- `manifest.json` lists every fixture with its size, simulated age, SHA-256 and the expected decision and reason.
- Scenario `mixed`: valid files, Office lock, hidden, marker, temp extensions, empty, unsupported, too fresh, and a corrupt PDF that passes the gate by design.
- Scenario `empty_folder`: no files; expected result is zero accepted items and no error.

Fixtures are generated from scratch, never anonymized from real documents (ADR-011).
