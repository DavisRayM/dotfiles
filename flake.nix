{
  description = "NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    username = "dave";
    gitUsername = "davisraym";
    gitEmail = "git@davisraym.com";
    gitSigningKey = "B21213D4E7D60355";
  in {
    nixosConfigurations.personal = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit username;
        inherit gitUsername;
        inherit gitEmail;
        inherit gitSigningKey;
      };
      modules = [
        {nix.settings.experimental-features = ["nix-command" "flakes"];}
        ./hosts/personal/configuration.nix
      ];
    };
  };
}
