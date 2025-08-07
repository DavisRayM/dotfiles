{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.asus-rog-strix-g513im
    ./hardware-configuration.nix
    ../../modules/core
  ];

  # ROG Strix Specific
  services.power-profiles-daemon.enable = true;
  services.supergfxd.enable = true;
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
}
