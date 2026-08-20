#!/bin/bash
# i3blocks Disk script

case "$BLOCK_BUTTON" in
    1) i3-msg -q "exec pcmanfm" ;;
    3) i3-msg -q "exec kitty --class floating_shell -e ncdu ~/ " ;;
esac

AVAIL=$(df -h / | awk 'NR==2 {print $4}')

echo "  ${AVAIL} free "
echo " ${AVAIL} "
echo "#43a5d5"
