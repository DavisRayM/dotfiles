{
  pkgs,
  hostname,
  ...
}: {
  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [networkmanagerapplet];
}
