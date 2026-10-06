{ ... }:

{
  flake.nixosModules.workspace =
    { pkgs, lib, ... }:
    {

      users.users.dave = {
        isNormalUser = true;
        description = "Davis Raymond Muro";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "udev"
        ];
        packages = with pkgs; [
          stow
        ];
      };

      environment.systemPackages = with pkgs; [
        # Tools / Utilities
        jq
        vim
        kdePackages.dolphin
        kdePackages.qtsvg

        # Git
        git
        delta

        # Socials
        discord
        gh

        # Python
        python3Minimal

        # Shell script
        shfmt
        shellcheck
      ];

      environment.extraInit = ''
        export PATH="$PATH:$HOME/dotfiles/scripts"
      '';

      programs.bash = {
        enable = true;
        completion.enable = true;
        enableLsColors = true;
        shellAliases = {
          git = "git --no-pager";
        };
      };

      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
      };

      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-rofi;
        settings = {
          default-cache-ttl = 600;
          max-cache-ttl = 7200;
        };
      };

      fonts = {
        packages = with pkgs; [
          nerd-fonts.terminess-ttf
          nerd-fonts.blex-mono
          nerd-fonts.symbols-only
          ibm-plex
          openmoji-color
          symbola
        ];
        fontconfig = {
          defaultFonts = {
            sansSerif = [ "IBM Plex Sans" ];
            serif = [ "IBM Plex Serif" ];
            monospace = [ "Terminess Nerd Font" ];
            emoji = [
              "OpenMoji Color"
              "Noto Color Emoji"
            ];
          };
        };
        enableDefaultPackages = true;
      };
    };
}
