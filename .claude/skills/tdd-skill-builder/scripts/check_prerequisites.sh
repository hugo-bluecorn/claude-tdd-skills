#!/bin/bash
# check_prerequisites.sh - Verifies and installs required tools
# Part of TDD Skill Builder

# Only enable strict mode when executed directly, not when sourced
# This allows tests to capture exit codes properly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  set -euo pipefail
fi

# Required tools for TDD skill building
readonly REQUIRED_TOOLS=("bashunit" "shellcheck" "shfmt")

# Tool versions and URLs
readonly BASHUNIT_VERSION="0.29.0"
readonly SHELLCHECK_VERSION="0.10.0"
readonly SHFMT_VERSION="3.8.0"

# Detect OS and architecture for downloads
get_os() {
  local os
  os=$(uname -s | tr '[:upper:]' '[:lower:]')
  case "${os}" in
    linux) echo "linux" ;;
    darwin) echo "darwin" ;;
    *) echo "unknown" ;;
  esac
}

get_arch() {
  local arch
  arch=$(uname -m)
  case "${arch}" in
    x86_64) echo "amd64" ;;
    aarch64 | arm64) echo "arm64" ;;
    *) echo "unknown" ;;
  esac
}

# Get the tools directory (project-local)
# Can be overridden by TOOLS_DIR environment variable
get_tools_dir() {
  if [[ -n "${TOOLS_DIR:-}" ]]; then
    echo "${TOOLS_DIR}"
    return
  fi

  # Find project root by looking for .claude directory
  local dir="${PWD}"
  while [[ "${dir}" != "/" ]]; do
    if [[ -d "${dir}/.claude" ]]; then
      echo "${dir}/tools"
      return
    fi
    dir=$(dirname "${dir}")
  done

  # Fallback to current directory
  echo "${PWD}/tools"
}

# Check if a single tool is installed
# Arguments:
#   $1 - Tool name to check
# Returns:
#   0 if installed, 1 if not
# Output:
#   Status message with checkmark or X
check_tool_installed() {
  local tool="$1"
  local tool_path
  if tool_path=$(command -v "${tool}" 2>/dev/null); then
    echo "✓ ${tool}: ${tool_path}"
    return 0
  else
    echo "✗ ${tool}: NOT FOUND"
    return 1
  fi
}

# Install bashunit to specified directory
# Arguments:
#   $1 - Target directory
# Returns:
#   0 on success, 1 on failure
install_bashunit() {
  local target_dir="${1:-$(get_tools_dir)}"
  local url="https://github.com/TypedDevs/bashunit/releases/download/${BASHUNIT_VERSION}/bashunit"

  mkdir -p "${target_dir}"

  echo "Downloading bashunit ${BASHUNIT_VERSION}..."

  if command -v curl &>/dev/null; then
    curl -fsSL -o "${target_dir}/bashunit" "${url}" || return 1
  elif command -v wget &>/dev/null; then
    wget -q -O "${target_dir}/bashunit" "${url}" || return 1
  else
    echo "ERROR: Neither curl nor wget found"
    return 1
  fi

  chmod +x "${target_dir}/bashunit"
  echo "✓ bashunit installed to ${target_dir}/bashunit"
  return 0
}

# Install shellcheck to specified directory
# Arguments:
#   $1 - Target directory
# Returns:
#   0 on success, 1 on failure
install_shellcheck() {
  local target_dir="${1:-$(get_tools_dir)}"
  local os arch tarball url

  os=$(get_os)
  arch=$(get_arch)

  if [[ "${os}" == "unknown" ]] || [[ "${arch}" == "unknown" ]]; then
    echo "ERROR: Unsupported platform (${os}/${arch})"
    return 1
  fi

  # ShellCheck releases use different naming convention
  case "${os}" in
    linux) tarball="shellcheck-v${SHELLCHECK_VERSION}.${os}.${arch/amd64/x86_64}.tar.xz" ;;
    darwin) tarball="shellcheck-v${SHELLCHECK_VERSION}.${os}.${arch/amd64/x86_64}.tar.xz" ;;
    *)
      echo "ERROR: Unsupported OS: ${os}"
      return 1
      ;;
  esac

  url="https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/${tarball}"

  mkdir -p "${target_dir}"

  echo "Downloading shellcheck ${SHELLCHECK_VERSION}..."

  local temp_dir
  temp_dir=$(mktemp -d)

  if command -v curl &>/dev/null; then
    curl -fsSL -o "${temp_dir}/shellcheck.tar.xz" "${url}" || {
      rm -rf "${temp_dir}"
      return 1
    }
  elif command -v wget &>/dev/null; then
    wget -q -O "${temp_dir}/shellcheck.tar.xz" "${url}" || {
      rm -rf "${temp_dir}"
      return 1
    }
  else
    echo "ERROR: Neither curl nor wget found"
    rm -rf "${temp_dir}"
    return 1
  fi

  # Extract shellcheck binary
  tar -xf "${temp_dir}/shellcheck.tar.xz" -C "${temp_dir}" --strip-components=1
  mv "${temp_dir}/shellcheck" "${target_dir}/shellcheck"
  chmod +x "${target_dir}/shellcheck"

  rm -rf "${temp_dir}"
  echo "✓ shellcheck installed to ${target_dir}/shellcheck"
  return 0
}

# Install shfmt to specified directory
# Arguments:
#   $1 - Target directory
# Returns:
#   0 on success, 1 on failure
install_shfmt() {
  local target_dir="${1:-$(get_tools_dir)}"
  local os arch binary url

  os=$(get_os)
  arch=$(get_arch)

  if [[ "${os}" == "unknown" ]] || [[ "${arch}" == "unknown" ]]; then
    echo "ERROR: Unsupported platform (${os}/${arch})"
    return 1
  fi

  binary="shfmt_v${SHFMT_VERSION}_${os}_${arch}"
  url="https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/${binary}"

  mkdir -p "${target_dir}"

  echo "Downloading shfmt ${SHFMT_VERSION}..."

  if command -v curl &>/dev/null; then
    curl -fsSL -o "${target_dir}/shfmt" "${url}" || return 1
  elif command -v wget &>/dev/null; then
    wget -q -O "${target_dir}/shfmt" "${url}" || return 1
  else
    echo "ERROR: Neither curl nor wget found"
    return 1
  fi

  chmod +x "${target_dir}/shfmt"
  echo "✓ shfmt installed to ${target_dir}/shfmt"
  return 0
}

# Prompt user for tool installation choice
# Returns:
#   "download" or "system" based on user choice
#   Defaults to "download" if not interactive
prompt_tool_choice() {
  # Non-interactive: default to download
  if [[ ! -t 0 ]] || [[ ! -t 1 ]]; then
    echo "download"
    return
  fi

  echo ""
  echo "Some tools are available on your system and some need to be installed."
  echo ""
  echo "Options:"
  echo "  1) Download all tools to project (recommended)"
  echo "  2) Use system tools where available"
  echo ""
  read -r -p "Choose [1/2] (default: 1): " choice

  case "${choice}" in
    2) echo "system" ;;
    *) echo "download" ;;
  esac
}

# Check all required prerequisites
# Returns:
#   0 if all installed, 1 if any missing
# Output:
#   Status of each tool and summary
check_all_prerequisites() {
  local missing=0
  local result

  echo "Checking prerequisites..."
  echo ""

  for tool in "${REQUIRED_TOOLS[@]}"; do
    # Capture result to avoid masking return value in if condition
    result=0
    check_tool_installed "${tool}" || result=$?
    if [[ ${result} -ne 0 ]]; then
      ((missing++)) || true
    fi
  done

  echo ""

  if [[ ${missing} -gt 0 ]]; then
    echo "ERROR: ${missing} required tool(s) missing."
    echo ""
    echo "Install missing tools:"
    echo "  bashunit:   curl -s https://bashunit.typeddevs.com/install.sh | bash"
    echo "  shellcheck: sudo apt install shellcheck (or brew install shellcheck)"
    echo "  shfmt:      sudo apt install shfmt (or brew install shfmt)"
    return 1
  fi

  echo "All prerequisites satisfied!"
  return 0
}

# Ensure all prerequisites are available
# Arguments:
#   --download: Download all tools to project (default)
#   --use-system: Use system tools if available, download only missing
#   --help: Show usage
# Returns:
#   0 on success, 1 on failure
ensure_prerequisites() {
  local mode="download"
  local tools_dir

  # Parse arguments
  case "${1:-}" in
    --download) mode="download" ;;
    --use-system) mode="system" ;;
    --help)
      echo "Usage: ensure_prerequisites [--download|--use-system|--help]"
      echo ""
      echo "Options:"
      echo "  --download     Download all tools to project tools/ directory (default)"
      echo "  --use-system   Use system tools if available, download only missing"
      echo "  --help         Show this help message"
      return 0
      ;;
    "")
      # Interactive mode: prompt user if some tools exist
      local has_system_tools=false
      for tool in "${REQUIRED_TOOLS[@]}"; do
        if command -v "${tool}" &>/dev/null; then
          has_system_tools=true
          break
        fi
      done

      if [[ "${has_system_tools}" == "true" ]]; then
        mode=$(prompt_tool_choice)
      fi
      ;;
    *)
      echo "ERROR: Unknown option: $1"
      echo "Use --help for usage information"
      return 1
      ;;
  esac

  tools_dir=$(get_tools_dir)
  mkdir -p "${tools_dir}"

  echo "Installing tools to: ${tools_dir}"
  echo "Mode: ${mode}"
  echo ""

  local failed=0

  for tool in "${REQUIRED_TOOLS[@]}"; do
    # Check if we should use system tool
    if [[ "${mode}" == "system" ]]; then
      local system_path
      if system_path=$(command -v "${tool}" 2>/dev/null); then
        echo "✓ Using system ${tool}: ${system_path}"
        continue
      fi
    fi

    # Check if already installed in tools dir
    if [[ -x "${tools_dir}/${tool}" ]]; then
      echo "✓ ${tool}: ${tools_dir}/${tool} (already installed)"
      continue
    fi

    # Install the tool
    echo "Installing ${tool}..."
    local install_result=0
    case "${tool}" in
      bashunit) install_bashunit "${tools_dir}" || install_result=$? ;;
      shellcheck) install_shellcheck "${tools_dir}" || install_result=$? ;;
      shfmt) install_shfmt "${tools_dir}" || install_result=$? ;;
      *)
        echo "ERROR: Unknown tool: ${tool}"
        install_result=1
        ;;
    esac

    if [[ ${install_result} -ne 0 ]]; then
      echo "✗ Failed to install ${tool}"
      ((failed++)) || true
    fi
  done

  echo ""

  if [[ ${failed} -gt 0 ]]; then
    echo "ERROR: Failed to install ${failed} tool(s)"
    return 1
  fi

  # Add tools to PATH info
  echo "Add to PATH: export PATH=\"${tools_dir}:\${PATH}\""
  echo ""
  echo "All prerequisites installed!"
  return 0
}

# Only run if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  # If run with arguments, use ensure_prerequisites
  if [[ $# -gt 0 ]]; then
    ensure_prerequisites "$@"
  else
    # Default behavior: check prerequisites
    check_all_prerequisites
  fi
fi
