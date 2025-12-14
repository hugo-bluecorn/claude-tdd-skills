#!/bin/bash
# Tests for skill_validator.sh
# TDD RED phase: These tests are written BEFORE implementation

# Get the directory of this test file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../.." && pwd)"

# Add project tools to PATH
[[ -d "${PROJECT_ROOT}/tools" ]] && export PATH="${PROJECT_ROOT}/tools:${PATH}"

# Source the script to test
# shellcheck source=../scripts/skill_validator.sh
source "${SCRIPT_DIR}/../scripts/skill_validator.sh" 2>/dev/null || true

# Helper function to create a temporary skill directory
create_temp_skill_dir() {
  mktemp -d
}

# ============================================================
# validate_skill_structure Tests
# ============================================================

# Test: validate_skill_structure fails when SKILL.md is missing
function test_fails_when_skill_md_missing() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  # No SKILL.md file - should fail
  local exit_code=0
  validate_skill_structure "${skill_dir}" &>/dev/null || exit_code=$?
  assert_equals 1 "${exit_code}"

  rm -rf "${skill_dir}"
}

# Test: validate_skill_structure fails when name field is missing
function test_fails_when_name_field_missing() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
---
description: Test skill description
---
# Test Skill
EOF

  local exit_code=0
  validate_skill_structure "${skill_dir}" &>/dev/null || exit_code=$?
  assert_equals 1 "${exit_code}"

  rm -rf "${skill_dir}"
}

# Test: validate_skill_structure fails when description field is missing
function test_fails_when_description_field_missing() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
---
name: test-skill
---
# Test Skill
EOF

  local exit_code=0
  validate_skill_structure "${skill_dir}" &>/dev/null || exit_code=$?
  assert_equals 1 "${exit_code}"

  rm -rf "${skill_dir}"
}

# Test: validate_skill_structure passes with valid SKILL.md
function test_passes_with_valid_skill_md() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
---
name: test-skill
description: Test skill description for validation
---
# Test Skill

This is a valid skill.
EOF

  local exit_code=0
  validate_skill_structure "${skill_dir}" &>/dev/null || exit_code=$?
  assert_equals 0 "${exit_code}"

  rm -rf "${skill_dir}"
}

# Test: validate_skill_structure output shows error message for missing SKILL.md
function test_shows_error_for_missing_skill_md() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  local result
  result=$(validate_skill_structure "${skill_dir}" 2>&1) || true
  assert_contains "SKILL.md" "${result}"

  rm -rf "${skill_dir}"
}

# Test: validate_skill_structure output shows error for missing name
function test_shows_error_for_missing_name() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
---
description: Test skill
---
EOF

  local result
  result=$(validate_skill_structure "${skill_dir}" 2>&1) || true
  assert_contains "name" "${result}"

  rm -rf "${skill_dir}"
}

# Test: validate_skill_structure output shows error for missing description
function test_shows_error_for_missing_description() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
---
name: test-skill
---
EOF

  local result
  result=$(validate_skill_structure "${skill_dir}" 2>&1) || true
  assert_contains "description" "${result}"

  rm -rf "${skill_dir}"
}

# Test: validate_skill_structure passes with multi-line description
function test_passes_with_multiline_description() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
---
name: test-skill
description: >-
  This is a multi-line description that spans
  multiple lines using YAML folded style.
---
# Test Skill
EOF

  local exit_code=0
  validate_skill_structure "${skill_dir}" &>/dev/null || exit_code=$?
  assert_equals 0 "${exit_code}"

  rm -rf "${skill_dir}"
}

# Test: validate_skill_structure warns about non-executable scripts
function test_warns_about_nonexecutable_scripts() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
---
name: test-skill
description: Test skill
---
EOF

  mkdir -p "${skill_dir}/scripts"
  echo '#!/bin/bash' >"${skill_dir}/scripts/helper.sh"
  # NOT making it executable - should warn

  local result
  result=$(validate_skill_structure "${skill_dir}" 2>&1) || true

  # Should warn about non-executable scripts
  assert_contains "not executable" "${result}" || assert_contains "warning" "${result}" || assert_contains "chmod" "${result}"

  rm -rf "${skill_dir}"
}

# ============================================================
# get_skill_name Tests
# ============================================================

# Test: get_skill_name extracts name from frontmatter
function test_get_skill_name_extracts_name() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
---
name: my-awesome-skill
description: Test skill
---
EOF

  local name
  name=$(get_skill_name "${skill_dir}/SKILL.md")
  assert_equals "my-awesome-skill" "${name}"

  rm -rf "${skill_dir}"
}

# Test: get_skill_name returns empty for missing name
function test_get_skill_name_returns_empty_when_missing() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
---
description: Test skill
---
EOF

  local name
  name=$(get_skill_name "${skill_dir}/SKILL.md")
  assert_empty "${name}"

  rm -rf "${skill_dir}"
}

# ============================================================
# get_skill_description Tests
# ============================================================

# Test: get_skill_description extracts description from frontmatter
function test_get_skill_description_extracts_description() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
---
name: test-skill
description: This is a test description
---
EOF

  local desc
  desc=$(get_skill_description "${skill_dir}/SKILL.md")
  assert_contains "test description" "${desc}"

  rm -rf "${skill_dir}"
}

# Test: get_skill_description returns empty for missing description
function test_get_skill_description_returns_empty_when_missing() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
---
name: test-skill
---
EOF

  local desc
  desc=$(get_skill_description "${skill_dir}/SKILL.md")
  assert_empty "${desc}"

  rm -rf "${skill_dir}"
}

# ============================================================
# has_frontmatter Tests
# ============================================================

# Test: has_frontmatter returns true for valid frontmatter
function test_has_frontmatter_returns_true_for_valid() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
---
name: test-skill
description: Test
---
# Content
EOF

  local exit_code=0
  has_frontmatter "${skill_dir}/SKILL.md" || exit_code=$?
  assert_equals 0 "${exit_code}"

  rm -rf "${skill_dir}"
}

# Test: has_frontmatter returns false for missing frontmatter
function test_has_frontmatter_returns_false_for_missing() {
  local skill_dir
  skill_dir=$(create_temp_skill_dir)

  cat >"${skill_dir}/SKILL.md" <<'EOF'
# No Frontmatter Here

Just content.
EOF

  local exit_code=0
  has_frontmatter "${skill_dir}/SKILL.md" || exit_code=$?
  assert_equals 1 "${exit_code}"

  rm -rf "${skill_dir}"
}

# ============================================================
# validate_skill_name Tests
# ============================================================

# Test: validate_skill_name accepts valid names
function test_validate_skill_name_accepts_valid() {
  assert_successful_code "validate_skill_name 'my-skill'"
  assert_successful_code "validate_skill_name 'skill123'"
  assert_successful_code "validate_skill_name 'my-awesome-skill'"
}

# Test: validate_skill_name rejects invalid names
function test_validate_skill_name_rejects_invalid() {
  local exit_code=0
  validate_skill_name "My Skill" &>/dev/null || exit_code=$?
  assert_equals 1 "${exit_code}"

  exit_code=0
  validate_skill_name "skill@name" &>/dev/null || exit_code=$?
  assert_equals 1 "${exit_code}"

  exit_code=0
  validate_skill_name "" &>/dev/null || exit_code=$?
  assert_equals 1 "${exit_code}"
}

# ============================================================
# CLI Tests
# ============================================================

# Test: --help flag shows usage and exits successfully
function test_help_flag_shows_usage() {
  local script_path="${SCRIPT_DIR}/../scripts/skill_validator.sh"
  local result
  local exit_code=0

  result=$("${script_path}" --help 2>&1) || exit_code=$?
  assert_equals 0 "${exit_code}"
  assert_contains "Usage:" "${result}"
}

# Test: -h flag shows usage and exits successfully
function test_h_flag_shows_usage() {
  local script_path="${SCRIPT_DIR}/../scripts/skill_validator.sh"
  local result
  local exit_code=0

  result=$("${script_path}" -h 2>&1) || exit_code=$?
  assert_equals 0 "${exit_code}"
  assert_contains "Usage:" "${result}"
}
