#!/usr/bin/env bash
set -euo pipefail

failed=0
check() {
  local label=$1
  shift
  if "$@"; then
    printf 'OK   %s\n' "$label"
  else
    printf 'FAIL %s\n' "$label"
    failed=1
  fi
}

check 'Working directory is /workspace' test "$PWD" = /workspace
check 'Running as agent' test "$(id -un)" = agent
check 'OMP installed' bash -c 'command -v omp >/dev/null'
check 'Native rules exist' test -s .omp/RULES.md
check 'No project MCP servers' jq -e '.mcpServers == {}' .omp/mcp.json
for dir in incoming projects output temp; do
  check "Directory: $dir" test -d "$dir"
done
check 'Credential directory writable' test -w /home/agent/.omp
check 'No Docker socket at default path' test ! -S /var/run/docker.sock
if [[ -r /proc/self/status ]]; then
  check 'No new privileges' grep -Eq '^NoNewPrivs:[[:space:]]+1$' /proc/self/status
  check 'No effective capabilities' grep -Eq '^CapEff:[[:space:]]+0+$' /proc/self/status
fi
check 'OMP version smoke test' omp --version
for spec in safe:always-ask normal:write yolo:yolo; do
  profile=${spec%%:*}
  expected=${spec#*:}
  if actual=$(omp --config ".omp/profiles/$profile.yml" config get tools.approvalMode 2>/dev/null); then
    check "$profile approval mode" test "$actual" = "$expected"
  else
    printf 'FAIL Cannot read %s profile\n' "$profile"
    failed=1
  fi
done
printf '%s\n' 'INFO OAuth is not verified by doctor. Use make login and test a small request.'
printf '%s\n' 'INFO Check actual mounts and limits with docker inspect on the host.'
exit "$failed"
