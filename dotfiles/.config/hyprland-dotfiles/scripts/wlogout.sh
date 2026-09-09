#!/usr/bin/env bash
res_h=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .height')
scale=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .scale')
w_margin=$(awk -v h="$res_h" -v s="$scale" 'BEGIN{printf "%d", (h*27)/(s*100)}')
[[ -z "$w_margin" || "$w_margin" -le 0 ]] && w_margin=300
wlogout -b 5 -T "$w_margin" -B "$w_margin"
