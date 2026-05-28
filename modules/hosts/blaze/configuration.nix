{ self, inputs, ... }:
{
  flake.nixosModules.blazeConfiguration =
    { pkgs, lib, ... }:
    {
      imports = [
        inputs.nixos-hardware.nixosModules.asus-rog-strix-g513im
        self.nixosModules.blazeHardware
        self.nixosModules.nix
        self.nixosModules.niri
        self.nixosModules.fonts
        self.nixosModules.docker
        self.nixosModules.emacs
        self.nixosModules.workspace
        self.nixosModules.neovim
      ];

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

      # Battery
      services.upower.enable = true;
      services.upower.ignoreLid = true;

      # ROG Strix Specific
      services.power-profiles-daemon.enable = true;
      services.supergfxd.enable = true;
      services.asusd = {
        enable = true;
      };

      programs.steam.enable = true;
      programs.dconf.enable = true;
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        stdenv.cc.cc
        zlib
      ];

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
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${lib.getExe pkgs.tuigreet} -c niri-session";
          };
        };
      };

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?
    };
}
