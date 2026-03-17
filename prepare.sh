#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading Countdown..."
python3 -c "
from datasets import load_dataset
import json, pathlib

dev = load_dataset('predibase/countdown', split='train[:200]')
dev_out = pathlib.Path('data/dev.jsonl')
with dev_out.open('w') as f:
    for row in dev:
        f.write(json.dumps({'question': row['question'] if 'question' in row else row.get('prompt',''), 'answer': str(row['answer']) if 'answer' in row else row.get('target','')}) + '\n')

test = load_dataset('predibase/countdown', split='test[:500]')
test_out = pathlib.Path('data/test.jsonl')
with test_out.open('w') as f:
    for row in test:
        f.write(json.dumps({'question': row['question'] if 'question' in row else row.get('prompt',''), 'answer': str(row['answer']) if 'answer' in row else row.get('target','')}) + '\n')

print(f'Dev:  {len(dev)} problems -> {dev_out}')
print(f'Test: {len(test)} problems -> {test_out}')
"
echo "Done."
