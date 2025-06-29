# modules/services/syncthing.nix (new module)
{ config, lib, pkgs, username, ... }:

with lib;
let
  cfg = config.myconfig.services.syncthing;
in
{
  options.myconfig.services.syncthing = {
    enable = mkEnableOption "Syncthing file synchronization";
    
    dataDir = mkOption {
      type = types.str;
      default = "/home/${username}";
      description = "Syncthing data directory";
    };
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = username;
      dataDir = cfg.dataDir;
      configDir = "${cfg.dataDir}/.config/syncthing";
    };
  };
}
