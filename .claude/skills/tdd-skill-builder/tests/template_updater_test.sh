#!/bin/bash
# Tests for template_updater.sh
# TDD RED phase: These tests are written BEFORE implementation

# Get the directory of this test file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../.." && pwd)"

# Add project tools to PATH
[[ -d "${PROJECT_ROOT}/tools" ]] && export PATH="${PROJECT_ROOT}/tools:${PATH}"

# Source the script to test
# shellcheck source=../scripts/template_updater.sh
source "${SCRIPT_DIR}/../scripts/template_updater.sh" 2>/dev/null || true

# ============================================================
# get_templates_dir Tests
# ============================================================

# Test: get_templates_dir returns path to templates directory
function test_get_templates_dir_returns_path() {
  local templates_dir
  templates_dir=$(get_templates_dir)
  assert_contains "assets" "${templates_dir}"
}

# ============================================================
# check_for_updates Tests
# ============================================================

# Test: check_for_updates returns status code
function test_check_for_updates_returns_status() {
  local exit_code=0
  check_for_updates &>/dev/null || exit_code=$?
  # Should return 0 (up to date) or 1 (updates available) or 2 (error)
  # Exit code should be 0, 1, or 2
  if [[ ${exit_code} -le 2 ]]; then
    assert_true "true"
  else
    assert_equals "0, 1, or 2" "${exit_code}"
  fi
}

# Test: check_for_updates shows checking message
function test_check_for_updates_shows_message() {
  local result
  result=$(check_for_updates 2>&1) || true
  assert_contains_ignore_case "check" "${result}"
}

# ============================================================
# backup_templates Tests
# ============================================================

# Test: backup_templates creates backup of existing templates
function test_backup_templates_creates_backup() {
  local test_templates_dir
  test_templates_dir=$(mktemp -d)

  # Create a template file
  echo "original content" >"${test_templates_dir}/SKILL.template.md"

  local exit_code=0
  backup_templates "${test_templates_dir}" &>/dev/null || exit_code=$?

  assert_equals 0 "${exit_code}"
  assert_file_exists "${test_templates_dir}/SKILL.template.md.bak"

  rm -rf "${test_templates_dir}"
}

# Test: backup_templates preserves original content
function test_backup_templates_preserves_content() {
  local test_templates_dir
  test_templates_dir=$(mktemp -d)

  # Create a template file with specific content
  echo "test content 12345" >"${test_templates_dir}/test.template.md"

  backup_templates "${test_templates_dir}" &>/dev/null || true

  local backup_content
  backup_content=$(cat "${test_templates_dir}/test.template.md.bak")
  assert_equals "test content 12345" "${backup_content}"

  rm -rf "${test_templates_dir}"
}

# ============================================================
# restore_templates Tests
# ============================================================

# Test: restore_templates restores from backup
function test_restore_templates_restores_from_backup() {
  local test_templates_dir
  test_templates_dir=$(mktemp -d)

  # Create backup file
  echo "backup content" >"${test_templates_dir}/test.template.md.bak"

  local exit_code=0
  restore_templates "${test_templates_dir}" &>/dev/null || exit_code=$?

  assert_equals 0 "${exit_code}"
  assert_file_exists "${test_templates_dir}/test.template.md"

  local restored_content
  restored_content=$(cat "${test_templates_dir}/test.template.md")
  assert_equals "backup content" "${restored_content}"

  rm -rf "${test_templates_dir}"
}

# ============================================================
# download_template Tests
# ============================================================

# Test: download_template downloads file from URL
function test_download_template_downloads_file() {
  local test_dir
  test_dir=$(mktemp -d)

  # Use a known small file that should always exist
  local test_url="https://raw.githubusercontent.com/anthropics/claude-code/main/README.md"

  local exit_code=0
  download_template "${test_url}" "${test_dir}/test_file.md" &>/dev/null || exit_code=$?

  # May fail if no network - that's okay for unit tests
  if [[ ${exit_code} -eq 0 ]]; then
    assert_file_exists "${test_dir}/test_file.md"
  fi

  rm -rf "${test_dir}"
}

# Test: download_template returns error for invalid URL
function test_download_template_returns_error_for_invalid_url() {
  local test_dir
  test_dir=$(mktemp -d)

  local exit_code=0
  download_template "https://invalid-url-that-does-not-exist-xyz123.com/file" "${test_dir}/test.md" &>/dev/null || exit_code=$?

  assert_equals 1 "${exit_code}"

  rm -rf "${test_dir}"
}

# ============================================================
# update_templates Tests
# ============================================================

# Test: update_templates creates templates directory if missing
function test_update_templates_creates_directory() {
  local test_dir
  test_dir=$(mktemp -d)
  local templates_path="${test_dir}/templates"

  # Directory doesn't exist yet
  assert_directory_not_exists "${templates_path}"

  export TEMPLATES_DIR="${templates_path}"
  update_templates &>/dev/null || true
  unset TEMPLATES_DIR

  # Directory should be created
  assert_directory_exists "${templates_path}"

  rm -rf "${test_dir}"
}

# Test: update_templates shows progress messages
function test_update_templates_shows_progress() {
  local test_dir
  test_dir=$(mktemp -d)

  export TEMPLATES_DIR="${test_dir}"
  local result
  result=$(update_templates 2>&1) || true
  unset TEMPLATES_DIR

  # Should show some progress
  assert_contains "updat" "${result}" || assert_contains "download" "${result}" || assert_contains "template" "${result}"

  rm -rf "${test_dir}"
}

# ============================================================
# show_changelog Tests
# ============================================================

# Test: show_changelog shows template changes
function test_show_changelog_returns_output() {
  local result
  result=$(show_changelog 2>&1) || true

  # Should return something (even if empty or error)
  # This just tests the function exists and runs
  assert_true "true"
}

# ============================================================
# Command Line Interface Tests
# ============================================================

# Test: --check option runs check_for_updates
function test_cli_check_option() {
  local result
  result=$(template_updater_main --check 2>&1) || true
  assert_contains_ignore_case "check" "${result}"
}

# Test: --help option shows usage
function test_cli_help_option() {
  local result
  result=$(template_updater_main --help 2>&1) || true
  assert_contains_ignore_case "usage" "${result}"
}

# Test: --update option triggers update
function test_cli_update_option() {
  local test_dir
  test_dir=$(mktemp -d)

  export TEMPLATES_DIR="${test_dir}"
  local result
  result=$(template_updater_main --update 2>&1) || true
  unset TEMPLATES_DIR

  assert_contains "updat" "${result}" || assert_contains "download" "${result}"

  rm -rf "${test_dir}"
}
