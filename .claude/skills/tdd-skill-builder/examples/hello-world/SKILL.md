---
name: hello-world
description: >-
  Example skill demonstrating TDD workflow with a simple greeting script.
---

# Hello World Example

This is a minimal example skill created using TDD.

## Usage

```bash
./scripts/hello.sh        # Output: Hello, World!
./scripts/hello.sh TDD    # Output: Hello, TDD!
```

## TDD Workflow Used

1. **RED**: Wrote tests in `tests/hello_test.sh` first
2. **GREEN**: Implemented `scripts/hello.sh` to pass tests
3. **REFACTOR**: Validated with shellcheck and shfmt
