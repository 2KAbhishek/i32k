#!/usr/bin/env bash

# Session manager for i32k

action="$1"

case "$action" in
    lock)
        if command -v i3lock >/dev/null 2>&1; then
            i3lock -c 000000
        else
            loginctl lock-session
        fi
        ;;
    logout)
        i3-msg exit
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
