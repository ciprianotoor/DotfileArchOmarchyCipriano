# Mr. Robot / fsociety mode.
# Este archivo se carga solo al entrar con ModoHacker.

# --- Lógica de terminal ---
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less -R"
export LESS="-FRX"
export KEYTIMEOUT=1

# Edición modal: Esc para comandos, i/a para insertar.
bindkey -v
setopt AUTO_CD
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt NO_BEEP

# Ctrl-R: historial; Ctrl-T: archivos; Alt-C: directorios.
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# --- Estado de la sesión ---
# Tiempo transcurrido desde que se abrió este ModoHacker.
typeset -gi MR_SESSION_START=${EPOCHSECONDS:-0}
typeset -g MR_CONTEXT_VALUE=''

function mr_update_context() {
  local elapsed=$(( EPOCHSECONDS - MR_SESSION_START ))
  (( elapsed < 0 )) && elapsed=0
  local hours=$(( elapsed / 3600 ))
  local minutes=$(( (elapsed % 3600) / 60 ))
  local age="${minutes}m"
  (( hours > 0 )) && age="${hours}h ${minutes}m"
  local user=${(%):-%n}
  local host=${(%):-%m}
  if [[ -n $MR_VPN_ADDR ]]; then
    MR_CONTEXT_VALUE="VPN:$MR_VPN_ADDR ◷ $age"
  else
    MR_CONTEXT_VALUE="$user@$host ◷ $age"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd mr_update_context
mr_update_context

function prompt_session_type() {
  local label icon color
  if [[ -n ${SSH_CONNECTION:-} || -n ${SSH_TTY:-} ]]; then
    label='HACKER/SSH'
    icon='⇄'
    color='magenta'
  elif [[ -n ${TMUX:-} ]]; then
    label='HACKER/TMUX'
    icon='▣'
    color='cyan'
  elif [[ -n ${WAYLAND_DISPLAY:-}${DISPLAY:-} ]]; then
    label='HACKER/LOCAL'
    icon='⌂'
    color='red'
  else
    label='HACKER/TTY'
    icon='▤'
    color='red'
  fi

  (( EUID == 0 )) && label+=':ROOT'
  p10k segment -f "$color" -i "$icon" -t "$label"
}

function prompt_session_age() {
  local elapsed=$(( EPOCHSECONDS - MR_SESSION_START ))
  (( elapsed < 0 )) && elapsed=0
  local hours=$(( elapsed / 3600 ))
  local minutes=$(( (elapsed % 3600) / 60 ))
  local text
  if (( hours > 0 )); then
    text="${hours}h ${minutes}m"
  else
    text="${minutes}m"
  fi
  p10k segment -f magenta -i '◷' -t "$text"
}

# Conserva la función original, pero sin comerse todo el ancho de la terminal.
function prompt_last_command() {
  local last_cmd=$(fc -ln -1 2>/dev/null)
  [[ -n $last_cmd ]] || return
  last_cmd=${last_cmd//$'\n'/ }
  last_cmd=${last_cmd//$'\r'/ }
  last_cmd=${last_cmd##+([[:space:]])}
  last_cmd=${last_cmd%%+([[:space:]])}
  local max_cmd=34
  [[ -n $MR_LAN_ADDR ]] && max_cmd=18
  (( ${#last_cmd} > max_cmd )) && last_cmd="${last_cmd[1,$((max_cmd - 3))]}…"
  p10k segment -f magenta -i '' -t "UC: $last_cmd }~>"
}

# Identidad persistente en la línea central; conserva la versión Proxmox si existe.
function prompt_proxmox_version() {
  local marker='<~{[*-*]Mr-Robot}'
  if command -v pveversion >/dev/null 2>&1; then
    local pvever=$(pveversion 2>/dev/null | head -n1)
    [[ -n $pvever ]] && marker+=" | ${pvever%%-*}"
  fi
  p10k segment -f red -i '⌁' -t "$marker"
}

# Identificador visible de Mr. Robot en la línea superior derecha.
function prompt_mr_robot() {
  local title='ModoHacker'
  if (( EUID == 0 )) || [[ -n ${SUDO_USER:-} ]]; then
    title='ModoHacker:SUDO'
  fi
  p10k segment -f red -i '' -t "$title"
}

# Usuario y equipo en la parte superior derecha.
function prompt_mr_user() {
  local uptime_text
  uptime_text=$(LC_ALL=C uptime -p 2>/dev/null)
  uptime_text=${uptime_text#up }
  uptime_text=${uptime_text// days/d}
  uptime_text=${uptime_text// day/d}
  uptime_text=${uptime_text// hours/h}
  uptime_text=${uptime_text// hour/h}
  uptime_text=${uptime_text// minutes/m}
  uptime_text=${uptime_text// minute/m}
  uptime_text=${uptime_text//, / }
  [[ -n $uptime_text ]] || uptime_text='?'

  p10k segment -f cyan -i '' -t "%n@%m │  $uptime_text"
}

# P10k ya trae este segmento personalizado registrado; lo reutilizamos para
# mostrar el tipo de sesión y el tiempo transcurrido sin perder la derecha.
function prompt_example() {
  local label icon color
  if [[ -n ${SSH_CONNECTION:-} || -n ${SSH_TTY:-} ]]; then
    label='HACKER/SSH'
    icon='⇄'
    color='magenta'
  elif [[ -n ${TMUX:-} ]]; then
    label='HACKER/TMUX'
    icon='▣'
    color='cyan'
  elif [[ -n ${WAYLAND_DISPLAY:-}${DISPLAY:-} ]]; then
    label='HACKER/LOCAL'
    icon='⌂'
    color='red'
  else
    label='HACKER/TTY'
    icon='▤'
    color='yellow'
  fi
  (( EUID == 0 )) && label+=':ROOT'

  local elapsed=$(( EPOCHSECONDS - MR_SESSION_START ))
  (( elapsed < 0 )) && elapsed=0
  local hours=$(( elapsed / 3600 ))
  local minutes=$(( (elapsed % 3600) / 60 ))
  local age="${minutes}m"
  (( hours > 0 )) && age="${hours}h ${minutes}m"

  p10k segment -f "$color" -i "$icon" -t "$label ◷ $age"
}

# Red: se consultan bajo demanda y no ralentizan el prompt.
function lanip() {
  command ip -4 -o addr show scope global 2>/dev/null |
    awk '$2 ~ /^(en|eth|wl|vmbr|br)/ {sub(/\/.*/, "", $4); print $2 ":" $4}'
}

function vpnip() {
  local result
  result=$(command ip -4 -o addr show scope global 2>/dev/null |
    awk '$2 ~ /^(tailscale|wg|tun|gpd|zt)/ {sub(/\/.*/, "", $4); print $2 ":" $4}')
  if [[ -n $result ]]; then
    print -r -- "$result"
  elif (( $+commands[tailscale] )); then
    print -r -- "tailscale: $(command tailscale ip -4 2>/dev/null)"
  fi
}

# Paquetes actualizables de Arch Linux.
function prompt_arch_updates() {
  local updates=0
  if (( $+commands[checkupdates] )); then
    updates=$(checkupdates 2>/dev/null | wc -l)
  fi
  updates=${updates//[[:space:]]/}
  p10k segment -f yellow -i '' -t "󰏗 {$updates}"
}


# --- Prompt P10k: oscuro, rojo de alerta y blanco de terminal ---
typeset -ga POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  mr_robot
  last_command
  newline
  mr_user
  newline
  dir
  battery
  load
  ram
  disk_usage
  newline
  prompt_char
)
typeset -ga POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  vpn_ip
  newline
  ip
  newline
  time
  newline
  os_icon
  arch_updates
  cpu_arch
  vcs
)

typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false
typeset -g POWERLEVEL9K_BACKGROUND=black
typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL='%F{red}%f'
typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='%F{grey}│%f'
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='%F{grey}│%f'

# Marco visual tipo consola de Elliot.
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%F{red}╭─{%f'
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%F{grey}├─%f'
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%F{red}╰─%f'
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX='%F{grey}─╮%f'
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX='%F{grey}─┤%f'
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX='%F{grey}─╯%f'

typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
typeset -g POWERLEVEL9K_CONTEXT_DEFAULT_CONTENT_EXPANSION='%n@%m'
typeset -g POWERLEVEL9K_CONTEXT_SUDO_CONTENT_EXPANSION='%n@%m'
typeset -g POWERLEVEL9K_CONTEXT_DEFAULT_CONTENT_EXPANSION='${MR_CONTEXT_VALUE}'
typeset -g POWERLEVEL9K_CONTEXT_SUDO_CONTENT_EXPANSION='${MR_CONTEXT_VALUE}'
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=red
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=black
typeset -g POWERLEVEL9K_CPU_ARCH_FOREGROUND=cyan
typeset -g POWERLEVEL9K_CPU_ARCH_BACKGROUND=black
typeset -g POWERLEVEL9K_CONTEXT_PREFIX=''
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=red
typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=red
typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=black
typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND=black
typeset -g POWERLEVEL9K_DIR_FOREGROUND=white
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=grey
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=red
typeset -g POWERLEVEL9K_DIR_BACKGROUND=black
typeset -g POWERLEVEL9K_DIR_SHORTENED_BACKGROUND=black
typeset -g POWERLEVEL9K_DIR_ANCHOR_BACKGROUND=black
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=green
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=red
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=red
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=black
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=black
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=black

typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=red
typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=green
typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=black
typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=black
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=yellow
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX='took '
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=black
typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=yellow
typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND=red
typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=red
typeset -g POWERLEVEL9K_LOAD_{NORMAL,WARNING,CRITICAL}_BACKGROUND=black
typeset -g POWERLEVEL9K_RAM_FOREGROUND=cyan
typeset -g POWERLEVEL9K_RAM_BACKGROUND=black
typeset -g POWERLEVEL9K_TIME_FOREGROUND=cyan
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%I:%M %p}'
typeset -g POWERLEVEL9K_TIME_PREFIX=''
typeset -g POWERLEVEL9K_TIME_BACKGROUND=black
typeset -g POWERLEVEL9K_DISK_USAGE_CONTENT_EXPANSION='${P9K_CONTENT}'

# Red privada: VPN/Tailscale y LAN en líneas separadas para no esconder la
# información cuando el prompt derecho está lleno.
typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND=magenta
typeset -g POWERLEVEL9K_VPN_IP_BACKGROUND=black
typeset -g POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION='%F{magenta}VPN:%f %F{magenta}${P9K_CONTENT}%f'
typeset -g POWERLEVEL9K_VPN_IP_INTERFACE='(gpd|wg|(.*tun)|tailscale)[0-9]*|(zt.*)'
typeset -g POWERLEVEL9K_IP_FOREGROUND=cyan
typeset -g POWERLEVEL9K_IP_BACKGROUND=black
typeset -g POWERLEVEL9K_IP_CONTENT_EXPANSION='${P9K_IP_RX_RATE:+%F{green}⇣$P9K_IP_RX_RATE %f}${P9K_IP_TX_RATE:+%F{yellow}⇡$P9K_IP_TX_RATE %f}%F{cyan}LAN:$P9K_IP_IP%f'
typeset -g POWERLEVEL9K_IP_INTERFACE='^(en|eth|wl|vmbr|br).*'

typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='»'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='»'
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=red
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=red
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❮'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❮'
