#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
INSTALL_SCRIPT="${REPO_ROOT}/scripts/install-skills.sh"
SKILL_COUNT="$(find "${REPO_ROOT}/skills" -mindepth 2 -maxdepth 2 -type f -name SKILL.md | wc -l | tr -d ' ')"
REPO_TARGET_COUNT=4
USER_TARGET_COUNT=4

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

pass() {
  echo "PASS: $1"
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local msg="$3"
  [[ "${haystack}" == *"${needle}"* ]] || fail "${msg}"
}

assert_eq() {
  local actual="$1"
  local expected="$2"
  local msg="$3"
  [[ "${actual}" == "${expected}" ]] || fail "${msg} (expected=${expected}, actual=${actual})"
}

tmp_root="$(mktemp -d "${TMPDIR:-/tmp}/skills-smoke.XXXXXX")"
trap 'rm -rf "${tmp_root}"' EXIT

# 1) Help text
help_out="$("${INSTALL_SCRIPT}" --help)"
assert_contains "${help_out}" "--scope <scope>" "help should describe --scope"
pass "help output"

# 2) Invalid arguments should fail
if "${INSTALL_SCRIPT}" --scope nope >/dev/null 2>&1; then
  fail "invalid --scope should fail"
fi
pass "invalid scope rejected"

if "${INSTALL_SCRIPT}" --skip-existing --overwrite >/dev/null 2>&1; then
  fail "--skip-existing and --overwrite together should fail"
fi
pass "invalid flag combination rejected"

# 3) Dry-run checks
repo_target="${tmp_root}/repo-target"
mkdir -p "${repo_target}"
repo_dry="$("${INSTALL_SCRIPT}" --dry-run --scope repo --target "${repo_target}")"
assert_contains "${repo_dry}" "${repo_target}/.cursor/skills" "repo dry-run should include cursor repo path"
assert_contains "${repo_dry}" "${repo_target}/.codex/skills" "repo dry-run should include codex repo path"
pass "repo dry-run paths"

user_home="${tmp_root}/user-home"
mkdir -p "${user_home}"
user_dry="$(HOME="${user_home}" "${INSTALL_SCRIPT}" --dry-run --scope user)"
assert_contains "${user_dry}" "${user_home}/.gemini/antigravity/skills" "user dry-run should include gemini antigravity path"
assert_contains "${user_dry}" "${user_home}/.codex/skills" "user dry-run should include codex user path"
pass "user dry-run paths"

# 4) Real install checks
"${INSTALL_SCRIPT}" --scope repo --target "${repo_target}" >/dev/null
repo_count="$(find "${repo_target}" -type f -name SKILL.md | wc -l | tr -d ' ')"
expected_repo_count="$((SKILL_COUNT * REPO_TARGET_COUNT))"
assert_eq "${repo_count}" "${expected_repo_count}" "repo install should create expected SKILL.md files"
pass "repo install file count"

HOME="${user_home}" "${INSTALL_SCRIPT}" --scope user >/dev/null
user_count="$(find "${user_home}" -type f -name SKILL.md | wc -l | tr -d ' ')"
expected_user_count="$((SKILL_COUNT * USER_TARGET_COUNT))"
assert_eq "${user_count}" "${expected_user_count}" "user install should create expected SKILL.md files"
pass "user install file count"

# 5) Skip existing should skip all existing skill targets in repo scope
skip_out="$("${INSTALL_SCRIPT}" --scope repo --target "${repo_target}" --skip-existing)"
skip_count="$(printf "%s\n" "${skip_out}" | rg -c "^Skipped existing: ")"
assert_eq "${skip_count}" "${expected_repo_count}" "skip-existing should skip all existing repo skill targets"
pass "skip-existing behavior"

# 6) both scope with target==HOME should dedupe target directories
same_home="${tmp_root}/same-home"
mkdir -p "${same_home}"
both_dry="$(HOME="${same_home}" "${INSTALL_SCRIPT}" --dry-run --scope both --target "${same_home}")"
ensure_count="$(printf "%s\n" "${both_dry}" | rg "^Would ensure directory: " | wc -l | tr -d ' ')"
unique_count="$(printf "%s\n" "${both_dry}" | rg "^Would ensure directory: " | sort -u | wc -l | tr -d ' ')"
assert_eq "${ensure_count}" "${unique_count}" "both scope should not emit duplicate ensure-directory targets"
pass "both scope dedupe"

echo "All install script smoke tests passed."
