#!/usr/bin/env bash

picture-of-the-day save ~/Workspace/dotfiles/modules/core/theme
IMAGE_PATH=$(ls -t ~/Workspace/dotfiles/modules/core/theme/ | head -n1)

mv -f "$HOME/Workspace/dotfiles/modules/core/theme/$IMAGE_PATH" ~/Workspace/dotfiles/modules/core/theme/background.jpg
sudo nixos-rebuild switch --flake ~/Workspace/dotfiles/#personal
