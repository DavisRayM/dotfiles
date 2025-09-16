{
  description = "NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    timezone = "America/Los_Angeles";
    gitEmail = "git@davisraym.com";
    gitSigningKey = "B21213D4E7D60355";
    gitUsername = "davisraym";
    hostname = "sanguine";
    username = "dave";
    winOSUUID = "4480-965B";
  in {
    nixosConfigurations.personal = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit username;
        inherit gitUsername;
        inherit gitEmail;
        inherit gitSigningKey;
        inherit hostname;
        inherit timezone;
        inherit winOSUUID;
      };
      modules = [
        {nix.settings.experimental-features = ["nix-command" "flakes"];}
        ./hosts/personal/configuration.nix
      ];
    };
  };
}
