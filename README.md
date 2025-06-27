# macportsAssistant

**A modern, unified macOS package manager installer for MacPorts**

[![macOS](https://img.shields.io/badge/macOS-10.12%2B-blue)](https://www.apple.com/macos/)
[![Version](https://img.shields.io/badge/version-3.0.0-green)](VERSION)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue)](COPYING)

## Quick Start

```bash
# Download and run - that's it!
sudo ./macportsAssistant.sh
```

The script automatically detects your system and does the right thing:
- 🆕 **Fresh installation** if MacPorts isn't installed
- ⬆️ **Smart upgrade** if you have an existing macportsAssistant installation  
- 🔄 **Update only** with `--update-only` flag

## Features

- ✅ **Zero Configuration** - Automatically detects what needs to be done
- 🎯 **Intelligent** - Knows the difference between install, upgrade, and update
- 🛡️ **Safe** - Backs up your ports before upgrades
- 🎨 **Modern** - Colorized output with clear progress indicators
- 🔧 **Robust** - Comprehensive error handling and recovery
- 📱 **Compatible** - Supports macOS 10.12 Sierra through macOS 15 Sequoia

## System Requirements

- macOS 10.12 Sierra or later
- Administrator privileges (`sudo`)
- Internet connection
- Xcode Command Line Tools (installed automatically if needed)

## Usage

### Basic Usage (Recommended)
```bash
# Let the script decide what to do
sudo ./macportsAssistant.sh
```

### Advanced Options
```bash
# Show help
sudo ./macportsAssistant.sh --help

# Force reinstallation
sudo ./macportsAssistant.sh --force

# Only update existing installation
sudo ./macportsAssistant.sh --update-only

# Show version
sudo ./macportsAssistant.sh --version
```

### Regular Maintenance
After installation, keep MacPorts updated with:
```bash
sudo ~/bin/macports_updater.sh
```

## What It Does

1. **🔍 Detection Phase**
   - Checks if MacPorts is installed
   - Determines if it was installed by macportsAssistant
   - Identifies your macOS version

2. **⚙️ Setup Phase**
   - Creates `~/bin/MacPorts` working directory
   - Installs/updates Xcode Command Line Tools
   - Downloads appropriate MacPorts version for your macOS

3. **📦 Installation/Upgrade Phase**
   - **New Install**: Fresh MacPorts installation
   - **Upgrade**: Backs up ports → Reinstalls MacPorts → Restores ports
   - **Update**: Updates MacPorts and all installed ports

4. **🔧 Maintenance Phase**
   - Creates updater script in `~/bin/`
   - Sets up proper permissions and ownership
   - Adds directories to PATH

## Directory Structure

```
macportsAssistant/
├── macportsAssistant.sh          # ← Main script (start here!)
├── macports_updater.sh            # Modern updater template
├── README.md                      # This file
├── CHANGELOG.md                   # Version history
├── VERSION                        # Current version info
├── legacy/                        # Legacy scripts for compatibility
│   ├── README.md                  # Legacy documentation
│   ├── macports_assistant_install.sh
│   ├── macports_assistant_upgrade.sh
│   └── macports_updater_legacy.sh
└── [documentation files...]
```

## Legacy Scripts

The original individual scripts are preserved in the `legacy/` directory for backward compatibility. New users should use the unified `macportsAssistant.sh` script.

## Troubleshooting

**Permission Errors**
```bash
# Ensure you're using sudo
sudo ./macportsAssistant.sh
```

**Download Failures**
- Check internet connection
- Try again (temporary network issues)
- Check if GitHub is accessible

**Xcode Issues**
```bash
# Manually install if automatic installation fails
xcode-select --install
```

**Port Restoration Issues**
- Backup files are saved in `~/bin/MacPorts/`
- Manually restore using: `sudo port install $(cat ~/bin/MacPorts/myports.txt)`

## Version Information

- **Current Version**: 3.0.0 (Unified script) / 2.2.2 (Legacy scripts)
- **Supported macOS**: 10.12 Sierra through 15 Sequoia
- **MacPorts Versions**: Automatically selects latest compatible version

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## Development

The project follows modern development practices:
- **Error Handling**: `set -euo pipefail` for robust bash scripting
- **Code Style**: `.editorconfig` for consistent formatting
- **Version Control**: Proper `.gitignore` and `.gitattributes`
- **Documentation**: Comprehensive changelog and docs

See [CONTRIBUTING](CONTRIBUTING) for contribution guidelines.

## Support

If you encounter issues:
1. Check [CHANGELOG.md](CHANGELOG.md) for known issues
2. Verify system requirements
3. Try `--force` for problematic installations
4. Report bugs following [BUGS](BUGS) guidelines

## License

GNU General Public License v3.0 - see [COPYING](COPYING) for details.

---

**Hoyt Harness** • [Positronikal](https://positronikal.github.io/) • [Email](mailto:hoyt.harness@gmail.com) • 2023-2024
