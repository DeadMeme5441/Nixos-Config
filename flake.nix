{
  description = "KooL's NixOS-Hyprland"; 
  	
  inputs = {
	nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  	#nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	
	#hyprland.url = "github:hyprwm/Hyprland"; # hyprland development
	#distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
	ags.url = "github:aylur/ags/v1"; # aylurs-gtk-shell-v1

    claude-desktop = {
        url = "github:k3d3/claude-desktop-linux-flake";
        inputs.nixpkgs.follows = "nixpkgs";
        };
  	};

  outputs = 
	inputs@{ self, nixpkgs, ags, claude-desktop, ... }:
    	let
      system = "x86_64-linux";
      host = "deadmeme-pc";
      username = "deadmeme";

    pkgs = import nixpkgs {
       	inherit system;
       	config = {
       	allowUnfree = true;
       	};
      };
    in
      {
	nixosConfigurations = {
      "${host}" = nixpkgs.lib.nixosSystem rec {
		specialArgs = { 
			inherit system;
			inherit inputs;
			inherit username;
			inherit host;
			};
	   		modules = [ 
				./hosts/${host}/default.nix 
				# inputs.distro-grub-themes.nixosModules.${system}.default
				];
			};
		};
	};
}
