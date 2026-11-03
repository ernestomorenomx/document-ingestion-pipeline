# BV-F-026: The conversion service has no media codec installed

- Status: OPEN
- Priority: P2
- Component: ocr
- Evidence (required): The service log at startup warns that the audio and video converter is missing. A synthetic HTML file converted correctly, so only audio and video inputs are suspected.
- Hypothesis (required): The image does not include the codec package. A successful conversion of a synthetic audio file would disprove it.
- Impact: Audio and video inputs probably fail or yield empty text. A rule that marks empty output as ready would hide this, which relates to the ready-state finding.
- Decision: none yet
- Change record: none yet
- Verification (required to close): A synthetic audio file converts to non-empty text, or the gate rejects audio inputs with a clear reason.
