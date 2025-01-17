#!/usr/bin/env bash
#
# Steward is a script designed to manage dotfile configurations. It allows users
# to sync dotfiles to/from remote, as well as executing helper scripts that are
# stored within the dotfiles.
set -e

PROGRAM_DIR=$(realpath "$0" | xargs dirname)
SCRIPTS_DIR="${PROGRAM_DIR}/scripts"
CONFIRM_BEFORE_EXECUTE="${STEWARD_CONFIRM_EXECUTE:-false}"
VERSION=0.0.1

# Files/Folders that reside in "$HOME/.config/".
CONFIGS=(
    "hypr"
    "mako"
    "wlogout"
    "swaylock"
    "kitty"
    "waybar"
    "doom"
    "nvim"
    "i3"
)
# Files/Folders that reside in "$HOME".
DOTFILES=(
    ".alacritty.toml"
    ".zshrc"
    ".zlogin"
    ".zlogout"
    ".zpreztorc"
    ".zprofile"
    ".zshenv"
    ".p10k.zsh"
)

source "${PROGRAM_DIR}/helpers.sh"

# Prints out usage information
usage() {
    cat <<EOF
Usage: ${0} COMMAND [OPTIONS]

Commands:
    install                      Installs the script to "$HOME/.local/bin".
    sync [local|remote]          Synchronizes state [Default: local]:
                                   - "local": Copies the local machine state to the repository.
                                   - "remote": Copies the repository files to the local machine.
    setup [OPTIONS]              Setup local machine. Supported options:
                                   - "base": Install my must-have packages (Yay, Emacs, Chrome, Rust, etc.).
                                   - "rog": Install Asus ROG ArchLinux packages.
                                   - "hypr": Install Hyprland environment.
                                   - "nvidia": Install Nvidia Graphics card packages.
                                   - "amdcpu": Install AMD CPU microcode.
                                   - "intelcpu": Install Intel CPU microcode.
                                   - "amdgpu": Install AMD GPU packages.
    execute SCRIPT               Execute one of the scripts in the repository.
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
    echo "=> $(ColorBlue 'Installing script')..."
    dest="$HOME/.local/bin"
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
    echo "=> $(ColorGreen 'Done'). Installed at $dest"
    return 0
}

####################################################################
# Description: Execute script; Fuzzy finds closest script matching
#              the query.
# Arguments:
#    Script to search for and execute
####################################################################
execute() {
    script=$1

    if [[ -z $script ]]; then
        echo "$(ColorRed 'Script search string missing')."
    fi

    readarray -t script < <(fd -t f -e sh -E setup.sh . "${PROGRAM_DIR}/scripts/" | fzf -q -1 --print0 -f "$script" | xargs -0 -n1)
    if [[ -n "${script[0]}" ]]; then
        if [[ "${CONFIRM_BEFORE_EXECUTE}" = "true" ]]; then
            echo "$(ColorYellow "Executing $(basename "${script[0]}")")"
            read -n1 -rp "Continue [Y|N]? " con
            echo

            if [[ $con == 'Y' ]] || [[ $con == 'y' ]]; then
                "${script[0]}" "${@:2}"
            fi
        else
            "${script[0]}" "${@:2}"
        fi
    else
        echo "$(ColorRed "Script not found")."
    fi
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
        echo "=> $(ColorBlue 'Synchronizing'): Local -> Remote"
        remote=0
        ;;
    remote)
        echo "=> $(ColorBlue 'Synchronizing'): Remote -> Local"
        remote=1
        ;;
    *)
        echo "$(ColorYellow 'Direction not specified')."
        echo "=> $(ColorBlue 'Synchronizing'): Local -> Remote"
        remote=0
        ;;
    esac

    localpath="$HOME"
    remotepath="$PROGRAM_DIR"

    for f in "${CONFIGS[@]}"; do
        if [[ $remote -eq 0 ]]; then
            to="${remotepath}/"
            from="${localpath}/.config/${f}"
        else
            to="${localpath}/.config/"
            from="${remotepath}/${f}"
        fi
        UpdateCopy "$from" "$to"
    done

    for f in "${DOTFILES[@]}"; do
        if [[ $remote -eq 0 ]]; then
            to="${remotepath}/"
            from="${localpath}/${f}"
        else
            to="${localpath}/"
            from="${remotepath}/${f}"
        fi
        UpdateCopy "$from" "$to"
    done

    echo "=> $(ColorGreen 'Done')."
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
    setup)
        bash "${SCRIPTS_DIR}/setup.sh" "${@:2}"
        exit $?
        ;;
    execute)
        execute "${@:2}"
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
