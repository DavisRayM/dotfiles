#!/bin/bash

# This script copies over local configuration to this repository
# for syncing.

cp --update=all -R ~/.config/doom .
cp --update=all -R ~/.config/hypr .
cp --update=all -R ~/.config/waybar .
cp --update=all -R ~/.config/mako .
cp --update=all -R ~/.config/wlogout .
cp --update=all ~/.zshrc .
