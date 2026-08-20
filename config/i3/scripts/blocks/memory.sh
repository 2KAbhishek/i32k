#!/bin/bash
# i3blocks Memory script

case "$BLOCK_BUTTON" in
    1) i3-msg -q "exec kitty --class floating_shell -e htop" ;;
esac

MEM_INFO=$(free -m | awk '/Mem:/ {printf "%.1fG/%.1fG (%d%%)", $3/1024, $2/1024, ($3/$2)*100}')
PCT=$(free | awk '/Mem:/ {print int(($3/$2)*100)}')

echo "  $MEM_INFO "
echo " $MEM_INFO "

if [ "$PCT" -ge 85 ]; then
    echo "#ff0043"
elif [ "$PCT" -ge 65 ]; then
    echo "#db7b55"
else
    echo "#a074c4"
fi
