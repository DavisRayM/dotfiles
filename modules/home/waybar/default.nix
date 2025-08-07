{...}: {
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = [
      {
        layer = "top";
        position = "top";
        width = 1910;
        margin-top = 2;
        spacing = 5;
        modules-left = [
          "hyprland/window"
        ];
        modules-center = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "idle_inhibitor"
          "clock"
          "power-profiles-daemon"
          "network"
          "pulseaudio"
          "battery"
          "battery#bat2"
          "backlight"
          "tray"
        ];
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        "hyprland/workspaces" = {
          format = "{id}";
          format-icons = {
            default = "";
            active = "l";
          };
        };
        tray = {
          spacing = 10;
        };
        clock = {
          format = "{:%a, %d %b %Y @ %H:%M}";
          tooltip = false;
        };
        backlight = {
          format = "{icon}";
          tooltip = false;
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };
        "battery#bat2" = {
          bat = "BAT2";
        };
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "{profile}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "󱀚";
            balanced = "";
            power-saver = "";
          };
        };
        network = {
          format-wifi = "{essid} {icon}";
          format-ethernet = "";
          tooltip-format = "{ifname} via {gwaddr}";
          format-disconnected = "󰤭";
          format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
        };
        pulseaudio = {
          format = "{icon} {format_source}";
          tooltip-format = "[Volume] {volume}%";
          tooltip = true;
          format-bluetooth = "{icon} | {format_source}";
          format-bluetooth-muted = "󰝟";
          format-muted = "󰝟";
          format-source = "󰍮";
          format-source-muted = "󰍭";
          format-icons = ["󰕿" "󰖀" "󰕾"];
          on-click = "pavucontrol";
        };
      }
    ];
  };
}
