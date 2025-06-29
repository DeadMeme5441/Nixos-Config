# modules/development/containers.nix
{ config, lib, pkgs, username, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    # Set up resource limits
    daemon.settings = {
      experimental = true;
      features = {
        buildkit = true;
      };
    };
  };

  # Virtualization / Containers
  virtualisation.libvirtd.enable = false;

  # Add user to docker group (this is handled in users.nix but we'll make it conditional)
  # users.users.${username}.extraGroups = [ "docker" ];
}
