#!/usr/bin/env zsh
# Execute code only if STDERR is bound to a TTY.
[[ -o INTERACTIVE && -t 2 ]] && {

} >&2
