# document-ingestion-pipeline

Automated document ingestion pipeline that converts PDF and DOCX to Markdown, with SHA-256 deduplication via PostgreSQL. Orchestrated with n8n on a self-hosted homelab server.

## Stack

| Component | Technology |
|-----------|------------|
| Orchestration | n8n self-hosted |
| Conversion | MarkItDown + FastAPI |
| Deduplication | SHA-256 + PostgreSQL UNIQUE |
| Infrastructure | Docker Compose + Debian 13 |

## Features

- Converts PDF and DOCX to clean Markdown
- Idempotent ingestion via SHA-256 deduplication
- Fully containerized with Docker Compose
- n8n flow exportable and reusable
- Full ingestion history in PostgreSQL

## Quick Start

Clone the repo, copy .env.example to .env, run docker compose up -d
Then import a flow from n8n/flows/ into n8n: document_ingestion_v1.json is the original flow and document_ingestion_v2_gate.json adds the ingestion gate. Both are sanitized: replace the `<...>` path placeholders with your own paths and link your credentials after importing.

## Author

Ernesto Moreno - @ernestomorenomx  
HSE Consultant and Automation Engineer - Culiacan, Sinaloa, MX
