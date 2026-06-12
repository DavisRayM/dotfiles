{ ... }:

{
  flake.nixosModules.emacs =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        cmake
        emacs
        emacs-lsp-booster
        emacsPackages.vterm
        gcc
        gdb
        glibc
        gnumake
        ispell
        libcxx
        libgcc
        libgccjit
        libtool
        libvterm
        graphviz
      ];

      environment.extraInit = ''
        export PATH="$PATH:$HOME/.config/emacs/bin"
      '';
    };
}
