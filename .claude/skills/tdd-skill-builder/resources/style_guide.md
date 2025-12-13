# TDD Style Guide for Bash Scripts

> **References:**
> - Google Shell Style Guide: https://google.github.io/styleguide/shellguide.html
> - bashunit docs: https://bashunit.typeddevs.com/
> - Comprehensive guide: [bash-testing-guide.md](bash-testing-guide.md)

## Test File Naming

```
tests/<script_name>_test.sh
```

Example: `scripts/my_feature.sh` → `tests/my_feature_test.sh`

## Test Function Naming

```bash
function test_<function_name>_<expected_behavior>() {
  # ...
}
```

Examples:
- `test_validate_returns_error_on_missing_file`
- `test_get_name_extracts_from_frontmatter`

## Arrange-Act-Assert Pattern

```bash
function test_example() {
  # Arrange - Set up test data
  local input="test value"

  # Act - Call the function
  local result
  result=$(my_function "${input}")

  # Assert - Verify the result
  assert_equals "expected" "${result}"
}
```

## Testing Exit Codes

```bash
function test_function_returns_error() {
  local exit_code=0
  my_function "bad input" &>/dev/null || exit_code=$?
  assert_equals 1 "${exit_code}"
}
```

## Common bashunit Assertions

| Assertion | Description |
|-----------|-------------|
| `assert_equals "expected" "actual"` | Exact match |
| `assert_not_equals "a" "b"` | Not equal |
| `assert_contains "needle" "haystack"` | Substring match |
| `assert_contains_ignore_case "needle" "haystack"` | Case-insensitive |
| `assert_empty "${var}"` | Variable is empty |
| `assert_not_empty "${var}"` | Variable has value |
| `assert_file_exists "path"` | File exists |
| `assert_directory_exists "path"` | Directory exists |

## Code Quality Commands

```bash
# Static analysis
./tools/shellcheck scripts/my_feature.sh

# Formatting check (shows diff)
./tools/shfmt -d -i 2 -ci scripts/my_feature.sh

# Auto-format
./tools/shfmt -w -i 2 -ci scripts/my_feature.sh
```

## Script Template

```bash
#!/bin/bash
# script_name.sh - Description

# Only enable strict mode when executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
fi

my_function() {
  local arg="$1"
  # Implementation
}

main() {
  my_function "$@"
}

# Only run if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
```

## Test Template

```bash
#!/bin/bash
# Tests for script_name.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../../../.." && pwd)"

# Add project tools to PATH
[[ -d "${PROJECT_ROOT}/tools" ]] && export PATH="${PROJECT_ROOT}/tools:${PATH}"

# Source the script to test
source "${SCRIPT_DIR}/../scripts/script_name.sh" 2>/dev/null || true

function test_my_function_does_something() {
  # Arrange
  local input="test"

  # Act
  local result
  result=$(my_function "${input}")

  # Assert
  assert_equals "expected" "${result}"
}
```
