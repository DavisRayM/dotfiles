# Source Prezto.
if [[ -s "$HOME/.zprezto/init.zsh" ]]; then
    source "$HOME/.zprezto/init.zsh"
fi

# Aliases
alias ce="source /etc/profile.d/cuda.sh"

# Programs
eval "$(keychain --eval --quiet --agents ssh,gpg ~/.ssh/git)"
eval "$(zoxide init zsh)"
source /usr/share/nvm/init-nvm.sh
