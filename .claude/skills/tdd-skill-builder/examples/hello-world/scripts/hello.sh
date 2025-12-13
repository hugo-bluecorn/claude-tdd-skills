#!/bin/bash
# hello.sh - Simple greeting script
# Part of hello-world example skill

# Only enable strict mode when executed directly, not when sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
fi

# Output a greeting
# Arguments:
#   $1 - Name to greet (optional, defaults to "World")
# Output:
#   Greeting message to stdout
say_hello() {
  local name="${1:-World}"
  echo "Hello, ${name}!"
}

main() {
  say_hello "$@"
}

# Only run if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
