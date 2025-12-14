---
name: tdd-skill-builder
description: >-
  Guides creation of new Claude Code Skills using TDD workflow.
  Use when the user wants to create a new skill or build a skill.
---

# TDD Skill Builder

> **Official Skill Specification:** https://code.claude.com/docs/en/skills

## TDD Workflow: Red-Green-Refactor

### 1. RED: Write Failing Tests First

```bash
./tools/bashunit tests/my_feature_test.sh  # Should fail
```

### 2. GREEN: Implement Minimum Code to Pass

```bash
./tools/bashunit tests/my_feature_test.sh  # Should pass
```

### 3. REFACTOR: Clean Up Code

```bash
./tools/shellcheck scripts/my_feature.sh
./tools/shfmt -d -i 2 -ci scripts/my_feature.sh
```

## Scripts

- `scripts/init_skill.sh` - Initialize new skill with TDD structure
- `scripts/check_prerequisites.sh` - Verify/install tools (bashunit, shellcheck, shfmt)
- `scripts/skill_validator.sh` - Validate skill structure
- `scripts/template_updater.sh` - Manage templates

## Structure (Official Anthropic Format)

```
skill-name/
├── SKILL.md        # Required: frontmatter + instructions
├── scripts/        # Executable code
├── tests/          # bashunit tests
├── references/     # Documentation loaded into context
└── assets/         # Templates for output generation
```

## Setup

```bash
./scripts/check_prerequisites.sh --download
```

## Resources

- [style_guide.md](references/style_guide.md) - Basic TDD patterns
- [bash-testing-guide.md](references/bash-testing-guide.md) - Comprehensive bashunit guide
- [anthropic-compliance.md](references/anthropic-compliance.md) - Anthropic skill specification compliance
