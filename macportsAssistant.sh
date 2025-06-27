#!/bin/bash

# macportsAssistant.sh
# Hoyt Harness, 2024
# Unified MacPorts installation, upgrade, and maintenance script for macOS
#
# Copyright (C) 2024 Hoyt Harness, hoyt.harness@gmail.com, Positronikal
# Licensed under GNU General Public License v3.0

set -euo pipefail

readonly SCRIPT_NAME="macportsAssistant"
readonly SCRIPT_VERSION="3.0.0"
readonly UPDATER_SCRIPT="macports_updater.sh"

# Color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Logging functions
log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_step() { echo -e "${BLUE}[STEP]${NC} $*"; }

# Cleanup on exit
cleanup_and_exit() {
    local exit_code=${1:-1}
    rm -f /tmp/macports_*.pkg 2>/dev/null || true
    exit "$exit_code"
}
trap 'cleanup_and_exit 130' INT TERM

# Show help
show_help() {
    cat << EOF
$SCRIPT_NAME v$SCRIPT_VERSION - MacPorts Management Tool

USAGE:
    sudo $0 [OPTION]

OPTIONS:
    -h, --help      Show this help message
    -v, --version   Show version information
    -f, --force     Force reinstallation
    --update-only   Only update existing MacPorts

DESCRIPTION:
    Automatically detects your system and:
    - Installs MacPorts if not present
    - Upgrades MacPorts if installed via this script
    - Updates MacPorts and ports if --update-only specified

REQUIREMENTS:
    - Must be run as root (use sudo)
    - macOS 10.12 Sierra or later
    - Internet connection

EXAMPLES:
    sudo $0                    # Auto-detect and install/upgrade
    sudo $0 --update-only      # Just update existing installation
    sudo $0 --force            # Force reinstall
EOF
}

# Check privileges
check_privileges() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Get macOS version
get_macos_version() {
    sw_vers -productVersion
}

# Get MacPorts package info
get_macports_info() {
    local os_version="$1"
    case "$os_version" in
        15.*) echo "v2.10.4 MacPorts-2.10.4-15-Sequoia.pkg" ;;
        14.*) echo "v2.10.4 MacPorts-2.10.4-14-Sonoma.pkg" ;;
        13.*) echo "v2.10.4 MacPorts-2.10.4-13-Ventura.pkg" ;;
        12.*) echo "v2.10.4 MacPorts-2.10.4-12-Monterey.pkg" ;;
        11.*) echo "v2.8.1 MacPorts-2.8.1-11-BigSur.pkg" ;;
        10.15.*) echo "v2.8.1 MacPorts-2.8.1-10.15-Catalina.pkg" ;;
        10.14.*) echo "v2.8.1 MacPorts-2.8.1-10.14-Mojave.pkg" ;;
        10.13.*) echo "v2.8.1 MacPorts-2.8.1-10.13-HighSierra.pkg" ;;
        10.12.*) echo "v2.8.1 MacPorts-2.8.1-10.12-Sierra.pkg" ;;
        *) 
            log_error "macOS version $os_version not supported"
            return 1
            ;;
    esac
}

# Check installation status
is_macports_installed() { command -v port >/dev/null 2>&1; }
is_assistant_installation() { [[ -d "/Users/$(logname 2>/dev/null || echo "$SUDO_USER")/bin/MacPorts" ]]; }

# Determine mode
determine_mode() {
    if ! is_macports_installed; then
        echo "install"
    elif is_assistant_installation; then
        echo "upgrade"
    else
        echo "external"
    fi
}

# Setup Xcode tools
setup_xcode_tools() {
    log_step "Setting up Xcode Command Line Tools..."
    [[ -d /Library/Developer/CommandLineTools ]] && rm -rf /Library/Developer/CommandLineTools
    xcode-select --install
    read -p "Press Enter after Xcode CLI tools installation completes..."
    [[ -d /Applications/Xcode.app ]] && xcodebuild -license accept 2>/dev/null || true
}

# Download package
download_macports() {
    local version="$1" package="$2"
    local url="https://github.com/macports/macports-base/releases/download/$version/$package"
    local temp_pkg="/tmp/$package"
    
    log_step "Downloading: $package"
    curl --fail --location --progress-bar --output "$temp_pkg" "$url" || return 1
    echo "$temp_pkg"
}

# Install base system
install_macports_base() {
    local os_version="$1"
    local macports_info package_path
    
    macports_info=$(get_macports_info "$os_version")
    read -r version package <<< "$macports_info"
    package_path=$(download_macports "$version" "$package")
    
    log_step "Installing MacPorts for macOS $os_version..."
    installer -pkg "$package_path" -target / || return 1
    rm -f "$package_path"
    
    if command -v port >/dev/null 2>&1; then
        log_info "Installation successful: $(port version | head -1)"
    else
        return 1
    fi
}

# Main workflows
run_update_only() {
    log_info "Updating existing MacPorts installation..."
    if ! command -v port >/dev/null 2>&1; then
        log_error "MacPorts not found"
        exit 1
    fi
    
    port -v selfupdate
    port upgrade outdated
    port uninstall inactive
    port uninstall leaves
    log_info "Update completed!"
}

main_install() {
    local os_version="$1"
    local user_name user_dir
    
    user_name=$(logname 2>/dev/null || echo "$SUDO_USER")
    user_dir="/Users/$user_name/bin/MacPorts"
    
    log_info "Installing MacPorts for macOS $os_version"
    
    mkdir -p "$user_dir"
    cd "$user_dir"
    
    setup_xcode_tools
    install_macports_base "$os_version"
    
    # Simple port restoration
    curl --fail --location --output restore_ports.tcl \
        "https://github.com/macports/macports-contrib/raw/master/restore_ports/restore_ports.tcl" || true
    [[ -f restore_ports.tcl ]] && {
        chmod +x restore_ports.tcl
        xattr -d com.apple.quarantine restore_ports.tcl 2>/dev/null || true
        touch myports.txt requested.txt
        ./restore_ports.tcl myports.txt 2>/dev/null || true
        rm -f restore_ports.tcl
    }
    
    create_updater_script
    log_info "Installation completed!"
}

main_upgrade() {
    local os_version="$1"
    local user_name user_dir
    
    user_name=$(logname 2>/dev/null || echo "$SUDO_USER")
    user_dir="/Users/$user_name/bin/MacPorts"
    
    log_info "Upgrading MacPorts for macOS $os_version"
    
    cd "$user_dir"
    
    # Backup existing ports
    port -qv installed > myports.txt 2>/dev/null || touch myports.txt
    port echo requested | cut -d ' ' -f 1 | uniq > requested.txt 2>/dev/null || touch requested.txt
    
    setup_xcode_tools
    
    # Uninstall existing ports
    port -f uninstall installed 2>/dev/null || true
    port reclaim 2>/dev/null || true
    
    install_macports_base "$os_version"
    
    # Restore ports
    curl --fail --location --output restore_ports.tcl \
        "https://github.com/macports/macports-contrib/raw/master/restore_ports/restore_ports.tcl" && {
        chmod +x restore_ports.tcl
        xattr -d com.apple.quarantine restore_ports.tcl 2>/dev/null || true
        ./restore_ports.tcl myports.txt 2>/dev/null || true
        port unsetrequested installed 2>/dev/null || true
        xargs port setrequested < requested.txt 2>/dev/null || true
        rm -f restore_ports.tcl
    }
    
    create_updater_script
    log_info "Upgrade completed!"
}

# Create updater script
create_updater_script() {
    local user_name user_bin updater_path
    user_name=$(logname 2>/dev/null || echo "$SUDO_USER")
    user_bin="/Users/$user_name/bin"
    updater_path="$user_bin/$UPDATER_SCRIPT"
    
    mkdir -p "$user_bin"
    
    cat > "$updater_path" << 'UPDATER_EOF'
#!/bin/bash
# macports_updater.sh - Generated by macportsAssistant v3.0.0
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Error: Must be run as root (use sudo)"
    exit 1
fi

if ! command -v port >/dev/null 2>&1; then
    echo "Error: MacPorts not found"
    exit 1
fi

echo "Updating MacPorts..."
port -v selfupdate

echo "Upgrading outdated ports..."
port upgrade outdated

echo "Cleaning up..."
port uninstall inactive
port uninstall leaves
port reclaim

echo "Update completed successfully!"
UPDATER_EOF

    chmod +x "$updater_path"
    chown "$user_name:staff" "$updater_path" 2>/dev/null || true
    log_info "Updater script created: $updater_path"
}

# Main execution
main() {
    local os_version mode force_install=false update_only=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help) show_help; exit 0 ;;
            -v|--version) echo "$SCRIPT_NAME v$SCRIPT_VERSION"; exit 0 ;;
            -f|--force) force_install=true ;;
            --update-only) update_only=true ;;
            *) log_error "Unknown option: $1"; show_help; exit 1 ;;
        esac
        shift
    done
    
    log_info "$SCRIPT_NAME v$SCRIPT_VERSION starting..."
    check_privileges
    
    os_version=$(get_macos_version)
    log_info "Detected macOS $os_version"
    
    # Verify OS support
    get_macports_info "$os_version" >/dev/null || exit 1
    
    if [[ $update_only == true ]]; then
        run_update_only
        return
    fi
    
    mode=$(determine_mode)
    
    if [[ $force_install == true ]]; then
        mode="install"
    fi
    
    case "$mode" in
        install)
            log_info "Performing fresh installation"
            main_install "$os_version"
            ;;
        upgrade)
            log_info "Performing upgrade of existing installation"
            main_upgrade "$os_version"
            ;;
        external)
            log_error "MacPorts installed externally - this script only manages its own installations"
            log_info "Use --force to reinstall or --update-only to just update"
            exit 1
            ;;
    esac
    
    log_info "All operations completed successfully!"
    log_info "Use 'sudo $UPDATER_SCRIPT' to update MacPorts and ports"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi