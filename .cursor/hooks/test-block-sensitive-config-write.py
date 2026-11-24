#!/usr/bin/env python3
"""Local checks for block-sensitive-config-write.py (not a Cursor hook)."""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SCRIPT = ROOT / ".cursor" / "hooks" / "block-sensitive-config-write.py"

CASES = [
    (
        "write-deny",
        {"tool_name": "Write", "tool_input": {"path": "src/config/anna.safe.rsc"}},
        "deny",
    ),
    (
        "read-tool-allow",
        {"tool_name": "Read", "tool_input": {"path": "src/config/anna.safe.rsc"}},
        "allow",
    ),
    (
        "shell-redirect-deny",
        {"command": "cat x > src/config/anna.safe.rsc"},
        "deny",
    ),
    (
        "shell-rg-allow",
        {"command": "rg chain=input src/config/anna.safe.rsc"},
        "allow",
    ),
    (
        "shell-cp-to-deny",
        {"command": "cp /tmp/x src/config/chr.safe.rsc"},
        "deny",
    ),
    (
        "shell-cp-from-allow",
        {"command": "cp src/config/anna.safe.rsc /tmp/anna.safe.rsc"},
        "allow",
    ),
    (
        "abs-write-deny",
        {
            "tool_name": "StrReplace",
            "tool_input": {
                "path": str(ROOT / "src/config/capxl.safe.rsc"),
            },
        },
        "deny",
    ),
    (
        "readme-write-allow",
        {"tool_name": "Write", "tool_input": {"path": "src/config/README.md"}},
        "allow",
    ),
    (
        "hooks-write-allow",
        {"tool_name": "Write", "tool_input": {"path": ".cursor/hooks.json"}},
        "allow",
    ),
    (
        "test-script-mention-allow",
        {
            "command": (
                "python3 -c "
                "'print(\"src/config/anna.safe.rsc\")'"
            )
        },
        "allow",
    ),
]


def main() -> int:
    ok = True
    for name, payload, expect in CASES:
        proc = subprocess.run(
            [sys.executable, str(SCRIPT)],
            input=json.dumps(payload),
            text=True,
            capture_output=True,
            cwd=str(ROOT),
        )
        if proc.returncode != 0:
            print(f"FAIL {name}: exit={proc.returncode} stderr={proc.stderr!r}")
            ok = False
            continue
        out = json.loads(proc.stdout)
        got = out.get("permission")
        status = "OK" if got == expect else "FAIL"
        if got != expect:
            ok = False
            print(f"{status} {name}: expect={expect} got={got} msg={out}")
        else:
            print(f"{status} {name}")
    print("ALL_OK" if ok else "SOME_FAILED")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
