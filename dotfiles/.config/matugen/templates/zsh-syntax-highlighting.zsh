# Matugen Theme (for zsh-syntax-highlighting)
#
# Generated with Matugen — do not edit manually.
# Source this file in ~/.zshrc before zsh-syntax-highlighting is loaded.
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

# Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
#
## General
### Diffs
### Markup
## Classes
## Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg={{colors.on_surface_variant.default.hex}}'
## Constants
## Entitites
## Functions/methods
ZSH_HIGHLIGHT_STYLES[alias]='fg={{colors.primary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg={{colors.primary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg={{colors.primary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[function]='fg={{colors.primary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[command]='fg={{colors.primary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[precommand]='fg={{colors.primary.default.hex}},italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg={{colors.secondary.default.hex}},italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg={{colors.secondary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg={{colors.secondary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg={{colors.tertiary.default.hex}}'
## Keywords
## Built ins
ZSH_HIGHLIGHT_STYLES[builtin]='fg={{colors.primary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg={{colors.primary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg={{colors.primary.default.hex}}'
## Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg={{colors.error.default.hex}}'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg={{colors.on_surface.default.hex}}'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg={{colors.on_surface.default.hex}}'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg={{colors.on_surface.default.hex}}'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg={{colors.error.default.hex}}'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg={{colors.error.default.hex}}'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg={{colors.error.default.hex}}'
## Serializable / Configuration Languages
## Storage
## Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg={{colors.tertiary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg={{colors.tertiary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg={{colors.tertiary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg={{colors.error.default.hex}}'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg={{colors.tertiary.default.hex}}'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg={{colors.error.default.hex}}'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg={{colors.tertiary.default.hex}}'
## Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg={{colors.on_surface.default.hex}}'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg={{colors.error.default.hex}}'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg={{colors.on_surface.default.hex}}'
ZSH_HIGHLIGHT_STYLES[assign]='fg={{colors.on_surface.default.hex}}'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg={{colors.on_surface.default.hex}}'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg={{colors.on_surface.default.hex}}'
## No category relevant in spec
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg={{colors.error.default.hex}}'
ZSH_HIGHLIGHT_STYLES[path]='fg={{colors.on_surface.default.hex}},underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg={{colors.error.default.hex}},underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg={{colors.on_surface.default.hex}},underline'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg={{colors.error.default.hex}},underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg={{colors.on_surface.default.hex}}'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg={{colors.tertiary.default.hex}}'
#ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
#ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg={{colors.error.default.hex}}'
ZSH_HIGHLIGHT_STYLES[redirection]='fg={{colors.on_surface.default.hex}}'
ZSH_HIGHLIGHT_STYLES[arg0]='fg={{colors.on_surface.default.hex}}'
ZSH_HIGHLIGHT_STYLES[default]='fg={{colors.on_surface.default.hex}}'
ZSH_HIGHLIGHT_STYLES[cursor]='fg={{colors.on_surface.default.hex}}'
