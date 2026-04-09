{ ... }:
{
  flake.nixosModules.docker =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        docker-buildx
        docker-compose
      ];

      virtualisation.docker = {
        enable = true;
      };
    };
}
