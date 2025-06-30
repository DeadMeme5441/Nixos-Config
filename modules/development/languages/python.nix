# modules/development/languages/python.nix
{ config, lib, pkgs, ... }:

let
  python-packages = pkgs.python3.withPackages (
    ps: with ps; [
      requests
      pyquery # needed for hyprland-dots Weather script
      pip
      setuptools
      wheel
      virtualenv
    ]
  );
in {
  environment.systemPackages = [
    # Keep the python with packages for system needs (like hyprland-dots)
    python-packages
    # uv for managing development Python environments
    pkgs.uv
  ];
}
