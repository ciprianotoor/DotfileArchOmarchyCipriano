# ==================================
# ModoHacker Tools
# ==================================

# LSD (ls moderno)
alias ls="lsd"
alias ll="lsd -lah"
alias la="lsd -a"
alias lt="lsd --tree"

# BAT (cat moderno)
alias cat="bat --paging=never"

# ripgrep
alias grep="rg"

# fzf
export FZF_DEFAULT_OPTS="
--height 40%
--layout=reverse
--border
"

# bat theme
export BAT_THEME="Catppuccin Mocha"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"
