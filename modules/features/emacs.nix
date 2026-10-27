{ ... }:

{
  flake.nixosModules.emacs =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        emacs
        emacsPackages.vterm
        ispell
        gcc
        gdb
        glibc
        gnumake
        libcxx
        libgcc
        libgccjit
        libtool
        libvterm
        ripgrep
        languagetool
        nil
        nixfmt
        cmake
        fd

        zig
        zls

        js-beautify
        stylelint
        html-tidy

        rustup

        clang-tools
      ];

      services.emacs = {
        defaultEditor = true;
        enable = false;
      };
    };
}
