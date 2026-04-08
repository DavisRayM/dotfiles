{ self, inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };

      environment.systemPackages = with pkgs; [
        google-chrome
        networkmanagerapplet
      ];

      xdg.portal.enable = true;
      xdg.portal.extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          prefer-no-csd = _: { };
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.keyboard.xkb.layout = "us";
          input.focus-follows-mouse = _: { };

          layout = {
            gaps = 8;
            focus-ring = {
              width = 2;
              active-color = "#8ec07c";
            };
          };

          spawn-at-startup = [
            (lib.getExe self'.packages.myNoctalia)
            (lib.getExe pkgs.networkmanagerapplet)
          ];

          layer-rules = [
            {
              matches = [
                {
                  namespace = "^notifications$";
                }
              ];
              block-out-from = "screencast";
            }
          ];
          window-rules = [
            {
              matches = [
                {
                  app-id = "^google-chrome$";
                  title = "Picture-in-Picture|picture-in-picture|Meet";
                }
              ];
              open-floating = true;
            }
            {
              matches = [
                {
                  app-id = "teams|^microsoft-teams$|^com\\.microsoft\\.teams$|^google-chrome$";
                  title = "Microsoft Teams|Teams|Caption|Captions|Meeting options";
                }
              ];
              open-floating = true;
            }
            {
              matches = [
                {
                  app-id = "zoom|^Zoom Workplace$|^google-chrome$";
                  title = "Zoom|Picture-in-Picture|Meeting|Chat";
                }
              ];
              open-floating = true;
            }
            {
              matches = [
                {
                  app-id = "^google-chrome$";
                  title = "^Bitwarden.*";
                }
              ];
              open-floating = true;
            }
            {
              matches = [
                {
                  is-window-cast-target = true;
                }
              ];
              focus-ring = {
                active-color = "#f38ba8";
              };
            }
            {
              matches = [
                {
                  app-id = "^rofi$";
                  title = "pinentry|Pinentry|GPG";
                }
              ];
              block-out-from = "screencast";
            }
          ];

          binds = {
            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+S".set-dynamic-cast-window = _: { };
            "Mod+Shift+S".set-dynamic-cast-monitor = _: { };
            "Mod+Ctrl+Shift+S".clear-dynamic-cast-target = _: { };
            "Mod+B".spawn-sh = "google-chrome-stable";
            "Mod+E".spawn-sh = "${lib.getExe' pkgs.emacs "emacsclient"} -c";
            "Mod+D".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
            "XF86AudioRaiseVolume".spawn-sh =
              "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";

            "XF86AudioLowerVolume".spawn-sh =
              "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.1-";

            "XF86AudioMute".spawn-sh =
              "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";

            "XF86AudioMicMute".spawn-sh =
              "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

            "XF86AudioPlay".spawn-sh = "${lib.getExe pkgs.playerctl} play-pause";

            "XF86AudioPause".spawn-sh = "${lib.getExe pkgs.playerctl} pause";

            "XF86AudioNext".spawn-sh = "${lib.getExe pkgs.playerctl} next";

            "XF86AudioPrev".spawn-sh = "${lib.getExe pkgs.playerctl} previous";

            "XF86MonBrightnessUp".spawn-sh = "${lib.getExe pkgs.brightnessctl} --class=backlight set +10%";
            "XF86MonBrightnessDown".spawn-sh = "${lib.getExe pkgs.brightnessctl} --class=backlight set 10%-";

            "XF86KbdBrightnessUp".spawn-sh = "${lib.getExe pkgs.brightnessctl} -d asus::kbd_backlight set 5%+";

            "XF86KbdBrightnessDown".spawn-sh =
              "${lib.getExe pkgs.brightnessctl} -d asus::kbd_backlight set 5%-";

            "Mod+Q".close-window = _: { };

            "Mod+H".focus-column-left = _: { };
            "Mod+J".focus-window-down = _: { };
            "Mod+K".focus-window-up = _: { };
            "Mod+L".focus-column-right = _: { };

            "Mod+Ctrl+H".move-column-left = _: { };
            "Mod+Ctrl+J".move-window-down = _: { };
            "Mod+Ctrl+K".move-window-up = _: { };
            "Mod+Ctrl+L".move-column-right = _: { };

            "Mod+Shift+H".focus-monitor-left = _: { };
            "Mod+Shift+J".focus-monitor-down = _: { };
            "Mod+Shift+K".focus-monitor-up = _: { };
            "Mod+Shift+L".focus-monitor-right = _: { };

            "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = _: { };
            "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = _: { };
            "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = _: { };
            "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = _: { };

            "Mod+Shift+Ctrl+H".move-column-to-monitor-left = _: { };
            "Mod+Shift+Ctrl+J".move-column-to-monitor-down = _: { };
            "Mod+Shift+Ctrl+K".move-column-to-monitor-up = _: { };
            "Mod+Shift+Ctrl+L".move-column-to-monitor-right = _: { };

            "Mod+F".fullscreen-window = _: { };
            "Mod+Shift+F".expand-column-to-available-width = _: { };
            "Mod+Ctrl+Shift+F".toggle-windowed-fullscreen = _: { };
            "Mod+M".maximize-window-to-edges = _: { };

            "Mod+V".toggle-window-floating = _: { };
            "Mod+Shift+V".switch-focus-between-floating-and-tiling = _: { };

            "Print".screenshot = _: { };
            "Ctrl+Print".screenshot-screen = _: { };
            "Alt+Print".screenshot-window = _: { };

            "Mod+Shift+Escape".quit = _: { };
            "Mod+Shift+Slash".show-hotkey-overlay = _: { };

            "Mod+R".switch-preset-column-width = _: { };
            "Mod+Shift+R".switch-preset-window-height = _: { };
            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";
            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";
            "Mod+Ctrl+R".reset-window-height = _: { };
          };
        };
      };
    };
}
