# modules/development/containers.nix 
{ config, lib, pkgs, username, ... }:

with lib;
let
  cfg = config.myconfig.development.docker;
in
{
  options.myconfig.development.docker = {
    enable = mkEnableOption "Docker development environment";
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;

      daemon.settings = {
        experimental = true;
        features = {
          buildkit = true;
        };
      };
    };

    virtualisation.libvirtd.enable = false;
    
    # Automatically add user to docker group
    users.users.${username}.extraGroups = [ "docker" ];
  };
}
