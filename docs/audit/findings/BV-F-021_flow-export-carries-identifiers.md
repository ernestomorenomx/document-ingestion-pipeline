# BV-F-021: The first flow export in the public repository carries instance and credential identifiers

- Status: RESOLVED
- Priority: P2
- Component: ops
- Evidence (required): The flow export committed in the repository's first feature commit is present on both the stable and the working branch. It holds real host paths and the vault folder name inside node parameters, an instance identifier in its metadata, and six credential identifiers with generic names. It holds no passwords, tokens, addresses or keys: credentials are referenced, not included. A scan over the whole published tree matched it; earlier scans looked only at added lines and missed it.
- Hypothesis (required): Replacing the file with a sanitized export removes these values from every published file from the next push on. It would be disproved if a scan of the published tree still matched the real values afterwards.
- Impact: Publishes details of the deployment layout and identifiers of the installation. No credential value is exposed.
- Decision: Replace the file and keep history untouched. Rewriting history was considered and set aside: nothing secret is exposed, and existing copies of a public repository keep the old version anyway.
- Change record: CR-004.
- Verification (required to close): On 2026-11-01, after publishing to both branches, a scan of the whole tree of each one, with no folder excluded, matched none of the real values. The old version remains only in history.
- Residual risk: The first commit's version stays in public history and in any existing copy.
