# modules/development/languages.nix
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
    python-packages
    pkgs.uv
  ];
}
