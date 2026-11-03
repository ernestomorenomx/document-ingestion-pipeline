# BV-F-022: The workflow engine is published on all network interfaces

- Status: OPEN
- Priority: P1
- Component: ops
- Evidence (required): The container port mapping binds the engine to the IPv4 and IPv6 wildcard addresses, and a connection test from another machine on the local network succeeded. This extends BV-F-016.
- Hypothesis (required): The container was created with a plain port publication and no host address. Reachability from outside the local network depends on the router, which was not inspected; a router rule blocking it would disprove the wider exposure.
- Impact: Anyone on the local network can reach the login page. While an owner account is unclaimed, for example after an account reset, the first visitor could claim it.
- Decision: none yet
- Change record: none yet
- Verification (required to close): The port is bound to the private-network address only, and a connection test from another local machine fails.
