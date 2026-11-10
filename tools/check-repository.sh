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
  README.md USER-RULES.md LLM-RULES.md AGENTS.md CONTRIBUTING.md SECURITY.md LICENSE
  .dev.env.example
  .gitignore .cursorignore .cursor/mcp.json .cursor/hooks.json
  .cursor/rules/safety.mdc .cursor/rules/routeros.mdc .cursor/rules/repository.mdc
  .cursor/rules/vendor.mdc .cursor/rules/user-rules-bootstrap.mdc
  .cursor/rules/sdd.mdc .cursor/rules/markdown.mdc
  .cursor/rules/readme-ru-text.mdc .cursor/rules/caveman-lite.mdc
  .cursor/rules/karpathy-guidelines.mdc
  .cursor/commands/routeros-docs.md .cursor/commands/routeros-check-script.md
  .cursor/commands/evolve.md .cursor/commands/caveman.md
  .cursor/agents/verifier.md
  .cursor/skills/sdd-explore/SKILL.md .cursor/skills/sdd-propose/SKILL.md
  .cursor/skills/sdd-apply/SKILL.md .cursor/skills/sdd-verify/SKILL.md
  .cursor/skills/sdd-archive/SKILL.md .cursor/skills/ru-text/SKILL.md
  .cursor/skills/caveman/SKILL.md .cursor/skills/caveman-help/SKILL.md
  .cursor/skills/design-doc-mermaid/SKILL.md
  .cursor/skills/design-doc-mermaid/scripts/extract_mermaid.py
  .cursor/skills/design-doc-mermaid/scripts/mermaid_to_image.py
  .cursor/skills/design-doc-mermaid/scripts/resilient_diagram.py
  spec/README.md spec/templates/proposal.md spec/templates/design.md
  spec/templates/tasks.md spec/templates/spec.md spec/templates/delta-spec.md
  spec/capabilities/README.md spec/changes/README.md
  spec/changes/archive/README.md spec/plans/README.md
  doc/architecture.md doc/devices/inventory.md
  doc/operations/backup-pipeline.md doc/operations/script-release.md
  doc/operations/diagnostics.md doc/operations/raw-policy.md
  doc/security/credentials.md doc/security/write-path-design.md
  doc/script-audit.md doc/style-canon.md doc/routeros-skills-review.md
  doc/migration-report.md doc/cutover-plan.md doc/cursor-tooling.md
  config/inventory.example.yml
  bin/README.md src/config/README.md vendor/README.md
  vendor/rosetta/LICENSE vendor/rosetta/UPSTREAM_COMMIT
  vendor/routeros-skills/LICENSE vendor/routeros-skills/UPSTREAM_COMMIT
  vendor/mikrotik-mcp/LICENSE vendor/mikrotik-mcp/UPSTREAM_COMMIT
  vendor/mikrotik-mcp/LOCAL_CHANGES.md
  tools/rosetta-db.sh tools/sync-routeros-skills.sh
)

for path in "${required[@]}"; do
  [[ -f "$path" ]] || fail "нет обязательного файла: $path"
done

while IFS= read -r path; do
  case "$path" in
    bin/README.md) ;;
    *) fail "в Git запрещено содержимое private-каталога: $path" ;;
  esac
done < <(git ls-files -- bin)

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
  doPushStatsToInfluxDB.rsc.txt
  doRandomGen.rsc.txt
  doSCEPClientCertificatesIssuing.rsc.txt
  doSomeAlarm.rsc.txt
  doStaleTSLConnectionsTrack.rsc.txt
  doStartupScript.rsc.txt
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

if [[ "${#actual_scripts[@]}" -ne 40 ]]; then
  fail "ожидалось 40 RouterOS-скриптов, найдено ${#actual_scripts[@]}"
fi
for name in "${expected_scripts[@]}"; do
  [[ -f "src/scripts/$name" ]] || fail "нет ожидаемого скрипта: $name"
done

mapfile -t registered_skills < <(
  find .cursor/skills -mindepth 2 -maxdepth 2 -path '.cursor/skills/routeros-*/SKILL.md' -print |
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

mapfile -t sdd_skills < <(
  find .cursor/skills -mindepth 2 -maxdepth 2 -path '.cursor/skills/sdd-*/SKILL.md' -print |
    LC_ALL=C sort
)
[[ "${#sdd_skills[@]}" -eq 5 ]] ||
  fail "ожидалось 5 SDD skills, найдено ${#sdd_skills[@]}"
for path in "${sdd_skills[@]}"; do
  grep -q '^disable-model-invocation: true' "$path" ||
    fail "SDD skill должен вызываться только явно: $path"
done

design_mermaid_files="$(
  find .cursor/skills/design-doc-mermaid -type f -print | wc -l | tr -d ' '
)"
[[ "$design_mermaid_files" -eq 25 ]] ||
  fail "ожидалось 25 файлов design-doc-mermaid, найдено $design_mermaid_files"

ru_text_files="$(
  find .cursor/skills/ru-text -type f -print | wc -l | tr -d ' '
)"
[[ "$ru_text_files" -eq 13 ]] ||
  fail "ожидалось 13 файлов ru-text, найдено $ru_text_files"

if git ls-files --error-unmatch .dev.env >/dev/null 2>&1; then
  fail ".dev.env не должен отслеживаться Git"
fi

if ! ./tools/sync-routeros-skills.sh check; then
  errors=$((errors + 1))
fi

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
        or rel.startswith(".cursor/skills/design-doc-mermaid/")
        or rel.startswith(".cursor/skills/ru-text/")
        or (rel.startswith("src/config/") and rel.endswith(".safe.rsc"))
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

printf 'OK: структура, 40 скриптов, private patterns и JSON/YAML проверены.\n'
