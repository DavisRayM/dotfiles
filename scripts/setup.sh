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
LLVM_RELEASE=release/20.x

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
    CreateDir "$HOME/workspace/thirdparty"
    CreateDir "$HOME/workspace/aur-packages"
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

install_neovim() {
    prerequisites=(
        "base-devel" "cmake" "ninja" "curl"
    )
    presentDir="$(pwd)"

    InstallPackages "${prerequisites[@]}"

    cd "$HOME/workspace/thirdparty"
    CloneOrUpdate https://github.com/neovim/neovim neovim
    cd neovim

    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install

    cd $presentDir
}

install_llvm() {
    prerequisites=(
        "base-devel" "cmake" "ninja" "curl"
    )
    presentDir="$(pwd)"

    InstallPackages "${prerequisites[@]}"

    cd "$HOME/workspace/thirdparty"
    CloneOrUpdate https://github.com/llvm/llvm-project llvm-project --depth 1 --branch $LLVM_RELEASE
    cd llvm-project

    git checkout $LLVM_RELEASE

    CreateDir build-release
    cd build-release
    cmake ../llvm \
        -DCMAKE_INSTALL_PREFIX=$HOME/local/llvm20-assert \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_ENABLE_PROJECTS="lld;clang" \
        -DLLVM_ENABLE_LIBXML2=OFF \
        -DLLVM_ENABLE_TERMINFO=OFF \
        -DLLVM_ENABLE_LIBEDIT=OFF \
        -DLLVM_ENABLE_ASSERTIONS=ON \
        -DLLVM_PARALLEL_LINK_JOBS=1 \
        -G Ninja
    ninja install

    cd $presentDir
}

install_zls() {
    presentDir="$(pwd)"

    cd "$HOME/workspace/thirdparty"
    CloneOrUpdate git@github.com:zigtools/zls.git zls

    cd zls
    zig build -Doptimize=ReleaseSafe
    ln -sf $(pwd)/zig-out/bin/zls ~/.local/bin/zls

    cd $presentDir
}

install_zig() {
    prerequisites=(
        "base-devel" "cmake" "ninja" "curl" "gcc" "clang"
    )
    presentDir="$(pwd)"

    InstallPackages "${prerequisites[@]}"
    install_llvm

    cd "$HOME/workspace/thirdparty"
    CloneOrUpdate git@github.com:ziglang/zig.git zig
    cd zig

    CreateDir build
    cd build
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH=$HOME/local/llvm20-assert
    make install
    ln -sf $(pwd)/stage3/bin/zig ~/.local/bin/zig

    cd $presentDir
}

install_hypr() {
    packages=(
        "alsa-utils" "bind" "blueman" "bluez" "bluez-utils"
        "bottom" "brightnessctl" "discord" "dolphin"
        "evtest" "firefox" "fish" "fisher" "gcr-4" "gimp" "git" "gnome-keyring"
        "gnu-netcat" "grim" "hyprland" "hyprland-qtutils" "hyprlock"
        "hyprpaper" "hyprpicker" "hyprpolkitagent" "inetutils" "jq" "kitty"
        "libnotify" "lxappearance" "mako" "man-db" "man-pages"
        "net-tools" "nodejs" "npm" "openssh" "pavucontrol" "playerctl" "qt5-wayland" "rofi" "rustup"
        "slurp" "tldr" "tmux" "ttf-sourcecodepro-nerd" "unzip"
        "waybar" "wev" "wget" "wl-clipboard" "xdg-desktop-portal-hyprland" "zoxide"
        "bat" "seahorse" "git-delta" "hyprlock" "hypridle" "fzf" "fd"
        "tree-sitter-cli" "lua-language-server" "ttf-nerd-fonts-symbols"
        "ttf-nerd-fonts-symbols-mono" "noto-fonts-emoji" "google-chrome"
        "github-cli" "pyenv" "virtualfish" "omnisharp-roslyn" "rust-analyzer"
        "gdb" "codelldb-bin" "minikube" "docker" "docker-compose" "docker-buildx"
        "kubectl"
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

    install_neovim

    echo "=> $(ColorBlue 'Setting up latest rust version')..."
    rustup install stable

    echo "=> $(ColorBlue 'Enabling SSH agent and Bluetooth service')..."
    EnableUserService gcr-ssh-agent.socket
    EnableStartService bluetooth.service
}

aur_packages() {
    presentDir="$(pwd)"
    cd ~/workspace/aur-packages

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
        nvim)
            install_neovim
            ;;
        zig)
            install_zig
            install_zls
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
