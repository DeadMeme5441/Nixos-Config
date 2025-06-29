# modules/applications/media.nix
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (mpv.override {scripts = [mpvScripts.mpris];}) # with tray
    spotify
    stremio
  ];
}
