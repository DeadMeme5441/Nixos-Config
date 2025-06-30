# modules/development/languages/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./python.nix
    ./javascript.nix
    ./rust.nix
    ./go.nix
    # Add other language modules here as you create them:
    # ./java.nix
    # ./haskell.nix
  ];
}
