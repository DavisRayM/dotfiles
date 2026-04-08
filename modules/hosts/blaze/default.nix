{ self, inputs, ... }:
{
  flake.nixosConfigurations.blaze = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.blazeConfiguration
    ];
  };
}
