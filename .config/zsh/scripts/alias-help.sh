#!/usr/bin/env bash

set -euo pipefail

alias_files=(
  "${ALIASES_FILE:-$HOME/.config/zsh/aliasesrc}"
  "$HOME/.zshrc"
)
query="${*:-}"

generate_aliases() {
  awk '
  function trim(value) {
    sub(/^[[:space:]]+/, "", value)
    sub(/[[:space:]]+$/, "", value)
    return value
  }
  function description(value, command) {
    if (value ~ /pacman -Syu/) return "Actualiza Arch Linux"
    if (value ~ /pacman -Ss/) return "Busca paquetes"
    if (value ~ /pacman -Si/) return "Muestra información del paquete"
    if (value ~ /pacman -Sc/) return "Limpia la caché de paquetes"
    if (value ~ /pacman -R/) return "Elimina paquetes"
    if (value ~ /pacman -Q/) return "Consulta paquetes instalados"
    if (value ~ /pacman -S/) return "Instala paquetes"
    if (value ~ /systemctl/) return "Muestra servicios activos"
    if (value ~ /lsd/) return "Lista archivos y directorios"
    if (value ~ /bat/) return "Muestra archivos con formato"
    if (value ~ /btop/) return "Monitoriza procesos y recursos"
    if (value ~ /nvim/) return "Abre Neovim"
    if (value ~ /clear/) return "Limpia la terminal"
    if (value ~ /scripts\//) return "Ejecuta una utilidad local"
    if (command == "cd") return "Cambia de directorio"
    return "Ejecuta " command
  }
  /^[[:space:]]*alias[[:space:]]+/ {
    line = $0
    sub(/^[[:space:]]*alias[[:space:]]+/, "", line)
    equal = index(line, "=")
    if (!equal) next
    name = trim(substr(line, 1, equal - 1))
    value = trim(substr(line, equal + 1))
    if (value ~ /^".*"$/ || value ~ /^'"'"'.*'"'"'$/)
      value = substr(value, 2, length(value) - 2)
    command = value
    sub(/^[[:space:]]*sudo[[:space:]]+/, "", command)
    sub(/[[:space:]].*$/, "", command)
    printf "%s|%s|%s\n", name, value, description(value, command)
  }
  ' "${alias_files[@]}" 2>/dev/null | awk '!seen[$0]++'
}

entries=$(generate_aliases)
if [[ -z "$entries" ]]; then
  printf 'No se encontraron aliases.\n'
  exit 1
fi

if command -v column >/dev/null 2>&1; then
  table=$(printf '%s\n' "$entries" | column -t -s '|')
else
  table="$entries"
fi

if command -v fzf >/dev/null 2>&1 && [[ -t 0 && -t 1 ]]; then
  selected=$(printf '%s\n' "$table" | fzf \
    --height=80% \
    --layout=reverse \
    --border \
    --header='ALIAS                         COMANDO                                      DESCRIPCIÓN' \
    --prompt='alias> ' \
    --query="$query" \
    --no-multi) || exit 0
  printf '%s\n' "$selected"
else
  printf '%s\n' "$table"
fi
