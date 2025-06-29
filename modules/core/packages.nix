# modules/core/packages.nix
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # System Packages
    bc
    baobab
    btrfs-progs
    clang
    curl
    cpufrequtils
    duf
    findutils
    ffmpeg   
    glib #for gsettings to work
    gsettings-qt
    killall  
    libappindicator
    libnotify
    openssl #required by Rainbow borders
    pciutils
    wget
    xdg-user-dirs
    xdg-utils
    ranger

    
    # System monitoring
    fastfetch
    btop
    inxi
    
    # Archive tools
    unzip
    xarchiver
  ];
}
