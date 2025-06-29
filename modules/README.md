# NixOS Configuration Modules

This directory contains modular NixOS configuration files organized by functionality.

## Structure

- `core/` - Essential system configuration (boot, nix daemon, networking)
- `hardware/` - Hardware-specific modules (GPU drivers, audio, bluetooth)
- `desktop/` - Desktop environment configuration (Hyprland, Waybar, themes)
- `development/` - Development tools and environments
- `applications/` - User applications organized by category
- `users/` - User-specific configurations

## Usage

Each module should follow this pattern:
1. Use `mkEnableOption` for optional features
2. Properly scope configuration with `mkIf`
3. Document options clearly
4. Keep modules focused on a single concern
