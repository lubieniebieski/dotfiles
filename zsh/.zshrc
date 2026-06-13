# ===== ENVIRONMENT =====
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# ===== PATH MANAGEMENT =====
# Personal bin directory
export PATH="$HOME/.bin:$PATH"

# Homebrew (Apple Silicon)
export PATH="/opt/homebrew/bin:$PATH"

# ===== SHELL OPTIONS =====

# History settings 
setopt HIST_FIND_NO_DUPS        # Don't display duplicates when searching
setopt HIST_SAVE_NO_DUPS        # Don't save duplicates to history file
setopt SHARE_HISTORY            # Share history between all sessions

# Completion improvements
setopt COMPLETE_ALIASES         # Complete aliases
setopt GLOB_COMPLETE            # Generate matches from globbing
setopt LIST_PACKED              # Make completion lists more compact

# ===== EXTERNAL TOOLS =====

# slimzsh
[ -f "$HOME/.slimzsh/slim.zsh" ] && source "$HOME/.slimzsh/slim.zsh"

# fzf - fuzzy matching
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide - smarter cd command
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# ===== ALIASES =====
# Load aliases from separate file
[ -f ~/.aliases ] && source ~/.aliases

# ===== LOCAL CONFIGURATION =====
# Load local zsh configuration if it exists
# This allows for machine-specific settings without modifying the main dotfiles
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# mise - dev tools version manager
eval "$(mise activate zsh)"
