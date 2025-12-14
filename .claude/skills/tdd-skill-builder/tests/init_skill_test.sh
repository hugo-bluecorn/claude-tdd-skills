#!/bin/bash
# Tests for init_skill.sh - Initialize new skills with TDD structure
# TDD RED phase: Tests are written BEFORE implementation

# Get the directory of this test file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../.." && pwd)"
SCRIPT_PATH="${SCRIPT_DIR}/../scripts/init_skill.sh"

# Add project tools to PATH
[[ -d "${PROJECT_ROOT}/tools" ]] && export PATH="${PROJECT_ROOT}/tools:${PATH}"

# Source the skill_validator for validate_skill_name function
# shellcheck source=../scripts/skill_validator.sh
source "${SCRIPT_DIR}/../scripts/skill_validator.sh" 2>/dev/null || true

# ============================================================
# Cycle 1: Basic Script Structure Tests
# ============================================================

# Test 1: Script exists
function test_init_skill_script_exists() {
  assert_file_exists "${SCRIPT_PATH}"
}

# Test 2: Script is executable
function test_init_skill_script_is_executable() {
  [[ -x "${SCRIPT_PATH}" ]]
  assert_equals "0" "$?"
}

# Test 3: Script has bash shebang
function test_init_skill_script_has_shebang() {
  local first_line
  first_line=$(head -n 1 "${SCRIPT_PATH}")
  assert_equals "#!/bin/bash" "${first_line}"
}

# Test 4: Script requires skill name argument
function test_init_skill_requires_skill_name() {
  local output exit_code
  output=$("${SCRIPT_PATH}" 2>&1) || exit_code=$?
  assert_equals "1" "${exit_code}"
  assert_contains "skill name" "${output}"
}

# Test 5: Script requires --path argument
function test_init_skill_requires_path_argument() {
  local output exit_code
  output=$("${SCRIPT_PATH}" "my-skill" 2>&1) || exit_code=$?
  assert_equals "1" "${exit_code}"
  assert_contains "--path" "${output}"
}

# Test 6: Script validates skill name format
function test_init_skill_validates_skill_name_format() {
  local output exit_code
  output=$("${SCRIPT_PATH}" "Invalid Name!" --path /tmp 2>&1) || exit_code=$?
  assert_equals "1" "${exit_code}"
  assert_contains "invalid" "${output}"
}

# Test 7: Script accepts valid skill name
function test_init_skill_accepts_valid_skill_name() {
  local tmp_dir output exit_code
  tmp_dir=$(mktemp -d)
  output=$("${SCRIPT_PATH}" "my-valid-skill" --path "${tmp_dir}" 2>&1) || exit_code=$?
  assert_equals "0" "${exit_code:-0}"
  rm -rf "${tmp_dir}"
}

# ============================================================
# Cycle 2: Directory Creation Tests
# ============================================================

# Test 8: Creates skill-name directory
function test_init_skill_creates_skill_directory() {
  local tmp_dir
  tmp_dir=$(mktemp -d)
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" >/dev/null 2>&1
  assert_directory_exists "${tmp_dir}/test-skill"
  rm -rf "${tmp_dir}"
}

# Test 9: Creates scripts/ subdirectory
function test_init_skill_creates_scripts_directory() {
  local tmp_dir
  tmp_dir=$(mktemp -d)
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" >/dev/null 2>&1
  assert_directory_exists "${tmp_dir}/test-skill/scripts"
  rm -rf "${tmp_dir}"
}

# Test 10: Creates tests/ subdirectory
function test_init_skill_creates_tests_directory() {
  local tmp_dir
  tmp_dir=$(mktemp -d)
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" >/dev/null 2>&1
  assert_directory_exists "${tmp_dir}/test-skill/tests"
  rm -rf "${tmp_dir}"
}

# Test 11: Creates references/ subdirectory
function test_init_skill_creates_references_directory() {
  local tmp_dir
  tmp_dir=$(mktemp -d)
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" >/dev/null 2>&1
  assert_directory_exists "${tmp_dir}/test-skill/references"
  rm -rf "${tmp_dir}"
}

# Test 12: Creates assets/ subdirectory
function test_init_skill_creates_assets_directory() {
  local tmp_dir
  tmp_dir=$(mktemp -d)
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" >/dev/null 2>&1
  assert_directory_exists "${tmp_dir}/test-skill/assets"
  rm -rf "${tmp_dir}"
}

# ============================================================
# Cycle 3: File Generation Tests
# ============================================================

# Test 13: Creates SKILL.md file
function test_init_skill_creates_skill_md() {
  local tmp_dir
  tmp_dir=$(mktemp -d)
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" >/dev/null 2>&1
  assert_file_exists "${tmp_dir}/test-skill/SKILL.md"
  rm -rf "${tmp_dir}"
}

# Test 14: SKILL.md has valid frontmatter
function test_init_skill_md_has_frontmatter() {
  local tmp_dir content
  tmp_dir=$(mktemp -d)
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" >/dev/null 2>&1
  content=$(cat "${tmp_dir}/test-skill/SKILL.md")
  assert_contains "---" "${content}"
  assert_contains "name:" "${content}"
  assert_contains "description:" "${content}"
  rm -rf "${tmp_dir}"
}

# Test 15: SKILL.md contains skill name
function test_init_skill_md_contains_skill_name() {
  local tmp_dir content
  tmp_dir=$(mktemp -d)
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" >/dev/null 2>&1
  content=$(cat "${tmp_dir}/test-skill/SKILL.md")
  assert_contains "test-skill" "${content}"
  rm -rf "${tmp_dir}"
}

# Test 16: SKILL.md uses custom description when provided
function test_init_skill_md_uses_custom_description() {
  local tmp_dir content
  tmp_dir=$(mktemp -d)
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" --description "My custom description" >/dev/null 2>&1
  content=$(cat "${tmp_dir}/test-skill/SKILL.md")
  assert_contains "My custom description" "${content}"
  rm -rf "${tmp_dir}"
}

# Test 17: SKILL.md references official docs
function test_init_skill_md_references_official_docs() {
  local tmp_dir content
  tmp_dir=$(mktemp -d)
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" >/dev/null 2>&1
  content=$(cat "${tmp_dir}/test-skill/SKILL.md")
  assert_contains "code.claude.com" "${content}"
  rm -rf "${tmp_dir}"
}

# ============================================================
# Cycle 4: Path Handling Tests
# ============================================================

# Test 18: Works with absolute paths
function test_init_skill_works_with_absolute_path() {
  local tmp_dir
  tmp_dir=$(mktemp -d)
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" >/dev/null 2>&1
  assert_file_exists "${tmp_dir}/test-skill/SKILL.md"
  rm -rf "${tmp_dir}"
}

# Test 19: Works with relative paths
function test_init_skill_works_with_relative_path() {
  local tmp_dir original_dir
  tmp_dir=$(mktemp -d)
  original_dir=$(pwd)
  cd "${tmp_dir}" || return 1
  "${SCRIPT_PATH}" "test-skill" --path "./" >/dev/null 2>&1
  assert_file_exists "${tmp_dir}/test-skill/SKILL.md"
  cd "${original_dir}" || return 1
  rm -rf "${tmp_dir}"
}

# ============================================================
# Cycle 5: Error Handling Tests
# ============================================================

# Test 20: Refuses to overwrite existing skill directory
function test_init_skill_refuses_overwrite() {
  local tmp_dir output exit_code
  tmp_dir=$(mktemp -d)
  # Create skill first time
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" >/dev/null 2>&1
  # Try to create again - should fail
  output=$("${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" 2>&1) || exit_code=$?
  assert_equals "1" "${exit_code}"
  assert_contains "already exists" "${output}"
  rm -rf "${tmp_dir}"
}

# Test 21: Shows help with --help flag
function test_init_skill_shows_help() {
  local output
  output=$("${SCRIPT_PATH}" --help 2>&1)
  assert_contains "Usage:" "${output}"
  assert_contains "--path" "${output}"
  assert_contains "--description" "${output}"
}

# Test 22: Created skill passes validator
function test_init_skill_created_skill_passes_validator() {
  local tmp_dir exit_code
  tmp_dir=$(mktemp -d)
  "${SCRIPT_PATH}" "test-skill" --path "${tmp_dir}" >/dev/null 2>&1
  # Run validator on created skill
  "${SCRIPT_DIR}/../scripts/skill_validator.sh" "${tmp_dir}/test-skill" >/dev/null 2>&1 || exit_code=$?
  assert_equals "0" "${exit_code:-0}"
  rm -rf "${tmp_dir}"
}
