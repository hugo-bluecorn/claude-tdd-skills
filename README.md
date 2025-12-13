# TDD Skill Builder

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A Claude Code Skill that guides development of new Claude Code Skills using Test-Driven Development (TDD).

## Installation

### Workflow 1: Add to Existing Project

Use this when you want to build skills for an existing project.

```bash
# From your project root
cd your-project

# Create skills directory if needed
mkdir -p .claude/skills

# Clone TDD Skill Builder
git clone https://github.com/hugo-bluecorn/claude-tdd-skills.git .claude/skills/tdd-skill-builder

# Install tools
./.claude/skills/tdd-skill-builder/scripts/check_prerequisites.sh --download
```

Your structure:
```
your-project/
├── .claude/skills/
│   ├── tdd-skill-builder/    # Development tool
│   └── my-skill/             # Skills you create (siblings)
├── tools/                    # bashunit, shellcheck, shfmt
└── (your project files)
```

### Workflow 2: Standalone Skill Development

Use this when building a skill intended for sharing/distribution.

```bash
# Create new skill project
mkdir md-to-latex
cd md-to-latex

# Create skills directory
mkdir -p .claude/skills

# Clone TDD Skill Builder
git clone https://github.com/hugo-bluecorn/claude-tdd-skills.git .claude/skills/tdd-skill-builder

# Install tools
./.claude/skills/tdd-skill-builder/scripts/check_prerequisites.sh --download

# Initialize your skill
mkdir -p .claude/skills/md-to-latex/{scripts,tests}
```

Your structure:
```
md-to-latex/
├── .claude/skills/
│   ├── tdd-skill-builder/    # Development tool (not distributed)
│   └── md-to-latex/          # Your skill (this gets shared)
├── tools/                    # bashunit, shellcheck, shfmt
└── README.md
```

To share your skill, users copy only `.claude/skills/md-to-latex/` to their projects.

## Verify Installation

```bash
./tools/bashunit --version
./tools/shellcheck --version
./tools/shfmt --version

# Run TDD Skill Builder tests
./tools/bashunit .claude/skills/tdd-skill-builder/tests/
```

## TDD Workflow

### 1. RED: Write Failing Tests First

```bash
./tools/bashunit .claude/skills/my-skill/tests/my_feature_test.sh  # Should fail
```

### 2. GREEN: Implement Minimum Code to Pass

```bash
./tools/bashunit .claude/skills/my-skill/tests/my_feature_test.sh  # Should pass
```

### 3. REFACTOR: Clean Up

```bash
./tools/shellcheck .claude/skills/my-skill/scripts/my_feature.sh
./tools/shfmt -d -i 2 -ci .claude/skills/my-skill/scripts/my_feature.sh
```

## Project Structure

```
.claude/skills/tdd-skill-builder/
├── SKILL.md              # Skill definition
├── scripts/              # check_prerequisites.sh, skill_validator.sh, template_updater.sh
├── tests/                # bashunit tests
├── templates/            # SKILL.md, script, and test templates
├── resources/            # Style guide, bash testing guide
└── examples/hello-world/ # Example skill
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
- [Style Guide](.claude/skills/tdd-skill-builder/resources/style_guide.md) - TDD patterns
- [Bash Testing Guide](.claude/skills/tdd-skill-builder/resources/bash-testing-guide.md) - Comprehensive bashunit guide

## References

- [Official Claude Code Skills](https://code.claude.com/docs/en/skills)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
