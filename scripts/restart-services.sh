#!/usr/bin/env bash
#
set -e
PROGRAM_DIR=$(realpath "$0" | xargs dirname)

# Ensures crucial services are running.
ensure_running() {
    if ! systemctl --user is-active emacs >/dev/null; then
        systemctl --user restart emacs
        notify-send -c "services" -u "low" -a Steward -i ~/workspace/dotfiles/icons/dream-icon.png "steward:services" "restarted emacs."
    fi
}

daemon() {
    while true; do
        ensure_running
    done
}

#Prints out usage information
usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTION]

command:
  daemon      Execute command as a service.

Options:
  -h          Print this help message
EOF
}

main() {
    while getopts "h" opt; do
        case $opt in
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
        esac
    done

    for option in "$@"; do
        case $option in
        daemon)
            daemon
            exit 0
            ;;
        *)
            usage
            exit 0
            ;;
        esac
    done

    ensure_running
}

main "$@"
