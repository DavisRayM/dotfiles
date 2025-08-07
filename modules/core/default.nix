{inputs, ...}: {
  imports = [
    inputs.stylix.nixosModules.stylix
    inputs.nixos-hardware.nixosModules.asus-rog-strix-g513im
    ./bootloader.nix
    ./default-user.nix
    ./fonts.nix
    ./networking.nix
    ./programs.nix
    ./sddm.nix
    ./services.nix
    ./stylix.nix
    ./time.nix
  ];
}
