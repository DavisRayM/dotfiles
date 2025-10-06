{
  inputs,
  username,
  ...
}: {
  # Allow unfree packages
  # NVIDIA and stuff
  nixpkgs.config.allowUnfree = true;

  # Configure Default User
  default-user.enable = true;
  default-user.userName = "${username}";

  imports = [
    inputs.stylix.nixosModules.stylix
    ./bootloader.nix
    ./default-user.nix
    ./fonts.nix
    ./networking.nix
    ./programs.nix
    ./sddm.nix
    ./security.nix
    ./services.nix
    ./stylix.nix
    ./system.nix
    ./time.nix
    ./virtualisation.nix
  ];
}
