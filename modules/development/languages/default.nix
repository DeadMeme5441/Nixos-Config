# modules/development/languages/default.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./python.nix
    ./javascript.nix
    # Add other language modules here as you create them:
    # ./rust.nix
    # ./java.nix
    # ./haskell.nix
    # ./go.nix
  ];
}
