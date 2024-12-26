#!/usr/bin/env bash
#
# Steward is a script designed to manage dotfile configurations. It allows users
# to sync dotfiles to/from remote, as well as executing helper scripts that are
# stored within the dotfiles.
set -e

VERSION=0.0.1

# Files/Folders that reside in "$HOME/.config/".
CONFIGS=(
    "hypr"
    "mako"
    "wlogout"
    "swaylock"
    "udiskie"
    "kitty"
    "waybar"
    "doom"
)
# Files/Folders that reside in "$HOME".
DOTFILES=(
    ".zshrc"
)

####
# Helper functions
####

# COLORS
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
RESET="\e[0m"

ColorRed() {
    echo -ne "${RED}${1}${RESET}"
}

ColorGreen() {
    echo -ne "${GREEN}${1}${RESET}"
}

ColorBlue() {
    echo -ne "${BLUE}${1}${RESET}"
}

ColorYellow() {
    echo -ne "${YELLOW}${1}${RESET}"
}

####
# Program functions
####

# Prints out usage information
usage() {
    cat <<EOF
Usage: ${0} COMMAND [OPTIONS]

Commands:
    install                      Installs the script to "$HOME/.local/bin".
    sync [local|remote]          Synchronizes state [Default: local]:
                                   - "local" copies the local machine state to the repository.
                                   - "remote" copies the repository files to the local machine.

Options:
    -h                           Display this help message.
    -V                           Show the program version.
EOF
}

####################################################################
# Description: Installs this script to "$HOME/.local/bin".
# Arguments:
#    None
###################################################################
install() {
    echo "$(ColorBlue 'Installing script')..."
    dest="$HOME/.local/bin"
    mkdir -p "$dest"
    dest="$dest/steward"
    src=$(realpath "$0")

    if [[ -L $dest ]]; then
        read -n1 -rp "File already exists at ${dest}. $(ColorRed 'Override') ? [Y|N] " override
        echo
        if [[ $override == "Y" ]] || [[ $override == "y" ]]; then
            ln -sf "$src" "$dest"
        else
            echo "$(ColorGreen 'Done')."
            return 0
        fi
    else
        ln -s "$src" "$dest"
    fi
    echo "$(ColorGreen 'Done'). Installed at $dest"
    return 0
}

####################################################################
# Description: Synchronize local or remote state.
# Arguments:
#    "local" or "remote"
####################################################################
sync() {
    local remote
    local localpath
    local remotepath
    case $1 in
    "local")
        echo "$(ColorBlue 'Synchronizing'): Local -> Remote"
        remote=0
        ;;
    remote)
        echo "$(ColorBlue 'Synchronizing'): Remote -> Local"
        remote=1
        ;;
    *)
        echo "$(ColorYellow 'Direction not specified')."
        echo "$(ColorBlue 'Synchronizing'): Local -> Remote"
        remote=0
        ;;
    esac

    localpath="$HOME"
    remotepath="$(realpath "$0" | xargs dirname)"

    for f in "${CONFIGS[@]}"; do
        if [[ $remote -eq 0 ]]; then
            to="${remotepath}/"
            from="${localpath}/.config/${f}"
        else
            to="${localpath}/.config/"
            from="${remotepath}/${f}"
        fi
        echo "$(ColorBlue 'Sync'): $(ColorRed "$from -> $to/$f")"
        cp --update=all -R "$from" "$to"
    done

    for f in "${DOTFILES[@]}"; do
        if [[ $remote -eq 0 ]]; then
            to="${remotepath}/"
            from="${localpath}/${f}"
        else
            to="${localpath}/"
            from="${remotepath}/${f}"
        fi
        echo "$(ColorBlue 'Sync'): $(ColorRed "$from -> $to/$f")"
        cp --update=all -R "$from" "$to"
    done

    echo "$(ColorGreen 'Done')."
    return 0
}

# Main entrypoint of the script
main() {
    while getopts "hv" opt; do
        case $opt in
        h)
            usage
            exit 0
            ;;
        v)
            echo "version: $VERSION"
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
        esac
    done

    command=$1
    if [[ -z ${command} ]]; then
        usage
        exit 1
    fi

    case ${command} in
    install)
        install "${@:2}"
        exit $?
        ;;
    sync)
        sync "${@:2}"
        exit $?
        ;;
    *)
        echo "unknown command: ${command}"
        usage
        exit 1
        ;;
    esac
}

main "$@"
