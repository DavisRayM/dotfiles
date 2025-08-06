{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerd-fonts.sauce-code-pro;
      name = "SauceCodePro Nerd Font Mono";
      size = 12.0;
    };
    keybindings = {
      "ctrl+shift+6" = "send_text ctrl+6";
      "ctrl+shift+l" = "next_tab";
      "ctrl+shift+h" = "previous_tab";
    };
  };
}
