{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+shift+6" = "send_text ctrl+6";
      "ctrl+shift+l" = "next_tab";
      "ctrl+shift+h" = "previous_tab";
      "ctrl+shift+enter" = "launch --cwd=current";
      "ctrl+alt+l" = "next_window";
      "ctrl+alt+h" = "previous_window";
    };
  };
}
