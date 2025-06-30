# modules/development/languages/javascript.nix
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # fnm - Fast Node Manager for managing Node.js versions
    fnm
    
    # Bun - all-in-one JavaScript runtime & toolkit
    bun
    
    # Yarn - Package manager (as a fallback/system-wide option)
    yarn
    
    # pnpm - Fast, disk space efficient package manager
    pnpm
  ];

  # Shell configuration for fnm
  programs.zsh.interactiveShellInit = ''
    # fnm initialization
    eval "$(fnm env --use-on-cd)"
  '';
}
