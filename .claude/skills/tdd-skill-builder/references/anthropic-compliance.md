# Anthropic Skill Compliance Guide

This document describes how TDD Skill Builder aligns with Anthropic's official skill specification.

> **Source:** [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)

## Official Skill Structure

Anthropic defines the following structure for Claude Code Skills:

```
skill-name/
├── SKILL.md        # REQUIRED: Frontmatter + instructions
├── scripts/        # Optional: Executable code (Python/Bash)
├── references/     # Optional: Documentation loaded into context
└── assets/         # Optional: Templates, icons, fonts for output
```

### Required vs Optional

| Component | Required | Description |
|-----------|----------|-------------|
| `SKILL.md` | **Yes** | Skill definition with YAML frontmatter |
| `name` field | **Yes** | Lowercase alphanumeric with hyphens |
| `description` field | **Yes** | Used by Claude to decide when to invoke |
| `scripts/` | No | Executable code called by the skill |
| `references/` | No | Documentation loaded into context as needed |
| `assets/` | No | Templates, images, fonts for output generation |

## SKILL.md Frontmatter

### Required Format

```yaml
---
name: skill-name
description: >-
  Brief description of what the skill does.
  Claude reads this to decide when to invoke the skill.
---

# Skill Title

Instructions for Claude...
```

### Name Field Validation

The `name` field must:
- Be lowercase only
- Use alphanumeric characters and hyphens
- Start and end with alphanumeric character
- Match pattern: `^[a-z0-9][a-z0-9-]*[a-z0-9]$` or `^[a-z0-9]$`

**Valid examples:**
- `my-skill`
- `code-reviewer`
- `tdd-skill-builder`

**Invalid examples:**
- `My-Skill` (uppercase)
- `my_skill` (underscore)
- `-my-skill` (starts with hyphen)

### Description Field

The `description` field:
- Is required for Claude to understand when to use the skill
- Should be concise but descriptive
- Supports multi-line YAML format (`>-`)

## How TDD Skill Builder Complies

### Directory Structure

TDD Skill Builder creates this structure via `init_skill.sh`:

```
skill-name/
├── SKILL.md        # Generated with valid frontmatter
├── scripts/        # Created (empty)
├── tests/          # Created (TDD addition, not in official spec)
├── references/     # Created (empty)
└── assets/         # Created (empty)
```

**Note:** The `tests/` directory is a TDD Skill Builder addition for bashunit tests. It does not conflict with the official specification.

### Validation

The `skill_validator.sh` script enforces Anthropic's requirements:

1. **SKILL.md must exist**
2. **Frontmatter must be present** (YAML between `---` delimiters)
3. **name field must exist and be valid** (lowercase alphanumeric with hyphens)
4. **description field must exist**
5. **Scripts must be executable** (warning level)

### Running Compliance Check

```bash
# Validate any skill against Anthropic requirements
./scripts/skill_validator.sh /path/to/skill

# Example output for valid skill:
# Validating skill at: /path/to/skill
# ✓ SKILL.md exists
# ✓ SKILL.md has frontmatter
# ✓ name: my-skill
# ✓ description: My skill description...
# Validation PASSED
```

## Skill Invocation

Skills are **model-invoked** (autonomous), not user-invoked:
- Claude reads the `description` field
- Claude decides when to use the skill based on context
- This differs from slash commands (`/command`) which are user-invoked

## TDD Skill Builder Self-Compliance

The TDD Skill Builder validates against itself:

```bash
./scripts/skill_validator.sh .claude/skills/tdd-skill-builder
# Validation PASSED
```

## References

- [Official Claude Code Skills](https://code.claude.com/docs/en/skills)
- [Anthropic Skills Repository](https://github.com/anthropics/skills)
