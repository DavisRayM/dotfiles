#!/usr/bin/env bash

makoctl reload
notify-send -t 5000 -u "low" -a Steward -i ~/workspace/dotfiles/icons/dream-icon.png "steward:low-status" "test notification"
notify-send -t 5000 -u "normal" -a Steward -i ~/workspace/dotfiles/icons/dream-icon.png "steward:normal-status" "test notification"
notify-send -t 5000 -u "critical" -a Steward -i ~/workspace/dotfiles/icons/dream-icon.png "steward:critical-status" "test notification"
