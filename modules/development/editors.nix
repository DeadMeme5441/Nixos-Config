# modules/development/editors.nix
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    emacs
    vscode
  ];
}
