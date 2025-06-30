# modules/development/languages/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./python.nix
    ./javascript.nix
    ./rust.nix
    ./go.nix
    ./java.nix
  ];
}
