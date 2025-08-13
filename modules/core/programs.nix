{pkgs, ...}: {
  programs = {
    hyprland.enable = true;
    dconf.enable = true;
    seahorse.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };

  environment.systemPackages = with pkgs; [google-chrome];
}
