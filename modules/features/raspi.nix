{ ... }:

{
  flake.nixosModules.raspi =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        rpi-imager
      ];

      # NOTE: Can't connect ? IP Probably changed :/
      networking.hosts = {
        "10.131.141.45" = [ "DavesPi" ];
      };
    };
}
