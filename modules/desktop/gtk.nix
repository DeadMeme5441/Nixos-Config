# modules/desktop/gtk.nix
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # GTK/Qt theming
    gtk-engine-murrine
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.qtwayland
    kdePackages.qtstyleplugin-kvantum
  ];

  # GTK theme settings
  programs.dconf.enable = true;
  programs.seahorse.enable = true;
}
