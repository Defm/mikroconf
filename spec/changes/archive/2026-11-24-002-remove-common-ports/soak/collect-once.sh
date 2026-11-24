#!/bin/bash
# Read-only soak sample for 002-remove-common-ports (anna + capxl).
# No config writes. Appends TELEMETRY.md and a sample file.

set -euo pipefail

SOAK="$(cd "$(dirname "$0")" && pwd)"
SAMPLES="$SOAK/samples"
TS="$(TZ=Europe/Moscow date '+%Y-%m-%dT%H:%M:%S%z')"
STAMP="$(TZ=Europe/Moscow date '+%Y%m%d-%H%M%S')"
OUT="$SAMPLES/$STAMP.md"
mkdir -p "$SAMPLES"

SSH_BASE=(
  ssh
  -i "$HOME/.ssh/mikrobackups/automation"
  -o IdentitiesOnly=yes
  -o UserKnownHostsFile="$HOME/.ssh/mikrobackups/known_hosts"
  -o StrictHostKeyChecking=yes
  -o ConnectTimeout=15
  -o BatchMode=yes
  -p 2223
)

anna() { "${SSH_BASE[@]}" -o HostKeyAlias=anna automation@anna.home "$@"; }
capxl() { "${SSH_BASE[@]}" -o HostKeyAlias=capxl automation@capxl.home "$@"; }

anna_q() { anna "$@" 2>/dev/null | tr -d '\r' | sed '/^$/d' | tail -n 1 | tr -d '[:space:]'; }
cap_q() { capxl "$@" 2>/dev/null | tr -d '\r'; }

common="$(anna_q '/ip firewall filter print count-only where chain=chain-self-common-ports' || echo ERR)"
# packets via get — без ломаного разбора пробелов в тысячах print stats
dhcp_j="$(anna_q ':put [/ip firewall filter get [find where comment="jump dhcp-server"] packets]' || echo ERR)"
dhcp_a="$(anna_q ':put [/ip firewall filter get [find where comment="DHCP clients to server"] packets]' || echo ERR)"
ntp_j="$(anna_q ':put [/ip firewall filter get [find where comment="jump ntp-server"] packets]' || echo ERR)"
ntp_a="$(anna_q ':put [/ip firewall filter get [find where comment="NTP clients to server"] packets]' || echo ERR)"
stats="$(anna '/ip firewall filter print stats where chain=chain-dhcp-server or chain=chain-ntp-server or jump-target=chain-dhcp-server or jump-target=chain-ntp-server' 2>/dev/null | tr -d '\r' || true)"
leases="$(anna_q '/ip dhcp-server lease print count-only where status=bound' || echo ERR)"
ospf="$(anna_q '/routing ospf neighbor print count-only' || echo ERR)"
dropc="$(anna_q '/log print count-only where message~"#DROP UNKNOWN (INPUT)"' || echo ERR)"
tun_raw="$(anna '/interface print where name=chr-tunnel' 2>/dev/null | tr -d '\r' || true)"
tun="down"
printf '%s\n' "$tun_raw" | grep -qE ' R ' && tun="running"

cap_dhcp_raw="$(cap_q '/ip dhcp-client print detail' || echo ERR)"
cap_ntp_raw="$(cap_q '/system ntp client print' || echo ERR)"
cap_resolve="$(cap_q ':put [/resolve anna.home]' || echo ERR)"

cdhcp="?"
cntp="?"
printf '%s\n' "$cap_dhcp_raw" | grep -q 'status=bound' && cdhcp="bound"
printf '%s\n' "$cap_ntp_raw" | grep -q 'synchronized' && cntp="synchronized"

ANNA_RAW="common=$common
dhcp_accept=$dhcp_a
dhcp_jump=$dhcp_j
ntp_accept=$ntp_a
ntp_jump=$ntp_j
leases_bound=$leases
ospf_neighbors=$ospf
drop_unknown_log_count=$dropc
chr_tunnel=$tun
--- stats ---
$stats
--- tunnel ---
$tun_raw"

CAP_RAW="dhcp=$cdhcp
ntp=$cntp
resolve_anna=$cap_resolve
---
$cap_dhcp_raw
---
$cap_ntp_raw"

{
  echo "# Soak sample $TS"
  echo
  echo "## anna"
  echo '```'
  echo "$ANNA_RAW"
  echo '```'
  echo
  echo "## capxl"
  echo '```'
  echo "$CAP_RAW"
  echo '```'
} >"$OUT"

pass="pass"
note=""
if [[ "$common" != "0" ]]; then pass="fail"; note="common-ports!=0"; fi
for v in "$dhcp_a" "$dhcp_j" "$ntp_a" "$ntp_j" "$leases"; do
  if [[ "$v" == "ERR" ]]; then pass="fail"; note="ssh-parse-error"; fi
done
if [[ "$cdhcp" != "bound" ]]; then pass="watch"; note="${note:+$note;}capxl-dhcp=$cdhcp"; fi
if [[ "$cntp" != "synchronized" ]]; then pass="watch"; note="${note:+$note;}capxl-ntp=$cntp"; fi

if [[ ! -f "$SOAK/TELEMETRY.md" ]]; then
  cat >"$SOAK/TELEMETRY.md" <<'HDR'
# Soak telemetry 002-remove-common-ports

Интервал: каждый час до **2026-11-24 22:23 Europe/Moscow**. Только чтение anna+capxl. Без правок config.

| TS (MSK) | verdict | common | dhcp A/J | ntp A/J | leases | ospf | tunnel | drop_log | capxl dhcp | capxl ntp | note | sample |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
HDR
fi

# Avoid duplicate header pollution from earlier bad run: ensure file ends with newline
echo "| $TS | $pass | $common | ${dhcp_a}/${dhcp_j} | ${ntp_a}/${ntp_j} | ${leases} | ${ospf} | ${tun} | ${dropc} | ${cdhcp} | ${cntp} | ${note:-} | [$STAMP](samples/$STAMP.md) |" >>"$SOAK/TELEMETRY.md"

echo "SOAK_SAMPLE ok ts=$TS pass=$pass file=$OUT"
