#!/bin/bash
# init_skill.sh - Initialize new skills with TDD structure
# Part of TDD Skill Builder
#
# Usage: init_skill.sh <skill-name> --path <directory> [--description "desc"]

# Only enable strict mode when executed directly, not when sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
fi

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source skill_validator for validate_skill_name function
# shellcheck source=skill_validator.sh
source "${SCRIPT_DIR}/skill_validator.sh" 2>/dev/null || true

# Display usage information
show_usage() {
  echo "Usage: init_skill.sh <skill-name> --path <directory> [--description \"desc\"]"
  echo ""
  echo "Arguments:"
  echo "  skill-name    Name for the new skill (lowercase, hyphens allowed)"
  echo "  --path        Directory where skill will be created (required)"
  echo "  --description Optional description for the skill"
  echo ""
  echo "Examples:"
  echo "  init_skill.sh my-skill --path .claude/skills/"
  echo "  init_skill.sh my-skill --path ./ --description \"My awesome skill\""
}

# Parse command line arguments
parse_args() {
  local skill_name=""
  local skill_path=""
  local skill_description=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --path)
        shift
        skill_path="${1:-}"
        ;;
      --description)
        shift
        skill_description="${1:-}"
        ;;
      --help | -h)
        show_usage
        exit 0
        ;;
      -*)
        echo "ERROR: Unknown option: $1"
        show_usage
        exit 1
        ;;
      *)
        if [[ -z "${skill_name}" ]]; then
          skill_name="$1"
        else
          echo "ERROR: Unexpected argument: $1"
          show_usage
          exit 1
        fi
        ;;
    esac
    shift
  done

  # Validate required arguments
  if [[ -z "${skill_name}" ]]; then
    echo "ERROR: skill name is required"
    show_usage
    exit 1
  fi

  if [[ -z "${skill_path}" ]]; then
    echo "ERROR: --path argument is required"
    show_usage
    exit 1
  fi

  # Validate skill name format
  if ! validate_skill_name "${skill_name}"; then
    echo "ERROR: invalid skill name '${skill_name}'"
    echo "Skill names must be lowercase, alphanumeric, with hyphens allowed"
    exit 1
  fi

  # Export parsed values
  SKILL_NAME="${skill_name}"
  SKILL_PATH="${skill_path}"
  SKILL_DESCRIPTION="${skill_description:-${skill_name} skill}"
}

# Create SKILL.md file with frontmatter
# Arguments:
#   $1 - Skill directory path
create_skill_md() {
  local skill_dir="$1"

  cat >"${skill_dir}/SKILL.md" <<EOF
---
name: ${SKILL_NAME}
description: >-
  ${SKILL_DESCRIPTION}
---

# ${SKILL_NAME}

## Overview

${SKILL_DESCRIPTION}

## Instructions

Add your skill instructions here.

## References

- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)
EOF
}

# Main entry point
init_skill_main() {
  parse_args "$@"

  local full_skill_path="${SKILL_PATH}/${SKILL_NAME}"

  # Check if skill already exists
  if [[ -d "${full_skill_path}" ]]; then
    echo "ERROR: Skill directory already exists: ${full_skill_path}"
    exit 1
  fi

  echo "Creating skill: ${SKILL_NAME}"
  echo "Location: ${full_skill_path}"
  echo ""

  # Create skill directory structure
  mkdir -p "${full_skill_path}"
  mkdir -p "${full_skill_path}/scripts"
  mkdir -p "${full_skill_path}/tests"
  mkdir -p "${full_skill_path}/references"
  mkdir -p "${full_skill_path}/assets"

  # Create SKILL.md from template
  create_skill_md "${full_skill_path}"

  echo "Skill '${SKILL_NAME}' created successfully!"
}

# Only run if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  init_skill_main "$@"
fi
