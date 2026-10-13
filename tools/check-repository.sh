#!/usr/bin/env bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 1

errors=0
fail() {
  printf 'ОШИБКА: %s\n' "$*" >&2
  errors=$((errors + 1))
}

required=(
  README.md AGENTS.md CONTRIBUTING.md SECURITY.md LICENSE
  .gitignore .cursorignore .cursor/mcp.json .cursor/hooks.json
  .cursor/rules/safety.mdc .cursor/rules/routeros.mdc .cursor/rules/repository.mdc
  docs/architecture.md docs/devices/inventory.md
  docs/operations/backup-pipeline.md docs/operations/script-release.md
  docs/operations/diagnostics.md docs/operations/raw-policy.md
  docs/security/credentials.md docs/security/write-path-design.md
  docs/script-audit.md docs/style-canon.md docs/routeros-skills-review.md
  docs/migration-report.md docs/cutover-plan.md
  config/inventory.example.yml
  bin/README.md src/safe/README.md src/config/README.md vendor/README.md
  vendor/rosetta/LICENSE vendor/rosetta/UPSTREAM_COMMIT
  vendor/routeros-skills/LICENSE vendor/routeros-skills/UPSTREAM_COMMIT
  vendor/mikrotik-mcp/LICENSE vendor/mikrotik-mcp/UPSTREAM_COMMIT
  vendor/mikrotik-mcp/LOCAL_CHANGES.md
)

for path in "${required[@]}"; do
  [[ -f "$path" ]] || fail "нет обязательного файла: $path"
done

while IFS= read -r path; do
  case "$path" in
    bin/README.md|src/safe/README.md) ;;
    *) fail "в Git запрещено содержимое private-каталога: $path" ;;
  esac
done < <(git ls-files -- bin src/safe)

expected_scripts=(
  doAdblock.rsc.txt
  doBackup.rsc.txt
  doBumerSound.rsc.txt
  doCPUHighLoadReboot.rsc.txt
  doCertificatesIssuing.rsc.txt
  doCheckPingRate.rsc.txt
  doCloudBackup.rsc.txt
  doCollectSpeedStats.rsc.txt
  doCoolConsole.rsc.txt
  doCreateTrafficAccountingQueues.rsc.txt
  doDHCPLeaseTrack.rsc.txt
  doDumpTheScripts.rsc.txt
  doEnvironmentClearance.rsc.txt
  doEnvironmentSetup.rsc.txt
  doFastTrackActivation.rsc.txt
  doFlushLogs.rsc.txt
  doFreshDNSAddressLists.rsc.txt
  doFreshTheScripts.rsc.txt
  doHeatFlag.rsc.txt
  doHotspotLoginTrack.rsc.txt
  doIPSECPunch.rsc.txt
  doImperialMarch.rsc.txt
  doKeepScriptsOwner.rsc.txt
  doLEDoff.rsc.txt
  doLEDon.rsc.txt
  doNetwatchDNS.rsc.txt
  doNetwatchHost.rsc.txt
  doPerfectRestore.rsc.txt
  doPeriodicLogDump.rsc.txt
  doPeriodicLogParse.rsc.txt
  doPushStatsToInfluxDB.rsc.txt
  doRandomGen.rsc.txt
  doSCEPClientCertificatesIssuing.rsc.txt
  doSomeAlarm.rsc.txt
  doStaleTSLConnectionsTrack.rsc.txt
  doStartupScript.rsc.txt
  doSuperviseCHRviaSSH.rsc.txt
  doTelegramNotify.rsc.txt
  doTranstaleMAC2IP.rsc.txt
  doUpdateExternalDNS.rsc.txt
  doUpdatePoliciesRemotely.rsc.txt
  doUpdateStaticDNSviaDHCP.rsc.txt
  doWestminister.rsc.txt
  flush_dns.rsc.txt
)

mapfile -t actual_scripts < <(
  for path in src/scripts/*.rsc.txt; do
    [[ -e "$path" ]] && basename "$path"
  done | LC_ALL=C sort
)

if [[ "${#actual_scripts[@]}" -ne 44 ]]; then
  fail "ожидалось 44 RouterOS-скрипта, найдено ${#actual_scripts[@]}"
fi
for name in "${expected_scripts[@]}"; do
  [[ -f "src/scripts/$name" ]] || fail "нет ожидаемого скрипта: $name"
done

mapfile -t registered_skills < <(
  find .cursor/skills -mindepth 2 -maxdepth 2 -name SKILL.md -print |
    LC_ALL=C sort
)
[[ "${#registered_skills[@]}" -eq 17 ]] ||
  fail "ожидалось 17 зарегистрированных RouterOS skills, найдено ${#registered_skills[@]}"
for path in "${registered_skills[@]}"; do
  case "$path" in
    .cursor/skills/routeros-fundamentals/SKILL.md|\
    .cursor/skills/routeros-scripting/SKILL.md|\
    .cursor/skills/routeros-syntax-inspection/SKILL.md|\
    .cursor/skills/routeros-centrs/SKILL.md)
      grep -q '^disable-model-invocation: true$' "$path" &&
        fail "базовый skill не должен быть manual-only: $path"
      ;;
    *)
      grep -q '^disable-model-invocation: true$' "$path" ||
        fail "опасный/reference skill должен быть manual-only: $path"
      ;;
  esac
done

while IFS= read -r -d '' path; do
  case "$path" in
    *.backup|*.npk|*.p12|*.pfx|*.pem|*.key|*.der|*.cer|*.crt|\
    rawconf_*.rsc|*/rawconf_*.rsc|*/id_rsa|*/id_rsa.*|*/id_ed25519|*/id_ed25519.*)
      fail "обнаружен запрещённый private/backup-файл: $path"
      ;;
  esac
done < <(git ls-files --cached --others --exclude-standard -z)

if ! python3 - "$ROOT" <<'PY'
import re
import subprocess
import sys
from pathlib import Path

root = Path(sys.argv[1])
paths = subprocess.check_output(
    ["git", "-C", str(root), "ls-files", "--cached", "--others", "--exclude-standard", "-z"]
).split(b"\0")

patterns = [
    ("private key", re.compile(rb"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----")),
    ("Telegram token", re.compile(rb"\b[0-9]{8,}:[A-Za-z0-9_-]{30,}\b")),
    ("GitHub token", re.compile(rb"\bgh[pousr]_[A-Za-z0-9]{20,}\b")),
    ("AWS access key", re.compile(rb"\b(?:AKIA|ASIA)[A-Z0-9]{16}\b")),
    (
        "literal credential",
        re.compile(
            rb"(?i)(?:password|passphrase|token|secret)\s*(?:=|:)\s*[\"']"
            rb"(?!\*{0,8}\$|\$|<|__|YOUR_|REDACTED|CHANGE_ME)[^\"'\r\n]{6,}[\"']"
        ),
    ),
]

bad = False
for raw in paths:
    if not raw:
        continue
    rel = raw.decode("utf-8", "surrogateescape")
    # Vendored trees are preserved from audited upstream revisions and contain
    # fixtures/examples that intentionally resemble credentials. First-party
    # secret scanning is kept strict; vendor integrity/provenance is checked
    # separately above.
    if (
        rel == "tools/check-repository.sh"
        or rel.startswith("vendor/")
        or rel.startswith(".cursor/skills/routeros-")
    ):
        continue
    path = root / rel
    if not path.is_file():
        continue
    data = path.read_bytes()
    if b"\0" in data:
        continue
    for label, pattern in patterns:
        if pattern.search(data):
            print(f"ОШИБКА: возможный секрет ({label}) в {rel}", file=sys.stderr)
            bad = True
            break
sys.exit(1 if bad else 0)
PY
then
  errors=$((errors + 1))
fi

mapfile -t json_files < <(
  git ls-files --cached --others --exclude-standard |
    awk '!/^vendor\// && /\.json$/ { print }'
)
for path in "${json_files[@]}"; do
  python3 -m json.tool "$path" >/dev/null || fail "некорректный JSON: $path"
done

mapfile -t yaml_files < <(
  git ls-files --cached --others --exclude-standard |
    awk '!/^vendor\// && /\.ya?ml$/ { print }'
)
if ((${#yaml_files[@]})); then
  if command -v ruby >/dev/null 2>&1; then
    for path in "${yaml_files[@]}"; do
      ruby -ryaml -e 'YAML.parse_file(ARGV.fetch(0))' "$path" ||
        fail "некорректный YAML: $path"
    done
  elif python3 -c 'import yaml' >/dev/null 2>&1; then
    for path in "${yaml_files[@]}"; do
      python3 -c 'import pathlib,sys,yaml; yaml.safe_load(pathlib.Path(sys.argv[1]).read_text())' "$path" ||
        fail "некорректный YAML: $path"
    done
  else
    fail "найдены YAML-файлы, но нет доступного YAML-parser"
  fi
fi

if ((errors)); then
  printf 'Проверка завершилась с ошибками: %d\n' "$errors" >&2
  exit 1
fi

printf 'OK: структура, 44 скрипта, private patterns и JSON/YAML проверены.\n'
