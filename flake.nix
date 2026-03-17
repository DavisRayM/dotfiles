{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:/nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    wrappers.url = "github:Lassulus/wrappers";
  };

  outputs =
    {
      stylix,
      nixpkgs,
      nixos-hardware,
      nix-index-database,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.blaze = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system nixpkgs; };
        system = system;
        modules = [
          nixos-hardware.nixosModules.asus-rog-strix-g513im
          stylix.nixosModules.stylix
          ./configuration.nix
          nix-index-database.nixosModules.default
        ];
      };
    };
}
