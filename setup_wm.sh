#!/bin/bash

set -e
shopt -s xpg_echo

# Inspired by: https://github.com/SolDoesTech/hyprland/blob/main/set-hypr
# This script attempts to setup a Hyprland environment on an Arch Linux Installation.
# Installs:
# - fd: Find alternative; Doomemacs requirement
# - libnotify: Notification library
# - Network utilities (inetutils, bind, wget)
# - mako: Notification daemon for Wayland
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
# - thunar: File manager
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
# - Theming (dracula theme, icons & lxappearance)
# - greetd & regreet: Login manager; https://github.com/rharish101/ReGreet
# - wlogout: Logout menu
# - swaylock-effects: Screen locking utility
# - apple-fonts: Some neat fonts for writing and stuff
# - texlive: Latex
# - [Optional] Nvidia drivers, utilities & GPU toolkit
# - [Optional] Asus ROG Utilities
#   (asusctl, supergfxctl, rog-control-center, power-profiles-daemon); https://asus-linux.org/guides/arch-guide/

YAY=/sbin/yay
mkdir -p ~/workspace/thirdparty

echo -e "-> Installing yay"
sudo pacman -Sy
sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git ~/workspace/thirdparty/yay
cd ~/workspace/thirdparty/yay
makepkg -si
cd -

echo -e "-> Updating local pacman database...\n"
yay -Syu

echo -e "-> Installing required packages; See script for list of installed packages...\n"
sleep 5
yay -S --noconfirm hyprland kitty waybar swagbg \
    emacs-nativecomp wofi ttf-jetbrains-mono-nerd \
    noto-fonts-emoji pamixer bluez blues-utils \
    xdg-desktop-portal-hyprland zsh google-chrome man tldr \
    ripgrep zoxide openssh ispell cmake nvm clang shellcheck \
    shfmt gcc fd uv python-pip python-black python-pyflakes \
    python-isort python-pipenv python-nose python-pytest \
    python-setuptools mako libnotify inetutils dig wget \
    thunar dracula-gtk-theme dracula-icons-git xfce4-settings \
    lxappearance greetd greetd-regreet wlogout swaylock-effects \
    slurp grim dotnet-sdk apple-fonts hyprland-qtutils \
    texlive-basic texlive-latex texlive-latexrecommended \
    texlive-mathscience texlive-latexextra udiskie libappindicator-gtk3

echo -e "-> Starting bluetooth service...\n"
sudo systemctl enable --now bluetooth.service
sleep 5

echo -e "-> Copying configuration files for Hyprland, Mako & Waybar...\n"
cp --update=all -R hypr ~/.config/
cp --update=all -R waybar ~/.config/
cp --update=all -R mako ~/.config/
cp --update=all -R wlogout ~/.config/
cp --update=all -R swaylock ~/.config/
cp --update=all -R udiskie ~/.config/
chmod +x ~/.config/hypr/xdg-portal-hyprland
chmod +x ~/.config/hypr/battery_notification.sh
sleep 5

echo -e "-> Configuring ReGreet as greeter...\n"
sudo systemctl enable greetd.service
sudo sed -i 's/agreety --cmd .*/Hyprland --config \/etc\/greetd\/hyprland.conf"/' /etc/greetd/config.toml
echo "monitor = , preferred, auto, 1\nexec-once = regreet --config /etc/greetd/regreet.toml; hyprctl dispatch exit" | sudo tee /etc/greetd/hyprland.conf
sudo cp ./regreet/grant-ritchie-x1w_Q78xNEY-unsplash.jpg /opt/
sudo cp --update=all ./regreet/regreet.toml /etc/greetd/
sleep 5

echo -e "-> Setting zsh as default shell...\n"
chsh --shell /usr/bin/zsh
sleep 5

echo -e "-> Installing Oh-My-Zsh...\n"
RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sleep 5

echo -e "-> Configuring git...\n"
git config --global user.email "davis.ray.muro@gmail.com"
git config --global user.name "Davis Muro"

echo -e "-> Installing doomemacs...\n"
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
cp --update=all -R doom ~/.config/
~/.config/emacs/bin/doom sync
systemctl --user enable --now emacs.service
sleep 5

echo -e "-> Copying configuration files for zsh...\n"
cp .zshrc ~/
sleep 5

echo -e "-> Installing latest stable node version...\n"
source /usr/share/nvm/init-nvm.sh
nvm install stable
sleep 5

read -n1 -rep 'Would you like to install Asus ROG support software? (y,n)' ROG
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

read -n1 -rep 'Would you like to install Nvidia drivers & CUDA toolkit? (y,n)' NVIDIA
if [[ $NVIDIA == "Y" || $NVIDIA == "y" ]]; then
    echo -e "-> Installing Nvidia pacakges...\n"
    yay -S --noconfirm nvidia nvidia-utils opencl-nvidia cuda
fi

echo -e "\n\n-> Setup complete!!"
sleep 10

read -n1 -rep 'Would you like to start Hyprland ? (Y|N)' START
if [[ $START == "Y" || $START == "y" ]]; then
    systemctl start greetd.service
else
    exit
fi
