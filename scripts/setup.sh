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
set -e
shopt -s xpg_echo
PROGRAM_DIR=$(realpath "$0" | xargs dirname)
source "$PROGRAM_DIR/../helpers.sh"
APPLICATIONS=(
    "emacs-nativecomp" "kitty" "wofi" "google-chrome" "thunar" "udiskie"
)
UTILITIES=(
    "pamixer" "bluez" "bluez-utils" "zsh" "man" "tldr" "ripgrep" "zoxide"
    "openssh" "ispell" "cmake" "nvm" "clang" "shellcheck" "shfmt" "gcc" "fd"
    "python-pip" "inetutils" "gnu-netcat" "net-tools" "bind" "wget" "dotnet-sdk"
    "texlive-basic" "texlive-latex" "texlive-latexrecommended"
    "texlive-mathscience" "texlive-latexextra" "libappindicator-gtk3"
    "bottom-git" "keychain"
)
FONTS=(
    "ttf-meslo-nerd-font-powerlevel10k" "noto-fonts-emoji"
    "ttf-noto-fonts-symbols" "apple-fonts"
)

# Prints out usage information
usage() {
    cat <<EOF
Usage: $(realpath --relative-to "$(pwd)" "$0") [OPTIONS]

Options:
  base        Install must-have packages (Yay, Emacs, Chrome, Rust, etc.) & setup environment.
  rog         Install Asus ROG ArchLinux packages.
  hypr        Install Hyprland environment.
  nvidia      Install Nvidia graphics card packages.
  amdcpu      Install AMD CPU microcode.
  intelcpu    Install Intel CPU microcode.
  amdgpu      Install AMD GPU packages.
EOF
}

install_required() {
    CreateDir "$HOME/.config"
    CreateDir "$HOME/.local/bin"
    CreateDir "$HOME/workspace/thirdparty"
    CreateDir "$HOME/Notes"
    CreateDir "$HOME/Books"

    if [[ ! -x $YAY ]]; then
        echo "=> $(ColorBlue 'Installing Yay')..."
        UpdatePacmanDB
        InstallPackages git base-devel
        git clone https://aur.archlinux.org/yay.git ~/workspace/thirdparty/yay >/dev/null
        cd ~/workspace/thirdparty/yay || return 1
        makepkg -si --noconfirm >/dev/null
        cd - || return 1
    fi
}

install_rog() {
    packages=(
        "asusctl" "power-profiles-daemon" "supergfxctl" "rog-control-center"
    )
    pacman-conf --repo-list | grep -q 'g14'
    if [[ $? -ne 0 ]]; then
        echo "=> $(ColorYellow 'Adding g14 repository')..."
        sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
        sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
        sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
        sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
        echo -e "\n[g14]\nServer = https://arch.asus-linux.org" | sudo tee -a /etc/pacman.conf
        UpdatePacmanDB
    fi

    InstallPackages "${packages[@]}"
    EnableStartService power-profiles-daemon.service supergfxd
}

install_hypr() {
    packages=(
        "brightnessctl" "greetd" "greetd-regreet" "grim" "hyprland"
        "hyprland-qtutils" "hyprpaper" "libnotify" "lxappearance" "mako"
        "nordic" "slurp" "swaylock-effects" "waybar" "wlogout"
        "xdg-desktop-portal-hyprland" "xfce4-settings"
    )

    echo "=> $(ColorBlue 'Setting up Hyprland')."
    echo "=> $(ColorBlue 'Installing packages')..."
    InstallPackages "${packages[@]}"

    echo "=> $(ColorBlue 'Configuring greeter'); You get all the info :).."
    set -x
    sudo sed -i 's/agreety --cmd .*/Hyprland --config \/etc\/greetd\/hyprland.conf"/' /etc/greetd/config.toml
    echo "preload = /opt/ign_mountains.png\nwallpaper = , /opt/ign_mountains.png" | sudo tee /etc/greetd/hyprpaper.conf
    echo "monitor = , preferred, auto, 1\nexec-once = hyprpaper --config /etc/greetd/hyprpaper.conf\nexec-once = regreet --config /etc/greetd/regreet.toml; hyprctl dispatch exit" | sudo tee /etc/greetd/hyprland.conf
    sudo cp "${PROGRAM_DIR}/../regreet/ign_mountains.png" /opt/
    sudo cp --update=all "${PROGRAM_DIR}/../regreet/regreet.toml" /etc/greetd/
    set +x
    echo "=> $(ColorYellow 'Enabling service'): greetd.service"
    sudo systemctl enable greetd.service

    echo "=> $(ColorBlue 'Configuring Hyprland, Mako, WLogout, SwayLock & WayBar')..."
    UpdateCopy "${PROGRAM_DIR}/../hypr" ~/.config/
    UpdateCopy "${PROGRAM_DIR}/../mako" ~/.config/
    UpdateCopy "${PROGRAM_DIR}/../wlogout" ~/.config/
    UpdateCopy "${PROGRAM_DIR}/../swaylock" ~/.config/
    UpdateCopy "${PROGRAM_DIR}/../waybar" ~/.config/
    chmod +x ~/.config/hypr/xdg-portal-hyprland
    chmod +x ~/.config/hypr/battery_notification.sh
}

install_base() {
    echo "=> $(ColorBlue 'Setting up base environment')."
    echo "=> $(ColorBlue 'Installing utilities')..."
    InstallPackages "${UTILITIES[@]}"
    echo "=> $(ColorBlue 'Installing applications')..."
    InstallPackages "${APPLICATIONS[@]}"
    echo "=> $(ColorBlue 'Installing fonts')..."
    InstallPackages "${FONTS[@]}"

    if [[ ! -x "$HOME/.config/emacs/bin/doom" ]]; then
        echo "=> $(ColorBlue 'Installing doomemacs')..."
        git clone --depth 1 https://github.com/doomemacs/doomemacs.git ~/.config/emacs >/dev/null 2>&1
        ~/.config/emacs/bin/doom install >/dev/null
        ~/.config/emacs/bin/doom sync >/dev/null
    fi

    echo "=> $(ColorBlue 'Installing latest stable node version')..."
    source /usr/share/nvm/init-nvm.sh
    nvm install stable

    echo "=> $(ColorBlue 'Setting zsh as default shell')..."
    set +e
    chsh --shell /usr/bin/zsh
    success=$?
    while [[ $success -ne 0 ]]; do
        read -n1 -rp "$(ColorRed 'Failed to change shell'). Skip[Y|N]? " SKIP
        echo
        if [[ $SKIP == "Y" ]] || [[ $SKIP == "y" ]]; then
            break
        fi
        chsh --shell /usr/bin/zsh
        success=$?
    done
    set -e

    echo "=> $(ColorBlue 'Configuring git')..."
    git config --global user.email "davis.ray.muro@gmail.com"
    git config --global user.name "Davis Muro"
    git config --global init.defaultBranch main

    echo "=> $(ColorBlue 'Configuring Emacs & Kitty')..."
    UpdateCopy "${PROGRAM_DIR}/../doom" ~/.config/
    UpdateCopy "${PROGRAM_DIR}/../kitty" ~/.config/
    ~/.config/emacs/bin/doom sync >/dev/null

    if [[ ! -d "$HOME/.zprezto" ]]; then
        echo "=> $(ColorBlue 'Installing prezto')..."
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto" >/dev/null 2>&1
    fi
    echo "=> $(ColorBlue 'Configuring Zsh')..."
    UpdateCopy "${PROGRAM_DIR}/../.zshrc" ~/
    UpdateCopy "${PROGRAM_DIR}/../.zlogin" ~/
    UpdateCopy "${PROGRAM_DIR}/../.zlogout" ~/
    UpdateCopy "${PROGRAM_DIR}/../.zpreztorc" ~/
    UpdateCopy "${PROGRAM_DIR}/../.zprofile" ~/
    UpdateCopy "${PROGRAM_DIR}/../.zshenv" ~/
    UpdateCopy "${PROGRAM_DIR}/../.p10k.zsh" ~/

    EnableStartService bluetooth.service
    echo "=> $(ColorYellow 'Starting & enabling service'): emacs.service"
    systemctl --user enable --now emacs.service
}

main() {
    install_required

    for option in "$@"; do
        case $option in
        amdcpu)
            InstallPackages "amd-ucode"
            ;;
        amdgpu)
            InstallPackages "mesa"
            ;;
        base)
            install_base
            ;;
        hypr)
            install_hypr
            ;;
        intelcpu)
            InstallPackages intell-ucode
            ;;
        nvidia)
            InstallPackages nvidia nvidia-utils opencl-nvidia cuda
            ;;
        rog)
            install_rog
            ;;
        *)
            echo "$(ColorRed 'Unknown option'): $option"
            usage
            exit 1
            ;;
        esac
    done

    exit 0
}

main "$@"
