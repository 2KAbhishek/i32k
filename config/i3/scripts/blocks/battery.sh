#!/bin/bash
# i3blocks Battery script

BAT_PATH="/sys/class/power_supply/BAT0"

if [ ! -d "$BAT_PATH" ]; then
    BAT_PATH=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n1)
fi

if [ -z "$BAT_PATH" ] || [ ! -f "$BAT_PATH/capacity" ]; then
    exit 0
fi

CAPACITY=$(cat "$BAT_PATH/capacity")
STATUS=$(cat "$BAT_PATH/status" 2>/dev/null)

if [ "$STATUS" = "Charging" ]; then
    ICON="󰂄"
    COLOR="#55b5db"
elif [ "$CAPACITY" -ge 90 ]; then
    ICON="󰁹"
    COLOR="#9fca56"
elif [ "$CAPACITY" -ge 60 ]; then
    ICON="󰁿"
    COLOR="#9fca56"
elif [ "$CAPACITY" -ge 30 ]; then
    ICON="󰁽"
    COLOR="#e6cd69"
elif [ "$CAPACITY" -ge 15 ]; then
    ICON="󰁻"
    COLOR="#db7b55"
else
    ICON="󰂃"
    COLOR="#ff0043"
fi

echo " $ICON ${CAPACITY}% "
echo " ${CAPACITY}% "
echo "$COLOR"
