#!/usr/bin/env bash
#
# mpv-reload.sh - push a regenerated theme into a RUNNING mpv via IPC.
#
# Usage: mpv-reload.sh [theme-file]
#   theme-file: basename under ~/.config/mpv/themes (default: matugen.conf)
#
# Env overrides (mainly for testing):
#   MPV_SOCKET            IPC socket path (default: /tmp/mpv-socket)
#   MPV_RELOAD_NO_NOTIFY  set to 1 to suppress desktop notifications
#
# Behavior:
#   - Sends `load-config-file <theme>` to the running mpv and validates the
#     IPC response instead of silently discarding errors.
#   - Detects a STALE socket file (exists but nothing listens, e.g. left
#     behind by a crashed mpv that blocks new instances from binding IPC)
#     and removes it so future mpv launches get a working socket.
#   - Appends a one-line record per run to the log file for diagnosis.
#   - Always exits 0: this runs as a matugen post-hook / theme helper and
#     must never break the wallpaper/theme pipeline.
#   - Notifies (once, only when mpv IS running but unreachable) so the user
#     knows a restart of mpv is needed. A running mpv without an IPC
#     listener cannot be themed from the outside at all.

SOCKET="${MPV_SOCKET:-/tmp/mpv-socket}"
THEME_NAME="${1:-matugen.conf}"
THEME_FILE="$HOME/.config/mpv/themes/$THEME_NAME"
LOG_FILE="$HOME/.cache/hyprland-dotfiles/mpv-reload.log"

log() {
  mkdir -p "$(dirname "$LOG_FILE")"
  printf '%s %s\n' "$(date '+%F %T')" "$1" >>"$LOG_FILE"
}

notify() {
  [ "${MPV_RELOAD_NO_NOTIFY:-0}" = "1" ] && return 0
  command -v notify-send >/dev/null 2>&1 || return 0
  notify-send -a "mpv-reload" -i "mpv" "$1" "$2" 2>/dev/null || true
}

if [ ! -f "$THEME_FILE" ]; then
  log "ERROR theme file missing: $THEME_FILE"
  exit 0
fi

# No mpv running: nothing to push to. Drop a stale socket file if one lingers
# so the next mpv launch can bind IPC cleanly.
if ! pgrep -x mpv >/dev/null 2>&1; then
  if [ -S "$SOCKET" ]; then
    rm -f "$SOCKET"
    log "INFO no mpv running, removed stale socket $SOCKET"
  else
    log "INFO no mpv running, nothing to reload ($THEME_NAME)"
  fi
  exit 0
fi

RESPONSE="$(printf '{"command": ["load-config-file", "%s"]}\n' "$THEME_FILE" |
  timeout 5 socat - "UNIX-CONNECT:$SOCKET" 2>&1)"
STATUS=$?

if [ $STATUS -eq 0 ] && printf '%s' "$RESPONSE" | grep -q '"error":"success"'; then
  log "OK reloaded $THEME_NAME into running mpv"
  exit 0
fi

# Failed while mpv is (supposedly) running. If the socket file exists but
# nothing answers, it is stale (crashed owner): remove it so the NEXT mpv
# launch binds IPC. The CURRENT instance has no listener and can only pick
# up the already-regenerated theme file on restart.
if [ -S "$SOCKET" ] || [ -e "$SOCKET" ]; then
  rm -f "$SOCKET"
  log "WARN stale socket $SOCKET removed (mpv unreachable: ${RESPONSE:-socat exit $STATUS})"
else
  log "WARN mpv running but no socket at $SOCKET (${RESPONSE:-socat exit $STATUS})"
fi

notify "mpv theme needs restart" "Wallpaper changed but the running mpv has no working IPC socket. Theme file updated ($THEME_NAME) - restart mpv to apply it on the fly next time."
exit 0
