#!/usr/bin/env zsh
# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ("$SHLVL" -eq 1 && ! -o LOGIN) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprofile"
fi

export EDITOR="nvim"
export GPG_TTY=$(tty)

typeset -U PATH path

# Rust/Cargo
export PATH=$PATH:$HOME/.cargo/bin
# DoomEmacs
export PATH=$PATH:$HOME/.config/emacs/bin
# .NET
export PATH=$PATH:$HOME/.dotnet/tools
# User-specific binaries
export PATH=$PATH:$HOME/.local/bin
. "$HOME/.cargo/env"
