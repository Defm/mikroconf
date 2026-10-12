# Local changes

This directory vendors `wiresage/mikrotik-mcp` v0.24.2. The exact upstream
revision is recorded in `UPSTREAM_COMMIT`; upstream's `LICENSE` is unchanged.

## Hardened read-only profile

Use the dedicated entry point:

```sh
MIKROTIK_HOST=192.0.2.1 \
MIKROTIK_USERNAME=observer \
MIKROTIK_KEY_FILENAME=/run/secrets/mikrotik_ed25519 \
MIKROTIK_KNOWN_HOSTS_PATH=/etc/mikrotik-mcp/known_hosts \
mcp-server-mikrotik-hardened
```

For an inventory, `known_hosts_path` may be set per device; otherwise
`MIKROTIK_KNOWN_HOSTS_PATH` is inherited by every device. Keep this trust file
separate from a user's mutable `~/.ssh/known_hosts`, owned by the service
account or root, and not writable by the MCP process. Populate and verify host
key fingerprints through a trusted out-of-band channel. Do not blindly trust
the output of `ssh-keyscan`.

The hardened launcher forces:

- profile `hardened-read-only`;
- read-only catalogue filtering;
- sensitive-data hiding;
- stdio transport.

Startup validation rejects attempts to weaken those settings or select an HTTP
transport. Tool annotations are not treated as an authorization boundary: the
profile also applies the explicit `HARDENED_READ_ONLY_TOOLS` name allowlist.
The allowlist excludes file/backup content retrieval, write/destructive tools,
and monitoring/scanning/traffic/load operations.

## SSH host-key policy

All SSH connections now load only the configured dedicated known_hosts file
and install Paramiko `RejectPolicy`. A missing path, missing file, unknown host
key, or changed host key fails closed; the implementation never uses
`AutoAddPolicy`.

## Tests

From this directory:

```sh
uv run --with pytest pytest tests/unit
```

The local tests enumerate the hardened catalogue, reject forbidden names and
verbs, verify that sensitive hiding and stdio cannot be disabled, and exercise
known_hosts loading and unknown-host rejection. Tests use mocks and do not
connect to network devices.
