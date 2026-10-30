#!/usr/bin/env python3
"""Generate synthetic fixtures for the Ingestion Gate (DN-004).

Stdlib only and deterministic: same script, same SHA-256 every time.
Writes files to ./generated/ (git-ignored) and the expected results to manifest.json.
"""
import hashlib
import io
import json
import zipfile
from pathlib import Path

HERE = Path(__file__).parent
OUT = HERE / "generated"
FIXED_DATE = (2020, 1, 1, 0, 0, 0)


def pdf(label: str) -> bytes:
    return (
        "%PDF-1.4\n"
        "1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\n"
        "2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj\n"
        "3 0 obj<</Type/Page/Parent 2 0 R/MediaBox[0 0 200 200]>>endobj\n"
        "trailer<</Root 1 0 R>>\n%%EOF\n"
        f"% synthetic fixture: {label}\n"
    ).encode()


def zipped(members) -> bytes:
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_STORED) as z:
        for name, data in members:
            info = zipfile.ZipInfo(name, FIXED_DATE)
            info.compress_type = zipfile.ZIP_STORED
            z.writestr(info, data)
    return buf.getvalue()


DOCX = zipped([("[Content_Types].xml", b"<Types/>"), ("word/document.xml", b"<w:document/>")])
EPUB = zipped([("mimetype", b"application/epub+zip"), ("OEBPS/content.opf", b"<package/>")])
OFFICE_LOCK = bytes([0x05, 0x45]) + b"x" * 160  # 162 bytes, no ZIP header

# name, content, age_seconds (now - max(mtime, ctime)), decision, reason
CASES = [
    ("valid_report.pdf", pdf("valid"), 3600, "ACCEPT", None),
    ("valid_letter.docx", DOCX, 3600, "ACCEPT", None),
    ("valid_book.epub", EPUB, 3600, "ACCEPT", None),
    ("UPPERCASE_REPORT.PDF", pdf("uppercase"), 3600, "ACCEPT", None),
    ("corrupt.pdf", b"not a real pdf, passes the gate by design", 3600, "ACCEPT", None),
    (".DS_Store", b"\x00\x00\x00\x01Bud1", 3600, "REJECT", "HIDDEN"),
    ("~$valid_letter.docx", OFFICE_LOCK, 3600, "REJECT", "OFFICE_LOCK"),
    ("it's_quoted.pdf", pdf("quote"), 3600, "REJECT", "UNSAFE_NAME"),
    ("back\\slash.pdf", pdf("backslash"), 3600, "REJECT", "UNSAFE_NAME"),
    ("valid_report.pdf.procesando", b"", 3600, "REJECT", "MARKER"),
    ("download.pdf.crdownload", b"partial", 3600, "REJECT", "TEMP_EXT"),
    ("partial.pdf.part", b"partial", 3600, "REJECT", "TEMP_EXT"),
    ("scratch.tmp", b"scratch", 3600, "REJECT", "TEMP_EXT"),
    ("incoming.download", b"partial", 3600, "REJECT", "TEMP_EXT"),
    ("empty.pdf", b"", 3600, "REJECT", "EMPTY"),
    ("data.bin", b"\x00\x01\x02", 3600, "REJECT", "UNSUPPORTED_EXT"),
    ("no_extension", b"plain", 3600, "REJECT", "UNSUPPORTED_EXT"),
    ("fresh_upload.pdf", pdf("fresh"), 5, "REJECT", "UNSTABLE"),
]


def main() -> None:
    OUT.mkdir(exist_ok=True)
    items = []
    for name, data, age, decision, reason in sorted(CASES, key=lambda c: c[0]):
        (OUT / name).write_bytes(data)
        items.append({
            "name": name,
            "size": len(data),
            "age_seconds": age,
            "sha256": hashlib.sha256(data).hexdigest(),
            "expected": {"decision": decision, "reason": reason},
        })
    manifest = {
        "rules_version": "DN-004 v1",
        "stability_window_seconds": 60,
        "allowed_extensions": ["pdf", "docx", "epub"],
        "scenarios": {
            "mixed": {"items": items},
            "empty_folder": {"items": [], "expected_accepted": 0, "expected_error": False},
        },
    }
    (HERE / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"generated {len(items)} fixtures")


if __name__ == "__main__":
    main()
