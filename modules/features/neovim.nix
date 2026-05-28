{ ... }:

{
  flake.nixosModules.neovim =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        neovim
      ];
    };
}
