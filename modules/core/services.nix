{...}: {
  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Display

  # FIX: SDDM is a bit flaky when I run the wayland
  # version... This isn't ideal but not entirely sure.
  # Enable sound with pipewire.
  services.xserver.enable = true;

  # Audio

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ROG Strix Specific
  services.power-profiles-daemon.enable = true;
  services.supergfxd.enable = true;
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
}
