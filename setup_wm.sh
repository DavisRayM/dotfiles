#!/bin/bash

set -xe

# Inspired by: https://github.com/SolDoesTech/hyprland/blob/main/set-hypr
# This script attempts to setup a Hyprland environment on an Arch Linux Installation.
# Installs:
# - fd: Find alternative; Doomemacs requirement
# - ripgrep: Search tool
# - zoxide: Smarter cd
# - ispell: Spelling checker
# - cmake: Build tool
# - hyprland: Tiling wayland compositor; https://github.com/hyprwm/Hyprland
# - kitty: GPU based terminal emulator; https://github.com/kovidgoyal/kitty
# - waybar: Wayland bar for compositors; https://github.com/Alexays/Waybar
# - swagbg: Wallpaper tool for Wayland compositors; https://github.com/swaywm/swaybg
# - emacs-nativecomp: EVIL Mode ❤
# - wofi: Application launcher
# - ttf-jetbrains-mono-nerd: Font
# - noto-fonts-emoji: Emoji font
# - polkit-gnome: authentication utility
# - pamixer: Audio device settings helper
# - bluez & bluez-utils: Bluetooth services
# - xdg-desktop-portal-hyprland: XDG Desktop Portal backend for Hyprland; https://github.com/hyprwm/xdg-desktop-portal-hyprland
# - zsh & Oh-My-Zsh: Unix shell; https://github.com/ohmyzsh/ohmyzsh
# - doomemacs: Emacs framework; https://github.com/doomemacs/doomemacs
# - google-chrome: Browser
# - man: Manual pages
# - tldr: Man pages are too long!!; https://github.com/tldr-pages/tldr
# - Coding tools: clang, shellcheck, shfmt, gcc, nvm, uv, pip, python-black,
#   python-pyflakes python-isort python-pipenv python-nose python-pytest python-setuptools
# - [Optional] Asus ROG Utilities
#   (asusctl, supergfxctl, rog-control-center, power-profiles-daemon); https://asus-linux.org/guides/arch-guide/

YAY=/sbin/yay

if [ -f "$YAY" ]; then
    echo -e "-> Updating local pacman database...\n"
    yay -Syu
else
    echo -e "yay has not been installed!\n"
    exit
fi

echo -e "-> Installing required packages; See script for list of installed packages...\n"
sleep 5
yay -S --noconfirm hyprland kitty waybar swagbg \
    emacs-nativecomp wofi ttf-jetbrains-mono-nerd \
    noto-fonts-emoji pamixer bluez blues-utils \
    xdg-desktop-portal-hyprland zsh google-chrome man tldr \
    ripgrep zoxide openssh ispell cmake nvm clang shellcheck \
    shfmt gcc fd uv python-pip python-black python-pyflakes \
    python-isort python-pipenv python-nose python-pytest \
    python-setuptools

echo -e "-> Starting bluetooth service...\n"
sudo systemctl enable --now bluetooth.service
sleep 5

echo -e "-> Copying configuration files for Hyprland & Waybar...\n"
cp -R hypr ~/.config/
cp -R waybar ~/.config/
chmod +x ~/.config/hypr/xdg-portal-hyprland
sleep 5

echo -e "-> Setting zsh as default shell...\n"
chsh --shell /usr/bin/zsh

echo -e "-> Installing Oh-My-Zsh...\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sleep 5

echo -e "-> Installing doomemacs...\n"
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
sleep 5

echo -e "-> Copying configuration files for zsh and emacs...\n"
cp .zshrc ~/
cp --update=all -R doom ~/.config/
sleep 5

echo -e "-> Installing latest stable node version...\n"
source /usr/share/nvm/init-nvm.sh
nvm install stable
sleep 5

read -n1 -rep 'Would you like to install Asus ROG software support? (y,n)' ROG
if [[ $ROG == "Y" || $ROG == "y" ]]; then
    echo -e "-> Adding g14 repo sign keys...\n"
    sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
    sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
    sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
    sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

    LOC="/etc/pacman.conf"
    echo -e "-> Updating $LOC with g14 repo.\n"
    echo -e "\n[g14]\nServer = https://arch.asus-linux.org" | sudo tee -a $LOC
    echo -e "\n"

    echo -e "-> Updating local pacman database...\n"
    sudo pacman -Suy

    echo -e "-> Installing ROG pacakges...\n"
    sudo pacman -S --noconfirm asusctl power-profiles-daemon supergfxctl rog-control-center
    echo -e "-> Activating ROG services...\n"
    sudo systemctl enable --now power-profiles-daemon.service
    sleep 5
    sudo systemctl enable --now supergfxd
    sleep 5
fi

echo -e "\n\n-> Setup complete!! Remember to run $(doom sync)"
sleep 10

read -n1 -rep 'Would you like to start Hyprland ? (Y|N)' START
if [[ $START == "Y" || $START == "y" ]]; then
    exec Hyprland
else
    exit
fi
