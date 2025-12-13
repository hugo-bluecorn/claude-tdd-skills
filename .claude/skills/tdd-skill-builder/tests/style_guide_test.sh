#!/bin/bash
# Tests for resources/style_guide.md
# TDD RED phase: Tests verify style guide meets requirements

# Get the directory of this test file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../.." && pwd)"
STYLE_GUIDE="${SCRIPT_DIR}/../resources/style_guide.md"

# Add project tools to PATH
[[ -d "${PROJECT_ROOT}/tools" ]] && export PATH="${PROJECT_ROOT}/tools:${PATH}"

# ============================================================
# Style Guide Existence Tests
# ============================================================

# Test: style_guide.md exists
function test_style_guide_exists() {
  assert_file_exists "${STYLE_GUIDE}"
}

# ============================================================
# Style Guide Content Tests
# ============================================================

# Test: style_guide.md references Google Shell Style Guide
function test_style_guide_references_google() {
  local content
  content=$(cat "${STYLE_GUIDE}")
  assert_contains "google.github.io/styleguide" "${content}"
}

# Test: style_guide.md references bashunit docs
function test_style_guide_references_bashunit() {
  local content
  content=$(cat "${STYLE_GUIDE}")
  assert_contains "bashunit.typeddevs.com" "${content}"
}

# Test: style_guide.md documents Arrange-Act-Assert pattern
function test_style_guide_has_aaa_pattern() {
  local content
  content=$(cat "${STYLE_GUIDE}")
  assert_contains "Arrange" "${content}"
  assert_contains "Act" "${content}"
  assert_contains "Assert" "${content}"
}

# Test: style_guide.md documents exit code testing
function test_style_guide_has_exit_code_pattern() {
  local content
  content=$(cat "${STYLE_GUIDE}")
  assert_contains "exit_code" "${content}"
}

# Test: style_guide.md documents common assertions
function test_style_guide_has_assertions() {
  local content
  content=$(cat "${STYLE_GUIDE}")
  assert_contains "assert_equals" "${content}"
  assert_contains "assert_contains" "${content}"
  assert_contains "assert_file_exists" "${content}"
}

# Test: style_guide.md documents shellcheck usage
function test_style_guide_has_shellcheck() {
  local content
  content=$(cat "${STYLE_GUIDE}")
  assert_contains "shellcheck" "${content}"
}

# Test: style_guide.md documents shfmt usage
function test_style_guide_has_shfmt() {
  local content
  content=$(cat "${STYLE_GUIDE}")
  assert_contains "shfmt" "${content}"
}

# Test: style_guide.md has test naming conventions
function test_style_guide_has_naming_conventions() {
  local content
  content=$(cat "${STYLE_GUIDE}")
  assert_contains "test_" "${content}"
  assert_contains "_test.sh" "${content}"
}
