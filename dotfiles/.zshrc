#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#  _ / /\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|

# Environment & paths
export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.spicetify:$PATH"
export STARSHIP_CONFIG=~/.config/starship.toml
export FZF_DEFAULT_OPTS_FILE=$HOME/.fzfrc

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_DUPS HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS HIST_EXPIRE_DUPS_FIRST

# Aliases
source ~/hyprland-dotfiles/dotfiles/.zshrc.d/aliases.zsh

# Set zsh-syntax-highlighting oh-my-zsh plugin theme
source ~/hyprland-dotfiles/dotfiles/.zshrc.d/zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Oh-my-zsh configuration
plugins=(
    git
    sudo
    web-search
    archlinux
    fzf-tab
    zsh-bat
    zoxide
    command-not-found
    systemd
    docker
    docker-compose
    extract
    history
    history-substring-search
    zsh-autosuggestions
    zsh-syntax-highlighting
    alias-finder
    copyfile
    copypath
    copybuffer
    dirhistory
    fancy-ctrl-z
    git-auto-status
)

# Load oh-my-zsh framework
source $ZSH/oh-my-zsh.sh

# alias-finder plugin: suggest aliases when you type a matching command
zstyle ':omz:plugins:alias-finder' autoload yes   # show without prompting to press enter
zstyle ':omz:plugins:alias-finder' longer yes      # match if typed command is longer than alias
zstyle ':omz:plugins:alias-finder' exact yes       # require exact match to original command
zstyle ':omz:plugins:alias-finder' cheaper yes     # prefer shorter (cheaper) alias

# fzf integration
source <(fzf --zsh)

# Prompt
# eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"
# eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/EDM115-newline.omp.json)"
eval "$(starship init zsh)"

# Run fastfetch on terminal open
if [[ $(tty) == *"pts"* ]]; then
    fastfetch
fi

# eval "$(uv generate-shell-completion zsh)"
# eval "$(uvx --generate-shell-completion zsh)"

# thefuck alias -> fuck. Corrects errors in previous console command
# corrects errors in previous console command
eval $(thefuck --alias)
