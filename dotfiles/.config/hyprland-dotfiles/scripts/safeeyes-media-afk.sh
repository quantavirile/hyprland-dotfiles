#!/bin/bash

is_mpv_window_visible() {
    hyprctl clients 2>/dev/null | grep -qi 'class:.*mpv'
}

while true; do
    if pgrep -x "freetube" >/dev/null; then
        safeeyes --disable
        echo "freetube is running"
        unset ENABLED_AFTER_CLOSE
    elif pgrep -x "mpv" >/dev/null; then
        if is_mpv_window_visible; then
            safeeyes --disable
            echo "mpv is running with visible window"
            unset ENABLED_AFTER_CLOSE
        else
            echo "mpv process lingering without window, killing it"
            pkill -x "mpv" 2>/dev/null
            if [ -z "${ENABLED_AFTER_CLOSE:-}" ]; then
                safeeyes --enable
                echo "safeeyes enabled after cleaning mpv"
                ENABLED_AFTER_CLOSE=1
            fi
        fi
    else
        if [ -z "${ENABLED_AFTER_CLOSE:-}" ]; then
            safeeyes --enable
            echo "mpv or freetube is not running"
            ENABLED_AFTER_CLOSE=1
        fi
    fi
    sleep 5
done
