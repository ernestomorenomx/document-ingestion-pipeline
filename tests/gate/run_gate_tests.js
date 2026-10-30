'use strict';
const path = require('path');
const { evaluate, parseListing, CONFIG } = require('../../n8n/gate/gate.js');
const manifest = require(path.join(__dirname, '../fixtures/synthetic/gate/manifest.json'));

const NOW = 1_800_000_000;
let failures = 0;
const check = (ok, msg) => { if (!ok) { failures++; console.log('FAIL', msg); } };

check(manifest.stability_window_seconds === CONFIG.stabilityWindowSeconds, 'stability window differs');
check(JSON.stringify(manifest.allowed_extensions) === JSON.stringify(CONFIG.allowedExtensions), 'allowed extensions differ');

const mixed = manifest.scenarios.mixed.items;
const listing = mixed
  .map((i) => `${i.name}\t${i.size}\t${NOW - i.age_seconds}.0\t${NOW - i.age_seconds}.0`)
  .join('\n') + '\n';
const { accepted, rejected } = evaluate(parseListing(listing), NOW);
const got = new Map([
  ...accepted.map((f) => [f.name, { decision: 'ACCEPT', reason: null }]),
  ...rejected.map((r) => [r.name, { decision: 'REJECT', reason: r.reason }]),
]);
for (const i of mixed) {
  const g = got.get(i.name);
  check(g && g.decision === i.expected.decision && g.reason === i.expected.reason,
    `${i.name}: expected ${i.expected.decision}/${i.expected.reason}, got ${g && g.decision}/${g && g.reason}`);
}
check(got.size === mixed.length, 'item count mismatch');

let emptyOk = true;
try {
  const r = evaluate(parseListing(''), NOW);
  emptyOk = r.accepted.length === manifest.scenarios.empty_folder.expected_accepted && r.rejected.length === 0;
} catch (e) { emptyOk = false; }
check(emptyOk, 'empty folder scenario');

console.log(failures === 0 ? `PASS ${mixed.length + 1} scenarios checked` : `${failures} failure(s)`);
process.exit(failures === 0 ? 0 : 1);
