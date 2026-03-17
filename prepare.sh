#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading Countdown..."
python3 -c "
from datasets import load_dataset
import json, pathlib, random

random.seed(42)

train = list(load_dataset('predibase/countdown', split='train[:500]'))
random.shuffle(train)
dev_out = pathlib.Path('data/dev.jsonl')
with dev_out.open('w') as f:
    for row in train[:150]:
        q = row.get('question', row.get('prompt', ''))
        a = str(row.get('answer', row.get('target', '')))
        f.write(json.dumps({'question': q, 'answer': a}) + '
')

test = list(load_dataset('predibase/countdown', split='test[:500]'))
random.shuffle(test)
test_out = pathlib.Path('data/test.jsonl')
with test_out.open('w') as f:
    for row in test[:150]:
        q = row.get('question', row.get('prompt', ''))
        a = str(row.get('answer', row.get('target', '')))
        f.write(json.dumps({'question': q, 'answer': a}) + '
')

print(f'Dev:  150 problems -> {dev_out}')
print(f'Test: 150 problems -> {test_out}')
"
echo "Done."
