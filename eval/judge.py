"""Evaluate agent.py on Countdown. Checks if expression equals target."""

import json
import re
import subprocess
import sys


def eval_expression(expr: str, target: int, available: list[int]) -> bool:
    """Check if expression evaluates to target using only available numbers."""
    # clean up expression
    expr = expr.strip().rstrip(".")
    # remove any text before the expression (e.g. "Answer: 1+2")
    for prefix in ["=", ":", "Answer", "Expression", "Result"]:
        if prefix in expr:
            expr = expr.split(prefix)[-1].strip()

    try:
        result = eval(expr)
        return abs(result - target) < 1e-6
    except:
        return False


def main():
    with open(sys.argv[1]) as f:
        problems = [json.loads(line) for line in f]

    total = len(problems)
    correct = 0

    print(f"Evaluating {total} problems...", file=sys.stderr)

    for item in problems:
        try:
            result = subprocess.run(
                ["python3", "agent.py"],
                input=json.dumps(item), capture_output=True, text=True, timeout=60,
            )
            expr = result.stdout.strip()
        except (subprocess.TimeoutExpired, Exception):
            expr = ""

        if eval_expression(expr, item["target"], item["numbers"]):
            correct += 1

    accuracy = correct / total
    print("---")
    print(f"accuracy:         {accuracy:.6f}")
    print(f"correct:          {correct}")
    print(f"total:            {total}")


if __name__ == "__main__":
    main()
