# CR-009: Conversion service no longer published on the host

- Date: 2026-11-01
- Findings addressed: BV-F-016 (conversion service part)
- Approved by: owner, in the working session, before the service's client log had been read
- Backup taken (required): None needed: the service keeps no state. The original container was kept stopped, renamed and without restart, as rollback.
- Change: The container was recreated from the same image ID on the internal network only, with no published port. The two host firewall rules allowing its port were then removed; they had no practical effect because published container ports bypass that firewall.
- Rollback: Remove the new container, rename the old one back, set its restart policy to always and start it. This reopens the port, which is the previous state. For the firewall rules, allow the port again.
- Verification (required): From another local machine the port gives connection refused. From the host the service answers HTTP 200 and the workflow engine reaches it by name. A synthetic HTML file converted to the expected Markdown with HTTP 200. The 168 executions of the previous four hours were all successful and no leftover markers existed. A later check found 1008 executions in 24 hours, all successful. The old container's log since June shows requests only from the workflow engine and the container itself, plus seven from loopback and Docker gateway addresses.
- Residual risk: Only HTML conversion was verified; PDF, OCR and audio were not (see BV-F-026). The first two start-up checks failed because the service needs more than five seconds to start; they were false negatives, so checks must retry for about a minute. The time of the first brief outage was not recorded. The previous container is still on disk and should be removed after a few days without problems.
