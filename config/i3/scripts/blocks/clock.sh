#!/bin/bash
# i3blocks Clock script

case "$BLOCK_BUTTON" in
    1) i3-msg -q "exec kitty --class floating_shell -e calcurse" ;;
esac

echo "  $(date '+%a, %b %d')   $(date '+%I:%M %p') "
echo " $(date '+%H:%M') "
echo "#ffffff"
