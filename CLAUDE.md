# Claude Code Memory: TDD Skill Builder Project

## Core Directive: Test-Driven Development

**Always use TDD (Red-Green-Refactor) when creating or modifying code in this project.**

### TDD Workflow

1. **RED**: Write failing tests first, then run to confirm failure
2. **GREEN**: Write minimum code to pass tests
3. **REFACTOR**: Clean up with shellcheck/shfmt, verify tests still pass

### When to Apply TDD

- Shell scripts (`.sh` files)
- Template files with testable structure
- SKILL.md and other markdown files with verifiable requirements
- Any code that can be validated programmatically

### TDD is Not Required For

- Configuration files (`.bashunitrc`, `.shellcheckrc`, `.editorconfig`)
- Pure documentation without structural requirements
- Directory structure creation

### Quality Gates

Before marking any code complete:

```bash
# 1. All tests pass
./tools/bashunit .claude/skills/tdd-skill-builder/tests/

# 2. No shellcheck errors
./tools/shellcheck .claude/skills/tdd-skill-builder/scripts/*.sh

# 3. Proper formatting
./tools/shfmt -d -i 2 -ci .claude/skills/tdd-skill-builder/scripts/*.sh
```

## Project Tools

Tools are installed in `tools/` directory. Always use project-local tools:

```bash
./tools/bashunit .claude/skills/tdd-skill-builder/tests/
./tools/shellcheck .claude/skills/tdd-skill-builder/scripts/*.sh
./tools/shfmt -d -i 2 -ci .claude/skills/tdd-skill-builder/scripts/*.sh
```

## Git Workflow

Follow `.claude/version-control.md` for:
- Branch naming conventions
- Commit message format (Conventional Commits)
- PR process
- CHANGELOG updates

## References

- Official Skill Spec: https://code.claude.com/docs/en/skills
- bashunit: https://bashunit.typeddevs.com/
- Google Shell Style Guide: https://google.github.io/styleguide/shellguide.html
