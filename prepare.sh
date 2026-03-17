#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading Countdown..."
python3 << 'PY'
from datasets import load_dataset
import json, pathlib
ds = load_dataset('predibase/countdown', split='test')
out = pathlib.Path('data/test.jsonl')
with out.open('w') as f:
    for row in ds:
        q = row.get('question', row.get('prompt', ''))
        a = str(row.get('answer', row.get('target', '')))
        f.write(json.dumps({"question": q, "answer": a}) + '\n')
print(f'Wrote {len(ds)} problems to {out}')
PY
echo "Done."
