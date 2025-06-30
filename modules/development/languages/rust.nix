# modules/development/languages/rust.nix
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # rustup - The Rust toolchain installer and version manager
    rustup
    
    # rust-analyzer - LSP server for Rust
    rust-analyzer
    
    # bacon - Background rust code checker
    bacon
    
    # sccache - Shared compilation cache for Rust
    sccache
  ];

  # Note: After installing, use rustup to manage Rust versions:
  # rustup default stable
  # rustup install nightly
  # rustup target add wasm32-unknown-unknown
  # rustup component add rustfmt clippy
}
