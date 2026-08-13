#!/usr/bin/env bash
# Tests for fleet-tests.sh — the quartermaster's scanner
# Validates argument parsing, project detection, and output format
# Run: ./test_fleet_tests.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLEET_TESTS="$SCRIPT_DIR/fleet-tests.sh"
PASS=0
FAIL=0

ok() { echo "  ✓ $1"; PASS=$((PASS + 1)); }
no() { echo "  ✗ $1"; FAIL=$((FAIL + 1)); }

# ─── Setup: create a temp projects dir with mock repos ───
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# Mock Rust repo
mkdir -p "$TMPDIR/rust-mock/.git"
cat > "$TMPDIR/rust-mock/Cargo.toml" <<EOF
[package]
name = "rust-mock"
version = "0.1.0"
EOF
mkdir -p "$TMPDIR/rust-mock/src"
cat > "$TMPDIR/rust-mock/src/lib.rs" <<EOF
pub fn add(a: i32, b: i32) -> i32 { a + b }

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_add() { assert_eq!(add(2, 2), 4); }
}
EOF

# Mock Python repo
mkdir -p "$TMPDIR/py-mock/.git"
cat > "$TMPDIR/py-mock/pyproject.toml" <<EOF
[project]
name = "py-mock"
version = "0.1.0"
EOF
mkdir -p "$TMPDIR/py-mock/tests"
cat > "$TMPDIR/py-mock/tests/test_basic.py" <<EOF
def test_pass():
    assert True
EOF

# Mock repo with no tests (just .git)
mkdir -p "$TMPDIR/empty-mock/.git"

# Mock non-git directory (should be skipped)
mkdir -p "$TMPDIR/not-a-repo"

echo "Running fleet-tests.sh tests..."
echo ""

# ─── Test 1: Script exists and is executable ───
if [ -x "$FLEET_TESTS" ] || [ -f "$FLEET_TESTS" ]; then
    ok "fleet-tests.sh exists"
else
    no "fleet-tests.sh not found"
fi

# ─── Test 2: Help/no-args doesn't crash ───
output=$(PROJECTS_DIR="$TMPDIR" bash "$FLEET_TESTS" 2>&1 || true)
if echo "$output" | grep -q "FLEET TOTAL"; then
    ok "Produces fleet total output"
else
    no "No FLEET TOTAL in output: $output"
fi

# ─── Test 3: Detects Rust repos ───
output=$(PROJECTS_DIR="$TMPDIR" bash "$FLEET_TESTS" 2>&1 || true)
if echo "$output" | grep -q "rust-mock"; then
    ok "Detects Rust repos"
else
    no "Did not detect rust-mock"
fi

# ─── Test 4: Detects Python repos ───
if echo "$output" | grep -q "py-mock"; then
    ok "Detects Python repos"
else
    no "Did not detect py-mock"
fi

# ─── Test 5: Skips non-git dirs ───
if ! echo "$output" | grep -q "not-a-repo"; then
    ok "Skips non-git directories"
else
    no "Should not include non-git dirs"
fi

# ─── Test 6: --json flag produces JSON-like output ───
output=$(PROJECTS_DIR="$TMPDIR" bash "$FLEET_TESTS" --json 2>&1 || true)
if echo "$output" | grep -q '"total"'; then
    ok "JSON mode produces total field"
else
    no "JSON mode missing total: $output"
fi

if echo "$output" | grep -q '"repo"'; then
    ok "JSON mode produces repo entries"
else
    no "JSON mode missing repo entries"
fi

# ─── Test 7: Numeric values are sanitized ───
# The empty-mock repo should not produce NaN or non-numeric output
output=$(PROJECTS_DIR="$TMPDIR" bash "$FLEET_TESTS" 2>&1 || true)
if echo "$output" | grep -q "NaN\|nan\|undefined"; then
    no "Output contains NaN/nan/undefined"
else
    ok "No NaN/nan/undefined in output"
fi

# ─── Test 8: Total is a number ───
total_line=$(echo "$output" | grep "FLEET TOTAL" || true)
if echo "$total_line" | grep -qP '\d+ tests across \d+ repos'; then
    ok "Total line format correct: $total_line"
else
    no "Total line format wrong: '$total_line'"
fi

# ─── Test 9: Unknown flags are ignored gracefully ───
output=$(PROJECTS_DIR="$TMPDIR" bash "$FLEET_TESTS" --bogus 2>&1 || true)
if echo "$output" | grep -q "FLEET TOTAL"; then
    ok "Unknown flags ignored gracefully"
else
    no "Unknown flag caused failure"
fi

# ─── Test 10: Empty projects dir doesn't crash ───
EMPTY_DIR=$(mktemp -d)
output=$(PROJECTS_DIR="$EMPTY_DIR" bash "$FLEET_TESTS" 2>&1 || true)
if echo "$output" | grep -q "FLEET TOTAL"; then
    ok "Empty projects dir handled"
else
    no "Empty projects dir crashed: $output"
fi
rm -rf "$EMPTY_DIR"

# ─── Summary ───
echo ""
echo "────────────────────────────────────────"
printf "Tests: %d passed, %d failed\n" "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
