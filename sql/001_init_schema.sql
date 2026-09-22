-- document-ingestion-pipeline
-- Schema inicial: tabla de documentos ingeridos con deduplicación por hash

CREATE TABLE IF NOT EXISTS documents (
    id          SERIAL PRIMARY KEY,
    filename    TEXT        NOT NULL,
    sha256      TEXT        NOT NULL UNIQUE,  -- deduplicación
    source_path TEXT        NOT NULL,
    markdown    TEXT,
    ingested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    status      TEXT        NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'processed', 'error'))
);

CREATE INDEX IF NOT EXISTS idx_documents_sha256 ON documents(sha256);
CREATE INDEX IF NOT EXISTS idx_documents_status ON documents(status);
