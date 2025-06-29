# modules/users/base.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myconfig.users;
in
{
  options.myconfig.users = {
    base = {
      enable = mkEnableOption "Enable base user configuration";
      
      defaultShell = mkOption {
        type = types.package;
        default = pkgs.zsh;
        description = "Default shell for users";
      };
      
      baseGroups = mkOption {
        type = types.listOf types.str;
        default = [
          "networkmanager"
          "wheel"
          "video" 
          "input" 
          "audio"
        ];
        description = "Base groups for all users";
      };
    };
  };

  config = mkIf cfg.base.enable {
    users.defaultUserShell = cfg.base.defaultShell;
    environment.shells = [ cfg.base.defaultShell ];
    users.mutableUsers = true;
  };
}
