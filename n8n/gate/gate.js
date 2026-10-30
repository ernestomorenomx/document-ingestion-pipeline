'use strict';
// Ingestion Gate v1 (DN-004). Pure metadata decisions, no filesystem access.
// Input: output of `find <input_dir> -maxdepth 1 -type f -printf '%f\t%s\t%T@\t%C@\n'`

const CONFIG = {
  allowedExtensions: ['pdf', 'docx', 'epub'],
  tempExtensions: ['tmp', 'part', 'crdownload', 'download'],
  stabilityWindowSeconds: 60,
};

function extensionOf(name) {
  const i = name.lastIndexOf('.');
  return i > 0 ? name.slice(i + 1).toLowerCase() : '';
}

function decide(file, nowSec, cfg) {
  const name = file.name;
  const ext = extensionOf(name);
  if (name.startsWith('.')) return 'HIDDEN';
  if (name.startsWith('~$')) return 'OFFICE_LOCK';
  if (name.endsWith('.procesando')) return 'MARKER';
  if (cfg.tempExtensions.includes(ext)) return 'TEMP_EXT';
  if (file.size === 0) return 'EMPTY';
  if (!cfg.allowedExtensions.includes(ext)) return 'UNSUPPORTED_EXT';
  const age = nowSec - Math.max(file.mtime, file.ctime);
  if (!(age >= cfg.stabilityWindowSeconds)) return 'UNSTABLE';
  return null;
}

function parseListing(text) {
  return String(text || '')
    .split('\n')
    .filter((l) => l.trim() !== '')
    .map((line) => {
      const [name, size, mtime, ctime] = line.split('\t');
      return { name, size: Number(size), mtime: Number(mtime), ctime: Number(ctime) };
    });
}

function evaluate(files, nowSec, cfg = CONFIG) {
  const accepted = [];
  const rejected = [];
  for (const f of files) {
    const reason = decide(f, nowSec, cfg);
    if (reason) rejected.push({ name: f.name, reason });
    else accepted.push(f);
  }
  return { accepted, rejected };
}

if (typeof module !== 'undefined') {
  module.exports = { CONFIG, evaluate, parseListing, extensionOf };
}

// n8n Code node entry (Run Once for All Items). Skipped when run under Node.
if (typeof $input !== 'undefined') {
  const text = $input.first().json.stdout ?? '';
  const { accepted, rejected } = evaluate(parseListing(text), Date.now() / 1000);
  const counts = {};
  for (const r of rejected) counts[r.reason] = (counts[r.reason] || 0) + 1;
  console.log(`gate: accepted=${accepted.length} rejected=${JSON.stringify(counts)}`);
  return accepted.map((f) => ({ json: { fileName: f.name, filename: f.name, size: f.size } }));
}
