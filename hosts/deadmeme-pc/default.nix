# hosts/deadmeme-pc/default.nix
{ config, pkgs, host, username, lib, inputs, ... }:

{
  imports = [
    # Hardware
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
    ../../modules/hardware/printing.nix
    ../../modules/hardware/vm-guest-services.nix
    ../../modules/hardware/local-hardware-clock.nix   

    # Hardware GPU drivers (updated paths)
    ../../modules/hardware/gpu/amd-drivers.nix
    ../../modules/hardware/gpu/intel-drivers.nix
    ../../modules/hardware/gpu/nvidia-drivers.nix
    ../../modules/hardware/gpu/nvidia-prime-drivers.nix

    # Development
    ../../modules/development/containers.nix
    ../../modules/development/tools.nix
    ../../modules/development/languages
    ../../modules/development/editors.nix

    # Applications
    ../../modules/applications/syncthing.nix
    ../../modules/applications/communication.nix
    ../../modules/applications/media.nix
    ../../modules/applications/file-manager.nix
    ../../modules/applications/gaming.nix
    
    # Desktop
    ../../modules/desktop/hyprland.nix   
    ../../modules/desktop/hyprland-config.nix   
    ../../modules/desktop/monitors.nix
    ../../modules/desktop/gtk.nix

    # User configuration
    ../../modules/users/base.nix
    ../../modules/users/deadmeme.nix
  ];


  # Configure the options
  myconfig = {
    # User modules
    users = {
      base.enable = true;
      deadmeme.enable = true;
    };
    
    # Host configuration (overrides defaults if needed)
    host = {
      # These are already set to your values as defaults, but you can override here
      terminal = "alacritty";  # You had this in your variables.nix
      gitUsername = "DeadMeme5441";
      gitEmail = "deadunderscorememe@gmail.com";
      browser = "firefox";
      keyboardLayout = "us";
    };
    

    # Desktop configuration
    desktop = {
      waybar.clock24h = true;
      hyprland = {
        extraMonitorSettings = "";
        config.enable = true;
      };
    };
    
    # Development configuration
    development = {
      docker.enable = true;  # Enable Docker for this host
    };
    
    # Applications
    applications = {
      gaming = {
        enable = false;  # Disable gaming for now
        steam.enable = false;
      };
    };
    
    # Hardware
    hardware = {
      printing.enable = false;  # Disable printing for now
    };
    
    # Services
    services = {
      syncthing.enable = false;  # Disable syncthing for now
    };
  };
}
