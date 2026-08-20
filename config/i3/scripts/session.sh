#!/usr/bin/env bash

# Session manager helper for XFCE + i3 and Standalone i3

action="$1"

case "$action" in
    lock)
        if pgrep -x xfce4-session >/dev/null 2>&1 && command -v xflock4 >/dev/null; then
            xflock4
        elif command -v i3lock >/dev/null; then
            i3lock -c 000000
        else
            loginctl lock-session
        fi
        ;;
    logout)
        if pgrep -x xfce4-session >/dev/null 2>&1; then
            xfce4-session-logout --logout
        else
            i3-msg exit
        fi
        ;;
    suspend)
        systemctl suspend || loginctl suspend
        ;;
    reboot)
        systemctl reboot || loginctl reboot
        ;;
    shutdown)
        systemctl poweroff || loginctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|reboot|shutdown}"
        exit 1
        ;;
esac
