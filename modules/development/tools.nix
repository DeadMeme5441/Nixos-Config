# modules/development/tools.nix
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Development tools
    git
    tree
    ripgrep
    coreutils
    fd
    
    # Docker tools
    docker-compose
    docker-buildx
    lazydocker
    dive
    
    # Kubernetes tools
    kubectl
    kubectx
    
    # Other dev tools
    goose-cli
    openfortivpn
  ];
}
