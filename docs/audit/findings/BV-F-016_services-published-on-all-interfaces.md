# BV-F-016: Services published on every network interface

- Status: OPEN
- Priority: P1
- Component: ops
- Aliases: production inventory
- Evidence (required): the production inventory found the database (5432), the converter (8490, no authentication) and other services bound to all interfaces. Docker publishes ports through its own firewall rules, so the host firewall does not protect them.
- Hypothesis (required): published ports were left at defaults. Disproved per port by a connection test from another host, run first against the open state and then the closed state.
- Impact: any host on the local network can reach internal services.
- Decision: close each port only after identifying its clients by connection sampling. Bind to loopback if only local proxies call it, to the private-network address if only the owner does.
- Change record: closed so far: converter (CR-009), container manager (CR-010), database (CR-014), orchestrator (CR-016). Still open: messaging gateway, file-sharing service, one Python service and the web server, pending 24 hours of connection sampling.
- Verification (required to close): before and after connection tests for every remaining port, linked from a change record each.
