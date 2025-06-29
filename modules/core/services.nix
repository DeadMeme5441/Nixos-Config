# modules/core/services.nix
{ config, lib, pkgs, username, ... }:

{
  # Services to start
  services = {
    xserver = {
      enable = false;
      xkb = {
        layout = "us";  # We'll make this configurable later
        variant = "";
      };
    };
    
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland"; # start Hyprland with a TUI login manager
        };
      };
    };
    
    smartd = {
      enable = false;
      autodetect = true;
    };
    
    gvfs.enable = true;
    tumbler.enable = true;

    udev.enable = true;
    envfs.enable = true;
    dbus.enable = true;

    fstrim = {
      enable = true;
      interval = "weekly";
    };
  
    libinput.enable = true;

    rpcbind.enable = false;
    nfs.server.enable = false;
  
    flatpak.enable = false;

    fwupd.enable = true;
    upower.enable = true;
    
    gnome.gnome-keyring.enable = true;
  };
  
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}

