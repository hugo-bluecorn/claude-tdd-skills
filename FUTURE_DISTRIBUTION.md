# Future Distribution Plan

> **Purpose**: Seed document for implementing plugin-based distribution (v1.0.0)
> **Created**: 2025-12-14
> **Status**: Planning

---

## Goal

Package TDD Skill Builder for distribution via Claude Code's plugin system, enabling users to install with:

```bash
/plugin marketplace add hugo-bluecorn/claude-tdd-skills
/plugin install tdd-skill-builder@tdd-skill-builder-marketplace
```

---

## Required Components

### 1. Plugin Manifest

**File:** `.claude-plugin/plugin.json`

```json
{
  "name": "tdd-skill-builder",
  "version": "1.0.0",
  "description": "Guides creation of Claude Code Skills using Test-Driven Development (TDD)",
  "author": {
    "name": "Hugo Bluecorn",
    "email": "hugo@example.com",
    "url": "https://github.com/hugo-bluecorn"
  },
  "homepage": "https://github.com/hugo-bluecorn/claude-tdd-skills",
  "repository": "https://github.com/hugo-bluecorn/claude-tdd-skills",
  "license": "Apache-2.0",
  "keywords": ["tdd", "skill-builder", "testing", "bashunit", "shellcheck"]
}
```

**Required fields:** name, version, description, author (name + email)

---

### 2. Marketplace File

**File:** `.claude-plugin/marketplace.json`

```json
{
  "name": "tdd-skill-builder-marketplace",
  "owner": {
    "name": "Hugo Bluecorn",
    "email": "hugo@example.com"
  },
  "metadata": {
    "description": "TDD Skill Builder - Create Claude Code Skills using Test-Driven Development",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "tdd-skill-builder",
      "description": "Guides creation of Claude Code Skills using TDD workflow with bashunit, shellcheck, and shfmt",
      "source": "./",
      "strict": false,
      "skills": [
        "./.claude/skills/tdd-skill-builder"
      ]
    }
  ]
}
```

---

### 3. Package Script

**File:** `.claude/skills/tdd-skill-builder/scripts/package_skill.sh`

Bash equivalent of Anthropic's `package_skill.py`:

```bash
#!/bin/bash
# package_skill.sh - Package a skill into a distributable .skill archive
# Usage: package_skill.sh <skill-directory> [output-directory]

# Functionality:
# 1. Validate skill structure (SKILL.md exists, frontmatter valid)
# 2. Run skill_validator.sh
# 3. Create ZIP archive with .skill extension
# 4. Output: <skill-name>.skill
```

**TDD Test Cases:**
- Script exists and is executable
- Requires skill directory argument
- Validates skill before packaging
- Creates .skill file (ZIP format)
- Names output file from skill name in frontmatter
- Supports custom output directory
- Fails gracefully with clear error messages
- Returns exit code 0 on success, 1 on failure

---

### 4. Directory Structure Changes

Current:
```
claude-tdd-skills/
├── .claude/skills/tdd-skill-builder/
├── tools/
├── README.md
└── ...
```

After implementation:
```
claude-tdd-skills/
├── .claude-plugin/
│   ├── plugin.json          # NEW
│   └── marketplace.json     # NEW
├── .claude/skills/tdd-skill-builder/
│   ├── scripts/
│   │   ├── package_skill.sh # NEW
│   │   └── ...
│   └── ...
├── tools/
└── ...
```

---

## Implementation Phases

### Phase 1: Create Plugin Infrastructure
1. RED: Write tests for plugin.json validation
2. GREEN: Create `.claude-plugin/plugin.json`
3. REFACTOR: Validate JSON schema

### Phase 2: Create Marketplace File
1. RED: Write tests for marketplace.json validation
2. GREEN: Create `.claude-plugin/marketplace.json`
3. REFACTOR: Validate against Anthropic schema

### Phase 3: Implement package_skill.sh (TDD)
1. RED: Write tests for package_skill.sh
2. GREEN: Implement packaging logic
3. REFACTOR: shellcheck/shfmt clean

### Phase 4: Integration Testing
1. Test full plugin installation workflow
2. Verify `/plugin marketplace add` works
3. Verify `/plugin install` works
4. Document any issues

### Phase 5: Documentation Updates
1. Update README.md with installation instructions
2. Update SKILL.md with packaging commands
3. Update CHANGELOG.md
4. Create release notes for v1.0.0

---

## Quality Gates

Before v1.0.0 release:

```bash
# All tests pass
./tools/bashunit .claude/skills/tdd-skill-builder/tests/

# All scripts clean
./tools/shellcheck .claude/skills/tdd-skill-builder/scripts/*.sh
./tools/shfmt -d -i 2 -ci .claude/skills/tdd-skill-builder/scripts/*.sh

# Plugin validates
# (manual test with /plugin commands)
```

---

## Validation Requirements

Per Anthropic's skill specification:

| Field | Requirement |
|-------|-------------|
| name | Max 64 chars, lowercase/numbers/hyphens only |
| description | Max 1024 chars, no XML tags, third-person |
| SKILL.md body | Recommended < 500 lines |

---

## References

- [Anthropic Skills Repository](https://github.com/anthropics/skills)
- [Plugin Marketplaces - Claude Code Docs](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)
- [Plugins Reference - Claude Code Docs](https://docs.claude.com/en/docs/claude-code/plugins-reference)
- [Skill Authoring Best Practices](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices)

---

## Notes

- Skills are discovered through explicit path references in marketplace.json
- Use `${CLAUDE_PLUGIN_ROOT}` for intra-plugin path references
- Component directories (skills/) must be at plugin root, NOT inside `.claude-plugin/`
- Consider submitting to anthropics/skills marketplace after v1.0.0
