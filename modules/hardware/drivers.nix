# modules/hardware/drivers.nix
{ config, lib, pkgs, ... }:

{
  # Extra Module Options
  drivers = {
    amdgpu.enable = false;
    intel.enable = true;
    nvidia.enable = true;
    nvidia-prime = {
      enable = false;
      intelBusID = "";
      nvidiaBusID = "";
    };
  };
  
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;
}
