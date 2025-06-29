# modules/applications/gaming.nix (new module for gaming)
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myconfig.applications.gaming;
in
{
  options.myconfig.applications.gaming = {
    enable = mkEnableOption "Gaming applications and optimizations";
    
    steam.enable = mkEnableOption "Steam gaming platform";
  };

  config = mkIf cfg.enable {
    programs.steam = mkIf cfg.steam.enable {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    
    # Gaming-related kernel parameters
    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
  };
}
