#!/usr/bin/env bash
set -euo pipefail
mkdir -p data

echo "Downloading Countdown..."
python3 -c "
from datasets import load_dataset
import json, pathlib, random

random.seed(42)
ds = load_dataset('predibase/countdown', split='test')
samples = list(ds)
random.shuffle(samples)
samples = samples[:50]

out = pathlib.Path('data/test.jsonl')
with out.open('w') as f:
    for row in samples:
        f.write(json.dumps({
            'target': row['target'],
            'numbers': row['nums'],
        }) + '\n')

print(f'Wrote {len(samples)} problems to {out}')
"

echo "Done. $(wc -l < data/test.jsonl) problems in data/test.jsonl"
