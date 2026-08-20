#!/bin/bash
# i3blocks Menu launcher script

case "$BLOCK_BUTTON" in
    1) i3-msg -q "exec rofi -show combi -combi-modi 'drun,run' -terminal kitty -show-icons -lines 10 -width 35" ;;
esac

echo "  Menu "
echo "  "
echo "#1688f0"
