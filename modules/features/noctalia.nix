{ self, inputs, ... }:
{
  flake.nixosModules.noctalia =
    { pkgs, lib, ... }:
    {
      imports = [
        inputs.noctalia.nixosModules.default
      ];

      programs.noctalia = {
        enable = true;
        recommendedServices.enable = true;
      };
    };
}
