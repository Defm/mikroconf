#!/bin/bash
# Hourly read-only soak until END_TS (Europe/Moscow). No config writes.

set -euo pipefail

SOAK="$(cd "$(dirname "$0")" && pwd)"
COLLECT="$SOAK/collect-once.sh"
END_TS="${1:-2026-11-24 22:23:00}"
LOG="$SOAK/runner.log"

# macOS date parse
END_EPOCH="$(TZ=Europe/Moscow date -j -f '%Y-%m-%d %H:%M:%S' "$END_TS" '+%s')"
NOW_EPOCH="$(TZ=Europe/Moscow date '+%s')"

echo "SOAK_RUNNER start end='$END_TS' end_epoch=$END_EPOCH now=$NOW_EPOCH" | tee -a "$LOG"

# Immediate first sample (covers near-T+1 window)
"$COLLECT" | tee -a "$LOG"

while true; do
  NOW_EPOCH="$(TZ=Europe/Moscow date '+%s')"
  if [[ "$NOW_EPOCH" -ge "$END_EPOCH" ]]; then
    echo "SOAK_RUNNER end-reached; final sample" | tee -a "$LOG"
    "$COLLECT" | tee -a "$LOG" || true
    echo "SOAK_RUNNER done $(TZ=Europe/Moscow date '+%Y-%m-%dT%H:%M:%S%z')" | tee -a "$LOG"
    echo 'AGENT_LOOP_TICK_soak002 {"prompt":"Soak 002 finished: read TELEMETRY.md, mark tasks 5.2/5.3 from samples, no device writes."}'
    exit 0
  fi
  # sleep until next hour boundary or remaining time, max 3600s
  REMAIN=$((END_EPOCH - NOW_EPOCH))
  SLEEP=3600
  if [[ "$REMAIN" -lt "$SLEEP" ]]; then
    SLEEP="$REMAIN"
  fi
  echo "SOAK_RUNNER sleep ${SLEEP}s (remain ${REMAIN}s)" | tee -a "$LOG"
  sleep "$SLEEP"
  echo "AGENT_LOOP_TICK_soak002 {\"prompt\":\"Soak 002 hourly tick: read latest soak/TELEMETRY.md row, append dynamics to tasks.md if needed, no device writes.\"}"
  "$COLLECT" | tee -a "$LOG" || echo "SOAK_RUNNER sample-failed" | tee -a "$LOG"
done
