{...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 15;
        hide_cursor = true;
      };

      label = [
        {
          text = "$TIME";
          font_size = 90;
          font_family = "SauceCodePro Nerd Font Mono";
          position = "0, 0";
          halign = "center";
          valign = "top";
        }
        {
          text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
          font_size = 25;
          font_family = "SauceCodePro Nerd Font Mono";
          position = "0, -150";
          halign = "center";
          valign = "top";
        }
      ];
    };
  };
}
