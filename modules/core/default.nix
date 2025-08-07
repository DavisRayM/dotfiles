{inputs, ...}: {
  imports = [
    inputs.stylix.nixosModules.stylix
    ./asus-rog.nix
    ./bootloader.nix
    ./default-user.nix
    ./fonts.nix
    ./sddm.nix
    ./stylix.nix
  ];
}
