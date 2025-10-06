{config, ...}: let
  userName = config.default-user.userName;
in {
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.users.${userName}.extraGroups = ["docker"];
}
