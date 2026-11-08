# BV-F-005: OCR capped at 20 pages and triggered only below 50 characters

- Status: OPEN
- Priority: P1
- Component: ocr
- Aliases: n8n audit H05
- Evidence (required): the OCR script rasterizes at 150 DPI, processes at most 20 pages, uses a 60 s rasterization timeout and a 30 s per-page timeout, and does not check the rasterizer exit status. The fallback runs only when the converter returns fewer than 50 characters.
- Hypothesis (required): a long scanned document yields partial text that is still marked complete, and a short garbage extraction above 50 characters never reaches OCR. Disproved by a synthetic 30-page scan that ends flagged as partial.
- Impact: silent truncation of long documents.
- Decision: none yet; quality criteria to be defined (MIME, page count, text quality, extractor errors).
- Change record: none yet.
- Verification (required to close): synthetic 30-page scan ends PARTIAL or fully processed, never silently ready.
