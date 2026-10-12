#!/usr/bin/env python3
"""Fail-closed gate for directly write-capable MCP tool names."""

import json
import re
import sys

WRITE_WORDS = re.compile(
    r"(^|[_:./-])"
    r"(create|update|delete|remove|write|edit|patch|apply|set|add|merge|"
    r"commit|push|upload|send|reply|dismiss|request|execute|exec|run_command|"
    r"deploy|restore|reboot|reset|import)"
    r"($|[_:./-])",
    re.IGNORECASE,
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


try:
    payload = json.load(sys.stdin)
    name = (
        payload.get("tool_name")
        or payload.get("toolName")
        or payload.get("name")
        or payload.get("mcp_tool_name")
    )
    if not isinstance(name, str) or not name.strip():
        respond("deny", "MCP-вызов заблокирован: не удалось определить имя инструмента.")
    elif WRITE_WORDS.search(name):
        respond("deny", f"MCP-инструмент «{name}» заблокирован локальной write-policy.")
    else:
        respond("allow", "Read-only MCP-вызов разрешён.")
except Exception:
    respond("deny", "MCP-вызов заблокирован: ошибка проверки policy.")
