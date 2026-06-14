#!/bin/bash

safeeyes_state="unknown"

disable_safeeyes() {
    if [ "$safeeyes_state" != "disabled" ]; then
        safeeyes --disable
        safeeyes_state="disabled"
    fi
}

enable_safeeyes() {
    if [ "$safeeyes_state" != "enabled" ]; then
        safeeyes --enable
        safeeyes_state="enabled"
    fi
}

while true; do
    if pgrep -x "freetube" >/dev/null; then
        echo "freetube is running"
        disable_safeeyes
    elif pgrep -x "mpv" >/dev/null; then
        echo "mpv is running"
        disable_safeeyes
    else
        echo "mpv or freetube is not running"
        enable_safeeyes
    fi
    sleep 5
done
