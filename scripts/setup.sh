#!/usr/bin/env bash
#
# Configures current environment; creating folder, installing & configuring
# packages. Supports various options:
#  - amdcpu
#  - amdgpu
#  - base
#  - hypr
#  - intelcpu
#  - nvidia
#  - rog
#  - rust
#  - osdev
set -e
shopt -s xpg_echo
PROGRAM_DIR=$(realpath "$0" | xargs dirname)
source "$PROGRAM_DIR/../helpers.sh"

# Prints out usage information
usage() {
    cat <<EOF
Usage: $(realpath --relative-to "$(pwd)" "$0") [GROUP] [OPTION]

Available Groups:
  amdcpu      Install AMD CPU microcode.
  amdgpu      Install AMD GPU packages.
  aur         Install Packages I use from Aur
  hypr        Install Hyprland environment.
  intelcpu    Install Intel CPU microcode.
  nvidia      Install Nvidia graphics card packages (NOTE: Must be after ROG if installing that too).
  rog         Install Asus ROG packages.

Options:
  -h          Print this help message
EOF
}

create_directories() {
    echo "=> $(ColorYellow 'Creating required directory structure')..."
    CreateDir "$HOME/.config"
    CreateDir "$HOME/.local/bin"
    CreateDir "$HOME/Workspace/thirdparty"
    CreateDir "$HOME/Workspace/aur-packages"
    CreateDir "$HOME/Downloads"
    CreateDir "$HOME/Pictures"
}

install_rog() {
    packages=(
        "asusctl" "power-profiles-daemon" "supergfxctl" "rog-control-center"
        "linux-g14" "linux-g14-headers"
    )
    if pacman-conf --repo-list | grep -q 'g14'; then
        echo "=> $(ColorGreen 'g14 repository already configured')."
    else
        echo "=> $(ColorYellow 'Adding g14 repository')..."
        sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
        sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
        sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
        sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
        echo -e "\n[g14]\nServer = https://arch.asus-linux.org" | sudo tee -a /etc/pacman.conf
        sudo pacman -Sy
    fi

    InstallPackages "${packages[@]}"
    EnableStartService power-profiles-daemon.service supergfxd
}

install_hypr() {
    packages=(
        "alsa-utils" "bind" "blueman" "bluez" "bluez-utils"
        "bottom" "brightnessctl" "discord" "dolphin"
        "evtest" "firefox" "fish" "fisher" "gcr-4" "gimp" "git" "gnome-keyring"
        "gnu-netcat" "grim" "hyprland" "hyprland-qtutils" "hyprlock"
        "hyprpaper" "hyprpicker" "hyprpolkitagent" "inetutils" "jq" "kitty"
        "libnotify" "lxappearance" "mako" "man-db" "man-pages" "neovim"
        "net-tools" "nodejs" "npm" "openssh" "pavucontrol" "playerctl" "qt5-wayland" "rofi" "rustup"
        "slurp" "steam-native-runtime" "tldr" "tmux" "ttf-noto-nerd" "unzip"
        "waybar" "wev" "wget" "wl-clipboard" "xdg-desktop-portal-hyprland" "zoxide"
        "bat" "seahorse"
    )

    echo "=> $(ColorBlue 'Setting up Hyprland')."
    echo "=> $(ColorBlue 'Installing packages')..."
    InstallPackages "${packages[@]}"

    echo "=> $(ColorBlue 'Configuring Hyprland & Grimblast...')..."
    UpdateCopy "${PROGRAM_DIR}/../hypr" ~/.config/
    chmod +x ~/.config/hypr/xdg-portal-hyprland
    sudo cp "${PROGRAM_DIR}/../third-party/grimblast" /usr/local/bin/
    sudo chmod +x /usr/local/bin/grimblast

    echo "=> $(ColorBlue 'Setting fish as default shell')..."
    set +e
    chsh --shell /usr/bin/fish
    success=$?
    while [[ $success -ne 0 ]]; do
        read -n1 -rp "$(ColorRed 'Failed to change shell'). Skip[Y|N]? " SKIP
        echo
        if [[ $SKIP == "Y" ]] || [[ $SKIP == "y" ]]; then
            break
        fi
        chsh --shell /usr/bin/fish
        success=$?
    done
    set -e

    echo "=> $(ColorBlue 'Setting up latest rust version')..."
    rustup install stable
    rustup component add rust-analyzer

    echo "=> $(ColorBlue 'Enabling SSH agent and Bluetooth service')..."
    EnableUserService gcr-ssh-agent.socket
    EnableStartService bluetooth.service
}

aur_packages() {
    presentDir="$(pwd)"
    cd ~/Workspace/aur-packages

    echo "=> $(ColorBlue 'Setting up paru')..."
    CloneOrUpdate https://aur.archlinux.org/paru.git paru
    cd paru
    echo "=> $(ColorBlue 'Installing paru package')..."
    makepkg -si
    cd -

    echo "=> $(ColorBlue 'Setting up Nordic')..."
    CloneOrUpdate https://aur.archlinux.org/nordic-theme.git nordic-theme
    cd nordic-theme
    echo "=> $(ColorBlue 'Installing Nordic package')..."
    makepkg -si
    cd -

    cd $presentDir
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

    create_directories

    for option in "$@"; do
        case $option in
        amdcpu)
            InstallPackages amd-ucode
            ;;
        amdgpu)
            InstallPackages mesa
            ;;
        aur)
            aur_packages
            ;;
        hypr)
            install_hypr
            ;;
        intelcpu)
            InstallPackages intel-ucode
            ;;
        nvidia)
            InstallPackages nvidia-dkms nvidia-utils
            ;;
        rog)
            install_rog
            ;;
        *)
            echo "$(ColorRed 'Unknown option'): $option"
            ;;
        esac
    done

    echo "=> $(ColorYellow 'Run `steward sync remote` to ensure configurations are present.')..."

    exit 0
}

main "$@"
