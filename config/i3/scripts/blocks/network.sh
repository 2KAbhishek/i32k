#!/bin/bash
# i3blocks Network script

case "$BLOCK_BUTTON" in
    1) i3-msg -q "exec kitty --class floating_shell -e nmtui connect" ;;
esac

IFACE=$(ip route | awk '/default/ {print $5}' | head -n1)

if [ -z "$IFACE" ]; then
    echo " 󰖪 Disconnected "
    echo " Disconnected "
    echo "#ff0043"
    exit 0
fi

IP=$(ip addr show "$IFACE" | grep 'inet ' | awk '{print $2}' | cut -d/ -f1 | head -n1)

if [[ "$IFACE" == w* ]]; then
    ESSID=$(iwgetid -r 2>/dev/null || echo "$IFACE")
    echo "  $ESSID ($IP) "
    echo "  $IP "
else
    echo " 󰈀 $IFACE ($IP) "
    echo " 󰈀 $IP "
fi

echo "#9fca56"
