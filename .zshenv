#!/usr/bin/env zsh
# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ("$SHLVL" -eq 1 && ! -o LOGIN) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprofile"
fi

export EDITOR=emacs
export GPG_TTY=$(tty)

typeset -U PATH path

# Rust/Cargo
export PATH=$PATH:$HOME/.cargo/env
# DoomEmacs
export PATH=$PATH:$HOME/.config/emacs/bin
# .NET
export PATH=$PATH:$HOME/.dotnet/tools
# User-specific binaries
export PATH=$PATH:$HOME/.local/bin
