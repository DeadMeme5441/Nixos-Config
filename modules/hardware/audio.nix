# modules/hardware/audio.nix
{ config, lib, pkgs, ... }:

{
  # Sound and audio configuration
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Disable pulseaudio as we're using pipewire
  services.pulseaudio.enable = false;

  # Security for audio (realtime kit)
  security.rtkit.enable = true;
}
