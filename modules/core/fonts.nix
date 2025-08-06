{pkgs, ...}:

{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.sauce-code-pro
      nerd-fonts.symbols-only
    ];
  };
}
