#!/usr/bin/env bash
# Comprehensive anna canary smoke after Fresh. No interactive prompts.
# Compatible with macOS bash 3.2 (no mapfile / associative arrays).
set -uo pipefail

SSH_BASE=(ssh -n -i "$HOME/.ssh/mikrobackups/automation"
  -o IdentitiesOnly=yes
  -o UserKnownHostsFile="$HOME/.ssh/mikrobackups/known_hosts"
  -o StrictHostKeyChecking=yes
  -o HostKeyAlias=anna
  -o ConnectTimeout=30
  -o BatchMode=yes
  -o ServerAliveInterval=5
  -o ServerAliveCountMax=3
  automation@192.168.90.1)

LOCAL_DIR="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)/src/scripts"
MARK="anna-full-$(date +%H%M%S)"
OUT_DIR="${TMPDIR:-/tmp}/$MARK"
mkdir -p "$OUT_DIR"
RESULTS="$OUT_DIR/results.txt"
: >"$RESULTS"
LOG_MAIN="$OUT_DIR/console.log"

HARD_SKIP_RE='^(doPerfectRestore|doCPUHighLoadReboot|doRandomGen)$'

ros() {
  "${SSH_BASE[@]}" "$@" </dev/null 2>&1 | tr -d '\r'
  return "${PIPESTATUS[0]}"
}

log() { printf '%s\n' "$*" | tee -a "$LOG_MAIN"; }

log "MARK=$MARK OUT_DIR=$OUT_DIR"
log "===== 0. PRE: identity / mgmt ====="
ros '/system identity print' | tee -a "$LOG_MAIN" || true
ros ':put [/ip address get [find interface=main-infrastructure-br] address]' | tee -a "$LOG_MAIN" || true

log ""
log "===== 1. SOURCE INTEGRITY ====="
NAMES_FILE="$OUT_DIR/names.txt"
ros ':foreach i in=[/system script find] do={:put [/system script get $i name]}' >"$NAMES_FILE" || true
# one RouterOS round-trip: print lengths
ros ':foreach i in=[/system script find] do={:local n [/system script get $i name]; :put ("LEN " . $n . " " . [:len [/system script get $i source]])}' >"$OUT_DIR/lens.txt" || true

while read -r line; do
  # LEN name number
  set -- $line
  [ "${1:-}" = "LEN" ] || continue
  s=$2
  DEV=$3
  if [ -f "$LOCAL_DIR/${s}.rsc.txt" ]; then
    LOC=$(wc -c <"$LOCAL_DIR/${s}.rsc.txt" | tr -d ' ')
    if [ "$DEV" = "$LOC" ]; then
      log "MATCH  $s $DEV"
    else
      log "DIFF   $s device=$DEV local=$LOC"
      echo "DIFF $s" >>"$RESULTS"
    fi
  else
    log "NOLOCAL $s device=$DEV"
    echo "NOLOCAL $s" >>"$RESULTS"
  fi
done <"$OUT_DIR/lens.txt"

log ""
log "===== repo scripts absent on anna ====="
for f in "$LOCAL_DIR"/*.rsc.txt; do
  base=$(basename "$f" .rsc.txt)
  if ! grep -qx "$base" "$NAMES_FILE" 2>/dev/null; then
    log "ABSENT $base"
    echo "ABSENT $base" >>"$RESULTS"
  fi
done

log ""
log "===== markers (batch) ====="
ros ':foreach n in={"doFreshTheScripts";"doIPSECPunch";"doCreateTrafficAccountingQueues";"doStaleTSLConnectionsTrack";"doPushStatsToInfluxDB";"doNetwatchDNS"} do={:local src [/system script get $n source]; :if (($src ~ "\\^skip-continue") or ($src ~ "\\^break-loop")) do={:put ("MARKOK $n")} else={:put ("MARKMISS $n")}}' \
  | tee -a "$LOG_MAIN" | tee "$OUT_DIR/markers.txt" || true
# fallback local check per file if batch regex awkward on ROS
for s in doFreshTheScripts doIPSECPunch doCreateTrafficAccountingQueues doStaleTSLConnectionsTrack doPushStatsToInfluxDB doNetwatchDNS; do
  src=$(ros ":put [/system script get $s source]" || true)
  if printf '%s' "$src" | grep -E -q '\^skip-continue|\^break-loop'; then
    log "MARKOK $s"
  else
    log "MARKMISS $s"
    echo "MARKMISS $s" >>"$RESULTS"
  fi
done

log ""
log "===== hooks ====="
log "old NetwatchHostName: $(ros '/tool netwatch print count-only where up-script~":global NetwatchHostName"' || echo err)"
log "new globalNetwatchHostName: $(ros '/tool netwatch print count-only where up-script~":global globalNetwatchHostName"' || echo err)"
LEASE=$(ros ':put [/ip dhcp-server get guest-dhcp-server lease-script]' || true)
printf '%s' "$LEASE" | grep -q '\$leaseBound' && log "lease \$vars OK" || { log "lease \$vars BROKEN"; echo "HOOK lease" >>"$RESULTS"; }
printf '%s' "$LEASE" | grep -q 'globalLeaseBound' && log "lease globalLease* OK" || { log "lease globalLease* MISSING"; echo "HOOK lease-name" >>"$RESULTS"; }

log ""
log "===== env helpers ====="
for g in globalSafeScriptCall globalSecret globalTimestamp globalNoteMe globalScriptBeforeRun globalTgMessage globalCallFetch globalCallSSH; do
  log "$g=$(ros ":put [:typeof \$$g]" | tail -1 || echo err)"
done

log ""
log "===== 2. INFRA SNAPSHOT ====="
ros '/ip dns print' | tee -a "$LOG_MAIN" || true
ros '/ip route print where dst-address=0.0.0.0/0' | tee -a "$LOG_MAIN" || true
ros '/ip ipsec active-peers print' | tee -a "$LOG_MAIN" || true
ros '/tool netwatch print proplist=name,host,status' | tee -a "$LOG_MAIN" || true

log ""
log "===== 3. SCRIPT RUN-ALL ====="
ros ":log info \"$MARK-FULL-BEGIN\"" || true

ORDER="doEnvironmentClearance
doEnvironmentSetup
doNetwatchHost
doDHCPLeaseTrack
doNetwatchDNS
doIPSECPunch
doCreateTrafficAccountingQueues
doStaleTSLConnectionsTrack
doPushStatsToInfluxDB
doFreshDNSAddressLists
doUpdateExternalDNS
doSuperviseCHRviaSSH
doUpdatePoliciesRemotely
doUpdateStaticDNSviaDHCP
doCheckPingRate
doCollectSpeedStats
doHeatFlag
doCoolConsole
doFlushLogs
flush_dns
doKeepScriptsOwner
doLEDon
doLEDoff
doWestminister
doBumerSound
doSomeAlarm
doImperialMarch
doFastTrackActivation
doTranstaleMAC2IP
doHotspotLoginTrack
doAdblock
doCertificatesIssuing
doSCEPClientCertificatesIssuing
doBackup
doCloudBackup
doDumpTheScripts
doFreshTheScripts
doStartupScript"

# ordered first, then leftovers from device
FINAL_FILE="$OUT_DIR/final.txt"
: >"$FINAL_FILE"
echo "$ORDER" | while read -r s; do
  [ -z "$s" ] && continue
  grep -qx "$s" "$NAMES_FILE" && echo "$s"
done >"$FINAL_FILE"
while read -r a; do
  [ -z "$a" ] && continue
  grep -qx "$a" "$FINAL_FILE" && continue
  echo "$a" >>"$FINAL_FILE"
done <"$NAMES_FILE"

run_one() {
  local s="$1" outf="$OUT_DIR/$s.out" CMD OUT rc=0
  if echo "$s" | grep -E -q "$HARD_SKIP_RE"; then
    log "SKIP $s"
    echo "SKIP $s" >>"$RESULTS"
    return
  fi
  log "===== $s @ $(date '+%H:%M:%S') ====="
  case "$s" in
    doNetwatchHost)
      CMD=':global globalNetwatchHostName "anna-full"; :global globalNetwatchHostState "UP"; /system script run doNetwatchHost'
      ;;
    doDHCPLeaseTrack)
      CMD=':global globalLeaseBound 1; :global globalLeaseServerName "guest-dhcp-server"; :global globalLeaseActMac "00:11:22:33:44:55"; :global globalLeaseActIp "192.168.99.99"; /system script run doDHCPLeaseTrack'
      ;;
    doHotspotLoginTrack)
      CMD=':global globalHotspotUser "anna-full-user"; /system script run doHotspotLoginTrack'
      ;;
    doFreshTheScripts)
      ros '/system scheduler remove [find name=doFreshTheScriptsFullSmoke]' >/dev/null || true
      ros '/system scheduler add name=doFreshTheScriptsFullSmoke on-event=doFreshTheScripts interval=5s start-time=startup policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon comment=full-smoke-once' || true
      local i jobs line
      for i in $(seq 1 72); do
        sleep 5
        jobs=$(ros '/system script job print count-only where script=doFreshTheScripts' | tail -1 || echo '?')
        line=$(ros '/log print where message~"doFreshTheScripts:.*(SUCCESS|FAILED)"' | tail -5 || true)
        log "  poll $i jobs=$jobs"
        if [ "$jobs" = "0" ] && [ "$i" -gt 3 ]; then
          printf '%s\n' "$line" | tee -a "$LOG_MAIN"
          break
        fi
      done
      ros '/system scheduler remove [find name=doFreshTheScriptsFullSmoke]' >/dev/null || true
      OUT=$(ros '/log print where message~"doFreshTheScripts:.*(SUCCESS|FAILED)"' | tail -8 || true)
      printf '%s\n' "$OUT" | tee "$outf" | tee -a "$LOG_MAIN"
      ;;
    *)
      CMD="/system script run $s"
      ;;
  esac
  if [ "$s" != "doFreshTheScripts" ]; then
    OUT=$(ros "$CMD") || rc=$?
    printf '%s\n' "$OUT" | tee "$outf" | tee -a "$LOG_MAIN" | tail -20
  fi
  if printf '%s' "$OUT" | grep -E -q "✗ FAILED|FAILED $s on"; then
    echo "FAIL $s" >>"$RESULTS"
    log "=> FAIL $s"
  elif printf '%s' "$OUT" | grep -Eiq "syntax error \(line|expected end of command|bad command name"; then
    echo "ERR  $s" >>"$RESULTS"
    log "=> ERR $s"
  elif printf '%s' "$OUT" | grep -q "✓ SUCCESS"; then
    echo "OK   $s" >>"$RESULTS"
    log "=> OK $s"
  elif printf '%s' "$OUT" | grep -Eiq "instance already running|cannot find .* in secret store"; then
    echo "WARN $s" >>"$RESULTS"
    log "=> WARN $s"
  else
    echo "DONE $s" >>"$RESULTS"
    log "=> DONE $s (rc=$rc)"
  fi
  log ""
}

while read -r s; do
  [ -z "$s" ] && continue
  run_one "$s"
done <"$FINAL_FILE"

ros ":log info \"$MARK-FULL-END\"" || true

log ""
log "===== 4. POST INFRA ====="
ros '/system identity print' | tee -a "$LOG_MAIN" || true
ros ':put [/ip address get [find interface=main-infrastructure-br] address]' | tee -a "$LOG_MAIN" || true
log "netwatch down count: $(ros '/tool netwatch print count-only where status=down' || echo err)"

log ""
log "===== SUMMARY ====="
sort "$RESULTS" | uniq -c | sort -k2 | tee -a "$LOG_MAIN"
log ""
log "----- detail -----"
cat "$RESULTS" | tee -a "$LOG_MAIN"
log "OUT_DIR=$OUT_DIR"
log "DONE $MARK"
