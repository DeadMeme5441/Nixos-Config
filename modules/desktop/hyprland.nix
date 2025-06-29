# modules/desktop/hyprland.nix
{ config, lib, pkgs, inputs, ... }:

{
  programs = {
    hyprland = {
      enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };
    
    hyprlock.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Hyprland essentials
    inputs.ags.packages.${pkgs.system}.default
    brightnessctl
    cava
    cliphist
    loupe
    grim
    hypridle
    imagemagick
    jq
    kitty
    alacritty
    tmux
    starship
    networkmanagerapplet
    nwg-displays
    nwg-look
    nvtopPackages.full
    pamixer
    pavucontrol
    playerctl
    polkit_gnome
    rofi-wayland
    slurp
    swappy
    swaynotificationcenter
    swww
    wallust
    wl-clipboard
    wlogout
    yad
    yt-dlp
    zsh-powerlevel10k
    gnome-system-monitor
  ];
}
