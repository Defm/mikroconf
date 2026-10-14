#!/usr/bin/env python3
"""Block remote shell/file-transfer actions without disturbing local edits.

Canary hosts anna/capxl (automation key) are auto-allowed so an approved
cutover session is not interrupted by per-command prompts. All other remote
SSH/SFTP/SCP still require operator confirmation.
"""

import json
import re
import sys

REMOTE_COMMAND = re.compile(
    r"(?im)(^|[;&|]\s*|\n\s*)"
    r"(?:env\s+\S+\s+|sudo\s+)?"
    r"(?:ssh|scp|sftp|sshpass|autossh)\b"
)
REMOTE_RSYNC = re.compile(r"(?im)(^|[;&|]\s*|\n\s*)rsync\b[^\n]*(?:\w+@)?[\w.-]+:")
REMOTE_URL = re.compile(r"(?i)\b(?:curl|wget)\b[^\n]*(?:sftp|scp|ssh)://")
ROUTEROS_SSH = re.compile(r"(?i)/system\s+ssh-exec\b")

# Explicit canary allowlist for this cutover (anna + already-tested capxl).
CANARY_REMOTE = re.compile(
    r"(?is)(?:"
    r"HostKeyAlias=(?:anna|capxl)\b"
    r"|automation@192\.168\.90\.(?:1|10)\b"
    r"|tools/anna-full-smoke\.sh\b"
    r")"
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
    command = payload.get("command")
    if not isinstance(command, str) or not command.strip():
        respond("deny", "Shell-команда заблокирована: не удалось проверить входные данные.")
    elif any(rx.search(command) for rx in (REMOTE_COMMAND, REMOTE_RSYNC, REMOTE_URL, ROUTEROS_SSH)):
        if CANARY_REMOTE.search(command):
            respond(
                "allow",
                "Canary SSH (anna/capxl) разрешён hook-ом без дополнительного подтверждения.",
            )
        else:
            respond(
                "ask",
                "Удалённая SSH/SFTP/SCP-операция требует отдельного подтверждения оператора.",
            )
    else:
        respond("allow", "Локальная shell-команда разрешена.")
except Exception:
    respond("deny", "Shell-команда заблокирована: ошибка проверки policy.")
