#!/usr/bin/env bash
#
# A collection of helpful functions and variables.
YAY=/sbin/yay
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
RESET="\e[0m"

###
# Color functions
###
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

###
# Filesystem helpers
###

CreateDir() {
    path=$1

    if [[ -z $path ]]; then
        echo "$(ColorRed 'Path argument required')."
        return 1
    fi

    if [[ -d $path ]]; then
        return
    fi

    echo "=> $(ColorGreen 'Creating'): $path"
    mkdir -p "$path"
}

UpdatePacmanDB() {
    echo "=> $(ColorGreen 'Updating local Pacman database')..."
    if [[ -x $YAY ]]; then
        $YAY -Sy
    else
        sudo pacman -Sy
    fi
}

InstallPackages() {
    echo "=> $(ColorYellow 'Installing packages'): $*"
    if [[ -x $YAY ]]; then
        $YAY -S --needed --noconfirm "$@" >/dev/null 2>&1
    else
        sudo pacman -S --needed --noconfirm "$@" >/dev/null 2>&1
    fi
}

EnableStartService() {
    echo "=> $(ColorYellow 'Starting & enabling service(s)'): $*"
    sudo systemctl enable --now "$@"
}

UpdateCopy() {
    echo "$(ColorBlue 'Copy'): $(ColorRed "$1 -> $2")"
    cp --update=all -R "$1" "$2"
}
