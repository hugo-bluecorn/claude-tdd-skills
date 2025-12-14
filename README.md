# TDD Skill Builder

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

> *"To build a skill builder, you must first build a skill builder to build the skill builder."*

A Claude Code Skill that guides development of new Claude Code Skills using Test-Driven Development (TDD).

## Table of Contents

- [Platform Compatibility](#platform-compatibility)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Self-Validation](#self-validation)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Platform Compatibility

| Platform | Status | Notes |
|----------|--------|-------|
| **Linux** | ✅ Fully supported | Primary development platform |
| **macOS** | ✅ Fully supported | Requires Bash 4+ (`brew install bash`) |
| **Windows (WSL)** | ✅ Fully supported | [WSL](https://docs.microsoft.com/en-us/windows/wsl/) recommended |
| **Windows (Git Bash)** | ⚠️ Partial | shellcheck requires manual install via [Scoop](https://scoop.sh/) or [Chocolatey](https://chocolatey.org/) |

**Requirements:**
- Bash 4.0+ (for associative arrays and modern features)
- `curl` or `wget` (for tool installation)
- Standard POSIX utilities (`grep`, `sed`, `awk`, `find`)

**Windows Git Bash users:** The auto-installer downloads Linux binaries which won't work. Install tools manually:
```bash
# Using Scoop (recommended)
scoop install shellcheck shfmt

# Or using Chocolatey
choco install shellcheck shfmt
```
bashunit works as-is (pure bash script).

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

# Initialize your skill using init_skill.sh
./.claude/skills/tdd-skill-builder/scripts/init_skill.sh md-to-latex --path .claude/skills/ --description "Converts Markdown to LaTeX"
```

Your structure:
```
md-to-latex/
├── .claude/skills/
│   ├── tdd-skill-builder/    # Development tool (not distributed)
│   └── md-to-latex/          # Your skill (this gets shared)
│       ├── SKILL.md
│       ├── scripts/
│       ├── tests/
│       └── references/
├── tools/                    # bashunit, shellcheck, shfmt
└── README.md
```

To share your skill, users copy only `.claude/skills/md-to-latex/` to their projects.

### Verify Installation

```bash
./tools/bashunit --version
./tools/shellcheck --version
./tools/shfmt --version

# Run TDD Skill Builder tests
./tools/bashunit .claude/skills/tdd-skill-builder/tests/
```

## Usage

### TDD Workflow: Red-Green-Refactor

#### 1. RED: Write Failing Tests First

```bash
./tools/bashunit .claude/skills/my-skill/tests/my_feature_test.sh  # Should fail
```

#### 2. GREEN: Implement Minimum Code to Pass

```bash
./tools/bashunit .claude/skills/my-skill/tests/my_feature_test.sh  # Should pass
```

#### 3. REFACTOR: Clean Up

```bash
./tools/shellcheck .claude/skills/my-skill/scripts/my_feature.sh
./tools/shfmt -d -i 2 -ci .claude/skills/my-skill/scripts/my_feature.sh
```

### Tools

| Tool | Purpose | Documentation |
|------|---------|---------------|
| bashunit | Testing framework for bash | [bashunit.typeddevs.com](https://bashunit.typeddevs.com/) |
| shellcheck | Static analysis for shell scripts | [shellcheck.net](https://www.shellcheck.net/) |
| shfmt | Shell script formatter | [github.com/mvdan/sh](https://github.com/mvdan/sh) |

## Project Structure

```
.claude/skills/tdd-skill-builder/
├── SKILL.md              # Skill definition
├── scripts/              # init_skill.sh, check_prerequisites.sh, skill_validator.sh, template_updater.sh
├── tests/                # bashunit tests
├── assets/               # SKILL.md, script, and test templates
├── references/           # Style guide, bash testing guide, Anthropic compliance
└── examples/hello-world/ # Example skill
```

## Self-Validation

> *"A TDD skill that doesn't TDD itself is just a suggestion."*

This skill validates itself. Run:

```bash
# The skill validates its own structure
./scripts/skill_validator.sh .claude/skills/tdd-skill-builder

# Output:
# ✓ SKILL.md exists
# ✓ SKILL.md has frontmatter
# ✓ name: tdd-skill-builder
# ✓ description: Guides creation of new Claude Code Skills using TDD workflow...
# ✓ All scripts executable
# Validation PASSED
```

The TDD Skill Builder:
- Passes its own `skill_validator.sh`
- Creates the same structure it uses (`scripts/`, `tests/`, `references/`, `assets/`)
- Has 109 tests (107 passing, 2 skipped) covering all functionality

## Documentation

- [Style Guide](.claude/skills/tdd-skill-builder/references/style_guide.md) - TDD patterns
- [Bash Testing Guide](.claude/skills/tdd-skill-builder/references/bash-testing-guide.md) - Comprehensive bashunit guide
- [Anthropic Compliance](.claude/skills/tdd-skill-builder/references/anthropic-compliance.md) - Official skill specification compliance
- [CHANGELOG.md](CHANGELOG.md) - Version history

### References

- [Official Claude Code Skills](https://code.claude.com/docs/en/skills)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
