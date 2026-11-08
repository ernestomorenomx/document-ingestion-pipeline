# BV-F-010: Heavy documents inside the synced vault tree

- Status: OPEN
- Priority: P2
- Component: sync
- Aliases: n8n audit H10, synchronization audit
- Evidence (required): the synced tree is about 1.7 GB across roughly 390 files, of which about 1.6 GB sits in one learning area made of video, audio and large PDFs. The ingestion folders (input, processed, archive) live inside the same tree and replicate to every device, including the phone, which reported insufficient free space at one point.
- Hypothesis (required): synchronization is doing the job of a document repository. Disproved if heavy files can be moved out of the tree without breaking references.
- Impact: the phone receives data it does not need; knowledge notes and bulky sources share one conflict surface.
- Decision: separate a light knowledge vault from a document repository; topology to be decided after auditing all three devices.
- Change record: none yet.
- Verification (required to close): the phone folder stays under an agreed size and no reference breaks after the move.
