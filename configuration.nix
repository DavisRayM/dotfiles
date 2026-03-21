{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    extraEntries = ''
      menuentry "Windows" {
        insmod part_gpt
        insmod fat
        insmod search_fs_uuid
        insmod chain
        search --fs-uuid --set=root C60C-1FE4
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
  time.hardwareClockInLocalTime = true;

  networking.networkmanager.enable = true;
  networking.hostName = "blaze";

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Display & Window Manager
  # services.xserver = {
  #   enable = true;
  #   desktopManager = {
  #     xterm.enable = false;
  #     xfce = {
  #       enable = true;
  #       noDesktop = true;
  #       enableXfwm = false;
  #     };
  #   };
  #   # Configure keymap in X11
  #   xkb = {
  #     layout = "us";
  #     variant = "";
  #   };
  #   windowManager.i3.enable = true;
  # };
  # services.displayManager.defaultSession = "xfce+i3";
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Niri
  programs.niri.enable = true;

  # Programs
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
  ];

  programs.steam.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-rofi;
    settings = {
      default-cache-ttl = 600;
      max-cache-ttl = 7200;
    };
  };
  programs.bash = {
    shellAliases = {
      git = "git --no-pager";
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

  nixpkgs.config.allowUnfree = true;
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

  environment.systemPackages = with pkgs; [
    # google-cloud-sdk
    # pkgs.rpi-imager
    # xss-lock
    bash-language-server
    brightnessctl
    clang
    clang-tools
    cmake
    coreutils
    delta
    dig
    discord
    discount
    docker-buildx
    docker-compose
    emacs-lsp-booster
    emacs
    emacsPackages.vterm
    fd
    fuzzel
    gcc
    gdb
    gimp
    git
    glibc
    gnumake
    go-grip
    google-chrome
    gnome-keyring
    graphviz
    html-tidy
    ispell
    jq
    js-beautify
    kitty
    libcxx
    libgcc
    libnotify
    libtool
    libvterm
    mako
    man-pages
    networkmanagerapplet
    nil
    nixfmt
    pavucontrol
    pkg-config
    ripgrep
    rofi
    rustup
    shellcheck
    shfmt
    sqlite
    stylelint
    swaybg
    terraform
    terraform-ls
    ty
    uv
    vim
    waybar
    wayland-utils
    wev
    wget
    wl-clipboard
    xwayland-satellite
  ];
  environment.variables = {
    PATH = "$PATH:~/.config/emacs/bin";
  };

  # Stylix
  stylix = {
    enable = true;
    image = ./wallpaper/wallpaper.jpg;
    autoEnable = true;

    polarity = "dark";

    fonts = {
      serif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Serif";
      };
      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans";
      };
      monospace = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  # Battery
  services.upower.enable = true;
  services.upower.ignoreLid = true;

  # ROG Strix Specific
  services.power-profiles-daemon.enable = true;
  services.supergfxd.enable = true;
  services.asusd = {
    enable = true;
  };

  # Security
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  # Virtualization
  virtualisation.docker = {
    enable = true;
  };

  # List services that you want to enable:
  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;
  services.blueman.enable = true;
  services.libinput.touchpad.disableWhileTyping = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Nix
  nix.settings.download-buffer-size = 250000000;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
