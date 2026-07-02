# fzf - fuzzy matching
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)

  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --strip-cwd-prefix'  # strip-cwd-prefix removes the leading ./ from results
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  export FZF_DEFAULT_OPTS='
    --height=60%
    --layout=reverse
    --border=rounded
    --prompt="  "
    --pointer="  "
    --preview-window=right:65%:wrap:border-left
  '

  _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
  export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

  # Ctrl+P: file picker excluding hidden files (VS Code-style Quick Open; overrides up-line-or-history)
  # NOTE: fzf must read its item list itself (via FZF_DEFAULT_COMMAND) and take stdin from
  # /dev/tty rather than a shell pipe -- inside a zle widget, piping a file list directly
  # into fzf breaks its terminal interaction and it exits instantly with no UI.
  _fzf_file_no_hidden() {
    local cmd result
    cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
    result=$(FZF_DEFAULT_COMMAND="${cmd:-find . -type f}" fzf --preview "$_FZF_PREVIEW_CMD" < /dev/tty) \
      && LBUFFER+="$result"  # LBUFFER is the text left of the cursor
    zle reset-prompt
  }
  zle -N _fzf_file_no_hidden
  bindkey '^P' _fzf_file_no_hidden

  # Ctrl+O: cd picker, same as the default Alt-C widget (overrides accept-line-and-down-history)
  bindkey '^O' fzf-cd-widget

  # Ctrl+R: history search, with Shift-Delete (or Ctrl-X) to remove an entry from
  # $HISTFILE on the spot. zsh has no live-history equivalent of bash's `history -d`,
  # so deletion only takes effect in $HISTFILE (new shells + this widget's own next
  # run); the current session's plain Up-arrow recall may still show it until restart.
  if [[ -x "$HOME/.zshrc.d/fzf-hist" ]]; then
    fzf-history-widget() {
      setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases no_glob no_sh_glob no_ksharrays extendedglob 2>/dev/null
      local -x FZF_HIST_BIN="$HOME/.zshrc.d/fzf-hist"
      local -x FZF_HIST_FILE="${HISTFILE:-$HOME/.zsh_history}"
      local -x FZF_HIST_ENTRIES
      FZF_HIST_ENTRIES=$(mktemp)
      local selected idx cmdtext
      local -a sel_lines cmds
      selected="$(
        "$FZF_HIST_BIN" prep "$FZF_HIST_FILE" "$FZF_HIST_ENTRIES" |
          FZF_DEFAULT_OPTS=$(__fzf_defaults "" "-n2..,.. --scheme=history --highlight-line --wrap-sign '\t↳ ' --preview '\"\$FZF_HIST_BIN\" show \"\$FZF_HIST_ENTRIES\" {1} | bat --color=always --style=plain --language=bash' --preview-window down:5:wrap --bind 'shift-delete:execute-silent(\"\$FZF_HIST_BIN\" delete \"\$FZF_HIST_FILE\" \"\$FZF_HIST_ENTRIES\" {+1})+exclude-multi' --bind 'ctrl-x:execute-silent(\"\$FZF_HIST_BIN\" delete \"\$FZF_HIST_FILE\" \"\$FZF_HIST_ENTRIES\" {+1})+exclude-multi' --multi ${FZF_CTRL_R_OPTS-} --read0 --query=${(qqq)LBUFFER}") \
          FZF_DEFAULT_OPTS_FILE='' fzf
      )"
      if [[ -n $selected ]]; then
        sel_lines=(${(f)selected})
        for line in "${sel_lines[@]}"; do
          idx="${line%%$'\t'*}"
          cmdtext="$("$FZF_HIST_BIN" show "$FZF_HIST_ENTRIES" "$idx")"
          cmds+=("$cmdtext")
        done
        LBUFFER="${(F)cmds}"
      fi
      command rm -f "$FZF_HIST_ENTRIES"
      zle reset-prompt
    }
  fi
fi
