# modules/desktop/monitors.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myconfig.desktop.monitors;
in
{
  options.myconfig.desktop.monitors = {
    enable = mkEnableOption "Enable monitor configuration";
    
    primary = mkOption {
      type = types.str;
      default = "";
      description = "Primary monitor name";
    };
    
    config = mkOption {
      type = types.lines;
      default = "";
      description = "Hyprland monitor configuration";
    };
  };

  config = mkIf cfg.enable {
    # This will be used by Hyprland config
    environment.sessionVariables = mkIf (cfg.primary != "") {
      HYPRLAND_PRIMARY_MONITOR = cfg.primary;
    };
  };
}
