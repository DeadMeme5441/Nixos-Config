# modules/applications/communication.nix
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    teams-for-linux
    ferdium
  ];
}
