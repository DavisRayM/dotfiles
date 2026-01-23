#!/usr/bin/env bash

# Apply dotfiles NixOS configuration
#
# This script automates switching your system to the NixOS configuration
# stored in your dotfiles. It performs the following steps:
#
#   1. Copies the local `configuration.nix` from your dotfiles repository
#      into the NixOS system configuration path
#      (defaults to `/etc/nixos/configuration` unless overridden by
#      the NIX_CONF environment variable).
#
#   2. Ensures the copied configuration file is owned by root:root,
#      as required for the system configuration.
#
#   3. Runs `nixos-rebuild switch` to build and activate the new
#      NixOS configuration immediately.
#
# Usage:
#   ./scripts/switch.sh
#
# Environment variables:
#   NIX_CONF  Optional. Target configuration path.
#             Default: /etc/nixos/configuration

NIX_CONF_LOCATION=${NIX_CONF:-/etc/nixos/configuration.nix}

COLOR_BLUE="\033[1;34m"
COLOR_RESET="\033[0m"

main() {
    echo -e "\n${COLOR_BLUE}[1/3] Overriding Nixos configuration${COLOR_RESET}"
    sudo cp -f configuration.nix "$NIX_CONF_LOCATION"

    echo -e "\n${COLOR_BLUE}[2/3] Changing ownership to root${COLOR_RESET}"
    sudo chown root:root "$NIX_CONF_LOCATION"

    echo -e "\n${COLOR_BLUE}[3/3] Switching OS version${COLOR_RESET}"
    sudo nixos-rebuild switch
}

main "$@"
