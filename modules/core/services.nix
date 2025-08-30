{...}: {
  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Display

  # FIX: SDDM is a bit flaky when I run the wayland
  # version... This isn't ideal but not entirely sure.
  # Enable sound with pipewire.
  services.xserver = {
    enable = true;
  };

  # Audio

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Night shift
  services.redshift = {
    provider = "geoclue2";
    enable = true;
  };
}
