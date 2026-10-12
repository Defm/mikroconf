#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bootstrap-readonly.sh plan <device-host> <admin-user>
  bootstrap-readonly.sh apply <device-host> <admin-user>

Required for apply:
  MIKROBACKUPS_BOOTSTRAP_APPROVED=<device-host>
  ADMIN_IDENTITY_FILE=/path/to/existing/admin/private-key

The device host key must already exist in:
  ~/.ssh/mikrobackups/known_hosts
EOF
}

[[ $# -eq 3 ]] || { usage >&2; exit 2; }
mode=$1
device=$2
admin_user=$3

case "$mode" in
  plan|apply) ;;
  *) usage >&2; exit 2 ;;
esac

diag_user=cursor-diag
diag_group=cursor-diag-readonly
diag_key="${HOME}/.ssh/mikrobackups/cursor-diag"
known_hosts="${HOME}/.ssh/mikrobackups/known_hosts"
remote_key_file=cursor-diag.pub

cat <<EOF
Device: ${device}
Administrative user: ${admin_user}
Changes:
  1. Upload ${remote_key_file}.
  2. Create/update group ${diag_group} with policies read,ssh.
  3. Create ${diag_user} disabled with a random password.
  4. Import the dedicated public key.
  5. Enable ${diag_user} and remove the uploaded file.
  6. Verify a read-only identity query with the new key.
EOF

[[ "$mode" == apply ]] || exit 0

[[ "${MIKROBACKUPS_BOOTSTRAP_APPROVED:-}" == "$device" ]] || {
  printf 'Refusing apply: set MIKROBACKUPS_BOOTSTRAP_APPROVED=%s\n' "$device" >&2
  exit 2
}
[[ -n "${ADMIN_IDENTITY_FILE:-}" && -f "$ADMIN_IDENTITY_FILE" ]] || {
  printf 'Refusing apply: ADMIN_IDENTITY_FILE must name an existing private key\n' >&2
  exit 2
}
[[ -f "$diag_key" && -f "${diag_key}.pub" && -f "$known_hosts" ]] || {
  printf 'Refusing apply: diagnostic key or known_hosts is missing\n' >&2
  exit 2
}
ssh-keygen -F "$device" -f "$known_hosts" >/dev/null || {
  printf 'Refusing apply: %s is not pinned in %s\n' "$device" "$known_hosts" >&2
  exit 2
}

ssh_opts=(
  -o BatchMode=yes
  -o IdentitiesOnly=yes
  -o StrictHostKeyChecking=yes
  -o "UserKnownHostsFile=${known_hosts}"
  -i "$ADMIN_IDENTITY_FILE"
)

scp "${ssh_opts[@]}" "${diag_key}.pub" \
  "${admin_user}@${device}:${remote_key_file}"

temporary_password=$(python3 -c 'import secrets; print(secrets.token_urlsafe(32))')
trap 'unset temporary_password' EXIT

ssh "${ssh_opts[@]}" "${admin_user}@${device}" <<EOF
:local groupName "${diag_group}"
:local userName "${diag_user}"
:local keyFile "${remote_key_file}"
:local temporaryPassword "${temporary_password}"
:if ([:len [/user group find where name=\$groupName]] = 0) do={
  /user group add name=\$groupName policy=read,ssh
} else={
  /user group set [find where name=\$groupName] policy=read,ssh
}
:if ([:len [/user find where name=\$userName]] = 0) do={
  /user add name=\$userName group=\$groupName password=\$temporaryPassword disabled=yes
} else={
  /user set [find where name=\$userName] group=\$groupName password=\$temporaryPassword disabled=yes
}
/user ssh-keys remove [find where user=\$userName]
/user ssh-keys import public-key-file=\$keyFile user=\$userName
/user set [find where name=\$userName] disabled=no
/file remove [find where name=\$keyFile]
EOF

ssh -o BatchMode=yes -o IdentitiesOnly=yes -o StrictHostKeyChecking=yes \
  -o "UserKnownHostsFile=${known_hosts}" -i "$diag_key" \
  "${diag_user}@${device}" ':put [/system identity get name]'
