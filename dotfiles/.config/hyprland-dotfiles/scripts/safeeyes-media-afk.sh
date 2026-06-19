#!/bin/bash

disable_safeeyes() {
    if ! safeeyes --status 2>/dev/null | grep -qi "disabled"; then
        safeeyes --disable
    fi
}

enable_safeeyes() {
    if safeeyes --status 2>/dev/null | grep -qi "disabled"; then
        safeeyes --enable
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
