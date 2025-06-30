# modules/development/languages/java.nix
{ config, lib, pkgs, ... }:

let
  # Java version wrapper that creates non-conflicting installations
  wrapJava = version: jdk: 
    pkgs.runCommand "java-${version}-wrapped" {
      nativeBuildInputs = [ pkgs.makeWrapper ];
    } ''
      # Create the directory structure
      mkdir -p $out/{bin,lib,include,man}
      
      # Create wrapper scripts for all binaries to avoid conflicts
      for binary in ${jdk}/bin/*; do
        binary_name=$(basename "$binary")
        makeWrapper "$binary" "$out/bin/java${version}-$binary_name" \
          --set JAVA_HOME "${jdk}"
      done
      
      # Copy other directories without conflicts
      cp -r ${jdk}/lib/* $out/lib/ 2>/dev/null || true
      cp -r ${jdk}/include/* $out/include/ 2>/dev/null || true
      if [ -d ${jdk}/man ]; then
        cp -r ${jdk}/man/* $out/man/ 2>/dev/null || true
      fi
      
      # Store the real JDK path for JAVA_HOME
      echo "${jdk}" > $out/.java-home-real
      
      # Create a marker file for version identification
      echo "${jdk}" > $out/.java-home
    '';

  # Available Java versions (wrapped to avoid conflicts)
  javaVersions = {
    "8" = wrapJava "8" pkgs.jdk8;
    "11" = wrapJava "11" pkgs.jdk11;
    "17" = wrapJava "17" pkgs.jdk17;
    "21" = wrapJava "21" pkgs.jdk21;
    # Add more versions as needed
  };

  # Java switcher script that works seamlessly
  javaSwitcher = pkgs.writeShellApplication {
    name = "java-switch";
    runtimeInputs = with pkgs; [ coreutils gnused findutils ];
    text = ''
      set -euo pipefail
      
      # Color codes for output
      GREEN=$'\e[32m'
      YELLOW=$'\e[33m'
      RED=$'\e[31m'
      BLUE=$'\e[34m'
      RESET=$'\e[0m'
      
      # Directory for Java symlinks
      JAVA_LINKS_DIR="$HOME/.local/share/java"
      CURRENT_FILE="$JAVA_LINKS_DIR/.current-java"
      
      # Available versions
      declare -A versions=(
        ["8"]="${javaVersions."8"}"
        ["11"]="${javaVersions."11"}"
        ["17"]="${javaVersions."17"}"
        ["21"]="${javaVersions."21"}"
      )
      
      # Function to get current version
      get_current() {
        if [[ -f "$CURRENT_FILE" ]]; then
          cat "$CURRENT_FILE"
        else
          echo "none"
        fi
      }
      
      # Function to list versions
      list_versions() {
        echo "''${BLUE}Available Java versions:''${RESET}"
        local current
        current=$(get_current)
        for version in $(echo "''${!versions[@]}" | tr ' ' '\n' | sort -n); do
          if [[ "$version" == "$current" ]]; then
            echo "  ''${GREEN}* $version (current)''${RESET}"
          else
            echo "    $version"
          fi
        done
      }
      
      # Function to setup Java environment
      setup_java_env() {
        local version=$1
        local wrapper_path="''${versions[$version]}"
        
        # Get the real JDK path from the wrapper
        local java_home
        if [[ -f "$wrapper_path/.java-home-real" ]]; then
          java_home=$(cat "$wrapper_path/.java-home-real")
        else
          java_home="$wrapper_path"
        fi
        
        # Create links directory
        mkdir -p "$JAVA_LINKS_DIR/bin"
        
        # Remove old symlinks
        find "$JAVA_LINKS_DIR/bin" -type l -delete
        
        # Create new symlinks for standard Java commands
        local commands=(java javac jar javadoc javap jshell jconsole jdb keytool)
        for cmd in "''${commands[@]}"; do
          if [[ -x "$wrapper_path/bin/java$version-$cmd" ]]; then
            ln -sf "$wrapper_path/bin/java$version-$cmd" "$JAVA_LINKS_DIR/bin/$cmd"
          fi
        done
        
        # Store current version
        echo "$version" > "$CURRENT_FILE"
        
        # Create activation script with real JAVA_HOME
        cat > "$JAVA_LINKS_DIR/activate.sh" <<EOF
      # Java environment setup
      export JAVA_HOME="$java_home"
      export PATH="$JAVA_LINKS_DIR/bin:\$PATH"
      EOF
        
        echo "''${GREEN}✓ Switched to Java $version''${RESET}"
        echo ""
        echo "''${YELLOW}To activate in current shell:''${RESET}"
        echo "  source $JAVA_LINKS_DIR/activate.sh"
        echo ""
        echo "''${YELLOW}To make permanent, add to your shell config:''${RESET}"
        echo "  echo 'source $JAVA_LINKS_DIR/activate.sh' >> ~/.zshrc"
      }
      
      # Function to show status
      show_status() {
        local current
        current=$(get_current)
        if [[ "$current" == "none" ]]; then
          echo "''${YELLOW}No Java version is currently set''${RESET}"
          echo "Use 'java-switch <version>' to set one"
        else
          echo "''${BLUE}Current Java version:''${RESET} ''${GREEN}$current''${RESET}"
          if [[ -f "$JAVA_LINKS_DIR/activate.sh" ]]; then
            if [[ ":$PATH:" == *":$JAVA_LINKS_DIR/bin:"* ]]; then
              echo "''${GREEN}✓ Java environment is active''${RESET}"
            else
              echo "''${YELLOW}! Java environment not active in current shell''${RESET}"
              echo "  Run: source $JAVA_LINKS_DIR/activate.sh"
            fi
          fi
        fi
      }
      
      # Main logic
      case "''${1:-}" in
        list|ls|"")
          list_versions
          echo ""
          show_status
          ;;
        status)
          show_status
          ;;
        -h|--help|help)
          echo "Usage: java-switch [COMMAND]"
          echo ""
          echo "Commands:"
          echo "  list, ls    List available Java versions"
          echo "  status      Show current Java version and environment status"
          echo "  <version>   Switch to specified Java version (8, 11, 17, 21)"
          echo "  help        Show this help message"
          echo ""
          echo "Example:"
          echo "  java-switch 17    # Switch to Java 17"
          ;;
        *)
          if [[ -z "''${versions[$1]:-}" ]]; then
            echo "''${RED}Error: Java version $1 is not available''${RESET}"
            echo ""
            list_versions
            exit 1
          fi
          setup_java_env "$1"
          ;;
      esac
    '';
  };

  # Shell integration script that provides seamless switching
  javaShellIntegration = pkgs.writeTextFile {
    name = "java-integration.sh";
    text = ''
      # Java seamless integration
      
      # Function to switch Java versions on-the-fly
      java-use() {
        local version="$1"
        if [[ -z "$version" ]]; then
          echo "Usage: java-use <version>"
          echo "Available versions: 8, 11, 17, 21"
          return 1
        fi
        
        # Run java-switch and source the activation script
        if java-switch "$version" >/dev/null 2>&1; then
          source "$HOME/.local/share/java/activate.sh"
          echo "Switched to Java $version in current shell"
        else
          echo "Failed to switch to Java $version"
          return 1
        fi
      }
      
      # Auto-activate Java environment if configured
      if [[ -f "$HOME/.local/share/java/activate.sh" ]]; then
        source "$HOME/.local/share/java/activate.sh"
      fi
      
      # Compatibility aliases (like archlinux-java)
      archlinux-java() {
        case "$1" in
          status)
            java-switch status
            ;;
          get)
            cat "$HOME/.local/share/java/.current-java" 2>/dev/null || echo "none"
            ;;
          set)
            java-switch "$2"
            ;;
          fix)
            # Re-setup current version
            local current
            current=$(cat "$HOME/.local/share/java/.current-java" 2>/dev/null || echo "")
            if [[ -n "$current" ]]; then
              java-switch "$current"
            fi
            ;;
          *)
            echo "Usage: archlinux-java {status|get|set <version>|fix}"
            ;;
        esac
      }
    '';
  };

in {
  environment.systemPackages = with pkgs; [
    # Install all wrapped Java versions
    javaVersions."8"
    javaVersions."11"
    javaVersions."17"
    javaVersions."21"
    
    # Java switcher
    javaSwitcher
    
    # Build tools
    maven
    gradle
    ant
    
    # Optional: Development tools
    # visualvm
    # jmeter
  ];

  # Add shell integration for all users
  programs.zsh = {
    interactiveShellInit = ''
      # Source Java integration
      source ${javaShellIntegration}
    '';
  };

  programs.bash = {
    interactiveShellInit = ''
      # Source Java integration  
      source ${javaShellIntegration}
    '';
  };

  # Create system-wide Java links directory
  system.activationScripts.javaSetup = {
    text = ''
      # Create system Java directory
      mkdir -p /usr/lib/jvm
      
      # Create compatibility symlinks to real JDK paths
      ${lib.concatMapStrings (version: 
        let 
          realJdk = if version == "8" then pkgs.jdk8
                    else if version == "11" then pkgs.jdk11
                    else if version == "17" then pkgs.jdk17
                    else if version == "21" then pkgs.jdk21
                    else throw "Unknown Java version: ${version}";
        in ''
          ln -sfn ${realJdk} /usr/lib/jvm/java-${version}-openjdk
        '') (lib.attrNames javaVersions)}
    '';
    deps = [];
  };

  # Add helpful documentation
  environment.etc."java/README.md" = {
    text = ''
      # Java Version Management on NixOS
      
      This system has multiple Java versions installed. Use the `java-switch` command
      to manage them, similar to archlinux-java.
      
      ## Quick Start
      
      1. List available versions:
         ```
         java-switch list
         ```
      
      2. Switch to a version:
         ```
         java-switch 17
         source ~/.local/share/java/activate.sh
         ```
      
      3. For seamless switching in current shell:
         ```
         java-use 17
         ```
      
      4. Check current version:
         ```
         java-switch status
         ```
      
      ## Compatibility
      
      The following archlinux-java compatible commands are available:
      - `archlinux-java status`
      - `archlinux-java get`
      - `archlinux-java set <version>`
      - `archlinux-java fix`
      
      ## IDE Configuration
      
      Java installations are available at:
      - /usr/lib/jvm/java-8-openjdk (points to real JDK)
      - /usr/lib/jvm/java-11-openjdk (points to real JDK)
      - /usr/lib/jvm/java-17-openjdk (points to real JDK)
      - /usr/lib/jvm/java-21-openjdk (points to real JDK)
      
      Note: JAVA_HOME will be set to the actual JDK path, not the wrapper.
      
      ## Making Changes Permanent
      
      Add to your ~/.zshrc or ~/.bashrc:
      ```
      source ~/.local/share/java/activate.sh
      ```
    '';
  };
}
