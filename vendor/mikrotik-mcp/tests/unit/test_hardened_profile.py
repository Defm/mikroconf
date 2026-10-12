import json
import os
from pathlib import Path
import re
import subprocess
import sys

import pytest
from pydantic import ValidationError


FORBIDDEN_PREFIXES = re.compile(
    r"^(?:add|create|set|update|remove|delete|enable|disable|move|flush|clear|"
    r"commit|rollback|restore|import|export|upload|download|run|start|stop|"
    r"reboot|reset|scan|monitor|test|check)_"
)
FORBIDDEN_TERMS = ("backup", "file", "sniffer", "torch", "flood", "bandwidth", "load")

def test_hardened_catalogue_is_explicit_and_contains_no_forbidden_tools():
    from mcp_mikrotik.configured_mcp_server import HARDENED_READ_ONLY_TOOLS

    repo_root = Path(__file__).parents[2]
    script = """
import asyncio
import json
from mcp_mikrotik.app import mcp
print(json.dumps([tool.name for tool in asyncio.run(mcp.list_tools())]))
"""
    env = {
        key: value for key, value in os.environ.items()
        if not key.startswith("MIKROTIK_")
    } | {
        "PYTHONPATH": str(repo_root / "src"),
        "MIKROTIK_PROFILE": "hardened-read-only",
        "MIKROTIK_READ_ONLY": "true",
        "MIKROTIK_SENSITIVE_HIDING": "true",
        "MIKROTIK_MCP__TRANSPORT": "stdio",
    }
    result = subprocess.run(
        [sys.executable, "-c", script],
        check=True,
        capture_output=True,
        cwd=repo_root,
        env=env,
        text=True,
    )
    names = set(json.loads(result.stdout))
    assert names
    assert names <= HARDENED_READ_ONLY_TOOLS
    assert "list_devices" in names
    assert "download_file" not in names
    assert not {name for name in names if FORBIDDEN_PREFIXES.search(name)}
    assert not {
        name for name in names
        if any(
            re.search(rf"(?:^|_){re.escape(term)}(?:$|_)", name.casefold())
            for term in FORBIDDEN_TERMS
        )
    }


@pytest.mark.parametrize(
    "overrides",
    [
        {"read_only": False},
        {"sensitive_hiding": False},
        {"mcp": {"transport": "sse"}},
        {"mcp": {"transport": "streamable-http"}},
    ],
)
def test_hardened_profile_rejects_weakened_configuration(overrides):
    from mcp_mikrotik.config import MikrotikConfig

    values = {
        "profile": "hardened-read-only",
        "read_only": True,
        "sensitive_hiding": True,
        "mcp": {"transport": "stdio"},
    }
    values.update(overrides)
    with pytest.raises(ValidationError):
        MikrotikConfig(**values)


def test_hardened_server_refuses_http_app_builders(monkeypatch):
    from mcp_mikrotik import config
    from mcp_mikrotik.configured_mcp_server import ConfiguredMCPServer

    monkeypatch.setattr(config, "mikrotik_config", _valid_hardened_config())
    server = ConfiguredMCPServer("hardened-http-test")

    with pytest.raises(RuntimeError, match="HTTP transports are disabled"):
        server.sse_app()
    with pytest.raises(RuntimeError, match="HTTP transports are disabled"):
        server.streamable_http_app()


def _valid_hardened_config():
    from mcp_mikrotik.config import MikrotikConfig

    return MikrotikConfig(
        profile="hardened-read-only",
        read_only=True,
        sensitive_hiding=True,
        mcp={"transport": "stdio"},
    )


def test_hardened_launcher_forces_profile_and_stdio(monkeypatch):
    from mcp_mikrotik import server

    captured = {}
    monkeypatch.setattr(
        server,
        "main",
        lambda forced_profile=None: captured.update(
            forced_profile=forced_profile,
            profile=server.os.environ.get("MIKROTIK_PROFILE"),
            read_only=server.os.environ.get("MIKROTIK_READ_ONLY"),
            sensitive=server.os.environ.get("MIKROTIK_SENSITIVE_HIDING"),
            transport=server.os.environ.get("MIKROTIK_MCP__TRANSPORT"),
        ),
    )

    server.hardened_main()
    assert captured == {
        "forced_profile": "hardened-read-only",
        "profile": "hardened-read-only",
        "read_only": "true",
        "sensitive": "true",
        "transport": "stdio",
    }
