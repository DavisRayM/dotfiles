{pkgs, ...}: {
  # User Apps and Display
  programs.firefox.enable = true;
  programs.hyprland.enable = true;

  # System
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
  programs.ssh.startAgent = true;
}
