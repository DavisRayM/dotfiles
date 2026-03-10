{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs =
    { nixpkgs, hardware, ... }@inputs:
    {
      nixosConfigurations.blaze = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          hardware.nixosModules.asus-rog-strix-g513im
          ./configuration.nix
        ];
      };
    };
}
