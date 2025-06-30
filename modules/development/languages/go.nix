# modules/development/languages/go.nix
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Go programming language
    go
    
    # gopls - Go language server
    gopls
    
    # go-tools - Collection of tools for Go development
    go-tools
    
    # golangci-lint - Fast linters runner for Go
    golangci-lint
    
    # delve - Debugger for Go
    delve
    
    # go-task - Task runner / build tool (alternative to make)
    go-task
  ];

  # Note: Go doesn't have a standard version manager like rustup.
  # Options for multiple versions:
  # 1. Use specific versions from nixpkgs (go_1_21, go_1_22, etc.)
  # 2. Use official Go approach: go install golang.org/dl/go1.21.0@latest
  # 3. Projects can specify Go version in go.mod
}
