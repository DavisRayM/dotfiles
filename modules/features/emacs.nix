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
        graphviz
        ispell
        libcxx
        libgcc
        libgccjit
        libtool
        libvterm
        maim
        texliveSmall
      ];

      services.emacs = {
        defaultEditor = true;
        enable = true;
      };
      environment.extraInit = ''
        export PATH="$PATH:$HOME/.config/emacs/bin"
      '';
    };
}
