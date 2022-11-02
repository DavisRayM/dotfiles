#!/bin/zsh

export GPG_TTY=$(tty)
export TERM=xterm-256color

# Prezto history-substring-search binding fix
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Add Rust binaries to path
export PATH=$PATH:~/.cargo/bin

# Setup zoxide for zsh
eval "$(zoxide init zsh)"

export EDITOR="nvim"
export VISUAL="nvim"
