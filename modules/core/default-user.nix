{
  lib,
  config,
  pkgs,
  inputs,
  gitUsername,
  gitEmail,
  gitSigningKey,
  ...
}: let
  cfg = config.default-user;
in {
  imports = [inputs.home-manager.nixosModules.default];

  options.default-user = {
    enable = lib.mkEnableOption "Enable default user module";
    userName = lib.mkOption {
      default = "dave";
      description = ''
        Username
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
    };

    programs.dconf.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      extraSpecialArgs = with cfg; {
        inherit inputs;
        inherit userName;
        inherit gitUsername;
        inherit gitEmail;
        inherit gitSigningKey;
      };
      users.${cfg.userName} = {
        imports = [../home];
        dconf.settings = {
          "apps/seahorse/listing" = {
            keyrings-selected = ["gnupg://"];
          };
        };
        home = {
          username = "${cfg.userName}";
          homeDirectory = "/home/${cfg.userName}";
          stateVersion = "25.05";
        };
        programs.home-manager.enable = true;
      };
    };
  };
}
