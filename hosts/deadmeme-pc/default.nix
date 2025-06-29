# hosts/deadmeme-pc/default.nix
{ config, pkgs, host, username, lib, inputs, ... }:

{
  imports = [
    # Hardware
    ./hardware.nix
    
    # Core system modules
    ../../modules/core/boot.nix
    ../../modules/core/fonts.nix
    ../../modules/core/system.nix
    ../../modules/core/networking.nix
    ../../modules/core/nix.nix
    ../../modules/core/security.nix
    ../../modules/core/services.nix
    ../../modules/core/packages.nix
    ../../modules/core/programs.nix
    
    # Hardware modules
    ../../modules/hardware/audio.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/hardware/drivers.nix
    ../../modules/hardware/system.nix
    
    # Hardware drivers (from original)
    ../../modules/amd-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
    
    # Development
    ../../modules/development/containers.nix
    ../../modules/development/tools.nix
    ../../modules/development/languages.nix
    ../../modules/development/editors.nix

    # Applications
    ../../modules/applications/communication.nix
    ../../modules/applications/media.nix
    ../../modules/applications/file-manager.nix

    # Desktop
    ../../modules/desktop/hyprland.nix   
    ../../modules/desktop/gtk.nix   

    # User configuration
    ./users.nix
  ];

  # Desktop-specific settings (3 monitors, etc) can go here later
}
