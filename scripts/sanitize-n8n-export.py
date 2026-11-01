#!/usr/bin/env python3
"""Sanitize an n8n workflow export for publication.

usage: sanitize-n8n-export.py SOURCE.json OUTPUT.json MAP.json

MAP.json is kept outside the repository: {"replacements": [[real, placeholder], ...]}
Only name, nodes, connections and settings are kept; credential ids are masked.
The script refuses to write the output if any real value or id survives.
"""
import json
import sys

KEEP = ("name", "nodes", "connections", "settings")


def main(src, dst, mapfile):
    w = json.load(open(src))
    repl = json.load(open(mapfile))["replacements"]
    out = {k: w[k] for k in KEEP if k in w}
    ids = set()
    for n in out["nodes"]:
        for c in (n.get("credentials") or {}).values():
            if c.get("id"):
                ids.add(c["id"])
                c["id"] = "<CREDENTIAL_ID>"
        n.pop("webhookId", None)
    text = json.dumps(out, indent=2, ensure_ascii=False)
    for real, placeholder in repl:
        text = text.replace(real, placeholder)
    leaks = [i for i in ids if i in text] + [r for r, _ in repl if r in text]
    if leaks:
        sys.exit("refused: %d identifiers survive" % len(leaks))
    json.loads(text)
    open(dst, "w").write(text + "\n")
    print("ok", dst, "nodes:", len(out["nodes"]))


main(*sys.argv[1:4])
