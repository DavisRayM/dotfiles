# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# NOTE: Going to need the unstable channel

{
  config,
  pkgs,
  ...
}:
let
  # Flameshot GTK issues
  unstable-pkgs = import <nixpkgs-unstable> { };
in
{
  imports = [
    # Include the results of the hardware scan.
    "${
      builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }
    }/asus/rog-strix/g513im"
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

  networking.hostName = "nixhost"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
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
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
    windowManager.i3.enable = true;
  };
  services.displayManager.defaultSession = "xfce+i3";
  programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dave = {
    isNormalUser = true;
    description = "Davis Raymond Muro";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "udev"
      "tss"
    ];
    packages = with pkgs; [
      stow
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Steam
  programs.steam.enable = true;

  # Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.terminess-ttf
      nerd-fonts.blex-mono
      nerd-fonts.symbols-only
      ibm-plex
      openmoji-color
      # Emacs fallback
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

  # Enable TPM
  security.tpm2.enable = true;
  # QEMU UEFI Support
  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ansible
    awscli2
    bash-language-server
    brave
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
    dockfmt
    emacs
    emacsPackages.vterm
    fd
    unstable-pkgs.flameshot
    gcc
    gdb
    git
    gimp
    glibc
    gnumake
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
    lxappearance
    man-pages
    material-black-colors
    networkmanagerapplet
    nil
    nixfmt
    openssl_3
    pavucontrol
    pipenv
    pkg-config
    playerctl
    python312
    python312Packages.black
    python312Packages.isort
    python312Packages.nose2
    python312Packages.pyflakes
    python312Packages.pytest
    qemu
    ripgrep
    rofi
    rustup
    shellcheck
    shfmt
    sqlite
    stylelint
    terraform
    terraform-ls
    unstable-pkgs.ty
    uv
    vim
    wget
    xclip
    xss-lock
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-rofi;
    settings = {
      default-cache-ttl = 600;
      max-cache-ttl = 7200;
    };
  };

  # Battery
  services.upower.enable = true;
  services.upower.ignoreLid = true;

  # ROG Strix Specific
  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.power-profiles-daemon.enable = true;
  services.supergfxd.enable = true;
  services.asusd = {
    enable = true;
    enableUserService = true;
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
  services.blueman.enable = true;
  services.libinput.touchpad.disableWhileTyping = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
