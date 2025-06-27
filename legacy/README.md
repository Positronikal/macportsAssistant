# Legacy Scripts

This directory contains the original macportsAssistant scripts for backward compatibility and reference.

## Files

- **`macports_assistant_install.sh`** - Original installation script (v2.2.2)
- **`macports_assistant_upgrade.sh`** - Original upgrade script (v2.2.2)  
- **`macports_updater_legacy.sh`** - Original updater script (v2.2.2)

## Usage

These scripts work exactly as they did before, but new users should use the unified `macportsAssistant.sh` in the parent directory instead.

### Legacy Installation
```bash
sudo ./legacy/macports_assistant_install.sh
```

### Legacy Upgrade
```bash
sudo ./legacy/macports_assistant_upgrade.sh
```

### Legacy Update
```bash
sudo ./legacy/macports_updater_legacy.sh
```

## Migration

If you're currently using the legacy scripts, you can seamlessly switch to the modern unified script:

```bash
# The new script will detect your existing installation
sudo ./macportsAssistant.sh
```

## Why Keep These?

1. **Backward Compatibility** - Existing users can continue using familiar scripts
2. **Reference** - Shows the evolution of the project
3. **Debugging** - Helps isolate issues during migration
4. **Documentation** - Preserves institutional knowledge

For new installations, please use `macportsAssistant.sh` in the parent directory.
