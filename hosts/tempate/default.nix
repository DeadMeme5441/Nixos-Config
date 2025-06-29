# hosts/template/default.nix
{ config, pkgs, host, username, lib, inputs, ... }:

{
  imports = [
    # Hardware (will be generated)
    ./hardware.nix
    
    # Core system modules
    ../../modules/core/options.nix
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
    ../../modules/hardware/vm-guest-services.nix
    ../../modules/hardware/local-hardware-clock.nix
   
    # Hardware GPU drivers
    ../../modules/hardware/gpu/amd-drivers.nix
    ../../modules/hardware/gpu/intel-drivers.nix
    ../../modules/hardware/gpu/nvidia-drivers.nix
    ../../modules/hardware/gpu/nvidia-prime-drivers.nix
    
    # Development
    ../../modules/development/containers.nix
    ../../modules/development/tools.nix
    ../../modules/development/languages.nix
    ../../modules/development/editors.nix

    # Applications
    ../../modules/applications/communication.nix
    ../../modules/applications/media.nix
    ../../modules/applications/file-manager.nix
    ../../modules/applications/gaming.nix
    ../../modules/applications/syncthing.nix

    # Desktop
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/hyprland-config.nix
    ../../modules/desktop/monitors.nix
    ../../modules/desktop/gtk.nix   

    # User configuration
    ../../modules/users/base.nix
  ];

  # Configure the options
  myconfig = {
    # User modules
    users = {
      base.enable = true;
    };
    
    # Host configuration (defaults)
    host = {
      terminal = "kitty";
      keyboardLayout = "us";
    };
    
    # Desktop configuration
    desktop = {
      waybar.clock24h = true;
      hyprland = {
        config.enable = true;
      };
    };
    
    # Development configuration
    development = {
      docker.enable = false;
    };
    
    # Applications
    applications = {
      gaming = {
        enable = false;
        steam.enable = false;
      };
      syncthing.enable = false;
    };
    
    # Hardware
    hardware = {
      printing.enable = false;
    };
  };
}
