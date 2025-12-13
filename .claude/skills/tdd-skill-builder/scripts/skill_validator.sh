#!/bin/bash
# skill_validator.sh - Validates Claude Code Skill structure and SKILL.md format
# Part of TDD Skill Builder

# Only enable strict mode when executed directly, not when sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
fi

# Check if a file has YAML frontmatter
# Arguments:
#   $1 - Path to file
# Returns:
#   0 if frontmatter exists, 1 if not
has_frontmatter() {
  local file="$1"

  if [[ ! -f "${file}" ]]; then
    return 1
  fi

  # Check if file starts with ---
  local first_line
  first_line=$(head -n 1 "${file}")
  if [[ "${first_line}" != "---" ]]; then
    return 1
  fi

  # Check if there's a closing ---
  if ! grep -n "^---$" "${file}" | tail -n +2 | head -n 1 &>/dev/null; then
    return 1
  fi

  return 0
}

# Extract the name field from SKILL.md frontmatter
# Arguments:
#   $1 - Path to SKILL.md file
# Output:
#   The name value, or empty if not found
get_skill_name() {
  local file="$1"

  if [[ ! -f "${file}" ]]; then
    return
  fi

  # Extract content between first and second ---
  local frontmatter
  frontmatter=$(sed -n '/^---$/,/^---$/p' "${file}" | sed '1d;$d')

  # Find name field
  echo "${frontmatter}" | grep "^name:" | sed 's/^name:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

# Extract the description field from SKILL.md frontmatter
# Arguments:
#   $1 - Path to SKILL.md file
# Output:
#   The description value, or empty if not found
get_skill_description() {
  local file="$1"

  if [[ ! -f "${file}" ]]; then
    return
  fi

  # Extract content between first and second ---
  local frontmatter
  frontmatter=$(sed -n '/^---$/,/^---$/p' "${file}" | sed '1d;$d')

  # Find description field (handles single line)
  local desc
  desc=$(echo "${frontmatter}" | grep "^description:" | sed 's/^description:[[:space:]]*//' | tr -d '"' | tr -d "'")

  # Handle multiline description (>- style)
  if [[ -z "${desc}" ]] || [[ "${desc}" == ">-" ]] || [[ "${desc}" == ">" ]] || [[ "${desc}" == "|" ]]; then
    # Get lines after description: until next field or end
    desc=$(echo "${frontmatter}" | sed -n '/^description:/,/^[a-z-]*:/p' | tail -n +2 | head -n -1 | tr '\n' ' ' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    if [[ -z "${desc}" ]]; then
      # Try getting everything after description: to end of frontmatter
      desc=$(echo "${frontmatter}" | sed -n '/^description:/,$p' | tail -n +2 | tr '\n' ' ' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    fi
  fi

  echo "${desc}"
}

# Validate skill name format
# Arguments:
#   $1 - Skill name to validate
# Returns:
#   0 if valid, 1 if invalid
# Output:
#   Error message if invalid
validate_skill_name() {
  local name="$1"

  # Name cannot be empty
  if [[ -z "${name}" ]]; then
    echo "ERROR: Skill name cannot be empty"
    return 1
  fi

  # Name must be lowercase with hyphens only (no spaces, no special chars)
  if [[ ! "${name}" =~ ^[a-z0-9][a-z0-9-]*[a-z0-9]$ ]] && [[ ! "${name}" =~ ^[a-z0-9]$ ]]; then
    echo "ERROR: Skill name must be lowercase alphanumeric with hyphens (e.g., 'my-skill')"
    return 1
  fi

  return 0
}

# Validate skill directory structure
# Arguments:
#   $1 - Path to skill directory
# Returns:
#   0 if valid, 1 if invalid
# Output:
#   Validation results and any errors/warnings
validate_skill_structure() {
  local skill_dir="$1"
  local errors=0
  local warnings=0

  echo "Validating skill at: ${skill_dir}"
  echo ""

  # Check SKILL.md exists
  if [[ ! -f "${skill_dir}/SKILL.md" ]]; then
    echo "✗ ERROR: SKILL.md not found"
    ((errors++))
    return 1
  fi
  echo "✓ SKILL.md exists"

  # Check frontmatter exists
  if ! has_frontmatter "${skill_dir}/SKILL.md"; then
    echo "✗ ERROR: SKILL.md missing YAML frontmatter (must start with ---)"
    ((errors++))
    return 1
  fi
  echo "✓ SKILL.md has frontmatter"

  # Check name field
  local name
  name=$(get_skill_name "${skill_dir}/SKILL.md")
  if [[ -z "${name}" ]]; then
    echo "✗ ERROR: SKILL.md missing required 'name' field in frontmatter"
    ((errors++))
  else
    echo "✓ name: ${name}"
    # Validate name format
    local name_check
    name_check=$(validate_skill_name "${name}" 2>&1) || {
      echo "✗ ${name_check}"
      ((errors++))
    }
  fi

  # Check description field
  local description
  description=$(get_skill_description "${skill_dir}/SKILL.md")
  if [[ -z "${description}" ]]; then
    echo "✗ ERROR: SKILL.md missing required 'description' field in frontmatter"
    ((errors++))
  else
    echo "✓ description: ${description:0:60}..."
  fi

  # Check scripts directory if it exists
  if [[ -d "${skill_dir}/scripts" ]]; then
    echo ""
    echo "Checking scripts..."
    local script
    for script in "${skill_dir}/scripts"/*.sh; do
      if [[ -f "${script}" ]]; then
        if [[ ! -x "${script}" ]]; then
          echo "⚠ WARNING: ${script##*/} is not executable (run: chmod +x)"
          ((warnings++))
        else
          echo "✓ ${script##*/} is executable"
        fi
      fi
    done
  fi

  echo ""

  # Summary
  if [[ ${errors} -gt 0 ]]; then
    echo "Validation FAILED: ${errors} error(s), ${warnings} warning(s)"
    return 1
  elif [[ ${warnings} -gt 0 ]]; then
    echo "Validation PASSED with ${warnings} warning(s)"
    return 0
  else
    echo "Validation PASSED"
    return 0
  fi
}

# Main function when run directly
main() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: skill_validator.sh <skill_directory>"
    echo ""
    echo "Validates a Claude Code Skill directory structure and SKILL.md format."
    echo ""
    echo "Example:"
    echo "  skill_validator.sh .claude/skills/my-skill"
    return 1
  fi

  validate_skill_structure "$1"
}

# Only run if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
