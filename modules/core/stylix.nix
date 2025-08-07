{pkgs, ...}: {
  stylix = {
    enable = true;
    image = ./theme/background.jpg;
    autoEnable = true;
    polarity = "dark";
    fonts = {
      monospace.name = "SauceCodePro Nerd Font Mono";
      monospace.package = pkgs.nerd-fonts.sauce-code-pro;
    };
  };
}
