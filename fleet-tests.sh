#!/usr/bin/env bash
# Fleet Test Runner — counts and runs tests across the entire fleet
# Usage: ./fleet-tests.sh [--run] [--json]
#   --run   Actually run tests (default: count only)
#   --json  Output as JSON

set -euo pipefail

PROJECTS_DIR="${PROJECTS_DIR:-/home/eileen/projects}"
JSON_MODE=false
RUN_MODE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --run)  RUN_MODE=true; shift ;;
    --json) JSON_MODE=true; shift ;;
    *)      shift ;;
  esac
done

# Collect results
declare -A RESULTS
TOTAL=0
PASSED=0
FAILED=0
REPOS_TESTED=0

run_rust_tests() {
  local dir="$1"
  local name=$(basename "$dir")
  if [ "$RUN_MODE" = true ]; then
    local output=$(cd "$dir" && cargo test 2>&1)
    local count=$(echo "$output" | grep "test result:" | grep -oP '\d+ passed' | grep -oP '\d+' | paste -sd+ | bc 2>/dev/null || echo 0)
    local failures=$(echo "$output" | grep "test result:" | grep -oP '\d+ failed' | grep -oP '\d+' | paste -sd+ | bc 2>/dev/null || echo 0)
    echo "$name:$count:$failures"
  else
    # Count only
    local count=$(cd "$dir" && cargo test 2>&1 | grep "test result:" | grep -oP '\d+ passed' | grep -oP '\d+' | paste -sd+ | bc 2>/dev/null || echo 0)
    echo "$name:$count:0"
  fi
}

run_vitest_tests() {
  local dir="$1"
  local name=$(basename "$dir")
  if [ "$RUN_MODE" = true ]; then
    local output=$(cd "$dir" && npx vitest run 2>&1)
    local count=$(echo "$output" | grep -oP '\d+ passed' | head -1 | grep -oP '\d+' || echo 0)
    echo "$name:$count:0"
  else
    local count=$(cd "$dir" && npx vitest run 2>&1 | grep -oP '\d+ passed' | head -1 | grep -oP '\d+' || echo 0)
    echo "$name:$count:0"
  fi
}

run_pytest_tests() {
  local dir="$1"
  local name=$(basename "$dir")
  local count
  if [ "$RUN_MODE" = true ]; then
    local output=$(cd "$dir" && python3 -m pytest -q 2>&1)
    count=$(echo "$output" | grep -oP '\d+ passed' | grep -oP '\d+' || echo 0)
    echo "$name:$count:0"
  else
    count=$(cd "$dir" && python3 -m pytest --co -q 2>&1 | tail -1 | grep -oP '\d+' || echo 0)
    echo "$name:$count:0"
  fi
}

run_node_tests() {
  local dir="$1"
  local name=$(basename "$dir")
  if [ "$RUN_MODE" = true ]; then
    local output=$(cd "$dir" && npm test 2>&1)
    local count=$(echo "$output" | grep -oP '\d+ passed' | grep -oP '\d+' || echo "0")
    echo "$name:$count:0"
  else
    echo "$name:0:0"
  fi
}

# Main loop
for dir in "$PROJECTS_DIR"/*/; do
  name=$(basename "$dir")
  # Skip non-git dirs
  [ -d "$dir/.git" ] || continue
  
  result=""
  
  if [ -f "$dir/Cargo.toml" ]; then
    result=$(run_rust_tests "$dir" 2>/dev/null || echo "$name:0:0")
  elif [ -f "$dir/package.json" ] && [ -f "$dir/vitest.config.ts" -o -f "$dir/vitest.config.js" ]; then
    result=$(run_vitest_tests "$dir" 2>/dev/null || echo "$name:0:0")
  elif [ -f "$dir/pyproject.toml" ] || [ -f "$dir/setup.py" ]; then
    result=$(run_pytest_tests "$dir" 2>/dev/null || echo "$name:0:0")
  elif [ -f "$dir/package.json" ]; then
    result=$(run_node_tests "$dir" 2>/dev/null || echo "$name:0:0")
  else
    continue
  fi
  
  IFS=':' read -r rname rcount rfail <<< "$result"
  
  # Sanitize — ensure numeric
  [[ "$rcount" =~ ^[0-9]+$ ]] || rcount=0
  [[ "$rfail" =~ ^[0-9]+$ ]] || rfail=0
  
  [ "$rcount" -eq 0 ] && [ "$rfail" -eq 0 ] && continue
  
  if [ "$JSON_MODE" = true ]; then
    echo "{\"repo\": \"$rname\", \"tests\": $rcount, \"failed\": $rfail},"
  else
    printf "%-40s %6s tests" "$rname" "$rcount"
    [ "$rfail" != "0" ] && printf " (%s FAILED)" "$rfail"
    echo
  fi
  
  TOTAL=$((TOTAL + rcount))
  REPOS_TESTED=$((REPOS_TESTED + 1))
done

if [ "$JSON_MODE" = true ]; then
  echo "{\"total\": $TOTAL, \"repos\": $REPOS_TESTED}"
else
  echo "─────────────────────────────────────────────────"
  printf "FLEET TOTAL: %d tests across %d repos\n" "$TOTAL" "$REPOS_TESTED"
fi
