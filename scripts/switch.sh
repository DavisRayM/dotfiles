#!/usr/bin/env bash
COLOR_BLUE="\033[1;34m"
COLOR_RESET="\033[0m"

main() {
    echo -e "${COLOR_BLUE}[INFO] Switching OS version${COLOR_RESET}"
    sudo nixos-rebuild switch --flake .
}

main "$@"
