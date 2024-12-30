#!/usr/bin/env bash
#
# Connect to a WPA2-Enterprise WiFi Network using NetworkManager
set -e
PROGRAM_DIR=$(realpath "$0" | xargs dirname)

#Prints out usage information
usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTION]

Options:
  -h          Print this help message
EOF
}

# Description: Connect to a WiFi WPA2-Enterprise Network
connect() {
    read -rp "Enter WiFi profile name: " profile
    read -rp "Enter WiFi SSID: " ssid
    read -rp "Enter WiFi Identity: " identity
    read -rsp "Enter WiFi Password: " password
    echo

    nmcli conn add \
        type wifi \
        connection.id "$profile" \
        wifi.ssid "$ssid" \
        wifi.mode infrastructure \
        wifi-sec.key-mgmt wpa-eap \
        802-1x.eap peap \
        802-1x.identity "$identity" \
        802-1x.phase2-auth mschapv2 \
        802-1x.password "$password"

    nmcli conn show "$profile"

    nmcli conn up "$profile"
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

    connect
}

main "$@"
