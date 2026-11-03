# BV-F-025: One superuser database role serves several services

- Status: OPEN
- Priority: P1
- Component: persistence
- Evidence (required): A role query shows the pipeline role has the superuser attribute and owns every database on the server, including the maintenance database. A session query shows five connections with that same role, opened by another service from a different container to its own database. That service reads its database settings from a single connection-string variable; its value was not inspected.
- Hypothesis (required): The role was created at database initialisation and reused for the second service for convenience. Whether both use the same password was not checked; a separate role in the second service's connection string would disprove the reuse.
- Impact: A compromise of the second service, which is reachable from the local network, would expose every database, including the document text, and allow commands inside the database container.
- Decision: One least-privilege role per service, none with the superuser attribute, and a rotated password. It needs its own change record because both services restart.
- Change record: none yet
- Verification (required to close): Each service connects with its own non-superuser role, and a session query shows no role shared between services and no application using the superuser.
- Addendum (2026-11-03): CR-012 gave the messaging gateway its own non-superuser role and moved ownership of its database to it. Still OPEN: the workflow engine and the pipeline keep using the superuser role and need their own change record.
