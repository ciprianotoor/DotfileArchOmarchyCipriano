# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================
# Sistema de autocompletado Zsh
# =========================

autoload -Uz compinit
compinit

# =========================
# Plugins
# =========================

source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

source ~/.config/zsh/functions/mc-menu.zsh

# =========================
# Tools
# =========================

source ~/.config/zsh/tools.zsh

source ~/.config/zsh/aliasesrc

# =========================
# Historial ZSH
# =========================

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# =========================
# Powerlevel10k
# =========================

source ~/.config/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# =========================
# Syntax Highlighting
# DEBE IR AL FINAL
# =========================

source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Omarchy-style zsh additions (added by Copilot) ---
# Use Starship prompt if available
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Provide common completions
if autoload -Uz compinit 2>/dev/null; then
  autoload -Uz compinit
  compinit -u
fi

# Add user-local bin to PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Useful aliases (Omarchy-friendly)
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias update='omarchy update'
alias restart-term='omarchy restart terminal'

# Source user omarchy envs if present
if [ -f "$HOME/.config/omarchy/envs" ]; then
  source "$HOME/.config/omarchy/envs"
fi
# --- End Omarchy-style zsh additions ---
