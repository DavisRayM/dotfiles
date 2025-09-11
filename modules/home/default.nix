{...}: {
  imports = [
    ./fish.nix
    ./gh.nix
    ./git.nix
    ./hyprland
    ./kitty.nix
    # ./mullvad.nix
    ./neovim.nix
    ./waybar
  ];

  # Stuff that probably dont need separate modules
  services.blueman-applet.enable = true;
  services.dunst.enable = true;
  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets"];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
