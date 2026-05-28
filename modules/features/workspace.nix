{ ... }:

{
  flake.nixosModules.workspace =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        # Tools / Utilities
        fd
        gimp
        gnome-keyring
        jq
        kubectl
        man-pages
        minikube
        pavucontrol
        ripgrep
        rustup
        terraform
        vim

        # Git
        git
        delta

        # C++
        clang
        clang-tools

        # Socials
        discord
        gh

        # Go
        go
        godef
        gomodifytags
        gopls
        gore
        gotests
        gotools

        # Python
        ruff

        # Markdown
        python313Packages.grip

        # Shell script
        shfmt
        shellcheck
      ];

      environment.extraInit = ''
        export PATH="$PATH:$HOME/.cargo/bin:$HOME/dotfiles/scripts:/usr/local/go/bin:$HOME/go/bin"
      '';

      programs.bash = {
        enable = true;
        completion.enable = true;
        enableLsColors = true;
        shellAliases = {
          git = "git --no-pager";
          ft = "file-traveler";
          project = "cd ~/Projects/DavisRayM/";
        };
        shellInit = ''
          eval "$(direnv hook bash)"
        '';
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
    };
}
