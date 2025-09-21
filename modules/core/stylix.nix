{pkgs, ...}: {
  stylix = {
    enable = true;
    image = ./theme/background.jpg;
    autoEnable = true;
    # polarity = "dark";
    cursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 24;
    };
    fonts = {
      monospace.name = "SauceCodePro Nerd Font Mono";
      monospace.package = pkgs.nerd-fonts.sauce-code-pro;
    };
  };
}
