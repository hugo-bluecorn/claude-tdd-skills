#!/bin/bash
# Tests for hello.sh
# TDD RED phase: Tests for hello-world example skill

# Get the directory of this test file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../../.." && pwd)"

# Add project tools to PATH
[[ -d "${PROJECT_ROOT}/tools" ]] && export PATH="${PROJECT_ROOT}/tools:${PATH}"

# Source the script to test
# shellcheck source=../scripts/hello.sh
source "${SCRIPT_DIR}/../scripts/hello.sh" 2>/dev/null || true

# ============================================================
# say_hello Tests
# ============================================================

# Test: say_hello outputs greeting
function test_say_hello_outputs_greeting() {
  local result
  result=$(say_hello)
  assert_contains "Hello" "${result}"
}

# Test: say_hello accepts name argument
function test_say_hello_with_name() {
  local result
  result=$(say_hello "World")
  assert_contains "World" "${result}"
}

# Test: say_hello with custom name
function test_say_hello_with_custom_name() {
  local result
  result=$(say_hello "TDD")
  assert_equals "Hello, TDD!" "${result}"
}

# ============================================================
# Script Execution Tests
# ============================================================

# Test: hello.sh is executable
function test_hello_script_is_executable() {
  assert_file_exists "${SCRIPT_DIR}/../scripts/hello.sh"
  local script="${SCRIPT_DIR}/../scripts/hello.sh"
  if [[ -x "${script}" ]]; then
    assert_true "true"
  else
    assert_equals "executable" "not executable"
  fi
}
