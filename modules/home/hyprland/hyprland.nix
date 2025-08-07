{pkgs, ...}: {
  home.packages = with pkgs; [
    rofi-wayland
    kdePackages.dolphin
    wireplumber
    brightnessctl
    grimblast
    playerctl
    pavucontrol
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "eDP-1, 1920x1080@300, -1920x0, 1"
        "HDMI-A-1, 1920x1080@60, 0x0, 1"
      ];

      exec-once = [
        "waybar"
        "rog-control-center"
      ];

      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "rofi -show drun";
      "$browser" = "firefox";
      "$fileManager" = "dolphin";

      general = {
        gaps_in = 1;
        gaps_out = 5;
        border_size = 1;
        "col.active_border" = "rgba(ffedc0ee)";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = true;
        layout = "master";
      };

      cursor = {
        sync_gsettings_theme = true;
        no_hardware_cursors = 2;
        enable_hyprcursor = false;
        warp_on_change_workspace = 2;
        no_warps = true;
      };

      decoration = {
        rounding = 0;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 0.8;
        shadow.enabled = false;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      bezier = [
        "easeOutQuint, 0.23, 1, 0.32, 1"
        "easeInOutCubic, 0.65, 0.05, 0.36, 1"
        "linear, 0, 0, 1, 1"
        "almostLinear, 0.5, 0.5, 0.75, 1.0"
        "quick, 0.15, 0, 0.1, 1"
      ];

      master.new_status = "slave";

      misc.force_default_wallpaper = 0;
      misc.disable_hyprland_logo = true;

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
      };

      bind = [
        "$mod, RETURN, exec, $terminal"
        "$mod, E, exec, $fileManager"
        "$mod, R, exec, $menu"
        "$mod, B, exec, $browser"
        "$mod, Q, killactive,"
        "$mod SHIFT, X, exit,"
        "$mod, F, togglefloating,"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod ALT, H, movecurrentworkspacetomonitor, l"
        "$mod ALT, L, movecurrentworkspacetomonitor, r"
        "$mod ALT, K, movecurrentworkspacetomonitor, u"
        "$mod ALT, J, movecurrentworkspacetomonitor, d"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        ", 156, exec, rog-control-center"
        ", 210, exec, asusctl led-mode -n"
        ", 211, exec, asusctl profile -n"
        ", 237, exec, brightnessctl -d asus::kbd_backlight set 5%-"
        ", 238, exec, brightnessctl -d asus::kbd_backlight set 5%+"
        ", PRINT, exec, grimblast copysave area"
      ];

      # TODO: Most of these packages are not installed at the moment.
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:272, resizewindow"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrule = [
        "opacity 1.0 override 1.0 override, class:^(kitty)$"
        "opacity 1.0 override 1.0 override, class:^(firefox)$"
        "opacity 1.0 override 1.0 override, class:^(discord)$"
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "opacity 1.0 override 1.0 override, class:^(gimp)$"
        "nofocus, class:^(slurp|grim|grimblast)$"
      ];
    };
  };
}
