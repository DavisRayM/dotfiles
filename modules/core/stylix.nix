{pkgs, ...}: {
  stylix = {
    enable = true;
    image = ./theme/background.jpg;
    autoEnable = true;
    fonts = {
      monospace.name = "SauceCodePro Nerd Font Mono";
      monospace.package = pkgs.nerd-fonts.sauce-code-pro;
    };
  };
}
