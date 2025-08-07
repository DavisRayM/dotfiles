{...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock --immediate";
        before_sleep_cmd = "hyprlock --immediate";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
      ];
    };
  };
}
