#!/usr/bin/env bash
# 💫 https://github.com/JaKooLit 💫 #

clear

printf "\n%.0s" {1..2}  
echo -e "\e[35m
	╦╔═┌─┐┌─┐╦    ╦ ╦┬ ┬┌─┐┬─┐┬  ┌─┐┌┐┌┌┬┐
	╠╩╗│ ││ │║    ╠═╣└┬┘├─┘├┬┘│  ├─┤│││ ││ 2025
	╩ ╩└─┘└─┘╩═╝  ╩ ╩ ┴ ┴  ┴└─┴─┘┴ ┴┘└┘─┴┘ 
\e[0m"
printf "\n%.0s" {1..1}

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

set -e

if [ -n "$(grep -i nixos < /etc/os-release)" ]; then
  echo "${OK} Verified this is NixOS."
  echo "-----"
else
  echo "$ERROR This is not NixOS or the distribution information is not available."
  exit 1
fi

if command -v git &> /dev/null; then
  echo "$OK Git is installed, continuing with installation."
  echo "-----"
else
  echo "$ERROR Git is not installed. Please install Git and try again."
  echo "Example: nix-shell -p git"
  exit 1
fi

echo "$NOTE Ensure In Home Directory"
cd || exit

echo "-----"

backupname=$(date "+%Y-%m-%d-%H-%M-%S")
if [ -d "NixOS-Hyprland" ]; then
  echo "$NOTE NixOS-Hyprland exists, backing up to NixOS-Hyprland-backups directory."
  if [ -d "NixOS-Hyprland-backups" ]; then
    echo "Moving current version of NixOS-Hyprland to backups directory."
    sudo mv "$HOME"/NixOS-Hyprland NixOS-Hyprland-backups/"$backupname"
    sleep 1
  else
    echo "$NOTE Creating the backups directory & moving NixOS-Hyprland to it."
    mkdir -p NixOS-Hyprland-backups
    sudo mv "$HOME"/NixOS-Hyprland NixOS-Hyprland-backups/"$backupname"
    sleep 1
  fi
else
  echo "$OK Thank you for choosing KooL's NixOS-Hyprland"
fi

echo "-----"

echo "$NOTE Cloning & Entering NixOS-Hyprland Repository"
git clone --depth 1 https://github.com/JaKooLit/NixOS-Hyprland.git ~/NixOS-Hyprland
cd ~/NixOS-Hyprland || exit

printf "\n%.0s" {1..2}

# Create a hardware config string for detected settings
HARDWARE_CONFIG=""

# Checking if running on a VM and enable in hardware config
if hostnamectl | grep -q 'Chassis: vm'; then
  echo "${NOTE} Your system is running on a VM. Enabling guest services.."
  echo "${WARN} A Kind reminder to enable 3D acceleration.."
  HARDWARE_CONFIG="${HARDWARE_CONFIG}  vm.guest-services.enable = true;\n"
fi
printf "\n%.0s" {1..1}

# Checking if system has nvidia gpu and enable in hardware config
if command -v lspci > /dev/null 2>&1; then
  # lspci is available, proceed with checking for GPUs
  if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    echo "${NOTE} Nvidia GPU detected. Setting up for nvidia..."
    HARDWARE_CONFIG="${HARDWARE_CONFIG}  drivers.nvidia.enable = true;\n"
  fi
  
  # Check for Intel GPU
  if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq intel; then
    echo "${NOTE} Intel GPU detected. Setting up for intel..."
    HARDWARE_CONFIG="${HARDWARE_CONFIG}  drivers.intel.enable = true;\n"
  fi
  
  # Check for AMD GPU
  if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq amd; then
    echo "${NOTE} AMD GPU detected. Setting up for amd..."
    HARDWARE_CONFIG="${HARDWARE_CONFIG}  drivers.amdgpu.enable = true;\n"
  fi
fi

echo "-----"
printf "\n%.0s" {1..1}

# Aylurs GTK Shell v1 installation option
read -p "${CAT} Do you want to add ${MAGENTA}AGS or aylur's gtk shell v1${RESET} for Desktop Overview Like? (Y/n): " answer

answer=${answer:-Y}
AGS_ENABLED=true

if [[ "$answer" =~ ^[Nn]$ ]]; then
    # Comment out AGS in flake.nix
    sed -i 's|^\([[:space:]]*\)ags.url = "github:aylur/ags/v1";|\1#ags.url = "github:aylur/ags/v1";|' flake.nix
    AGS_ENABLED=false
fi

echo "-----"
printf "\n%.0s" {1..1}

echo "$NOTE Default options are in brackets []"
echo "$NOTE Just press ${MAGENTA}ENTER${RESET} to select the default"
sleep 1

echo "-----"

read -rp "$CAT Enter Your New Hostname: [ default ] " hostName
if [ -z "$hostName" ]; then
  hostName="default"
fi

echo "-----"

# Check if template exists, if not create from default/deadmeme-pc
if [ ! -d "hosts/template" ]; then
  echo "$NOTE Template directory not found, creating from existing configuration..."
  if [ -d "hosts/default" ]; then
    cp -r hosts/default hosts/template
    # Clean up any hardware-specific files from template
    rm -f hosts/template/hardware.nix hosts/template/hardware-config.nix 2>/dev/null || true
  elif [ -d "hosts/deadmeme-pc" ]; then
    cp -r hosts/deadmeme-pc hosts/template
    # Clean up any hardware-specific files from template
    rm -f hosts/template/hardware.nix hosts/template/hardware-config.nix hosts/template/monitors.nix 2>/dev/null || true
    # Remove user-specific imports from template
    sed -i '/monitors\.nix/d' hosts/template/default.nix
    sed -i '/deadmeme\.nix/d' hosts/template/default.nix
    sed -i '/deadmeme\.enable = true;/d' hosts/template/default.nix
  else
    echo "$ERROR No template or existing configuration found!"
    exit 1
  fi
fi

# Create directory for the new hostname
if [ "$hostName" = "template" ]; then
  echo "$ERROR Cannot use 'template' as hostname. Please choose a different name."
  exit 1
elif [ "$hostName" != "default" ]; then
  echo "${NOTE} Creating configuration for ${hostName}..."
  mkdir -p hosts/"$hostName"
  cp -r hosts/template/* hosts/"$hostName"/ 2>/dev/null || true
  
  # Create hardware-config.nix with detected settings
  cat > hosts/"$hostName"/hardware-config.nix <<EOF
# Hardware-specific configuration detected by installer
{ config, lib, ... }:

{
${HARDWARE_CONFIG}  # Default to false if nothing detected
  drivers.amdgpu.enable = lib.mkDefault false;
  drivers.intel.enable = lib.mkDefault false;
  drivers.nvidia.enable = lib.mkDefault false;
  vm.guest-services.enable = lib.mkDefault false;
  local.hardware-clock.enable = lib.mkDefault false;
}
EOF

  # Update default.nix to import hardware-config.nix if not already there
  if ! grep -q "hardware-config.nix" hosts/"$hostName"/default.nix; then
    sed -i '/\.\/hardware\.nix/a \    ./hardware-config.nix' hosts/"$hostName"/default.nix
  fi
else
  echo "Using default hostname configuration."
  if [ ! -d "hosts/default" ]; then
    mkdir -p hosts/default
    cp -r hosts/template/* hosts/default/ 2>/dev/null || true
    
    # Create hardware-config.nix for default
    cat > hosts/default/hardware-config.nix <<EOF
# Hardware-specific configuration detected by installer
{ config, lib, ... }:

{
${HARDWARE_CONFIG}  # Default to false if nothing detected
  drivers.amdgpu.enable = lib.mkDefault false;
  drivers.intel.enable = lib.mkDefault false;
  drivers.nvidia.enable = lib.mkDefault false;
  vm.guest-services.enable = lib.mkDefault false;
  local.hardware-clock.enable = lib.mkDefault false;
}
EOF

    if ! grep -q "hardware-config.nix" hosts/default/default.nix; then
      sed -i '/\.\/hardware\.nix/a \    ./hardware-config.nix' hosts/default/default.nix
    fi
  fi
fi

echo "-----"

read -rp "$CAT Enter your keyboard layout: [ us ] " keyboardLayout
if [ -z "$keyboardLayout" ]; then
  keyboardLayout="us"
fi

# Update keyboard layout in the host config
if grep -q "keyboardLayout = " hosts/"$hostName"/default.nix; then
  sed -i "s/keyboardLayout = \"[^\"]*\";/keyboardLayout = \"$keyboardLayout\";/" hosts/"$hostName"/default.nix
else
  # Add keyboard layout to the host configuration section
  sed -i "/host = {/a \      keyboardLayout = \"$keyboardLayout\";" hosts/"$hostName"/default.nix
fi

echo "-----"

installusername=$(echo $USER)
sed -i 's/username\s*=\s*"\([^"]*\)"/username = "'"$installusername"'"/' ./flake.nix

# Create user-specific module if it doesn't exist
if [ ! -f "modules/users/${installusername}.nix" ]; then
  echo "${NOTE} Creating user module for ${installusername}..."
  cat > modules/users/"${installusername}".nix <<EOF
# User configuration for ${installusername}
{ config, lib, pkgs, username, ... }:

with lib;
let
  cfg = config.myconfig.users.${installusername};
  gitUsername = config.myconfig.host.gitUsername;
in
{
  options.myconfig.users.${installusername} = {
    enable = mkEnableOption "Enable ${installusername} user configuration";
  };

  config = mkIf (cfg.enable && username == "${installusername}") {
    users.users.\${username} = {
      homeMode = "755";
      isNormalUser = true;
      description = gitUsername;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video" 
        "input" 
        "audio"
      ];
      packages = with pkgs; [];
    };
    
    # Add basic zsh configuration for new users
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "funky";
      };
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      
      promptInit = ''
        fastfetch -c \$HOME/.config/fastfetch/config-compact.jsonc
        
        # Set-up icons for files/directories in terminal using lsd
        alias ls='lsd'
        alias l='ls -l'
        alias la='ls -a'
        alias lla='ls -la'
        alias lt='ls --tree'

        source <(fzf --zsh);
        HISTFILE=~/.zsh_history;
        HISTSIZE=10000;
        SAVEHIST=10000;
        setopt appendhistory;
      '';
    };
  };
}
EOF

  # Update the host config to import and enable the user
  if ! grep -q "${installusername}.nix" hosts/"$hostName"/default.nix; then
    sed -i "/modules\/users\/base.nix/a \    ../../modules/users/${installusername}.nix" hosts/"$hostName"/default.nix
  fi
  
  if ! grep -q "${installusername}.enable = true;" hosts/"$hostName"/default.nix; then
    sed -i "/base.enable = true;/a \      ${installusername}.enable = true;" hosts/"$hostName"/default.nix
  fi
fi

# Handle AGS in the host configuration
if [ "$AGS_ENABLED" = false ]; then
  # Comment out AGS import in desktop modules
  sed -i 's|inputs.ags.packages.${pkgs.system}.default|#inputs.ags.packages.${pkgs.system}.default|' modules/desktop/hyprland.nix
fi

echo "$NOTE Generating The Hardware Configuration"
attempts=0
max_attempts=3
hardware_file="./hosts/$hostName/hardware.nix"

while [ $attempts -lt $max_attempts ]; do
  sudo nixos-generate-config --show-hardware-config > "$hardware_file" 2>/dev/null

  if [ -f "$hardware_file" ]; then
    echo "${OK} Hardware configuration successfully generated."
    break
  else
    echo "${WARN} Failed to generate hardware configuration. Attempt $(($attempts + 1)) of $max_attempts."
    attempts=$(($attempts + 1))

    # Exit if this was the last attempt
    if [ $attempts -eq $max_attempts ]; then
      echo "${ERROR} Unable to generate hardware configuration after $max_attempts attempts."
      exit 1
    fi
  fi
done

echo "-----"

echo "$NOTE Setting Required Nix Settings Then Going To Install"
git config --global user.name "installer"
git config --global user.email "installer@gmail.com"
git add .
sed -i 's/host\s*=\s*"\([^"]*\)"/host = "'"$hostName"'"/' ./flake.nix

printf "\n%.0s" {1..2}

echo "$NOTE Rebuilding NixOS..... so pls be patient.."
echo "-----"
echo "$CAT In the meantime, go grab a coffee and stretch your legs or atleast do something!!..."
echo "-----"
echo "$ERROR YES!!! YOU read it right!!.. you staring too much at your monitor ha ha... joke :)......"
printf "\n%.0s" {1..2}
echo "-----"
printf "\n%.0s" {1..1}

# Set the Nix configuration for experimental features
NIX_CONFIG="experimental-features = nix-command flakes"
#sudo nix flake update
sudo nixos-rebuild switch --flake ~/NixOS-Hyprland/#"${hostName}"

echo "-----"
printf "\n%.0s" {1..2}

# for initial zsh
# Check if ~/.zshrc and  exists, create a backup, and copy the new configuration
if [ -f "$HOME/.zshrc" ]; then
 	cp -b "$HOME/.zshrc" "$HOME/.zshrc-backup" || true
fi

# Copying the preconfigured zsh themes and profile
cp -r 'assets/.zshrc' ~/

# GTK Themes and Icons installation
printf "Installing GTK-Themes and Icons..\n"

if [ -d "GTK-themes-icons" ]; then
    echo "$NOTE GTK themes and Icons directory exist..deleting..." 
    rm -rf "GTK-themes-icons" 
fi

echo "$NOTE Cloning GTK themes and Icons repository..." 
if git clone --depth 1 https://github.com/JaKooLit/GTK-themes-icons.git ; then
    cd GTK-themes-icons
    chmod +x auto-extract.sh
    ./auto-extract.sh
    cd ..
    echo "$OK Extracted GTK Themes & Icons to ~/.icons & ~/.themes directories" 
else
    echo "$ERROR Download failed for GTK themes and Icons.." 
fi

echo "-----"
printf "\n%.0s" {1..2}

 # Check for existing configs and copy if does not exist
for DIR1 in gtk-3.0 Thunar xfce4; do
  DIRPATH=~/.config/$DIR1
  if [ -d "$DIRPATH" ]; then
    echo -e "${NOTE} Config for $DIR1 found, no need to copy." 
  else
    echo -e "${NOTE} Config for $DIR1 not found, copying from assets." 
    cp -r assets/$DIR1 ~/.config/ && echo "Copy $DIR1 completed!" || echo "Error: Failed to copy $DIR1 config files."
  fi
done

echo "-----"
printf "\n%.0s" {1..3}

# Clean up
# GTK Themes and Icons
if [ -d "GTK-themes-icons" ]; then
    echo "$NOTE GTK themes and Icons directory exist..deleting..." 
    rm -rf "GTK-themes-icons" 
fi

echo "-----"
printf "\n%.0s" {1..3}


# Cloning Hyprland-Dots repo to home directory
# KooL's Dots installation
printf "$NOTE Downloading Hyprland dots from main to HOME directory..\n"
if [ -d ~/Hyprland-Dots ]; then
  cd ~/Hyprland-Dots
  git stash
  git pull
  chmod +x copy.sh
  ./copy.sh 
else
  if git clone --depth 1 https://github.com/JaKooLit/Hyprland-Dots ~/Hyprland-Dots; then
    cd ~/Hyprland-Dots || exit 1
    chmod +x copy.sh
    ./copy.sh 
  else
    echo -e "$ERROR Can't download Hyprland-Dots"
  fi
fi

#return to NixOS-Hyprland directory
cd ~/NixOS-Hyprland

# copy fastfetch config if nixos.png is not present
if [ ! -f "$HOME/.config/fastfetch/nixos.png" ]; then
    cp -r assets/fastfetch "$HOME/.config/"
fi

printf "\n%.0s" {1..2}

if command -v Hyprland &> /dev/null; then
  printf "\n${OK} Yey! Installation Completed.${RESET}\n"
  sleep 2
  printf "\n${NOTE} You can start Hyprland by typing Hyprland (note the capital H!).${RESET}\n"
  printf "\n${NOTE} It is highly recommended to reboot your system.${RESET}\n\n"

  # Prompt user to reboot
  read -rp "${CAT} Would you like to reboot now? (y/n): ${RESET}" HYP

  if [[ "$HYP" =~ ^[Yy]$ ]]; then
    # If user confirms, reboot the system
    systemctl reboot
  else
    # Print a message if the user does not want to reboot
    echo "Reboot skipped."
  fi
else
  # Print error message if Hyprland is not installed
  printf "\n${WARN} Hyprland failed to install. Please check Install-Logs...${RESET}\n\n"
  exit 1
fi
