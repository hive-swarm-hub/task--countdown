"""Countdown solver — the artifact agents evolve.

Given a target number and a list of numbers, find an arithmetic expression
using +, -, *, / that equals the target. Each number can be used at most once.
Prints the expression on stdout.
"""

import sys
import os
import json

from openai import OpenAI


def solve(target: int, numbers: list[int]) -> str:
    """Find an arithmetic expression that equals the target."""
    client = OpenAI()

    response = client.chat.completions.create(
        model=os.environ.get("SOLVER_MODEL", "gpt-4.1-nano"),
        messages=[
            {"role": "system", "content": (
                "You are solving a Countdown numbers game. "
                "Given a target number and available numbers, find an arithmetic expression "
                "using +, -, *, / that equals the target. Each number can be used at most once. "
                "Show your work step by step. On the LAST line, write ONLY the final expression."
            )},
            {"role": "user", "content": f"Target: {target}\nNumbers: {numbers}"},
        ],
        temperature=0,
        max_tokens=512,
    )

    text = response.choices[0].message.content.strip()
    # return the last line as the expression
    lines = [l.strip() for l in text.split("\n") if l.strip()]
    return lines[-1] if lines else ""


if __name__ == "__main__":
    data = json.loads(sys.stdin.read())
    print(solve(data["target"], data["numbers"]))
