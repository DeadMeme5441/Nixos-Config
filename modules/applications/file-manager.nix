# modules/applications/file-manager.nix
{ config, lib, pkgs, ... }:

{
  programs = {
    thunar.enable = true;
    thunar.plugins = with pkgs.xfce; [
      exo
      mousepad
      thunar-archive-plugin
      thunar-volman
      tumbler
    ];
  };
}
