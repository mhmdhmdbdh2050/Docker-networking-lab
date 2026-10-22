#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
cd -- "$PROJECT_DIR"

for service in cont1 cont2 cont3 cont4; do
  if ! docker compose exec -T "$service" sh -c 'command -v ping >/dev/null' >/dev/null 2>&1; then
    echo "Cannot run ping in $service. Check that the service is running and this Docker CLI context can reach its engine." >&2
    exit 1
  fi
done

expect_reachable() {
  local source="$1" target="$2"
  if docker compose exec -T "$source" sh -c \
    'ping -c 1 -W 2 "$1" >/dev/null 2>&1; result=$?; if [ "$result" -eq 0 ]; then exit 0; else exit 10; fi' \
    sh "$target" >/dev/null 2>&1; then
    echo "PASS: $source can reach $target"
  else
    echo "FAIL: expected $source to reach $target" >&2
    return 1
  fi
}

expect_isolated() {
  local source="$1" target="$2"
  local result=0
  if docker compose exec -T "$source" sh -c \
    'ping -c 1 -W 2 "$1" >/dev/null 2>&1; result=$?; if [ "$result" -eq 0 ]; then exit 0; else exit 10; fi' \
    sh "$target" >/dev/null 2>&1; then
    echo "FAIL: $source unexpectedly reached isolated address $target" >&2
    return 1
  else
    result=$?
    if [[ "$result" -eq 10 ]]; then
      echo "PASS: $source cannot reach isolated address $target"
    else
      echo "ERROR: isolation probe failed to run (exit $result)." >&2
      return "$result"
    fi
  fi
}

expect_reachable cont1 172.29.10.3
expect_reachable cont1 172.29.10.4
expect_reachable cont4 10.30.10.2
expect_isolated cont4 172.29.10.3
