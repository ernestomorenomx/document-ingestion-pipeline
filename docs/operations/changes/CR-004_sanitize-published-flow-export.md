# CR-004: Published flow export replaced by sanitized exports

- Date: 2026-10-31
- Findings addressed: BV-F-021
- Approved by: owner, in the working session, option A chosen (no pull request or issue link yet)
- Backup taken (required): The source exports of both workflows were taken on 2026-10-30 and are kept outside the repository with private permissions. The previous published version stays in the repository history.
- Change: Added scripts/sanitize-n8n-export.py, which keeps only the name, nodes, connections and settings, masks credential identifiers and replaces real paths with placeholders taken from a map file kept outside the repository; it refuses to write if any real value survives. Replaced n8n/flows/document_ingestion_v1.json with the sanitized original flow and added n8n/flows/document_ingestion_v2_gate.json with the sanitized gated flow. Updated the README note on importing them.
- Rollback: Revert the commit; the earlier version is in history.
- Verification (required): A scan of both files for host paths, the vault folder name, the instance identifier, addresses, device identifiers and key-like strings matched nothing. Both keep only the four allowed top-level keys and the only credential identifier left is the placeholder. A scan of the published tree after the push is pending.
- Residual risk: The sanitizer replaces only the values listed in its map, so a new kind of sensitive text passes unless the map or the scan is extended. Importing a sanitized flow requires filling the placeholders and linking credentials again. The old version remains in public history.

## Addendum, 2026-11-01: ignore file and publication

A whole-tree scan before merging to the stable branch matched one line of the ignore file that named the vault folder. The line became a comment and the name moved to the clone's local exclude file, which Git honors and never publishes. The working branch was then fast-forwarded into the stable branch without force. Verification: for a path inside the vault folder the ignore check reports the local exclude as the matching rule, and a scan of the whole tree of both published branches matched none of the real values. Residual risk: the name and the old export remain in the history of both branches, and the local exclude exists only in this clone.
