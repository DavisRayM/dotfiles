{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware/master";

    index-db.url = "github:nix-community/nix-index-database";
    index-db.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      hardware,
      index-db,
      ...
    }@inputs:
    {
      nixosConfigurations.blaze = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          hardware.nixosModules.asus-rog-strix-g513im
          ./configuration.nix
          index-db.nixosModules.default
        ];
      };
    };
}
