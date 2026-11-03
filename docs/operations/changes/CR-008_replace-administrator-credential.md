# CR-008: Administrator API key replaced by a least-privilege key

- Date: 2026-11-01
- Findings addressed: none registered. The old key carried administrator scopes, including credentials, users and packages, and was found in clear text in the server shell history.
- Approved by: owner, in the working session
- Backup taken (required): The consistent database copy and key file described in CR-007, with recorded checksums.
- Change: A new key with eight scopes (workflow create, list, read, update, activate and deactivate; execution list and read) and a 90-day expiry ending 2027-01-30 was created. The old key was revoked in the interface. Lines containing the old key were removed from the server shell history after a second session was closed.
- Rollback: A revoked key cannot be restored. If a consumer breaks, create another key with the same scopes and update that consumer.
- Verification (required): The new key returned HTTP 200 on workflows and executions and 403 on credentials. A read of the key table shows only the new key. A search of the owner's home folder, the local script folder, system unit folders, cron folders and the exported flows found no use of the key outside the shell history. The history had 0 token matches before and after the second session closed (1969 and 1985 lines).
- Residual risk: The revocation and the storage of the new key in the password manager were reported by the owner, not observed. The key must be rotated before 2027-01-30. Physical erasure of removed copies is not guaranteed on an unencrypted disk.
