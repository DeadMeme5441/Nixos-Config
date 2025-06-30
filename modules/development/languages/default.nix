# modules/development/languages/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./python.nix
    ./javascript.nix
    ./rust.nix
    ./go.nix
    ./java.nix
    # Add other language modules here as you create them:
    # ./haskell.nix
  ];
}
