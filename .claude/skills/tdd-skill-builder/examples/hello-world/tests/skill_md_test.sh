#!/bin/bash
# Tests for hello-world SKILL.md
# TDD RED phase: Validate example skill structure

# Get the directory of this test file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../../.." && pwd)"
SKILL_DIR="${SCRIPT_DIR}/.."
SKILL_MD="${SKILL_DIR}/SKILL.md"

# Add project tools to PATH
[[ -d "${PROJECT_ROOT}/tools" ]] && export PATH="${PROJECT_ROOT}/tools:${PATH}"

# Source the validator from parent skill
# shellcheck source=../../../scripts/skill_validator.sh
source "${SCRIPT_DIR}/../../../scripts/skill_validator.sh" 2>/dev/null || true

# ============================================================
# SKILL.md Tests
# ============================================================

# Test: SKILL.md exists
function test_skill_md_exists() {
  assert_file_exists "${SKILL_MD}"
}

# Test: SKILL.md has valid frontmatter
function test_skill_md_has_frontmatter() {
  local exit_code=0
  has_frontmatter "${SKILL_MD}" || exit_code=$?
  assert_equals 0 "${exit_code}"
}

# Test: SKILL.md has name field
function test_skill_md_has_name() {
  local name
  name=$(get_skill_name "${SKILL_MD}")
  assert_equals "hello-world" "${name}"
}

# Test: SKILL.md has description
function test_skill_md_has_description() {
  local desc
  desc=$(get_skill_description "${SKILL_MD}")
  assert_not_empty "${desc}"
}

# Test: SKILL.md passes full validation
function test_skill_md_passes_validation() {
  local exit_code=0
  validate_skill_structure "${SKILL_DIR}" &>/dev/null || exit_code=$?
  assert_equals 0 "${exit_code}"
}
