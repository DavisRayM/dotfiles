{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+shift+6" = "send_text ctrl+6";
      "ctrl+shift+l" = "next_tab";
      "ctrl+shift+h" = "previous_tab";
      "ctrl+shift+enter" = "launch --cwd=current";
      "ctrl+l" = "next_window";
      "ctrl+h" = "previous_window";
    };
  };
}
