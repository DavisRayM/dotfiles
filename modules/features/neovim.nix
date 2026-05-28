{ ... }:

{
  flake.nixosModules.neovim =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        neovim
        unzip
        tree-sitter
        fzf
      ];
    };
}
