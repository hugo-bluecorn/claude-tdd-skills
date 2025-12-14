# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Core Directive: Test-Driven Development

**Always use TDD (Red-Green-Refactor) when creating or modifying code.**

1. **RED**: Write failing tests first, run to confirm failure
2. **GREEN**: Write minimum code to pass tests
3. **REFACTOR**: Clean up with shellcheck/shfmt, verify tests still pass

**Apply TDD to:** Shell scripts, template files, SKILL.md with verifiable requirements.
**Skip TDD for:** Config files (`.bashunitrc`, `.shellcheckrc`, `.editorconfig`), pure documentation.

## Commands

All tools are in `tools/`. Always use project-local versions.

```bash
# Run all tests
./tools/bashunit .claude/skills/tdd-skill-builder/tests/

# Run single test file
./tools/bashunit .claude/skills/tdd-skill-builder/tests/skill_validator_test.sh

# Run specific test function (filter by name)
./tools/bashunit --filter "test_validates_skill_name" .claude/skills/tdd-skill-builder/tests/

# Static analysis
./tools/shellcheck .claude/skills/tdd-skill-builder/scripts/*.sh

# Format check (diff mode)
./tools/shfmt -d -i 2 -ci .claude/skills/tdd-skill-builder/scripts/*.sh

# Auto-format in place
./tools/shfmt -w -i 2 -ci .claude/skills/tdd-skill-builder/scripts/*.sh

# Install/verify tools
./.claude/skills/tdd-skill-builder/scripts/check_prerequisites.sh --download
```

## Quality Gates

Before marking code complete, all three must pass:

```bash
./tools/bashunit .claude/skills/tdd-skill-builder/tests/
./tools/shellcheck .claude/skills/tdd-skill-builder/scripts/*.sh
./tools/shfmt -d -i 2 -ci .claude/skills/tdd-skill-builder/scripts/*.sh
```

## Architecture

This is a Claude Code Skill that helps build other skills using TDD.

```
.claude/skills/tdd-skill-builder/
├── SKILL.md              # Skill definition (triggers on "create a skill")
├── scripts/              # Implementation
│   ├── init_skill.sh           # Initialize new skill with TDD structure
│   ├── check_prerequisites.sh  # Tool installer/verifier
│   ├── skill_validator.sh      # Validates skill structure
│   └── template_updater.sh     # Template management
├── tests/                # bashunit tests (*_test.sh)
├── assets/               # SKILL.md, script, test templates
├── references/           # style_guide.md, bash-testing-guide.md, anthropic-compliance.md
└── examples/hello-world/ # Working example skill
```

Test files mirror scripts: `scripts/foo.sh` → `tests/foo_test.sh`

## Git Workflow

See `.claude/version-control.md` for full details.

- **Branches**: `feature/`, `fix/`, `docs/`, `refactor/`, `test/`, `chore/` prefixes
- **Commits**: Conventional Commits format (`feat:`, `fix:`, `docs:`, etc.)
- **PRs**: Update CHANGELOG.md for every PR
- **Merge**: Squash and merge preferred

## References

- [Official Skill Spec](https://code.claude.com/docs/en/skills)
- [bashunit](https://bashunit.typeddevs.com/)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
