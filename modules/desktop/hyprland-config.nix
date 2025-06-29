# modules/desktop/hyprland-config.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myconfig.desktop.hyprland;
in
{
  options.myconfig.desktop.hyprland = {
    config = {
      enable = mkEnableOption "Enable custom Hyprland configuration";
      
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra Hyprland configuration";
      };
    };
  };

  config = mkIf cfg.config.enable {
    # Create a Hyprland config file that includes monitor settings
    environment.etc."hypr/monitors.conf" = mkIf config.myconfig.desktop.monitors.enable {
      text = config.myconfig.desktop.monitors.config;
    };
  };
}
