# CR-011: Container manager administrator password reset

- Date: 2026-11-01
- Findings addressed: none registered. Follows CR-010: when the owner tried to log in over the private network, the stored credential could not be found.
- Approved by: owner, in the working session
- Backup taken (required): An archive of the container manager's data volume, made with the container stopped, in a private folder on the root disk: 14 entries including its database, key and certificates, 66729 bytes, SHA-256 recorded next to it. The archive was listed before the reset.
- Change: The container was stopped, the vendor's password reset helper was run against the data volume, and the container was started again. The helper sets a random password for the administrator account.
- Rollback: Stop the container, extract the archive into the volume and start it. This restores the previous account state.
- Verification (required): Observed: archive contents, size and checksum, and the login page showing the existing-account form rather than first-run setup. Reported by the owner, not observed: the helper's output, login with the generated password, storage of that password in the password manager and its replacement by a long password from the manager.
- Residual risk: The helper ran from a floating image tag (BV-F-023). The container still mounts the Docker socket, so its administrator account equals control of the server. The previous container from CR-010 remains stopped and should be removed in a later cleanup.
