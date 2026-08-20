#!/bin/bash
# i3blocks volume script

case "$BLOCK_BUTTON" in
    1) i3-msg -q "exec pavucontrol" ;;
    2) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    3) i3-msg -q "exec kitty -e alsamixer" ;;
    4) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    5) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
esac

MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{print $2}')
VOL=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | awk -F'/' '{print $2}' | tr -d ' %' | head -n1)

if [ "$MUTE" = "yes" ] || [ -z "$VOL" ]; then
    echo " 󰖁 Muted "
    echo " Muted "
    echo "#ff0043"
else
    if [ "$VOL" -ge 70 ]; then
        ICON=""
    elif [ "$VOL" -ge 30 ]; then
        ICON="󰖀"
    else
        ICON=""
    fi
    echo " $ICON ${VOL}% "
    echo " $VOL% "
    echo "#55b5db"
fi
