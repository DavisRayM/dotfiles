{inputs, ...}: {
  imports = [
    inputs.stylix.nixosModules.stylix
    inputs.nixos-hardware.nixosModules.asus-rog-strix-g513im
    ./bootloader.nix
    ./default-user.nix
    ./fonts.nix
    ./sddm.nix
    ./stylix.nix
  ];
}
