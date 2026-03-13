{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    wrappers.url = "github:Lassulus/wrappers";
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      nix-index-database,
      wrappers,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      mkMenu =
        menu:
        let
          configFile = pkgs.writeText "config.yaml" (
            pkgs.lib.generators.toYAML { } {
              anchor = "bottom-right";
              # ...
              inherit menu;
            }
          );
        in
        pkgs.writeShellScriptBin "my-menu" ''
          exec ${pkgs.lib.getExe pkgs.wlr-which-key} ${configFile}
        '';
    in
    {
      packages.${system}.default =
        (wrappers.wrapperModules.niri.apply {
          inherit pkgs;
          settings = {
            binds = {
              "Mod+d".spawn-sh = pkgs.lib.getExe (mkMenu [
                {
                  key = "g";
                  desc = "Google";
                  cmd = "google-chrome-stable";
                }
                {
                  key = "e";
                  desc = "Emacs";
                  cmd = "emacsclient -c";
                }
              ]);
            };
          };
        }).wrapper;

      nixosConfigurations.blaze = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system nixpkgs; };
        modules = [
          nixos-hardware.nixosModules.asus-rog-strix-g513im
          # {
          #   programs.niri = with pkgs; {
          #     enable = true;
          #     useNautilus = true;
          #     package = niri;
          #   };
          # }
          ./configuration.nix
          nix-index-database.nixosModules.default
        ];
      };
    };
}
