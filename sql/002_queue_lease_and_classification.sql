-- 002: claim with lease for processing_queue and extraction classification primitives.
-- Addresses BV-F-003, BV-F-013 and the database side of BV-F-002 (change record CR-018).
-- Additive only: the live workflow does not call any of these objects yet.
BEGIN;
SET LOCAL lock_timeout = '5s';

DO $$
BEGIN
  IF to_regclass('public.document') IS NULL OR to_regclass('public.processing_queue') IS NULL THEN
    RAISE EXCEPTION 'expected tables are missing';
  END IF;
  IF (SELECT count(*) FROM processing_queue) <> 0 THEN
    RAISE EXCEPTION 'processing_queue is not empty; review before migrating';
  END IF;
END $$;

ALTER TABLE processing_queue
  ADD COLUMN not_before       timestamptz NOT NULL DEFAULT now(),
  ADD COLUMN max_attempts     integer     NOT NULL DEFAULT 3,
  ADD COLUMN locked_by        text,
  ADD COLUMN lease_expires_at timestamptz,
  ADD COLUMN started_at       timestamptz,
  ADD COLUMN finished_at      timestamptz,
  ADD COLUMN error_class      text,
  ADD COLUMN last_error       text;

ALTER TABLE processing_queue
  ADD CONSTRAINT processing_queue_status_check
    CHECK (status IN ('queued','processing','done','quarantine')),
  ADD CONSTRAINT processing_queue_error_class_check
    CHECK (error_class IS NULL OR error_class IN ('TRANSIENT','DETERMINISTIC','UNKNOWN')),
  ADD CONSTRAINT processing_queue_attempts_check
    CHECK (attempts >= 0 AND max_attempts >= 1),
  ADD CONSTRAINT processing_queue_lease_check
    CHECK ((status = 'processing') = (locked_by IS NOT NULL AND lease_expires_at IS NOT NULL));

CREATE UNIQUE INDEX uq_queue_one_active_task
  ON processing_queue (document_id, task_type)
  WHERE status IN ('queued','processing');
CREATE INDEX idx_queue_lease
  ON processing_queue (lease_expires_at)
  WHERE status = 'processing';

CREATE FUNCTION enqueue_task(p_document uuid, p_task text, p_priority integer DEFAULT 5, p_pages integer DEFAULT NULL)
RETURNS uuid LANGUAGE sql AS $$
  INSERT INTO processing_queue (document_id, task_type, priority, estimated_pages)
  VALUES (p_document, p_task, p_priority, p_pages)
  ON CONFLICT (document_id, task_type) WHERE status IN ('queued','processing') DO NOTHING
  RETURNING id;
$$;

CREATE FUNCTION claim_task(p_worker text, p_lease_seconds integer DEFAULT 300)
RETURNS SETOF processing_queue LANGUAGE sql AS $$
  UPDATE processing_queue
     SET status = CASE WHEN attempts >= max_attempts THEN 'quarantine' ELSE 'queued' END,
         error_class = COALESCE(error_class, 'UNKNOWN'),
         last_error = 'lease expired',
         finished_at = CASE WHEN attempts >= max_attempts THEN clock_timestamp() END,
         locked_by = NULL,
         lease_expires_at = NULL
   WHERE status = 'processing' AND lease_expires_at < clock_timestamp();
  WITH next AS (
    SELECT id FROM processing_queue
     WHERE status = 'queued' AND not_before <= clock_timestamp()
     ORDER BY priority, created_at
     FOR UPDATE SKIP LOCKED
     LIMIT 1)
  UPDATE processing_queue q
     SET status = 'processing',
         locked_by = p_worker,
         lease_expires_at = clock_timestamp() + make_interval(secs => GREATEST(p_lease_seconds, 1)),
         attempts = q.attempts + 1,
         started_at = clock_timestamp(),
         finished_at = NULL
    FROM next
   WHERE q.id = next.id
  RETURNING q.*;
$$;

CREATE FUNCTION complete_task(p_id uuid, p_worker text)
RETURNS boolean LANGUAGE plpgsql AS $$
BEGIN
  UPDATE processing_queue
     SET status = 'done', finished_at = clock_timestamp(), locked_by = NULL, lease_expires_at = NULL
   WHERE id = p_id AND status = 'processing' AND locked_by = p_worker
     AND lease_expires_at >= clock_timestamp();
  RETURN FOUND;
END $$;

CREATE FUNCTION fail_task(p_id uuid, p_worker text, p_class text, p_error text)
RETURNS text LANGUAGE plpgsql AS $$
DECLARE v_status text;
BEGIN
  IF p_class NOT IN ('TRANSIENT','DETERMINISTIC','UNKNOWN') THEN
    RAISE EXCEPTION 'invalid error class %', p_class;
  END IF;
  UPDATE processing_queue
     SET status = CASE WHEN p_class = 'DETERMINISTIC' OR attempts >= max_attempts
                       THEN 'quarantine' ELSE 'queued' END,
         error_class = p_class,
         last_error = left(p_error, 500),
         not_before = CASE WHEN p_class = 'DETERMINISTIC' OR attempts >= max_attempts
                           THEN not_before
                           ELSE clock_timestamp() + make_interval(secs => 30 * power(2, attempts - 1)) END,
         finished_at = CASE WHEN p_class = 'DETERMINISTIC' OR attempts >= max_attempts
                            THEN clock_timestamp() END,
         locked_by = NULL,
         lease_expires_at = NULL
   WHERE id = p_id AND status = 'processing' AND locked_by = p_worker
  RETURNING status INTO v_status;
  RETURN v_status;
END $$;

-- Status vocabulary for document.status after the workflow is changed:
-- ready | partial | low_confidence | quarantine (plus existing pending/processing).
CREATE FUNCTION classify_extraction(p_content text,
                                    p_expected_pages integer DEFAULT NULL,
                                    p_extracted_pages integer DEFAULT NULL,
                                    p_min_chars_per_page integer DEFAULT 20)
RETURNS text LANGUAGE sql IMMUTABLE AS $$
  SELECT CASE
    WHEN length(btrim(coalesce(p_content, ''))) = 0 THEN 'low_confidence'
    WHEN p_expected_pages IS NOT NULL AND p_extracted_pages IS NOT NULL
         AND p_extracted_pages < p_expected_pages THEN 'partial'
    WHEN p_expected_pages IS NOT NULL AND p_expected_pages > 0
         AND length(btrim(p_content)) < p_expected_pages * p_min_chars_per_page THEN 'low_confidence'
    ELSE 'ready'
  END;
$$;

CREATE VIEW document_needs_review AS
SELECT id, original_name, mime_type, status, has_images, ocr_engine, created_at
  FROM document
 WHERE status IN ('partial','low_confidence','quarantine')
    OR (status = 'ready' AND length(btrim(coalesce(content_md, ''))) = 0);

COMMENT ON FUNCTION claim_task(text, integer) IS
  'Reclaims expired leases, then claims one queued task with FOR UPDATE SKIP LOCKED and a lease.';
COMMENT ON FUNCTION complete_task(uuid, text) IS
  'Completes a task only for the worker that holds an unexpired lease (fencing).';
COMMENT ON FUNCTION fail_task(uuid, text, text, text) IS
  'TRANSIENT retries with exponential backoff until max_attempts; DETERMINISTIC goes to quarantine.';

COMMIT;
