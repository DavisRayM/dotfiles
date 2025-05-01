abbr -a e nvim
abbr -a g git
abbr -a ga 'git add -p'
abbr -a gc 'git commit'
abbr -a gb 'git checkout -b'
abbr -a gsw 'git switch'
abbr -a gst 'git status'
abbr -a gp 'git push'
abbr -a vdiff 'nvim -d'

if status --is-interactive
	switch $TERM
		case 'linux'
			exec Hyprland
		case '*'
			if ! set -q TMUX
				exec tmux
			end
	end
end

# Environment variables
set PATH $PATH $HOME/.local/bin $HOME/.cargo/bin $HOME/.dotnet/tools
set EDITOR nbim
set -gx GPG_TTY (tty)

# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set __fish_git_prompt_use_informative_chars 'yes'
set -g fish_prompt_pwd_dir_length 3

function fish_prompt
	set_color blue
	echo -n (hostnamectl hostname)
	if [ $PWD != $HOME ]
		set_color brblack
		echo -n ':'
		set_color yellow
		echo -n (basename $PWD)
	end
	set_color green
	printf '%s ' (fish_git_prompt)
	set_color red
	echo -n '| '
	set_color normal
end

function fish_greeting
end

# Zoxide
zoxide init fish | source

# GPG
gpg-connect-agent updatestartuptty /bye >/dev/null
