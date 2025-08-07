{...}: {
  imports = [
    ./fish.nix
    ./git.nix
    ./hyprland
    ./kitty.nix
    ./neovim.nix
    ./waybar
    ./zoxide.nix
  ];

  # Stuff that probably dont need separate modules
  services.blueman-applet.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
