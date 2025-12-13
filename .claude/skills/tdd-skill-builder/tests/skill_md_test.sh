#!/bin/bash
# Tests for the main SKILL.md file
# TDD RED phase: These tests verify SKILL.md meets requirements

# Get the directory of this test file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../.." && pwd)"
SKILL_DIR="${SCRIPT_DIR}/.."
SKILL_MD="${SKILL_DIR}/SKILL.md"

# Add project tools to PATH
[[ -d "${PROJECT_ROOT}/tools" ]] && export PATH="${PROJECT_ROOT}/tools:${PATH}"

# Source the validator
# shellcheck source=../scripts/skill_validator.sh
source "${SCRIPT_DIR}/../scripts/skill_validator.sh" 2>/dev/null || true

# ============================================================
# SKILL.md Existence Tests
# ============================================================

# Test: SKILL.md exists
function test_skill_md_exists() {
  assert_file_exists "${SKILL_MD}"
}

# ============================================================
# SKILL.md Frontmatter Tests
# ============================================================

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
  assert_not_empty "${name}"
}

# Test: SKILL.md name is tdd-skill-builder
function test_skill_md_name_is_correct() {
  local name
  name=$(get_skill_name "${SKILL_MD}")
  assert_equals "tdd-skill-builder" "${name}"
}

# Test: SKILL.md has description field
function test_skill_md_has_description() {
  local desc
  desc=$(get_skill_description "${SKILL_MD}")
  assert_not_empty "${desc}"
}

# Test: SKILL.md description contains trigger phrase
function test_skill_md_description_has_trigger() {
  local desc
  desc=$(get_skill_description "${SKILL_MD}")
  # Should trigger when user wants to "create a new skill" or "build a skill"
  assert_contains_ignore_case "skill" "${desc}"
  assert_contains_ignore_case "creat" "${desc}" # Matches create/creation
}

# ============================================================
# SKILL.md Content Tests
# ============================================================

# Test: SKILL.md references official docs
function test_skill_md_references_official_docs() {
  local content
  content=$(cat "${SKILL_MD}")
  assert_contains "code.claude.com" "${content}"
}

# Test: SKILL.md documents TDD workflow
function test_skill_md_documents_tdd_workflow() {
  local content
  content=$(cat "${SKILL_MD}")
  assert_contains "RED" "${content}"
  assert_contains "GREEN" "${content}"
  assert_contains "REFACTOR" "${content}"
}

# Test: SKILL.md references available scripts
function test_skill_md_references_scripts() {
  local content
  content=$(cat "${SKILL_MD}")
  assert_contains "check_prerequisites" "${content}"
  assert_contains "skill_validator" "${content}"
  assert_contains "template_updater" "${content}"
}

# ============================================================
# SKILL.md Validation Test
# ============================================================

# Test: SKILL.md passes full validation
function test_skill_md_passes_validation() {
  local exit_code=0
  validate_skill_structure "${SKILL_DIR}" &>/dev/null || exit_code=$?
  assert_equals 0 "${exit_code}"
}
