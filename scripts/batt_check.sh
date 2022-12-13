#!/bin/zsh
# Just a simple script to send battery notifications
# Note: You may want to change the BATT_CAPACITY_FILE to your respective battery
# Usually BAT0 or BAT1
BATT_CAPACITY_FILE="/sys/class/power_supply/BAT0"

if [[ $(cat "${BATT_CAPACITY_FILE}/capacity") -ge "80" && $(cat "${BATT_CAPACITY_FILE}/status") == "Charging" ]]
then
#	notify-send -u critical -t 50000 -i battery -c battery "Disconnect charger" "Charger is at or above 80%"
fi

if [[ $(cat "${BATT_CAPACITY_FILE}/capacity") -le "30" && $(cat "${BATT_CAPACITY_FILE}/status") == "Discharging" ]]
then
	notify-send -u critical -t 50000 -i battery -c battery "Connect charger" "Charger is at or below 30%"
fi
