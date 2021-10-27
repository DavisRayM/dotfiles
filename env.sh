#!/bin/zsh

export EDITOR="nvim"

# Add Rust binaries to path
export PATH=$PATH:~/.cargo/bin

# Setup zoxide for zsh
eval "$(zoxide init zsh)"

# Aliases
alias vim="nvim"
