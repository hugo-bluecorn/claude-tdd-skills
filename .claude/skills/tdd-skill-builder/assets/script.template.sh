#!/bin/bash
# {{SCRIPT_NAME}} - {{SCRIPT_DESCRIPTION}}
# Part of {{SKILL_NAME}} skill
#
# Official skill docs: https://code.claude.com/docs/en/skills

# Only enable strict mode when executed directly, not when sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
fi

# {{SCRIPT_FUNCTIONS}}

# Main function when run directly
main() {
  echo "{{SCRIPT_NAME}} executed"
}

# Only run if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
