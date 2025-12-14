# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.2.0] - 2025-12-14

### Added

- `init_skill.sh` - Initialize new skills with TDD structure
  - Usage: `./scripts/init_skill.sh <skill-name> --path <directory> [--description "desc"]`
  - Creates skill directory with scripts/, tests/, references/, assets/ subdirectories
  - Generates SKILL.md with frontmatter from template
  - Validates skill name format and prevents overwriting existing skills
- `references/anthropic-compliance.md` - Documents how TDD Skill Builder aligns with Anthropic's official skill specification
- `FUTURE_DISTRIBUTION.md` - Planning document for v1.0.0 plugin-based distribution

### Changed

- **Directory renames to match official Anthropic structure:**
  - `resources/` → `references/` (documentation loaded into context)
  - `templates/` → `assets/` (templates for output generation)
- Updated all path references in scripts, tests, and documentation
- Updated SKILL.md structure diagram to show official format
- Added `references/` directory to `examples/hello-world/`
- Reorganized README.md following Standard README structure
- Added platform compatibility documentation (Linux, macOS, Windows WSL/Git Bash)

### Fixed

- `skill_validator.sh` now properly handles `--help` and `-h` flags (previously treated as path arguments)

### Tests

- Test count increased from 85 to 109 total (22 new for init_skill.sh, 2 new for --help flags)
- Current: 107 passing, 2 skipped

## [0.1.0] - 2025-12-13

### Added

- Initial TDD Skill Builder implementation
- **Scripts:**
  - `check_prerequisites.sh` - Verify and install required tools (bashunit, shellcheck, shfmt)
  - `skill_validator.sh` - Validate Claude Code Skill directory structure and SKILL.md format
  - `template_updater.sh` - Manage skill templates (backup, restore, update)
- **Templates:**
  - `SKILL.template.md` - Template for new skill definitions
  - `script.template.sh` - Template for bash scripts with TDD structure
  - `test.template.sh` - Template for bashunit test files
- **Documentation:**
  - `SKILL.md` - Main skill definition with TDD workflow instructions
  - `style_guide.md` - Basic TDD patterns and conventions
  - `bash-testing-guide.md` - Comprehensive bashunit testing guide
  - `version-control.md` - Git workflow and conventions
  - `CLAUDE.md` - Project memory with TDD directive
  - `README.md` - Project overview and quick start
- **Example:**
  - `hello-world` - Complete example skill demonstrating TDD workflow
- **Tests:**
  - 92 passing tests covering all scripts, templates, and SKILL.md validation
- **Tools:**
  - Project-local installation of bashunit, shellcheck, and shfmt in `tools/` directory
