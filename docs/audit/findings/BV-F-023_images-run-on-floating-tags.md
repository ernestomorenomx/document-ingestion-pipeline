# BV-F-023: Several services run on floating image tags

- Status: OPEN
- Priority: P2
- Component: ops
- Evidence (required): The image references of the workflow engine, the container manager and the conversion service end in the latest tag. The engine was observed at version 2.27.4. The other images were already pinned in the production compose file.
- Hypothesis (required): The containers were created by hand from the latest tag and never pinned. Recorded digests for these three images in the production compose file would disprove it.
- Impact: A restart that pulls a newer image can change behaviour, data format or API without notice, and a rollback needs the old image to still be on disk.
- Decision: Pin by tag and digest, as already done for the other images.
- Change record: none yet
- Verification (required to close): The production compose file lists each image by tag and digest and the running containers report those digests.
