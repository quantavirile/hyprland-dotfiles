#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#  _ / /\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|

# Environment & paths
export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.spicetify:$PATH"
export STARSHIP_CONFIG="$HOME/.config/starship/starship-matugen.toml"
export FZF_DEFAULT_OPTS="--preview 'bat --color=always {}'"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/colors"
# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_DUPS HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS HIST_EXPIRE_DUPS_FIRST

# Set zsh-syntax-highlighting oh-my-zsh plugin theme
source ~/hyprland-dotfiles/dotfiles/.zshrc.d/zsh-syntax-highlighting/themes/matugen-zsh-syntax-highlighting.zsh

# Oh-my-zsh configuration
plugins=(
    git
    thefuck
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

# Custom aliases (loaded after oh-my-zsh to take precedence)
source ~/hyprland-dotfiles/dotfiles/.zshrc.d/aliases.zsh

# alias-finder plugin: suggest aliases when you type a matching command
zstyle ':omz:plugins:alias-finder' autoload yes   # show without prompting to press enter
zstyle ':omz:plugins:alias-finder' longer yes      # match if typed command is longer than alias
zstyle ':omz:plugins:alias-finder' exact yes       # require exact match to original command
zstyle ':omz:plugins:alias-finder' cheaper yes     # prefer shorter (cheaper) alias

# fzf integration
source <(fzf --zsh)

# Prompt
eval "$(starship init zsh)"

# Run fastfetch on terminal open
if [[ $(tty) == *"pts"* ]]; then
    fastfetch
fi

# eval "$(uv generate-shell-completion zsh)"
# eval "$(uvx --generate-shell-completion zsh)"

# thefuck alias -> fuck. Corrects errors in previous console command
eval $(thefuck --alias)
