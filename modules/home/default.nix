{...}: {
  imports = [
    ./fish.nix
    ./git.nix
    ./hyprland
    ./kitty.nix
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
