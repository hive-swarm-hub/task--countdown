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
with pathlib.Path('data/train.jsonl').open('w') as f:
    for row in train[:100]:
        q = row.get('question', row.get('prompt', ''))
        a = str(row.get('answer', row.get('target', '')))
        f.write(json.dumps({'question': q, 'answer': a}) + '\n')
test = list(load_dataset('predibase/countdown', split='test[:500]'))
random.shuffle(test)
with pathlib.Path('data/test.jsonl').open('w') as f:
    for row in test[:100]:
        q = row.get('question', row.get('prompt', ''))
        a = str(row.get('answer', row.get('target', '')))
        f.write(json.dumps({'question': q, 'answer': a}) + '\n')
print('Train: 100, Test: 100')
"
echo "Done."
