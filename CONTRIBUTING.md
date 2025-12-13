# Contributing to TDD Skill Builder

Thank you for your interest in contributing! This project follows Test-Driven Development (TDD) practices.

## Getting Started

1. **Fork and clone the repository:**
   ```bash
   git clone https://github.com/<your-username>/claude-tdd-skills.git
   cd claude-tdd-skills
   ```

2. **Install tools:**
   ```bash
   ./.claude/skills/tdd-skill-builder/scripts/check_prerequisites.sh --download
   ```

3. **Verify setup:**
   ```bash
   ./tools/bashunit --version
   ./tools/shellcheck --version
   ./tools/shfmt --version
   ```

4. **Run existing tests:**
   ```bash
   ./tools/bashunit .claude/skills/tdd-skill-builder/tests/
   ```

## Development Workflow

This project strictly follows **TDD (Red-Green-Refactor)**:

### 1. RED: Write Failing Tests First

```bash
# Create test file before implementation
# Tests go in .claude/skills/tdd-skill-builder/tests/
vim .claude/skills/tdd-skill-builder/tests/my_feature_test.sh

# Run tests - should fail
./tools/bashunit .claude/skills/tdd-skill-builder/tests/my_feature_test.sh
```

### 2. GREEN: Implement Minimum Code to Pass

```bash
# Create implementation
# Scripts go in .claude/skills/tdd-skill-builder/scripts/
vim .claude/skills/tdd-skill-builder/scripts/my_feature.sh

# Run tests - should pass
./tools/bashunit .claude/skills/tdd-skill-builder/tests/my_feature_test.sh
```

### 3. REFACTOR: Clean Up Code

```bash
# Static analysis
./tools/shellcheck .claude/skills/tdd-skill-builder/scripts/my_feature.sh

# Format check
./tools/shfmt -d -i 2 -ci .claude/skills/tdd-skill-builder/scripts/my_feature.sh

# Verify tests still pass
./tools/bashunit .claude/skills/tdd-skill-builder/tests/my_feature_test.sh
```

## Code Quality Requirements

Before submitting a PR, ensure:

- [ ] All tests pass:
  ```bash
  ./tools/bashunit .claude/skills/tdd-skill-builder/tests/
  ```
- [ ] No shellcheck warnings:
  ```bash
  ./tools/shellcheck .claude/skills/tdd-skill-builder/scripts/*.sh
  ```
- [ ] Code is formatted:
  ```bash
  ./tools/shfmt -d -i 2 -ci .claude/skills/tdd-skill-builder/scripts/*.sh
  ```
- [ ] CHANGELOG.md is updated

## Git Workflow

See [.claude/version-control.md](.claude/version-control.md) for detailed git workflow guidelines.

### Branch Naming

```
feature/description   # New features
fix/description       # Bug fixes
docs/description      # Documentation
test/description      # Test additions
refactor/description  # Code restructuring
chore/description     # Maintenance
```

### Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new validator function
fix: resolve path resolution error
docs: update contributing guide
test: add edge case tests
refactor: extract common utilities
chore: update tool versions
```

## Pull Request Process

1. Create a feature branch from `main`
2. Follow TDD workflow for all changes
3. Update CHANGELOG.md
4. Push and create PR
5. Ensure all checks pass
6. Request review

## Project Structure

```
.claude/skills/tdd-skill-builder/
├── scripts/    # Implementation (check_prerequisites.sh, skill_validator.sh, etc.)
├── tests/      # Test files (*_test.sh)
├── templates/  # Code templates
├── resources/  # Style guides and documentation
└── examples/   # Example skills (hello-world)
```

## Resources

- [bashunit Documentation](https://bashunit.typeddevs.com/)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck Wiki](https://www.shellcheck.net/wiki/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## Questions?

Open an issue for questions or discussions.
