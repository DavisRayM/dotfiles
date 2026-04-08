{ ... }:
{
  flake.nixosModules.fonts =
    { pkgs, lib, ... }:
    {
      fonts = {
        packages = with pkgs; [
          nerd-fonts.terminess-ttf
          nerd-fonts.blex-mono
          nerd-fonts.symbols-only
          ibm-plex
          openmoji-color
          symbola
        ];
        fontconfig = {
          defaultFonts = {
            sansSerif = [ "IBM Plex Sans" ];
            serif = [ "IBM Plex Serif" ];
            monospace = [ "Terminess Nerd Font" ];
            emoji = [
              "OpenMoji Color"
              "Noto Color Emoji"
            ];
          };
        };
        enableDefaultPackages = true;
      };
    };
}
