{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }:

    {

      # used since nix determine is used instead
      nix.enable = false;

      homebrew = {
          enable = true;

          # Manual permissions required after first install
          # (System Settings → Privacy & Security — cannot be automated on macOS):
          #
          #   hammerspoon     → Accessibility (required for hotkeys / window management)
          #   karabiner-elements → Accessibility, Input Monitoring
          #   raycast         → Accessibility (for window management / hotkeys)
          #   ghostty         → Accessibility (if using shell integration shortcuts)
          #   telegram        → Notifications
          #   obsidian        → Notifications
          casks = [
            "ghostty"
            "karabiner-elements"
            "hammerspoon"
            "obsidian"
            "telegram"
            "brave-browser"
            "raycast"
            "codex"
          ];
      };

      launchd.user.agents.kmonad = {
          serviceConfig = {
              ProgramArguments = [
                  "/usr/bin/sudo"
                      "/Users/outlawedchop/.local/bin/kmonad"
                      "/Users/outlawedchop/.config/kmonad/config.kbd"
              ];

              RunAtLoad = true;
              KeepAlive = true;

              ProcessType = "Interactive";

              LimitLoadToSessionType = "Aqua";

              StandardOutPath = "/tmp/kmonad.stdout";
              StandardErrorPath = "/tmp/kmonad.stderr";

              EnvironmentVariables = {
                  PATH = "/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin";
                  HOME = "/Users/outlawedchop";
              };
          };
      };

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
          # Core CLI Tools
          git
          git-lfs
          wget
          curl
          ripgrep
          fzf
          zoxide
          htop
          tmux
          chezmoi
          p7zip
          yazi
          oh-my-posh

          # Security / Networking
          gnupg
          inetutils
          nmap

          # Better Unix Tools
          coreutils
          gnutar
          gnused
          jq
          fd
          bat
          eza
          delta

          # Shell / Terminal
          zsh
          oh-my-posh

          # Editors
          neovim

          # Development Tools
          cmake
          (poetry.withPlugins (ps: [ ps.poetry-plugin-export ]))
          stack
          pyenv
          postgresql
          openvpn


          # Languages / Runtimes
          python312
          lua
          luarocks
          rustup
          nodejs

          # Java
          jdk
          jdk11

          # Media / Graphics
          imagemagick
          ffmpeg
          exiftool
          opencv
          poppler

          # macOS-specific
          blueutil

        ];

      security.sudo.extraConfig = ''
          outlawedchop ALL=(ALL) NOPASSWD: /Users/outlawedchop/.local/bin/kmonad
      '';

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      system.primaryUser = "outlawedchop";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Viktors-MacBook-Pro
    darwinConfigurations."vsmac" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ./vpn.nix ];
    };
  };
}
