# modules/core/programs.nix
{ config, lib, pkgs, ... }:

{
    programs = {
    firefox.enable = true;
    git.enable = true;
    nm-applet.indicator = true;
    waybar.enable = true;

    virt-manager.enable = false;

    xwayland.enable = true;

    fuse.userAllowOther = true;
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
      ];
    };

    };


    # Extra Portal Configuration
    xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
        ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
        ];
    };
}
