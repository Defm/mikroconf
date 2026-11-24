#!/usr/bin/env python3
"""Fail-closed gate: deny agent writes to src/config/*.safe.rsc; allow reads."""

from __future__ import annotations

import json
import re
import shlex
import sys
from pathlib import Path
from typing import Any, Iterable

PROTECTED_SAFE_RSC = re.compile(
    r"(?:^|[/\\])src[/\\]config[/\\][^/\\]+\.safe\.rsc$",
    re.IGNORECASE,
)

WRITE_TOOL = re.compile(
    r"(^|:)(Write|Delete|StrReplace|Edit|TabWrite|ApplyPatch)($|:)",
    re.IGNORECASE,
)

REDIRECT_TO = re.compile(r"(>>?)\s*(?:'([^']+)'|\"([^\"]+)\"|(\S+))")
CMD_CP_MV = re.compile(
    r"(?im)(?:^|[;&|]\s*|\n\s*)(?:cp|mv|install|rsync)\b([^\n;&|]*)"
)
CMD_RM = re.compile(
    r"(?im)(?:^|[;&|]\s*|\n\s*)(?:rm|unlink|shred)\b([^\n;&|]*)"
)
CMD_TEE = re.compile(
    r"(?im)(?:^|[;&|]\s*|\n\s*)tee\b([^\n;&|]*)"
)
CMD_SED_I = re.compile(
    r"(?im)(?:^|[;&|]\s*|\n\s*)(?:sed|perl)\b(?=[^\n]*\s-(?:i|in-place)\b)([^\n;&|]*)"
)
CMD_TRUNCATE = re.compile(
    r"(?im)(?:^|[;&|]\s*|\n\s*)(?:truncate|sponge)\b([^\n;&|]*)"
)
CMD_DD_OF = re.compile(r"(?im)\bdd\b[^\n]*\bof=([^\s;|&]+)")

PATH_KEYS = (
    "path",
    "file_path",
    "filePath",
    "target_file",
    "targetFile",
    "filename",
    "file",
)


def respond(permission: str, message: str) -> None:
    print(
        json.dumps(
            {
                "permission": permission,
                "user_message": message,
                "agent_message": message,
            },
            ensure_ascii=False,
        )
    )


def normalize_path(value: str) -> str:
    text = value.strip().strip("'\"")
    if not text:
        return ""
    try:
        return Path(text).expanduser().as_posix()
    except Exception:
        return text.replace("\\", "/")


def is_protected_path(value: str) -> bool:
    path = normalize_path(value)
    if not path:
        return False
    if PROTECTED_SAFE_RSC.search(path):
        return True
    try:
        parts = Path(path).parts
    except Exception:
        return False
    for i in range(len(parts) - 2):
        if (
            parts[i].lower() == "src"
            and parts[i + 1].lower() == "config"
            and parts[i + 2].lower().endswith(".safe.rsc")
        ):
            return True
    return False


def walk_strings(node: Any) -> Iterable[str]:
    if isinstance(node, str):
        yield node
        return
    if isinstance(node, dict):
        for value in node.values():
            yield from walk_strings(value)
        return
    if isinstance(node, list):
        for item in node:
            yield from walk_strings(item)


def collect_protected_paths(*nodes: Any) -> list[str]:
    found: list[str] = []
    for node in nodes:
        if isinstance(node, str):
            if is_protected_path(node):
                found.append(normalize_path(node))
            continue
        if not isinstance(node, (dict, list)):
            continue
        for value in walk_strings(node):
            if is_protected_path(value):
                found.append(normalize_path(value))
    return found


def deny_message(paths: list[str]) -> str:
    shown = ", ".join(sorted(set(paths))[:5])
    return (
        "Запись в src/config/*.safe.rsc заблокирована hook-ом "
        f"(только чтение; пишет doBackup/оператор): {shown}"
    )


def split_args(fragment: str) -> list[str]:
    try:
        return shlex.split(fragment, posix=True)
    except ValueError:
        return fragment.split()


def operands(args: list[str]) -> list[str]:
    out: list[str] = []
    i = 0
    while i < len(args):
        arg = args[i]
        if arg == "--":
            out.extend(args[i + 1 :])
            break
        if arg.startswith("-") and len(arg) > 1:
            # skip -flag and optional value for -o style when glued
            i += 1
            continue
        out.append(arg)
        i += 1
    return out


def check_tool_payload(payload: dict[str, Any]) -> tuple[str, str] | None:
    tool_name = (
        payload.get("tool_name")
        or payload.get("toolName")
        or payload.get("name")
        or ""
    )
    if not isinstance(tool_name, str) or not WRITE_TOOL.search(tool_name):
        return None

    tool_input = (
        payload.get("tool_input")
        or payload.get("toolInput")
        or payload.get("arguments")
        or payload.get("input")
        or {}
    )
    paths = collect_protected_paths(
        *(payload.get(key) for key in PATH_KEYS),
        tool_input,
    )
    if paths:
        return ("deny", deny_message(paths))
    return None


def check_shell_command(command: str) -> tuple[str, str] | None:
    hits: list[str] = []

    for match in REDIRECT_TO.finditer(command):
        target = match.group(2) or match.group(3) or match.group(4) or ""
        if is_protected_path(target):
            hits.append(normalize_path(target))

    for match in CMD_CP_MV.finditer(command):
        ops = operands(split_args(match.group(1)))
        if ops and is_protected_path(ops[-1]):
            hits.append(normalize_path(ops[-1]))

    for rx in (CMD_RM, CMD_TEE, CMD_SED_I, CMD_TRUNCATE):
        for match in rx.finditer(command):
            for op in operands(split_args(match.group(1))):
                if is_protected_path(op):
                    hits.append(normalize_path(op))

    for match in CMD_DD_OF.finditer(command):
        target = match.group(1).strip("'\"")
        if is_protected_path(target):
            hits.append(normalize_path(target))

    if hits:
        return ("deny", deny_message(hits))
    return None


try:
    payload = json.load(sys.stdin)
    if not isinstance(payload, dict):
        respond("deny", "Запись в safe.rsc заблокирована: некорректный payload hook.")
        raise SystemExit(0)

    command = payload.get("command")
    if isinstance(command, str) and command.strip():
        decision = check_shell_command(command)
        if decision:
            respond(*decision)
        else:
            respond("allow", "Shell-команда не пишет в src/config/*.safe.rsc.")
        raise SystemExit(0)

    decision = check_tool_payload(payload)
    if decision:
        respond(*decision)
    else:
        respond("allow", "Операция не пишет в src/config/*.safe.rsc.")
except SystemExit:
    raise
except Exception:
    respond(
        "deny",
        "Запись в src/config/*.safe.rsc заблокирована: ошибка проверки policy.",
    )
