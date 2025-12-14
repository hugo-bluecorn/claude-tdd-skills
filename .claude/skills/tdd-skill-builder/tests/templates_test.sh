#!/bin/bash
# Tests for asset files (templates)
# TDD RED phase: These tests are written BEFORE implementation

# Get the directory of this test file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../.." && pwd)"
TEMPLATES_DIR="${SCRIPT_DIR}/../assets"

# Add project tools to PATH
[[ -d "${PROJECT_ROOT}/tools" ]] && export PATH="${PROJECT_ROOT}/tools:${PATH}"

# ============================================================
# SKILL.template.md Tests
# ============================================================

# Test: SKILL.template.md exists
function test_skill_template_exists() {
  assert_file_exists "${TEMPLATES_DIR}/SKILL.template.md"
}

# Test: SKILL.template.md has frontmatter
function test_skill_template_has_frontmatter() {
  local first_line
  first_line=$(head -n 1 "${TEMPLATES_DIR}/SKILL.template.md")
  assert_equals "---" "${first_line}"
}

# Test: SKILL.template.md has name placeholder
function test_skill_template_has_name_placeholder() {
  local content
  content=$(cat "${TEMPLATES_DIR}/SKILL.template.md")
  assert_contains "{{SKILL_NAME}}" "${content}"
}

# Test: SKILL.template.md has description placeholder
function test_skill_template_has_description_placeholder() {
  local content
  content=$(cat "${TEMPLATES_DIR}/SKILL.template.md")
  assert_contains "{{SKILL_DESCRIPTION}}" "${content}"
}

# Test: SKILL.template.md references official docs
function test_skill_template_references_official_docs() {
  local content
  content=$(cat "${TEMPLATES_DIR}/SKILL.template.md")
  assert_contains "code.claude.com" "${content}"
}

# ============================================================
# script.template.sh Tests
# ============================================================

# Test: script.template.sh exists
function test_script_template_exists() {
  assert_file_exists "${TEMPLATES_DIR}/script.template.sh"
}

# Test: script.template.sh has shebang
function test_script_template_has_shebang() {
  local first_line
  first_line=$(head -n 1 "${TEMPLATES_DIR}/script.template.sh")
  assert_equals "#!/bin/bash" "${first_line}"
}

# Test: script.template.sh has conditional strict mode
function test_script_template_has_conditional_strict_mode() {
  local content
  content=$(cat "${TEMPLATES_DIR}/script.template.sh")
  assert_contains 'BASH_SOURCE[0]' "${content}"
  assert_contains "set -euo pipefail" "${content}"
}

# Test: script.template.sh has main function pattern
function test_script_template_has_main_function() {
  local content
  content=$(cat "${TEMPLATES_DIR}/script.template.sh")
  assert_contains "main()" "${content}"
}

# Test: script.template.sh passes shellcheck
function test_script_template_passes_shellcheck() {
  # Replace placeholders with valid content for shellcheck
  local temp_file
  temp_file=$(mktemp)
  sed 's/{{[^}]*}}//g' "${TEMPLATES_DIR}/script.template.sh" >"${temp_file}"

  local exit_code=0
  shellcheck "${temp_file}" &>/dev/null || exit_code=$?

  rm -f "${temp_file}"
  assert_equals 0 "${exit_code}"
}

# ============================================================
# test.template.sh Tests
# ============================================================

# Test: test.template.sh exists
function test_test_template_exists() {
  assert_file_exists "${TEMPLATES_DIR}/test.template.sh"
}

# Test: test.template.sh has shebang
function test_test_template_has_shebang() {
  local first_line
  first_line=$(head -n 1 "${TEMPLATES_DIR}/test.template.sh")
  assert_equals "#!/bin/bash" "${first_line}"
}

# Test: test.template.sh has bashunit docs reference
function test_test_template_references_bashunit_docs() {
  local content
  content=$(cat "${TEMPLATES_DIR}/test.template.sh")
  assert_contains "bashunit.typeddevs.com" "${content}"
}

# Test: test.template.sh has test function pattern
function test_test_template_has_test_function_pattern() {
  local content
  content=$(cat "${TEMPLATES_DIR}/test.template.sh")
  assert_contains "function test_" "${content}"
}

# Test: test.template.sh has Arrange-Act-Assert pattern
function test_test_template_has_aaa_pattern() {
  local content
  content=$(cat "${TEMPLATES_DIR}/test.template.sh")
  assert_contains "# Arrange" "${content}"
  assert_contains "# Act" "${content}"
  assert_contains "# Assert" "${content}"
}

# Test: test.template.sh sources script under test
function test_test_template_sources_script() {
  local content
  content=$(cat "${TEMPLATES_DIR}/test.template.sh")
  assert_contains "source" "${content}"
  assert_contains "../scripts/" "${content}"
}

# Test: test.template.sh adds tools to PATH
function test_test_template_adds_tools_to_path() {
  local content
  content=$(cat "${TEMPLATES_DIR}/test.template.sh")
  assert_contains "PROJECT_ROOT" "${content}"
  assert_contains "tools" "${content}"
  assert_contains "PATH" "${content}"
}
