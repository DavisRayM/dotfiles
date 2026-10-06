{ ... }:

{
  flake.nixosModules.emacs =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        emacs
        emacsPackages.vterm
        gcc
        gdb
        glibc
        gnumake
        libcxx
        libgcc
        libgccjit
        libtool
        libvterm
      ];

      services.emacs = {
        defaultEditor = true;
        enable = true;
      };
    };
}
