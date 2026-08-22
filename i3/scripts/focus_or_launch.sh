#!/bin/bash
# Usage: focus_or_launch.sh <command> [class_search]
# Example: focus_or_launch.sh kitty
#          focus_or_launch.sh chromium chromium

CMD="$1"
SEARCH="${2:-${1%% *}}"

if [ -z "$CMD" ]; then
    echo "Usage: $0 <command> [class_search]"
    exit 1
fi

# Find an existing window matching class or instance in i3 tree
WIN_ID=$(i3-msg -t get_tree | jq -r '.. | select(.window_properties? | select((.class? != null and (.class | ascii_downcase | contains("'"$SEARCH"'" | ascii_downcase))) or (.instance? != null and (.instance | ascii_downcase | contains("'"$SEARCH"'" | ascii_downcase))))) | .id' 2>/dev/null | head -n1)

if [ -n "$WIN_ID" ]; then
    i3-msg "[con_id=\"$WIN_ID\"] focus"
else
    eval "$CMD &"
fi
