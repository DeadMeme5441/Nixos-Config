# modules/core/options.nix
{ config, lib, ... }:

with lib;
{
  options.myconfig = {
    host = {
      gitUsername = mkOption {
        type = types.str;
        default = "DeadMeme5441";
        description = "Git username for repositories";
      };
      
      gitEmail = mkOption {
        type = types.str;
        default = "deadunderscorememe@gmail.com";
        description = "Git email for repositories";
      };
      
      browser = mkOption {
        type = types.str;
        default = "firefox";
        description = "Default browser";
      };
      
      terminal = mkOption {
        type = types.str;
        default = "alacritty";
        description = "Default terminal emulator";
      };
      
      keyboardLayout = mkOption {
        type = types.str;
        default = "us";
        description = "Keyboard layout";
      };
    };
    
    desktop = {
      waybar = {
        clock24h = mkOption {
          type = types.bool;
          default = true;
          description = "Use 24-hour clock in Waybar";
        };
      };
      
      hyprland = {
        extraMonitorSettings = mkOption {
          type = types.str;
          default = "";
          description = "Extra monitor configuration for Hyprland";
        };
      };
    };
  };
}
