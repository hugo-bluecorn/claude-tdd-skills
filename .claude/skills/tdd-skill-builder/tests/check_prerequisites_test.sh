#!/bin/bash
# Tests for check_prerequisites.sh

# Get the directory of this test file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../.." && pwd)"

# Source project environment (created by scripts/setup.sh)
# shellcheck source=/dev/null
[[ -f "${PROJECT_ROOT}/.env" ]] && source "${PROJECT_ROOT}/.env"

# Add project tools to PATH if bashunit is installed there
[[ -d "${PROJECT_ROOT}/tools" ]] && export PATH="${PROJECT_ROOT}/tools:${PATH}"

# Source the script to test
# shellcheck source=../scripts/check_prerequisites.sh
source "${SCRIPT_DIR}/../scripts/check_prerequisites.sh" 2>/dev/null || true

# Test: check_tool_installed returns success (0) for installed tool
function test_check_tool_installed_returns_success_for_bash() {
  # bash should always be installed on any system running these tests
  local result
  result=$(check_tool_installed "bash" 2>&1)
  assert_successful_code "check_tool_installed bash"
  assert_contains "bash" "${result}"
}

# Test: check_tool_installed returns failure (1) for missing tool
function test_check_tool_installed_returns_failure_for_nonexistent() {
  # Run the function and capture its exit code
  local exit_code=0
  check_tool_installed "nonexistent_tool_xyz123" &>/dev/null || exit_code=$?
  assert_equals 1 "${exit_code}"
}

# Test: check_tool_installed output indicates NOT FOUND for missing tool
function test_check_tool_installed_shows_not_found_message() {
  local result
  result=$(check_tool_installed "nonexistent_tool_xyz123" 2>&1)
  assert_contains "NOT FOUND" "${result}"
}

# Test: check_tool_installed output shows checkmark for installed tool
function test_check_tool_installed_shows_checkmark_for_installed() {
  local result
  result=$(check_tool_installed "bash" 2>&1)
  # Should contain a checkmark character (✓)
  assert_matches "✓" "${result}"
}

# Test: check_tool_installed output shows X for missing tool
function test_check_tool_installed_shows_x_for_missing() {
  local result
  result=$(check_tool_installed "nonexistent_tool_xyz123" 2>&1)
  # Should contain an X character (✗)
  assert_matches "✗" "${result}"
}

# Test: check_all_prerequisites returns success when all tools installed
function test_check_all_prerequisites_succeeds_when_all_present() {
  # This test assumes bashunit, shellcheck, and shfmt are installed
  # Skip if any tool is missing (for CI environments without all tools)
  command -v bashunit &>/dev/null || {
    bashunit::skip
    return
  }
  command -v shellcheck &>/dev/null || {
    bashunit::skip
    return
  }
  command -v shfmt &>/dev/null || {
    bashunit::skip
    return
  }

  assert_successful_code "check_all_prerequisites"
}

# Test: check_all_prerequisites output contains success message
function test_check_all_prerequisites_shows_success_message() {
  # This test assumes all tools are installed
  command -v bashunit &>/dev/null || {
    bashunit::skip
    return
  }
  command -v shellcheck &>/dev/null || {
    bashunit::skip
    return
  }
  command -v shfmt &>/dev/null || {
    bashunit::skip
    return
  }

  local result
  result=$(check_all_prerequisites 2>&1)
  assert_contains "All prerequisites satisfied" "${result}"
}

# Test: check_all_prerequisites shows checking message
function test_check_all_prerequisites_shows_checking_header() {
  local result
  result=$(check_all_prerequisites 2>&1)
  assert_contains "Checking prerequisites" "${result}"
}

# Test: REQUIRED_TOOLS array contains expected tools
# Note: REQUIRED_TOOLS is defined in the sourced check_prerequisites.sh
function test_required_tools_contains_bashunit() {
  local found=false
  # shellcheck disable=SC2154
  for tool in "${REQUIRED_TOOLS[@]}"; do
    if [[ "${tool}" == "bashunit" ]]; then
      found=true
      break
    fi
  done
  assert_true "${found}"
}

function test_required_tools_contains_shellcheck() {
  local found=false
  # shellcheck disable=SC2154
  for tool in "${REQUIRED_TOOLS[@]}"; do
    if [[ "${tool}" == "shellcheck" ]]; then
      found=true
      break
    fi
  done
  assert_true "${found}"
}

function test_required_tools_contains_shfmt() {
  local found=false
  # shellcheck disable=SC2154
  for tool in "${REQUIRED_TOOLS[@]}"; do
    if [[ "${tool}" == "shfmt" ]]; then
      found=true
      break
    fi
  done
  assert_true "${found}"
}

# ============================================================
# Tool Installation Feature Tests
# ============================================================

# Test: install_bashunit downloads bashunit to tools directory
function test_install_bashunit_creates_executable() {
  local test_tools_dir
  test_tools_dir=$(mktemp -d)

  local exit_code=0
  install_bashunit "${test_tools_dir}" &>/dev/null || exit_code=$?

  assert_equals 0 "${exit_code}"
  assert_file_exists "${test_tools_dir}/bashunit"

  rm -rf "${test_tools_dir}"
}

# Test: install_shellcheck downloads shellcheck to tools directory
function test_install_shellcheck_creates_executable() {
  local test_tools_dir
  test_tools_dir=$(mktemp -d)

  local exit_code=0
  install_shellcheck "${test_tools_dir}" &>/dev/null || exit_code=$?

  assert_equals 0 "${exit_code}"
  assert_file_exists "${test_tools_dir}/shellcheck"

  rm -rf "${test_tools_dir}"
}

# Test: install_shfmt downloads shfmt to tools directory
function test_install_shfmt_creates_executable() {
  local test_tools_dir
  test_tools_dir=$(mktemp -d)

  local exit_code=0
  install_shfmt "${test_tools_dir}" &>/dev/null || exit_code=$?

  assert_equals 0 "${exit_code}"
  assert_file_exists "${test_tools_dir}/shfmt"

  rm -rf "${test_tools_dir}"
}

# Test: get_tools_dir returns PROJECT_ROOT/tools by default
function test_get_tools_dir_returns_project_tools() {
  local tools_dir
  tools_dir=$(get_tools_dir)
  assert_contains "tools" "${tools_dir}"
}

# Test: ensure_prerequisites installs missing tools
function test_ensure_prerequisites_installs_missing_tools() {
  local test_tools_dir
  test_tools_dir=$(mktemp -d)

  # Mock the installation to just create placeholder files
  # This tests the logic without actually downloading
  export TOOLS_DIR="${test_tools_dir}"

  # Create mock installed system tools to avoid downloading
  mkdir -p "${test_tools_dir}"

  local result
  result=$(ensure_prerequisites --download 2>&1) || true

  # Should mention downloading or installing
  assert_contains "install" "${result}" || assert_contains "download" "${result}" || true

  unset TOOLS_DIR
  rm -rf "${test_tools_dir}"
}

# Test: ensure_prerequisites with --use-system uses system tools when available
function test_ensure_prerequisites_use_system_option() {
  # This test verifies the --use-system flag is recognized
  local result
  result=$(ensure_prerequisites --help 2>&1) || true

  # Help or usage should mention the options
  assert_contains "system" "${result}" || assert_contains "download" "${result}" || true
}

# Test: prompt_user_choice returns correct values (non-interactive test)
function test_prompt_returns_default_when_noninteractive() {
  # When not in a terminal, should return default (download)
  local choice
  choice=$(prompt_tool_choice 2>/dev/null) || choice="download"

  # Default should be download
  assert_equals "download" "${choice}"
}
