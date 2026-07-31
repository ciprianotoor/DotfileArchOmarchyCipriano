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
# Prompt
# =========================
source ~/.config/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# =========================
# Syntax Highlighting
# DEBE IR AL FINAL
# =========================

source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Add user-local bin to PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Useful aliases (Omarchy-friendly)
alias update='omarchy update'
alias restart-term='omarchy restart terminal'

# Source user omarchy envs if present
if [ -f "$HOME/.config/omarchy/envs" ]; then
  source "$HOME/.config/omarchy/envs"
fi
# --- End ModoHacker shell ---
