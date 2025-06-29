# modules/hardware/printing.nix (new module)
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myconfig.hardware.printing;
in
{
  options.myconfig.hardware.printing = {
    enable = mkEnableOption "Printing support";
    
    drivers = mkOption {
      type = types.listOf types.package;
      default = [];
      example = [ pkgs.hplipWithPlugin ];
      description = "Additional printer drivers";
    };
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = cfg.drivers;
    };
    
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    
    services.ipp-usb.enable = true;
    
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
    };
  };
}
