# Version Control & Git Workflow

This document describes the git workflow for this project. These rules are **required** for both Claude Code and developers unless explicitly overridden.

## Overview

We use **GitHub Flow** with an **approval-gated commit workflow**:
- `main` branch is always stable and deployable
- All work happens in short-lived feature branches
- Changes merge to `main` via Pull Request
- Claude Code stages changes and proposes commits, requiring explicit approval

This ensures quality control while maintaining a clean, linear history.

---

## Branching Strategy

### Branch Structure

```
main (protected, always deployable)
  ├── feature/add-new-validator
  ├── feature/template-generator
  ├── fix/shellcheck-warning
  ├── docs/update-readme
  └── chore/update-tools
```

### Branch Types

| Prefix | Purpose | Example |
|--------|---------|---------|
| `feature/` | New functionality | `feature/add-skill-generator` |
| `fix/` | Bug fixes | `fix/template-path-error` |
| `docs/` | Documentation only | `docs/add-contributing-guide` |
| `refactor/` | Code restructuring, no behavior change | `refactor/extract-common-functions` |
| `test/` | Test additions/fixes only | `test/add-validator-tests` |
| `chore/` | Maintenance, dependencies, tooling | `chore/update-bashunit` |

### Branch Naming Conventions

**Format:** `<type>/<short-description>`

**Rules:**
- Use lowercase only
- Use hyphens to separate words (not underscores)
- Keep descriptions concise (2-5 words)
- Include ticket/issue number if applicable: `fix/issue-42-path-error`

**Examples:**
```
✓ feature/add-skill-generator
✓ fix/shellcheck-sc2034
✓ docs/update-setup-instructions
✗ Feature/Add_New_Thing        (wrong case, underscores)
✗ feature/this-is-a-very-long-branch-name-that-describes-everything  (too long)
```

---

## Feature Branch Workflow

### Starting New Work

1. **Ensure `main` is up to date:**
   ```bash
   git checkout main
   git pull origin main
   ```

2. **Create feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Work in small commits** following TDD:
   - Write failing test → commit
   - Make test pass → commit
   - Refactor → commit

### During Development

- **Commit frequently** with clear messages (see Commit Message Format below)
- **Push regularly** to remote for backup:
  ```bash
  git push -u origin feature/your-feature-name
  ```
- **Keep branch focused** on single feature/fix
- **Rebase on main** if branch lives longer than expected:
  ```bash
  git fetch origin
  git rebase origin/main
  ```

### Completing Work

1. **Ensure all tests pass:** `./tools/bashunit .claude/skills/tdd-skill-builder/tests/`
2. **Ensure analysis passes:** `./tools/shellcheck .claude/skills/tdd-skill-builder/scripts/*.sh`
3. **Ensure code is formatted:** `./tools/shfmt -d -i 2 -ci .claude/skills/tdd-skill-builder/scripts/*.sh`
4. **Update CHANGELOG.md** (required for every PR)
5. **Push final changes**
6. **Create Pull Request** (see PR Guidelines below)

---

## Pull Request Guidelines

### When to Create a PR

**Always create a PR for:**
- Any merge to `main`
- Even solo work (creates documentation trail)

### PR Creation (Claude Code)

When Claude Code completes a feature branch, it will:

1. **Push the branch** to remote
2. **Create PR** with this format:
   ```
   ## Summary
   - Brief description of changes (1-3 bullets)

   ## Changes
   - List of specific changes made

   ## Testing
   - How the changes were tested
   - Test commands run

   ## Checklist
   - [ ] Tests pass (`./tools/bashunit tests/`)
   - [ ] Analysis passes (`./tools/shellcheck scripts/*.sh`)
   - [ ] Code formatted (`./tools/shfmt -d -i 2 -ci scripts/*.sh`)
   - [ ] CHANGELOG.md updated
   ```

3. **Request review** (or self-review for solo work)

### PR Review Checklist

Before merging, verify:
- [ ] Changes match PR description
- [ ] Tests are adequate for the changes
- [ ] No shellcheck warnings introduced
- [ ] CHANGELOG entry is accurate
- [ ] Branch is up to date with `main`

### Merging

**Preferred method:** Squash and merge
- Creates clean, linear history
- Single commit per feature on `main`
- PR description becomes commit message

**Alternative:** Rebase and merge
- Use when commit history is valuable
- Each commit must be atomic and pass tests

**Never:** Merge commit
- Creates unnecessary merge bubbles
- Complicates history

---

## Release and Tagging

### Release Strategy

This project uses **milestone-based releases**.

### Version Numbering

Follow [Semantic Versioning](https://semver.org/):

```
MAJOR.MINOR.PATCH

0.1.0  → Initial release
0.2.0  → New feature added
0.2.1  → Bug fix
1.0.0  → Stable release
```

### Creating a Release

1. **Ensure `main` is stable** and all tests pass

2. **Update CHANGELOG.md**:
   - Move items from `[Unreleased]` to versioned section
   - Add release date
   ```markdown
   ## [0.1.0] - 2025-12-13

   ### Added
   - Initial TDD Skill Builder implementation
   - ...
   ```

3. **Commit version bump:**
   ```bash
   git commit -am "chore(release): bump version to 0.1.0"
   ```

4. **Create annotated tag:**
   ```bash
   git tag -a v0.1.0 -m "Release 0.1.0: Initial Release"
   ```

5. **Push with tags:**
   ```bash
   git push origin main --tags
   ```

### Tag Naming

- Format: `v<MAJOR>.<MINOR>.<PATCH>`
- Examples: `v0.1.0`, `v1.0.0`, `v1.2.3`

---

## Exceptions and Overrides

These rules are **required by default** but can be overridden when explicitly requested.

### Valid Override Scenarios

| Scenario | Override | How to Request |
|----------|----------|----------------|
| **Emergency hotfix** | Commit directly to `main` | "Commit this hotfix directly to main" |
| **Trivial fix** | Skip PR for typo/comment | "Skip PR for this one-line fix" |
| **Experimentation** | Work on `main` temporarily | "Let's experiment on main, I'll reset if needed" |
| **Quick iteration** | Delay PR until stable | "Keep working on main, we'll PR when ready" |

### How Overrides Work

1. **Developer explicitly requests** the override
2. **Claude Code acknowledges** the deviation from standard workflow
3. **Work proceeds** with the override
4. **Document why** in commit message if relevant

### What Cannot Be Overridden

- Running tests before release
- Updating CHANGELOG for releases
- Using conventional commit format
- Tagging releases with proper version

---

## Commit Workflow

### Step 1: Claude Code Proposes Changes

When Claude Code completes a task:
1. It stages all modified files
2. It generates a clear, descriptive commit message
3. It proposes the commit to you with the message and file list

### Step 2: Review and Approve

Before Claude Code commits, you should:
1. Review the staged files and changes
2. Review the proposed commit message
3. Approve or request modifications

### Step 3: Documentation Updates

Before proposing the commit, Claude Code will:
1. Identify which documentation files are affected by the changes
2. Update relevant files according to the guide below
3. Include documentation updates in the staged changes

### Step 4: Execute Commit

Once approved, Claude Code commits the changes with the approved message.

## Documentation Update Strategy

The following documentation files should be updated based on the type of changes:

### README.md

Update when:
- Adding or modifying the project's functionality
- Changing how to run or build the project
- Updating installation or usage instructions
- Adding new features or capabilities

### CHANGELOG.md

Update **always** before every commit. Use the following format:

```
## [Unreleased]

### Added
- Description of new features

### Changed
- Description of modified existing features

### Fixed
- Description of bug fixes

### Removed
- Description of removed features
```

## Commit Message Format

Claude Code will use conventional commit format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Where:
- **type**: feat, fix, docs, style, refactor, perf, test, chore
- **scope**: optional, the area affected
- **subject**: concise description (imperative mood, lowercase)
- **body**: optional, more detailed explanation
- **footer**: optional, references to issues (e.g., "Closes #123")

### Example Commit Messages

```
feat: add skill validator script

Validates SKILL.md frontmatter and directory structure.

fix: resolve shellcheck SC2034 warning

Added shellcheck disable comment for reserved constant.

docs: update setup instructions

Clarified tool installation process and added troubleshooting section.

refactor: extract common test utilities

Moved shared test helpers to separate file for reuse.
```

---

## References

- **Keep a Changelog:** https://keepachangelog.com/
- **Conventional Commits:** https://www.conventionalcommits.org/
- **Semantic Versioning:** https://semver.org/
