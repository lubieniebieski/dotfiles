# ===== RC FILES =====
# Hand-written config, split up and sourced in dependency order.
# One-liners are kept inline here rather than split into their own file.
[ -f ~/.zshrc.d/path.zsh ] && source ~/.zshrc.d/path.zsh        # must come first, other files rely on PATH (e.g. Homebrew bin) being set
[ -f ~/.zshrc.d/options.zsh ] && source ~/.zshrc.d/options.zsh  # shell setopts
[ -f "$HOME/.slimzsh/slim.zsh" ] && source "$HOME/.slimzsh/slim.zsh"  # must come before fzf, which intentionally overrides some of its bindings
[ -f ~/.zshrc.d/completion.zsh ] && source ~/.zshrc.d/completion.zsh  # tweaks on top of slimzsh's completion (grouping, make targets)
[ -f ~/.zshrc.d/fzf.zsh ] && source ~/.zshrc.d/fzf.zsh          # fuzzy matching, file/history/cd pickers
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"  # smarter cd command

# ===== ALIASES =====
# Load aliases from separate file
[ -f ~/.aliases ] && source ~/.aliases

# ===== LOCAL CONFIGURATION =====
# Load local zsh configuration if it exists
# This allows for machine-specific settings without modifying the main dotfiles
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# mise - dev tools version manager
eval "$(mise activate zsh)"
