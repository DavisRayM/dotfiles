{
  lib,
  pkgs,
  ...
}: {
  # Use Bash as the Login Shell; Switch to Fish for Interactive Sessions
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      e = "nvim";
      g = "git";
      ga = "git add -p";
      gc = "git commit";
      gb = "git checkout -b";
      gsw = "git switch";
      gst = "git status";
      gp = "git push";
      vdiff = "nvim -d";
    };
    interactiveShellInit = ''
      set __fish_git_prompt_showuntrackedfiles "yes"
      set __fish_git_prompt_showdirtystate "yes"
      set __fish_git_prompt_showstashstate ""
      set __fish_git_prompt_showupstream "none"
      set __fish_git_prompt_use_informative_chars "yes"
      set -g fish_prompt_pwd_dir_length 3
      set -g fish_key_bindings fish_vi_key_bindings

      function fish_mode_prompt;end

      function fish_prompt
        set_color blue
        echo -n '['
        switch $fish_bind_mode
          case default
            set_color --bold red
            echo -n 'C'
          case insert
            set_color --bold green
            echo -n 'I'
          case replace_one
            set_color --bold green
            echo -n 'R'
          case visual
            set_color --bold brmagenta
            echo -n 'V'
          case '*'
            set_color --bold red
            echo -n '?'
        end
        set_color blue
        echo -n '] '

        echo -n (hostnamectl hostname)

        if [ $PWD != $HOME ]
                set_color brblack
                echo -n ":"
                set_color yellow
                echo -n (basename $PWD)
        end
        set_color green
        printf "%s " (fish_git_prompt)
        if set -q VIRTUAL_ENV
                set_color brblack
                echo -n "("
                set_color yellow
                echo -n (basename "$VIRTUAL_ENV")
                set_color brblack
                echo -n ") "
        end
        echo
        set_color red
        echo -n "↳ "
        set_color normal
      end

      function fish_greeting
      end
    '';
  };
}
