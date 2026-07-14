policy_url="https://raw.githubusercontent.com/ente/ente/main/mobile/apps/auth/assets/polkit/com.ente.auth.policy"
policy_sha256="efba0409db9a0a53196fa8a7c9f4d4e874234b48287eb5242cf399f466e4c695"
policy="$(mktemp)"

if curl -fsSL "$policy_url" -o "$policy" &&
  printf "%s  %s\n" "$policy_sha256" "$policy" | sha256sum -c -; then

  # Use /etc on immutable distros (read-only /usr), /usr/share on traditional ones
  if findmnt -n -o OPTIONS --target /usr/share/polkit-1/actions 2>/dev/null | grep -qw ro; then
    install_path="/etc/polkit-1/actions/com.ente.auth.policy"
  else
    install_path="/usr/share/polkit-1/actions/com.ente.auth.policy"
  fi

  sudo install -D -o root -g root -m 0644 "$policy" "$install_path"

  if command -v restorecon >/dev/null 2>&1; then
    sudo restorecon -v "$install_path" || true
  fi

  # Give polkit time to pick up the new action via inotify
  sleep 1

  pkaction --action-id com.ente.auth.unlock --verbose
else
  echo "Policy download or checksum verification failed. Not installing."
fi

rm -f "$policy"
