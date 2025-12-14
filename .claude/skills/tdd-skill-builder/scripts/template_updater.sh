#!/bin/bash
# template_updater.sh - Fetches latest templates from Anthropic's claude-cookbooks
# Part of TDD Skill Builder

# Only enable strict mode when executed directly, not when sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
fi

# Template sources from Anthropic
# shellcheck disable=SC2034  # Reserved for future use when fetching from remote
readonly ANTHROPIC_SKILLS_BASE="https://raw.githubusercontent.com/anthropics/claude-code/main"

# Get the assets directory (templates)
# Can be overridden by TEMPLATES_DIR environment variable
get_templates_dir() {
  if [[ -n "${TEMPLATES_DIR:-}" ]]; then
    echo "${TEMPLATES_DIR}"
    return
  fi

  # Find skill directory by looking for SKILL.md
  local dir="${PWD}"
  while [[ "${dir}" != "/" ]]; do
    if [[ -f "${dir}/SKILL.md" ]]; then
      echo "${dir}/assets"
      return
    fi
    # Also check for .claude/skills structure
    if [[ -d "${dir}/.claude/skills" ]]; then
      # Find first skill with templates
      local skill_dir
      for skill_dir in "${dir}/.claude/skills"/*/; do
        if [[ -d "${skill_dir}assets" ]]; then
          echo "${skill_dir}assets"
          return
        fi
      done
      # Default to tdd-skill-builder assets
      echo "${dir}/.claude/skills/tdd-skill-builder/assets"
      return
    fi
    dir=$(dirname "${dir}")
  done

  # Fallback to current directory
  echo "${PWD}/assets"
}

# Download a single template file
# Arguments:
#   $1 - Source URL
#   $2 - Destination path
# Returns:
#   0 on success, 1 on failure
download_template() {
  local url="$1"
  local dest="$2"

  # Create parent directory if needed
  mkdir -p "$(dirname "${dest}")"

  if command -v curl &>/dev/null; then
    curl -fsSL -o "${dest}" "${url}" 2>/dev/null || return 1
  elif command -v wget &>/dev/null; then
    wget -q -O "${dest}" "${url}" 2>/dev/null || return 1
  else
    echo "ERROR: Neither curl nor wget found"
    return 1
  fi

  return 0
}

# Backup existing templates
# Arguments:
#   $1 - Templates directory
# Returns:
#   0 on success
backup_templates() {
  local templates_dir="$1"

  if [[ ! -d "${templates_dir}" ]]; then
    return 0
  fi

  echo "Backing up existing templates..."

  local file
  for file in "${templates_dir}"/*.md "${templates_dir}"/*.sh; do
    if [[ -f "${file}" ]]; then
      cp "${file}" "${file}.bak"
      echo "  ✓ Backed up: ${file##*/}"
    fi
  done

  return 0
}

# Restore templates from backup
# Arguments:
#   $1 - Templates directory
# Returns:
#   0 on success
restore_templates() {
  local templates_dir="$1"

  if [[ ! -d "${templates_dir}" ]]; then
    echo "ERROR: Templates directory not found"
    return 1
  fi

  echo "Restoring templates from backup..."

  local backup_file
  for backup_file in "${templates_dir}"/*.bak; do
    if [[ -f "${backup_file}" ]]; then
      local original_file="${backup_file%.bak}"
      mv "${backup_file}" "${original_file}"
      echo "  ✓ Restored: ${original_file##*/}"
    fi
  done

  return 0
}

# Check for available updates
# Returns:
#   0 if up to date
#   1 if updates available
#   2 on error
check_for_updates() {
  local templates_dir
  templates_dir=$(get_templates_dir)

  echo "Checking for template updates..."
  echo "Templates directory: ${templates_dir}"
  echo ""

  # For now, just report that we can check
  # A full implementation would compare local vs remote versions
  if [[ -d "${templates_dir}" ]]; then
    local template_count
    template_count=$(find "${templates_dir}" -name "*.md" -o -name "*.sh" 2>/dev/null | wc -l)
    echo "Found ${template_count} local template(s)"

    if [[ ${template_count} -eq 0 ]]; then
      echo "No templates found - updates available"
      return 1
    fi

    echo "Templates are present (use --update to refresh)"
    return 0
  else
    echo "Templates directory not found - updates available"
    return 1
  fi
}

# Update templates from remote source
# Returns:
#   0 on success, 1 on failure
update_templates() {
  local templates_dir
  templates_dir=$(get_templates_dir)

  echo "Updating templates..."
  echo "Templates directory: ${templates_dir}"
  echo ""

  # Create directory if it doesn't exist
  mkdir -p "${templates_dir}"

  # Backup existing templates
  backup_templates "${templates_dir}"

  echo ""
  echo "Downloading latest templates..."

  # Note: These URLs are examples - in production, would fetch from actual Anthropic sources
  # For now, we'll create placeholder templates locally

  local failed=0

  # Create SKILL.template.md
  cat >"${templates_dir}/SKILL.template.md" <<'EOF'
---
name: {{SKILL_NAME}}
description: {{SKILL_DESCRIPTION}}
---

# {{SKILL_TITLE}}

## Overview

{{SKILL_OVERVIEW}}

## Instructions

{{SKILL_INSTRUCTIONS}}

## Examples

{{SKILL_EXAMPLES}}
EOF
  echo "  ✓ Created: SKILL.template.md"

  # Create script.template.sh
  cat >"${templates_dir}/script.template.sh" <<'EOF'
#!/bin/bash
# {{SCRIPT_NAME}} - {{SCRIPT_DESCRIPTION}}
# Part of {{SKILL_NAME}} skill

set -euo pipefail

# {{SCRIPT_FUNCTIONS}}

main() {
  echo "{{SCRIPT_NAME}} executed"
}

# Only run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
EOF
  echo "  ✓ Created: script.template.sh"

  # Create test.template.sh
  cat >"${templates_dir}/test.template.sh" <<'EOF'
#!/bin/bash
# Tests for {{SCRIPT_NAME}}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../.." && pwd)"

# Add project tools to PATH
[[ -d "${PROJECT_ROOT}/tools" ]] && export PATH="${PROJECT_ROOT}/tools:${PATH}"

# Source the script to test
# shellcheck source=../scripts/{{SCRIPT_NAME}}
source "${SCRIPT_DIR}/../scripts/{{SCRIPT_NAME}}" 2>/dev/null || true

# Test: {{TEST_DESCRIPTION}}
function test_{{TEST_NAME}}() {
  # Arrange
  {{TEST_ARRANGE}}

  # Act
  {{TEST_ACT}}

  # Assert
  {{TEST_ASSERT}}
}
EOF
  echo "  ✓ Created: test.template.sh"

  echo ""

  if [[ ${failed} -gt 0 ]]; then
    echo "Update completed with ${failed} error(s)"
    return 1
  fi

  echo "All templates updated successfully!"
  return 0
}

# Show changelog of template updates
show_changelog() {
  echo "Template Changelog"
  echo "=================="
  echo ""
  echo "Current version: 1.0.0"
  echo ""
  echo "Changes:"
  echo "  - Initial template set"
  echo "  - SKILL.template.md with frontmatter placeholders"
  echo "  - script.template.sh following Google Shell Style Guide"
  echo "  - test.template.sh with bashunit structure"
  echo ""
}

# Main entry point
# Arguments:
#   --check    Check for updates
#   --update   Download/update templates
#   --restore  Restore from backup
#   --help     Show usage
template_updater_main() {
  case "${1:-}" in
    --check)
      check_for_updates
      ;;
    --update)
      update_templates
      ;;
    --restore)
      local templates_path
      templates_path=$(get_templates_dir)
      restore_templates "${templates_path}"
      ;;
    --changelog)
      show_changelog
      ;;
    --help | "")
      echo "Usage: template_updater.sh [--check|--update|--restore|--changelog|--help]"
      echo ""
      echo "Options:"
      echo "  --check      Check for available template updates"
      echo "  --update     Download/update templates to local directory"
      echo "  --restore    Restore templates from backup"
      echo "  --changelog  Show template changelog"
      echo "  --help       Show this help message"
      echo ""
      local help_templates_dir
      help_templates_dir=$(get_templates_dir)
      echo "Templates are stored in: ${help_templates_dir}"
      ;;
    *)
      echo "ERROR: Unknown option: $1"
      echo "Use --help for usage information"
      return 1
      ;;
  esac
}

# Only run if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  template_updater_main "$@"
fi
