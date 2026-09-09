#!/usr/bin/env bash

SOCKET="/tmp/mpv-socket"

if ! pgrep -x mpv >/dev/null 2>&1; then
  rm -f "$SOCKET"
fi

echo '{"command": ["load-config-file", "~/.config/mpv/themes/matugen.conf"]}' | socat - "$SOCKET" 2>/dev/null || true
