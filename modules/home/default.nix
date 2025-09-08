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

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
