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
check 'Only reviewed GitHub MCP server' jq -e '.mcpServers == {
  "github": {
    "type": "http",
    "url": "https://api.githubcopilot.com/mcp/x/all",
    "headers": {"Authorization": "Bearer ${GITHUB_MCP_TOKEN}"}
  }
}' .omp/mcp.json
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
  if actual=$(PI_CONFIG_FILES=".omp/profiles/$profile.yml" omp config get tools.approvalMode 2>/dev/null); then
    check "$profile approval mode" test "$actual" = "$expected"
  else
    printf 'FAIL Cannot read %s profile\n' "$profile"
    failed=1
  fi
  if actual=$(PI_CONFIG_FILES=".omp/profiles/$profile.yml" omp config get task.maxConcurrency 2>/dev/null); then
    check "$profile subagent concurrency limit" test "$actual" = 3
  else
    printf 'FAIL Cannot read %s subagent limit\n' "$profile"
    failed=1
  fi
  if [[ "$profile" != yolo ]]; then
    if actual=$(PI_CONFIG_FILES=".omp/profiles/$profile.yml" omp config get tools.approval --json | jq -er '.value.edit'); then
      check "$profile edit/patch approval" test "$actual" = prompt
    else
      printf 'FAIL Cannot read %s edit/patch approval\n' "$profile"
      failed=1
    fi
  fi
done
printf '%s\n' 'INFO OAuth is not verified by doctor. Use make login and test a small request.'
printf '%s\n' 'INFO GitHub MCP authentication is not verified. Use /mcp test github in OMP.'
printf '%s\n' 'INFO Check actual mounts and limits with docker inspect on the host.'
exit "$failed"
