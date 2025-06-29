# Migration Mapping

This documents where configuration will move from the monolithic files to modules.

## From hosts/deadmeme-pc/config.nix:

### To modules/core/boot.nix:
- boot.* configuration
- Plymouth settings

### To modules/core/nix.nix:
- nix.* settings
- Cachix configuration
- Garbage collection

### To modules/core/system.nix:
- Time zone settings
- Locale configuration
- Basic system packages (curl, wget, git, etc.)

### To modules/core/networking.nix:
- networking.* configuration
- SSH settings

### To modules/hardware/nvidia.nix:
- All Nvidia-related configuration
- OpenGL settings specific to Nvidia

### To modules/hardware/audio.nix:
- Pipewire configuration
- Audio-related services

### To modules/development/containers.nix:
- Docker configuration
- Container-related settings

## From hosts/deadmeme-pc/packages-fonts.nix:

### To modules/development/editors.nix:
- neovim, emacs, vscode

### To modules/development/tools.nix:
- git, ripgrep, tree, etc.

### To modules/applications/communication.nix:
- discord, teams-for-linux, ferdium

### To modules/applications/browsers.nix:
- firefox (already using programs.firefox)
