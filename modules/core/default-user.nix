{ lib, config, pkgs, inputs, gitUsername, gitEmail, gitSigningKey, ... }:

let
  cfg = config.default-user;
in
{ 
  imports = [ inputs.home-manager.nixosModules.default ];

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
      extraGroups = [ "networkmanager" "wheel" ];
    };

    home-manager = {
      useUserPackages = true;
      extraSpecialArgs = with cfg; {
        inherit inputs;
	inherit userName;
	inherit gitUsername;
	inherit gitEmail;
	inherit gitSigningKey;
      };
      users.${cfg.userName} = {
        imports = [ ../home ];
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
