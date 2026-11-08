# CR-018: queue claim with lease and extraction classification primitives

- Date: 2026-11-08
- Findings addressed: BV-F-003, BV-F-013, BV-F-002 (database side only)
- Approved by: owner, typed approval at the script prompt on 2026-11-08 after a successful rehearsal
- Backup taken: custom-format dump of the main database taken immediately before the change; non-empty, SHA-256 recorded in the checksum file, table of contents checked (5 table-data entries)
- Change: sql/002_queue_lease_and_classification.sql applied in one transaction. It adds lease, retry and error columns to the processing queue; constraints on status, error class and lease consistency; a unique index that allows one active task per document and task type; functions to enqueue (idempotent), claim (FOR UPDATE SKIP LOCKED with a lease), complete (fenced by worker and unexpired lease) and fail (classified, exponential backoff, quarantine); a pure function that classifies extraction results; and a review view. One row that was marked ready with empty content was reclassified to low_confidence.
- Rollback: restore the pre-change dump, or run the statements below. The queue was empty and unused, so no workflow depends on any of these objects.

    DROP VIEW document_needs_review;
    DROP FUNCTION classify_extraction(text, integer, integer, integer);
    DROP FUNCTION fail_task(uuid, text, text, text);
    DROP FUNCTION complete_task(uuid, text);
    DROP FUNCTION claim_task(text, integer);
    DROP FUNCTION enqueue_task(uuid, text, integer, integer);
    DROP INDEX uq_queue_one_active_task, idx_queue_lease;
    ALTER TABLE processing_queue
      DROP CONSTRAINT processing_queue_status_check,
      DROP CONSTRAINT processing_queue_error_class_check,
      DROP CONSTRAINT processing_queue_attempts_check,
      DROP CONSTRAINT processing_queue_lease_check,
      DROP COLUMN not_before, DROP COLUMN max_attempts, DROP COLUMN locked_by,
      DROP COLUMN lease_expires_at, DROP COLUMN started_at, DROP COLUMN finished_at,
      DROP COLUMN error_class, DROP COLUMN last_error;

- Verification: rehearsal on a throwaway database built from a schema-only copy of production: 17 assertions (idempotent enqueue, claim, expired-lease reclaim, fencing, transient retry with backoff, quarantine after the last attempt, deterministic failure, non-owner failure, re-enqueue after quarantine, lease constraint, five classification cases) and a concurrency run with 8 parallel sessions over 60 tasks that produced 60 claims, 60 distinct and 60 completed. In production: catalog check of the new objects and an insert-enqueue-claim-complete smoke test rolled back, leaving 0 rows.
- Residual risk: the live workflow does not call any of this yet, so BV-F-002 and BV-F-003 are not resolved. The next change must route the workflow through the queue, write the classified status, and renew leases for long OCR jobs. The status column of the document table still accepts any text; a vocabulary constraint is deferred until the workflow is changed. A lease shorter than the longest OCR run would let a second worker take the same task, so the lease length must come from measured durations.
