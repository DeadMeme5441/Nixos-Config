# modules/development/languages/java.nix
{ config, lib, pkgs, ... }:

let
  # All available Java versions
  javaVersions = {
    "8" = pkgs.jdk8;
    "11" = pkgs.jdk11;
    "17" = pkgs.jdk17;
    "21" = pkgs.jdk21;
    # JDK 24 might not be available yet in stable channel
    # Uncomment when available:
    # "24" = pkgs.jdk24;
  };

  # Create a wrapper for each Java version that doesn't conflict
  javaWrapped = lib.mapAttrs (version: jdk:
    pkgs.runCommand "java-${version}" { } ''
      mkdir -p $out
      ln -s ${jdk} $out/jdk
    ''
  ) javaVersions;

  # Java version switcher script
  javaSwitcher = pkgs.writeShellScriptBin "java-switch" ''
    set -e
    
    JAVA_BASE="$HOME/.local/share/java"
    CURRENT_LINK="$JAVA_BASE/current"
    
    # Available versions
    declare -A versions=(
      ["8"]="${javaWrapped."8"}/jdk"
      ["11"]="${javaWrapped."11"}/jdk"
      ["17"]="${javaWrapped."17"}/jdk"
      ["21"]="${javaWrapped."21"}/jdk"
      ${lib.optionalString (javaVersions ? "24") ''["24"]="${javaWrapped."24"}/jdk"''}
    )
    
    # Function to list available versions
    list_versions() {
      echo "Available Java versions:"
      for version in "''${!versions[@]}"; do
        if [[ -L "$CURRENT_LINK" && "$(readlink -f "$CURRENT_LINK")" == "''${versions[$version]}" ]]; then
          echo "  * $version (current)"
        else
          echo "    $version"
        fi
      done
    }
    
    # Function to get current version
    get_current() {
      if [[ -L "$CURRENT_LINK" ]]; then
        local current_path=$(readlink -f "$CURRENT_LINK")
        for version in "''${!versions[@]}"; do
          if [[ "$current_path" == "''${versions[$version]}" ]]; then
            echo "$version"
            return
          fi
        done
      fi
      echo "none"
    }
    
    # Function to switch Java version
    switch_version() {
      local version=$1
      
      if [[ -z "''${versions[$version]}" ]]; then
        echo "Error: Java version $version is not available"
        echo ""
        list_versions
        exit 1
      fi
      
      mkdir -p "$JAVA_BASE"
      rm -f "$CURRENT_LINK"
      ln -s "''${versions[$version]}" "$CURRENT_LINK"
      
      echo "Switched to Java $version"
      echo ""
      echo "To make this change effective, you need to:"
      echo "  1. Reload your shell configuration: source ~/.zshrc"
      echo "  2. Or start a new shell session"
    }
    
    # Main logic
    case "$1" in
      list|ls|"")
        list_versions
        ;;
      current)
        current=$(get_current)
        if [[ "$current" == "none" ]]; then
          echo "No Java version is currently set"
          echo "Use 'java-switch <version>' to set one"
        else
          echo "Current Java version: $current"
        fi
        ;;
      -h|--help|help)
        echo "Usage: java-switch [COMMAND]"
        echo ""
        echo "Commands:"
        echo "  list, ls    List available Java versions"
        echo "  current     Show current Java version"
        echo "  <version>   Switch to specified Java version (8, 11, 17, 21)"
        echo "  help        Show this help message"
        echo ""
        echo "Example:"
        echo "  java-switch 17    # Switch to Java 17"
        ;;
      *)
        switch_version "$1"
        ;;
    esac
  '';

  # Script to initialize Java in the shell
  javaInit = pkgs.writeTextFile {
    name = "java-init.sh";
    text = ''
      # Java environment setup
      JAVA_BASE="$HOME/.local/share/java"
      if [[ -L "$JAVA_BASE/current" ]]; then
        export JAVA_HOME="$JAVA_BASE/current"
        export PATH="$JAVA_HOME/bin:$PATH"
      fi
    '';
  };

in {
  environment.systemPackages = with pkgs; [
    # Java versions (wrapped to avoid conflicts)
    javaWrapped."8"
    javaWrapped."11"
    javaWrapped."17"
    javaWrapped."21"
    # javaWrapped."24"  # Uncomment when available
    
    # Java version switcher
    javaSwitcher
    
    # Maven
    maven
    
    # Other Java tools
    gradle
    ant
    
    # Optional: Java development tools
    # visualvm
    # jmeter
  ];

  # Set up the Java initialization in the shell
  programs.zsh.interactiveShellInit = ''
    # Initialize Java environment
    source ${javaInit}
  '';

  # Also set up for bash users
  programs.bash.interactiveShellInit = ''
    # Initialize Java environment
    source ${javaInit}
  '';

  # Note for users
  system.activationScripts.javaSetup = {
    text = ''
      echo ""
      echo "Java version management is available!"
      echo "Use 'java-switch' to manage Java versions"
      echo "Run 'java-switch help' for more information"
      echo ""
    '';
    deps = [];
  };
}
