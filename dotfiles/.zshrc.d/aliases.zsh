# File Operations
alias cp='cp -aiv'
alias mv='mv -iv'
alias rm='trash -v'
alias ls='eza -a --group-directories-first --icons=always'
alias l='eza -alb --group-directories-first --icons=always'
alias ll='eza -alb --group-directories-first --icons=always'
alias lD='eza -albD --show-symlinks  --icons=always'
alias lF='eza -albf --show-symlinks --icons=always'
alias lS='eza -alb --sort=size --icons=always'
alias lT='eza -alb --sort=newest --icons=always'
alias lt1='eza -ab --tree --level=1 --icons=always'
alias lt2='eza -ab --tree --level=2 --icons=always'
alias lt3='eza -ab --tree --level=3 --icons=always'

# Unset LS_COLORS so eza's theme.yml takes full effect
unset LS_COLORS

# Editors
alias v='$EDITOR'
alias diff="nvim -d"
alias se='sudoedit'
alias sv='sudoedit'

# Git
alias lg='lazygit'

# System
alias c='clear'
alias q='exit'
alias src='exec zsh'
alias df='duf'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias shutdown='systemctl poweroff'

# Package Management
alias cu='checkupdates'
alias cuc='checkupdates | wc -l'
alias ycu='yay -Qum'
alias ycuc='yay -Qum | wc -l'
alias tg='topgrade'
alias gearlever='flatpak run it.mijorus.gearlever'
alias bi='bin install'
alias bls='bin list'
alias brm='bin remove'

# Downloading
alias yt='yt-dlp --config-locations ~/.config/yt-dlp/yt.conf'
alias yta='yt-dlp --config-locations ~/.config/yt-dlp/yt-alt.conf'
alias dl='aria2c -s16 -x16'

# Mounting
alias mntdls='sudo mount --bind ~/Downloads ~/.local/share/waydroid/data/media/0/Download'

# Network Monitoring
alias bw='bandwhich --total-utilization'
alias bwwlan='bandwhich --total-utilization --interface wlan0'
alias bwwwp='bandwhich --total-utilization --interface wwp0s20f0u2i12'
alias vnwwp='vnstat --iface wwp0s20f0u2i12'
alias vnwlan='vnstat --iface wlan0'

# Waydroid
alias wss='waydroid session stop'

# Info & Utils
uptime_info() {
    local uptime_sec=$(cut -d. -f1 /proc/uptime 2>/dev/null)
    local days=$((uptime_sec / 86400))
    local hours=$(((uptime_sec % 86400) / 3600))
    local mins=$(((uptime_sec % 3600) / 60))
    
    echo "Uptime:"
    if [[ $days -gt 0 ]]; then
        echo "  ${days}d ${hours}h ${mins}m"
    elif [[ $hours -gt 0 ]]; then
        echo "  ${hours}h ${mins}m"
    else
        echo "  ${mins}m"
    fi
    
    echo ""
    echo "Booted:"
    who -b | awk '{print "  "$3" "$4}'
}
alias ff='fastfetch'
alias clock='tty-clock'
alias ascii='~/.config/hyprland-dotfiles/scripts/figlet.sh'
alias map='npx mapscii'
alias spotx='bash <(curl -sSL https://raw.githubusercontent.com/SpotX-Official/SpotX-Bash/main/spotx.sh) -h'
alias lowfi='lowfi -s 2'

# alias scrcpy='scrcpy --turn-screen-off --stay-awake'
