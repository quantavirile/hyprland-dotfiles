# transient-prompt.zsh - collapse retired starship prompts (p10k-style bare transient).
#
# Starship renders a 2-line prompt: L1 = powerline bubbles (wallpaper colors),
# L2 = `<glyph> <command>`. Truecolor escapes baked into scrollback can never
# be recolored, so on preexec (after Enter, before any output) this rewrites
# the old prompt in place:
#   L1 (bubbles) -> erased entirely (bare style, no replacement text)
#   L2 `<colored glyph> <cmd>` -> `<plain glyph> <cmd>` (command verbatim)
# The live prompt stays full starship. Retired lines use only the terminal
# default foreground, so they can never go stale.
#
# Knobs:
#   TRANSIENT_ENABLED=1  set to 0 to disable without unsourcing
#   TRANSIENT_GLYPH      retired-prompt glyph (default 🞈, uncolored)
#
# Notes / accepted tradeoffs:
#   - Multiline commands are reprinted verbatim, but PS2 continuation markers
#     (`> `) are not preserved on retired lines.
#   - Soft-wrapped lines (long path/branch on a narrow terminal) break the row
#     math; the width guard below skips the rewrite instead of glitching.

[[ -o interactive ]] || return 0
(( $+functions[add-zsh-hook] )) || autoload -Uz add-zsh-hook

: "${TRANSIENT_ENABLED:=1}"
: "${TRANSIENT_GLYPH:=🞈}"

_transient_prompt_preexec() {
  (( TRANSIENT_ENABLED )) || return 0
  local cmd="$1"
  [[ -n "$cmd" ]] || return 0

  # Logical lines in the command. Layout: [L1 bubbles][L2 glyph + line 1]
  # [line 2..N], cursor at the end, so L1 is N rows up.
  local -i nlines=$(( ${#${(f)cmd}} ))

  # Width guard: soft-wrapped lines break row math; skip instead of glitching.
  local line
  for line in "${(@f)cmd}"; do
    (( ${#line} < COLUMNS )) || return 0
  done

  # Up to L1 and erase the bubble line (no trailing newline: rows must not shift).
  print -n "\e[${nlines}A\e[G\e[2K"
  # Down to L2 start, clear to end of screen (only our own command lines are
  # below; output hasn't printed yet), reprint glyph + command verbatim,
  # terminated by a real newline: the Enter newline was consumed by line
  # editing before preexec runs, so without this the command's output would
  # start on the reprinted prompt line. Exactly one newline => output begins
  # on the next line, same as a normal (non-transient) command.
  # -r: no backslash interpretation; no -P: a command may contain `%`.
  # ($'\n' carries a real LF; a literal "\n" under -r would print as text.)
  print -n "\e[1B\e[G\e[J"
  print -rn -- "${TRANSIENT_GLYPH} ${cmd}"$'\n'
}

add-zsh-hook preexec _transient_prompt_preexec
