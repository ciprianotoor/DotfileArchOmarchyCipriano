#!/usr/bin/env bash
# Componentes visuales compartidos para las utilidades de terminal de Omarchy.

UI_RESET=$'\e[0m'
UI_MUTED=$'\e[38;5;8m'
UI_BLUE=$'\e[38;5;4m'
UI_MAGENTA=$'\e[38;5;5m'
UI_CYAN=$'\e[38;5;6m'
UI_GREEN=$'\e[38;5;2m'
UI_YELLOW=$'\e[38;5;3m'
UI_RED=$'\e[38;5;1m'

ui_title() {
  printf '\n%s╭─ %s󰣇  %s%s\n' "$UI_MUTED" "$UI_BLUE" "$1" "$UI_RESET"
  printf '%s╰────────────────────────────────────────%s\n\n' "$UI_MUTED" "$UI_RESET"
}

ui_item() {
  printf '%s%s%-27s%s %s\n' "$UI_MUTED" '├─ ' "$1" "$UI_RESET" "$2"
}

ui_success() { printf '%s󰄬 %s%s\n' "$UI_GREEN" "$1" "$UI_RESET"; }
ui_warning() { printf '%s󰀪 %s%s\n' "$UI_YELLOW" "$1" "$UI_RESET"; }
ui_error() { printf '%s󰅚 %s%s\n' "$UI_RED" "$1" "$UI_RESET" >&2; }
ui_pause() { read -rp $'\n󰌑  ENTER para continuar'; }

ui_menu_option() {
  printf '  %s%s%s  %s\n' "$UI_MAGENTA" "$1" "$UI_RESET" "$2"
}
