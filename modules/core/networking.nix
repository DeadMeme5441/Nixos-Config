# modules/core/networking.nix
{ config, lib, pkgs, host, options, ... }:

{
  # networking
  networking = {
    networkmanager.enable = true;
    hostName = host;  # This will use the host variable from flake
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
  }; 

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
