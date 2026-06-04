#!/usr/bin/env bash
#    __            __   _         ___
#   / /_____ __ __/ /  (_)__  ___/ (_)__  ___ ____
#  /  '_/ -_) // / _ \/ / _ \/ _  / / _ \/ _ `(_-<
# /_/\_\\__/\_, /_.__/_/_//_/\_,_/_/_//_/\_, /___/
#          /___/                        /___/
#

# -----------------------------------------------------
# Get keybindings location based on variation
# -----------------------------------------------------
config_file=~/.config/hypr/conf/keybinds.lua
config_file=${config_file//source = ~//home/$USER}

# -----------------------------------------------------
# Load Launcher
# -----------------------------------------------------
launcher=$(cat $HOME/.config/hyprland-dotfiles/settings/launcher)

# -----------------------------------------------------
# Path to keybindings config file
# -----------------------------------------------------
echo "Reading from: $config_file"

keybinds=$(python3 << PYEOF
import re, sys, os

path = os.path.expanduser("$config_file")
with open(path) as f:
    content = f.read()

content = re.sub(r'--.*', '', content)

calls = []
i = 0
while i < len(content):
    idx = content.find('hl.bind(', i)
    if idx == -1:
        break
    depth = 1
    j = idx + 8
    while j < len(content) and depth > 0:
        if content[j] == '(':
            depth += 1
        elif content[j] == ')':
            depth -= 1
        j += 1
    calls.append(content[idx+8:j-1])
    i = j

for call in calls:
    depth = 0
    end = -1
    for k, ch in enumerate(call):
        if ch == '(':
            depth += 1
        elif ch == ')':
            depth -= 1
        elif ch == ',' and depth == 0:
            end = k
            break
    if end == -1:
        continue
    first = call[:end].strip()
    key = ''
    for part in re.split(r'\s*\.\.\s*', first):
        part = part.strip()
        if part == 'mainMod':
            key += 'SUPER'
        elif part.startswith('"') and part.endswith('"'):
            key += part[1:-1]
    if not key:
        m = re.search(r'"([^"]+)"', first)
        if m:
            key = m.group(1)
    if not key:
        continue
    key = re.sub(r'\s*\+\s*', ' + ', key.strip())
    m = re.search(r'description\s*=\s*"([^"]+)"', call)
    if m:
        print(key + '\r ' + m.group(1))
PYEOF
2>/dev/null)

sleep 0.2

if [ "$launcher" == "walker" ]; then
  keybinds=$(echo -n "$keybinds" | tr '\r' ':')
  $HOME/.config/walker/launch.sh -d -N -H -p "Search Keybinds" <<<"$keybinds"
elif [ "$launcher" == "fuzzel" ]; then
  fuzzel --dmenu -p "Keybinds" <<<"$keybinds"
else
  rofi -dmenu -i -markup -eh 2 -replace -p "Keybinds" -config ~/.config/rofi/catppuccin/config-keybinds.rasi <<<"$keybinds"
fi
