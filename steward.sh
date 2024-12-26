#!/usr/bin/env bash
#
# Steward is a script designed to manage dotfile configurations. It allows users
# to sync dotfiles to/from remote, as well as executing helper scripts that are
# stored within the dotfiles.
VERSION=0.0.1

# Prints out usage information
usage() {
    cat <<EOF
Usage: ${0} COMMAND [OPTION]

Commands:
    install         Installs this script in "$HOME/.local/bin".
    sync            Synchronize current state of local repository with
                    remote repository.
Options:
    -h              Show this help message.
    -V              Display program version.
EOF
}

####################################################################
# Description: Creates a symlink to this script in $HOME/.local/bin
# Arguments:
#    None
###################################################################
install() {
    dest="$HOME/.local/bin"
    mkdir -p "$dest"
    dest="$dest/steward"
    src=$(realpath "$0")

    if [[ -L $dest ]]; then
        read -n1 -rp "File already exists at ${dest}. Override ? [Y|N] " override
        echo
        if [[ $override == "Y" ]] || [[ $override == "y" ]]; then
            ln -sf "$src" "$dest"
        else
            return
        fi
    else
        ln -s "$src" "$dest"
    fi
    echo "Symlink created: $dest"
}

####################################################################
# Description: Synchronizes local repository state with upstream
# Arguments:
#    None
####################################################################
sync() {

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
        exit 0
        ;;
    *)
        echo "unknown command: ${command}"
        usage
        exit 1
        ;;
    esac
}

main "$@"
