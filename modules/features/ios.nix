{ ... }:

{
  flake.nixosModules.ios =
    { pkgs, lib, ... }:
    {
      services.usbmuxd = {
        enable = true;
        package = pkgs.usbmuxd2;
      };

      environment.systemPackages = with pkgs; [
        libimobiledevice
        # optional, to mount using 'ifuse'
        ifuse
      ];
    };
}
