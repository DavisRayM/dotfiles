{
  pkgs,
  gitUsername,
  gitEmail,
  gitSigningKey,
  ...
}: {
  home.packages = with pkgs; [delta];

  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";

    extraConfig = {
      "ui \"color\"" = {ui = "always";};
      color = {ui = true;};
      commit = {
        gpgsign = true;
        verbose = true;
      };
      core = {
        editor = "nvim";
        autocrlf = false;
        safecrlf = true;
        pager = "delta";
      };
      delta = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
      };
      help = {autocorrect = "prompt";};
      init = {defaultBranch = "main";};
      interactive = {diffFilter = "delta --color-only";};
      merge = {conflictStyle = "zdiff3";};
      user = {signingkey = "${gitSigningKey}";};
      pull = {rebase = true;};
      push = {autoSetupRemote = true;};
      alias = {
        ignore = "!gi() { local IFS=','; curl -sL https://www.toptal.com/developers/gitignore/api/\"$*\"; }; gi";
        graph = "log --all --graph --decorate --oneline";
        l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };
  };
}
