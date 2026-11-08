# CR-016: n8n published only on the private-network address

- Date: 2026-11-08 (change itself made on 2026-11-06, documented retroactively)
- Findings addressed: BV-F-022
- Approved by: owner, reported verbally; no written approval record exists for this change
- Backup taken: not evidenced in this record. The previous container (n8n-old, stopped) was kept as rollback and shares the same data folders
- Change: n8n container recreated on 2026-11-06 from the same image ID. Port 5678 moved from all interfaces to the private-network address only. Mounts and restart policy unchanged (always)
- Rollback: stop n8n, then start n8n-old. Never run both at once: they share the same SQLite data folder
- Verification: container inspect shows the binding on the private-network address only; ss shows 5678 listening only on that address; a LAN connection test from the laptop to 5678 timed out; 0 errors in 48 h of n8n logs
- Residual risk: no "before" network test was captured, so the before state rests on the old container's configuration only. Findings BV-F-016 (other published ports) and BV-F-025 (shared superuser role) remain open
