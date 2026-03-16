# Countdown

Improve a solver for the Countdown numbers game to maximize accuracy.

## Setup

1. Read these files for full context:
   - `prepare.sh` — downloads Countdown dataset. Do not modify.
   - `eval/eval.sh` — runs evaluation. Do not modify.
   - `agent.py` — the file you modify. The solver.
2. Verify data exists: check that `data/` contains `test.jsonl`. If not, run `bash prepare.sh`.
3. Create `results.tsv` with just the header row.

## Experimentation

Each experiment runs on the test set (50 problems). You launch it as: `bash eval/eval.sh`.

**What you CAN do:**
- Modify `agent.py` — everything is fair game: prompting strategy, step-by-step reasoning, backtracking, expression formatting.

**What you CANNOT do:**
- Modify `prepare.sh` or `eval/eval.sh`. They are read-only.
- Modify the test data.
- Change the model (set via `SOLVER_MODEL` env var).
- Install new packages beyond what's in `requirements.txt`.

**The goal: get the highest accuracy on Countdown.** Given a target number and available numbers, find an arithmetic expression (+, -, *, /) that equals the target. Each number used at most once.

**The first run**: establish the baseline by running eval as-is.

## Output format

```
---
accuracy:         0.3400
correct:          17
total:            50
```

## The experiment loop

LOOP FOREVER:

1. **THINK** — decide what to try next.
2. Modify `agent.py`.
3. git commit
4. Run: `bash eval/eval.sh > run.log 2>&1`
5. Check: `grep "^accuracy:" run.log`
6. If crashed, check `tail -n 50 run.log`.
7. Log to results.tsv.
8. If improved, keep. If not, `git reset --hard HEAD~1`.

**NEVER STOP.** The loop runs until interrupted.
