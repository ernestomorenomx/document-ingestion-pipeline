# document-ingestion-pipeline

Self-hosted pipeline that turns PDF, DOCX and EPUB files into Markdown, with SHA-256 deduplication in PostgreSQL. n8n orchestrates MarkItDown for conversion and Tesseract as an OCR fallback. It runs on a Debian homelab server.

This repository is also an audit trail: each problem found in production is written down as a finding with its evidence, and each change as a change record with its backup, rollback and verification.

## Current status

| Area | State |
| --- | --- |
| Ingestion gate: rejects lock files, hidden and temporary files, unsafe names; an empty input folder is not an error | Deployed and verified in production |
| Daily PostgreSQL backup with a tested restore and an offsite copy | Verified |
| Daily backup of the password manager's data | Verified |
| Processing states, claims and retries | Not started |
| OCR that never reports partial text as complete | Not started |
| Logical document identity model | Designed, not implemented |

Known limitations of the deployed flow: OCR stops at 20 pages, the duplicate check loads the whole document table on every run, and a marker file is the only guard against concurrent runs. The findings BV-F-001 to BV-F-017 are not published yet; BV-F-018 to BV-F-021 are in `docs/audit/findings/`.

## Repository layout

| Path | What it holds |
| --- | --- |
| `n8n/gate/gate.js` | The ingestion gate, pasted into an n8n Code node |
| `n8n/flows/` | Sanitized workflow exports: the original flow and the one with the gate |
| `deploy/production.compose.yml` | Describes the deployed stack with pinned image versions. The running containers were not created from it |
| `docker-compose.yml` | An early reference stack. It does not match the deployment: different images, a different n8n storage and no file-sync service |
| `sql/` | The schema taken from production, and the archived prototype |
| `scripts/` | Backup scripts, the OCR script and the export sanitizer |
| `tests/` | Synthetic fixtures with expected results and the gate test runner |
| `docs/` | Design note, findings and change records |

## Try it

The gate tests need Node.js only:

    node tests/gate/run_gate_tests.js

To regenerate the synthetic fixtures (Python 3, standard library only):

    python3 tests/fixtures/synthetic/gate/generate.py

## Deployment

There is no one-command deployment. Copy `.env.example` to `.env` and fill it in, use `deploy/production.compose.yml` as the description of the stack, import a flow from `n8n/flows/`, replace the `<...>` placeholders with your own paths and link your credentials.

## Safety rules

Real documents, secrets and database dumps never enter Git: `.gitignore` blocks them, the fixtures are generated from scratch, and workflow exports go through `scripts/sanitize-n8n-export.py`, which refuses to write if any real value survives.

## Author

Ernesto Moreno - @ernestomorenomx  
HSE Consultant and Automation Engineer - Culiacan, Sinaloa, MX
