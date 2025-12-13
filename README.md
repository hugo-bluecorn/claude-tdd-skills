# TDD Skill Builder

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A Claude Code Skill that guides development of new Claude Code Skills using Test-Driven Development (TDD).

## Quick Start

```bash
# Install tools to project directory
./.claude/skills/tdd-skill-builder/scripts/check_prerequisites.sh --download

# Verify installation
./tools/bashunit --version
./tools/shellcheck --version
./tools/shfmt --version

# Run all tests
./tools/bashunit .claude/skills/tdd-skill-builder/tests/
```

## TDD Workflow

### 1. RED: Write Failing Tests First

```bash
# Create test file in your skill's tests/ directory
cat > .claude/skills/my-skill/tests/my_feature_test.sh << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../scripts/my_feature.sh"

function test_my_function_works() {
  local result
  result=$(my_function "input")
  assert_equals "expected" "${result}"
}
EOF

# Run tests - should fail
./tools/bashunit .claude/skills/my-skill/tests/my_feature_test.sh
```

### 2. GREEN: Implement to Pass

```bash
# Create implementation
cat > .claude/skills/my-skill/scripts/my_feature.sh << 'EOF'
#!/bin/bash
my_function() {
  echo "expected"
}
EOF

# Run tests - should pass
./tools/bashunit .claude/skills/my-skill/tests/my_feature_test.sh
```

### 3. REFACTOR: Clean Up

```bash
./tools/shellcheck .claude/skills/my-skill/scripts/my_feature.sh
./tools/shfmt -d -i 2 -ci .claude/skills/my-skill/scripts/my_feature.sh
```

## Project Structure

```
claude-tdd-skills/
├── .claude/
│   ├── skills/tdd-skill-builder/
│   │   ├── SKILL.md              # Skill definition
│   │   ├── scripts/              # Implementation scripts
│   │   ├── tests/                # bashunit tests
│   │   ├── templates/            # Code templates
│   │   ├── resources/            # Style guides
│   │   └── examples/hello-world/ # Example skill
│   └── version-control.md        # Git workflow
├── tools/                        # Local tool binaries (bashunit, shellcheck, shfmt)
├── CLAUDE.md                     # Project memory/directives
├── CHANGELOG.md                  # Version history
├── CONTRIBUTING.md               # Contribution guidelines
├── LICENSE                       # Apache 2.0
└── README.md                     # This file
```

## Tools

| Tool | Purpose | Documentation |
|------|---------|---------------|
| bashunit | Testing framework for bash | [bashunit.typeddevs.com](https://bashunit.typeddevs.com/) |
| shellcheck | Static analysis for shell scripts | [shellcheck.net](https://www.shellcheck.net/) |
| shfmt | Shell script formatter | [github.com/mvdan/sh](https://github.com/mvdan/sh) |

## Documentation

- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [.claude/version-control.md](.claude/version-control.md) - Git workflow
- [Style Guide](.claude/skills/tdd-skill-builder/resources/style_guide.md) - TDD patterns
- [Bash Testing Guide](.claude/skills/tdd-skill-builder/resources/bash-testing-guide.md) - Comprehensive bashunit guide

## References

- [Official Claude Code Skills](https://code.claude.com/docs/en/skills)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Conventional Commits](https://www.conventionalcommits.org/)

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
