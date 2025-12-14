#!/bin/bash
# Tests for {{SCRIPT_NAME}}
# TDD RED phase: Write tests BEFORE implementation
#
# bashunit docs: https://bashunit.typeddevs.com/

# Get the directory of this test file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../.." && pwd)"

# Add project tools to PATH
[[ -d "${PROJECT_ROOT}/tools" ]] && export PATH="${PROJECT_ROOT}/tools:${PATH}"

# Source the script to test
# shellcheck source=../scripts/{{SCRIPT_NAME}}
source "${SCRIPT_DIR}/../scripts/{{SCRIPT_NAME}}" 2>/dev/null || true

# ============================================================
# {{FUNCTION_NAME}} Tests
# ============================================================

# Test: {{TEST_DESCRIPTION}}
function test_{{TEST_NAME}}() {
  # Arrange
  {{TEST_ARRANGE}}

  # Act
  {{TEST_ACT}}

  # Assert
  {{TEST_ASSERT}}
}

# ============================================================
# Additional Test Patterns
# ============================================================

# Pattern: Test exit codes
# function test_function_returns_error_on_invalid_input() {
#   local exit_code=0
#   some_function "invalid" &>/dev/null || exit_code=$?
#   assert_equals 1 "${exit_code}"
# }

# Pattern: Test output contains expected text
# function test_function_shows_message() {
#   local result
#   result=$(some_function 2>&1) || true
#   assert_contains "expected text" "${result}"
# }

# Pattern: Test file creation
# function test_function_creates_file() {
#   local test_dir
#   test_dir=$(mktemp -d)
#   some_function "${test_dir}/output.txt"
#   assert_file_exists "${test_dir}/output.txt"
#   rm -rf "${test_dir}"
# }
