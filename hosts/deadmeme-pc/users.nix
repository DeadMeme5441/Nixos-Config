# 💫 https://github.com/JaKooLit 💫 #
# Users - NOTE: Packages defined on this will be on current user only

{ pkgs, username, ... }:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  users = { 
    mutableUsers = true;
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video" 
        "input" 
        "audio"
        "docker"
      ];

    # define user packages here
    packages = with pkgs; [
      ];
    };
    
    defaultUserShell = pkgs.zsh;
  }; 
  
  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [ lsd fzf ]; 
    
  programs = {
  # Zsh configuration
	  zsh = {
    	enable = true;
	  	enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git" "aws" "bun" "cabal" "docker" "docker-compose" "fzf" "gh" "golang" "helm" "jira" "kubectl" "mongocli" "mvn" "nvm" "postgres" "python" "rsync" "ssh" "ssh-agent" "systemd" ];
        theme = ""; 
      	};
      
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      
      promptInit = ''
        fastfetch -c $HOME/.config/fastfetch/config.jsonc

        #pokemon colorscripts like. Make sure to install krabby package
        #krabby random --no-mega --no-gmax --no-regional --no-title -s; 
	source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme;


	# Set default editor
	export EDITOR='vim'
	export VISUAL='vim'
    export WEBKIT_DISABLE_COMPOSITING_MODE=1

    # Doom Emacs Environment Variables
    export DOOMDIR="$HOME/.config/doom"
    export DOOMLOCALDIR="$HOME/.local/share/doom"
    export DOOMPROFILELOADFILE="$HOME/.local/share/doom/profiles/load.el"
    export EMACSDIR="$HOME/.config/emacs"
    
    # Add Doom to PATH
    export PATH="$EMACSDIR/bin:$PATH"
    
    # For LSP performance
    export LSP_USE_PLISTS=true

	# Aliases
	# File listing with lsd
	alias ls='lsd'
	alias l='ls -l'
	alias la='ls -a'
	alias lla='ls -la'
	alias lt='ls --tree'

	# Directory navigation
	alias ..='cd ..'
	alias ...='cd ../..'
	alias ....='cd ../../..'
	alias .....='cd ../../../..'


	# Git aliases (additional to oh-my-zsh git plugin)
	alias gs='git status'
	alias gd='git diff'
	alias gdc='git diff --cached'
	alias gl='git log --oneline --graph --decorate'

	# System aliases
	alias vim='nvim' # if you have neovim
	alias update='sudo nixos-rebuild switch --flake ~/NixOS-Hyprland/#$(hostname)'
	alias clean='sudo nix-collect-garbage -d'

	# Colorful man pages
	export LESS_TERMCAP_mb=$'\e[1;32m'
	export LESS_TERMCAP_md=$'\e[1;32m'
	export LESS_TERMCAP_me=$'\e[0m'
	export LESS_TERMCAP_se=$'\e[0m'
	export LESS_TERMCAP_so=$'\e[01;33m'
	export LESS_TERMCAP_ue=$'\e[0m'
	export LESS_TERMCAP_us=$'\e[1;4;31m'

	# FZF configuration
	export FZF_DEFAULT_OPTS="--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

	# Set up FZF key bindings and fuzzy completion
	source <(fzf --zsh)

	# History configuration
	HISTFILE=~/.zsh_history
	HISTSIZE=10000
	SAVEHIST=10000
	setopt appendhistory
	setopt sharehistory
	setopt hist_expire_dups_first
	setopt hist_ignore_dups
	setopt hist_ignore_space
	setopt hist_verify
       '';
      };
   };
}
