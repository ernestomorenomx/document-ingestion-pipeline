# CR-015: Docker starts after the private-network daemon

- Date: 2026-11-03
- Findings addressed: BV-F-016 (supporting: containers published only on the private-network address need that address to exist when Docker starts at boot).
- Approved by: owner, in the working session
- Backup taken (required): None needed beyond the scheduled one: the change adds one systemd configuration file and touches no data. The scheduled backup of both databases kept running normally afterwards (observed in the journal on 2026-11-05).
- Change: Added a systemd drop-in for the Docker service with two lines: After=tailscaled.service and Wants=tailscaled.service. No container, image, network or data was modified.
- Rollback: Delete the drop-in file, run systemctl daemon-reload; the ordering reverts the next time Docker starts. Not used.
- Verification (required): Observed on 2026-11-05: the drop-in exists with exactly those two lines under [Unit]. NOT verified: behaviour across a real server reboot. No reboot has been done since the change.
- Residual risk: Untested at boot. After= orders Docker after the start of the Tailscale daemon, but that does not by itself guarantee the private-network interface already has its address when Docker tries to publish a port on it, so a race may remain. A planned reboot test (check that the container manager and the workflow engine come up bound to the private address) is needed before this change counts as verified.
