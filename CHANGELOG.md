# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

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
