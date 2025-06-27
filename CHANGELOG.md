# Changelog

All notable changes to macportsAssistant will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.2] - 2024-12-27

### Fixed
- Fixed syntax error: Changed `Echo` to `echo` in install script
- Fixed double redirect issue: `echo >> $updtr >> $updtr` to `echo >> $updtr`
- Fixed logic flaw in upgrade script's updater creation
- Standardized OS version detection using `sw_vers -productVersion`

### Changed
- Updated MacPorts to v2.10.4 for macOS 12-14 (was v2.8.1)
- Improved updater script with better error handling and bash features
- Updated version documentation for consistency across all files
- Enhanced code comments and structure

### Added
- Added `.editorconfig`, `.gitattributes`, and `.gitignore` for better development workflow
- Added this CHANGELOG.md for tracking changes
- Improved error handling in updater script with `set -euo pipefail`
- Better progress messaging in updater script

## [2.2.1] - 2024-11-06

### Fixed
- Minor post-upgrade bug fixes

## [2.2.0] - 2024-11-06

### Added
- Added support for macOS 15 Sequoia

## [2.1.0] - 2023-11-16

### Fixed
- Minor syntax corrections

## [2.0.0] - 2023-11-16

### Added
- First stable release with support for macOS 10.14 through 14.0

## [1.0.0] - 2023-02-15

### Added
- Initial release
- Basic MacPorts installation and upgrade functionality
