abbr -a e nvim
abbr -a o xdg-open
abbr -a g git
abbr -a ga 'git add -p'
abbr -a gc 'git commit'
abbr -a gb 'git checkout -b'
abbr -a gsw 'git switch'
abbr -a gst 'git status'
abbr -a gp 'git push'
abbr -a vdiff 'nvim -d'

# Start tmux for interactive shells
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
set PATH $PATH $HOME/.local/bin $HOME/.cargo/bin $HOME/go/bin
set GOPATH $HOME/go
set EDITOR nvim
set -gx GPG_TTY (tty)

# Cuda Variables: From /etc/profile.d/cuda.sh
set CUDA_PATH /opt/cuda
set PATH $PATH /opt/cuda/bin opt/cuda/nsight_compute /opt/cuda/nsight_systems/bin
# This is a problem since it changes often
set NVCC_CCBIN /usr/bin/g++-13

# NVM
nvm use lts

# OS Dev stupp
set PATH $PATH $HOME/opt/cross/bin

# Dotnet
set PATH $PATH $HOME/.dotnet/tools

# Conda
source /opt/miniconda3/etc/fish/conf.d/conda.fish

# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set __fish_git_prompt_use_informative_chars 'yes'
set -g fish_prompt_pwd_dir_length 3

# Prompt
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

# Stuff I do often
function single_screen
    hyprctl keyword monitor "eDP-1, disable"
    pkill -9 "yambar"
    hyprctl dispatch exec yambar
end

function multi_screen
    hyprctl keyword monitor "eDP-1, 1920x1080@60, 0x0, 1"
    pkill -9 "yambar"
    hyprctl dispatch exec yambar
end

# Zoxide
zoxide init fish | source

# GPG
gpg-connect-agent updatestartuptty /bye >/dev/null
