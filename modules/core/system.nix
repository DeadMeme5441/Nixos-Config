# modules/core/system.nix (updated)
{ config, lib, pkgs, options, ... }:

{
  # Set your time zone.
  services.automatic-timezoned.enable = true;
  
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Console keymap - now using the option
  console.keyMap = config.myconfig.host.keyboardLayout;

  # For Electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    QT_QPA_PLATFORM = "wayland;xcb";
    BROWSER = config.myconfig.host.browser;
    TERMINAL = config.myconfig.host.terminal;
  };

  environment.localBinInPath = true;

  # This value determines the NixOS release
  system.stateVersion = "24.11";
}
