# CR-010: Container manager reachable only over the private network

- Date: 2026-11-01
- Findings addressed: BV-F-016 (container manager part)
- Approved by: owner, in the working session
- Backup taken (required): None needed beyond the data volume, which stays in place; the account recovery in CR-011 added an archive of that volume. The original container was kept stopped, renamed and without restart, as rollback.
- Change: The container was recreated from the same image ID, with the same data volume and Docker socket mount, publishing its port only on the private-network address.
- Rollback: Remove the new container, rename the old one back, set its restart policy to always and start it. This reopens the port on all interfaces, which is the previous state.
- Verification (required): The port mapping shows only the private-network address. From another local machine a connection to the local-network address timed out, where before it succeeded, and a connection over the private network succeeded. The service answered HTTP 200 on the second attempt after start-up. Reported by the owner, not observed: login over the private network, after the account recovery in CR-011.
- Residual risk: The container still mounts the Docker socket, so access to it equals control of the server, and it runs on a floating tag (BV-F-023). The previous container is still on disk.
