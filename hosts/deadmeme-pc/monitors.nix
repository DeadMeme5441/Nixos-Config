# hosts/deadmeme-pc/monitors.nix
{ config, lib, ... }:

{
  myconfig.desktop.monitors = {
    enable = true;
    primary = "DP-1";  # Adjust to your actual primary monitor
    
    # Configure your 3-monitor setup here
    # This is an example - adjust to your actual monitor setup
    config = ''
      # Monitor configuration for 3-monitor setup
      # Format: monitor=name,resolution@refreshrate,position,scale
      
      # Left monitor
      monitor=DP-2,2560x1440@144,0x0,1
      
      # Center monitor (primary)
      monitor=DP-1,2560x1440@144,2560x0,1
      
      # Right monitor  
      monitor=HDMI-A-1,2560x1440@144,5120x0,1
      
      # Fallback for any other connected monitors
      monitor=,preferred,auto,1
    '';
  };
}
