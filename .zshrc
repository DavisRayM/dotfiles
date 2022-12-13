# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Ensure zoxide is started
eval "$(zoxide init zsh)"

# Ensure nvm is configured
source /usr/share/nvm/init-nvm.sh

# Pyenv configurations
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Virtualenvwrapper configurations
export WORKON_HOME="~/.venvs"
VIRTUALENVWRAPPER_SCRIPT=$(echo "/home/dave/.pyenv/versions/$(cat ~/.pyenv/version)/bin/virtualenvwrapper.sh")
source $VIRTUALENVWRAPPER_SCRIPT

# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"

# Configure Oh My ZSH to remind me to update
zstyle ':omz:update' mode reminder

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Change the command execution time stamp shown in the history command output.
HIST_STAMPS="dd-mm-yyyy"

# Specify Terminal Plugins
plugins=(
	# Git aliases
	git
	# Allows you to press Ctrl-Z instead of typing fg to bring
	# back background tasks.
	fancy-ctrl-z
	# Enables GPG Agent if it's not running
	gpg-agent
	# Convenient aliases for the history command
	# See: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/history
	history
	# Substring search
	history-substring-search
	# Load pyenv and checks if it's properly configured
	pyenv
	# SSH Agent Helper; Ensures it's started and loads keys
	ssh-agent
	# Fish-like command suggestions and completion
	zsh-autosuggestions
)

# SSH Agent Plugin Settings
# Load Identities
zstyle ':omz:plugins:ssh-agent' identities /home/dave/.ssh/id_ed25519_main
# Ensure plugin lazy loading is disabled
zstyle ':omz:plugins:ssh-agent' lazy no

# Source Oh My ZSH
source $ZSH/oh-my-zsh.sh

# User configuration
# Load local uncommited profile
source ~/.localrc
# Set preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export PATH=$PATH:/usr/local/go/bin

# Aliases
alias e=$EDITOR
