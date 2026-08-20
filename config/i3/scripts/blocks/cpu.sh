#!/bin/bash
# i3blocks CPU script

case "$BLOCK_BUTTON" in
    1) i3-msg -q "exec kitty --class floating_shell -e btop" ;;
esac

# Calculate CPU usage percentage
USAGE=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print int((u-u1)*100/(t-t1));}' <(grep 'cpu ' /proc/stat; sleep 0.3; grep 'cpu ' /proc/stat))

[ -z "$USAGE" ] && USAGE=0

echo "  ${USAGE}% "
echo " ${USAGE}% "

if [ "$USAGE" -ge 85 ]; then
    echo "#ff0043"
elif [ "$USAGE" -ge 60 ]; then
    echo "#db7b55"
else
    echo "#e6cd69"
fi
