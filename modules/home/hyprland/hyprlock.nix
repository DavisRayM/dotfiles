{...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 15;
        hide_cursor = true;
      };
      background = [
        {
          blur_passes = 0;
        }
      ];

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

      input-field = [
        {
          size = "300, 60";
          outline_thickness = 1;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          fade_on_empty = true;
          placeholder_text = "<span><i>󰌾 Logged in as </i><span>$USER</span></span>";
          hide_input = false;
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          position = "0, -47";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
